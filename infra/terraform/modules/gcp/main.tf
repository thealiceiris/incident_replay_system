

variable "name" { type = string }
variable "region" { type = string }
variable "tags" { type = map(string) }
variable "node_size" { type = string }
variable "replicas" { type = number }
variable "data_layer_config" { type = object({ versioning_enabled = bool, retention_days = number, audit_logging = bool, query_logging = bool }) }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}

data "google_project" "current" {}



locals {

  machine_type = {
    small  = "e2-medium"
    medium = "e2-standard-4"
    large  = "e2-standard-8"
  }[var.node_size]
}
resource "google_container_cluster" "this" {
  name                = var.name
  location            = var.region
  enable_autopilot    = true
  resource_labels     = var.tags
  deletion_protection = false

  # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
  # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
  # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
  # operational model. You cannot 1-in-1 translate `version = "1.34"`.
  release_channel { channel = "REGULAR" }
}

# TRANSLATION-EXAMPLE (Standard mode) — the node_size -> machine_type mapping, GCP's parallel to the
# EKS node group. Autopilot (above) has NO node pool. If you choose Standard instead of Autopilot:
# remove `enable_autopilot`, add `remove_default_node_pool = true` + `initial_node_count = 1` to the
# cluster, then uncomment:
# resource "google_container_node_pool" "this" {
#   name       = "${var.name}-np"
#   cluster    = google_container_cluster.this.name
#   location   = var.region
#   node_count = var.replicas  # COST: on a REGIONAL cluster this is PER ZONE (x3 nodes) and the
#                              # mgmt fee is NOT free-tier-covered. Use a single zone for zonal billing.
#   node_config {
#     machine_type = local.machine_type
#     labels       = var.tags
#   }
# }

# W5 PIPELINE AUTH (Outcome 8): Workload Identity Federation for GitHub Actions — keyless CI -> GCP.
# TRANSLATION SEAM: WORKLOAD AUTH MODEL.
# AWS scaffolds an OIDC provider + an IAM ROLE the GitHub token ASSUMES. GCP needs a workload identity
# POOL + an OIDC PROVIDER + a SERVICE ACCOUNT the pool IMPERSONATES. Same intent ("let CI call cloud
# APIs without keys"); different object graph — not a 1-in-1 translation. (Distinct from in-cluster
# GKE Workload Identity for pods, which is a separate concern.)
resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "${var.name}-gha-pool"
}
resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  oidc { issuer_uri = "https://token.actions.githubusercontent.com" }
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  # Restrict workload identity to your GitHub repository
  attribute_condition = "attribute.repository == 'thealiceiris/incident_replay_system'"
}

# Service account for GitHub Actions to impersonate
resource "google_service_account" "github_actions" {
  account_id   = "${var.name}-gha-sa"
  display_name = "GitHub Actions service account for ${var.name}"
}

# Allow the GitHub workload identity pool to impersonate this service account
resource "google_service_account_iam_member" "github_actions_impersonate" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/thealiceiris/incident_replay_system"
}

# Your capstone's primary managed data resource — GCS bucket for incident replay data.
resource "google_storage_bucket" "capstone" {
  name     = "${var.name}-data"
  location = var.region
  labels   = var.tags

  # TRANSLATION SEAM: OBJECT VERSIONING SEMANTICS.
  # S3 versioning uses status="Enabled" + delete markers + lifecycle rules. GCS versioning KEEPS
  # versions INDEFINITELY until a lifecycle_rule removes them — there is no delete-marker concept.
  # If your AWS design leaned on S3's automatic delete-marker + lifecycle, you MUST add an explicit
  # lifecycle_rule here or you will silently leak storage cost.
  versioning {
    enabled = var.data_layer_config.versioning_enabled
  }

  # Automatically delete old versions after retention_days to manage storage cost
  lifecycle_rule {
    condition {
      age = var.data_layer_config.retention_days
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_sql_database" "database" {
  name     = "${var.name}-pg-db"
  instance = google_sql_database_instance.instance.name
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name                = "${var.name}-pg-instance"
  region              = var.region
  database_version    = "POSTGRES_15"
  deletion_protection = false
  settings {
    tier              = "db-g1-small"
    availability_type = "ZONAL"

    backup_configuration {
      enabled = true
    }

    # PostgreSQL logging flags
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }
    database_flags {
      name  = "log_statement"
      value = "all"
    }
    database_flags {
      name  = "cloudsql_iam_authentication"
      value = "on"
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}

output "cluster_endpoint" { value = google_container_cluster.this.endpoint }
output "workload_identity_pool" { value = google_iam_workload_identity_pool.github.name }
