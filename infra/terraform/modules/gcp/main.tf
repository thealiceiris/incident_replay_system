# W4 starter — GCP implementation of the SAME shared variable contract (GKE).
# Copy into your capstone repo as infra/terraform/modules/gcp/main.tf.
#
# In the Thu lab this is usually your Part-B AI-TRANSLATION READING ARTIFACT: generate it from the
# AWS module with AI, then read it and NAME THE SEAMS. Do NOT apply it if AWS is your chosen cloud.
# The `# TRANSLATION SEAM:` comments are the exemplars — yours should look like these.

variable "name" { type = string }
variable "region" { type = string }
variable "tags" { type = map(string) } # GCP calls these "labels" — see the first seam.
variable "node_size" { type = string }
variable "replicas" { type = number }
variable "data_layer_config" { type = object({ versioning_enabled = bool }) }

locals {
  # Same contract, different target: node_size -> a GCP machine type (used by the Standard example below).
  machine_type = {
    small  = "e2-medium"
    medium = "e2-standard-4"
    large  = "e2-standard-8"
  }[var.node_size]
}

# COST-SAFE DEFAULT = Autopilot. The GKE free tier credits $74.40/mo, which covers ONE Autopilot
# (or zonal Standard) cluster's $0.10/hr management fee — a near-free control plane, unlike EKS which
# has no free tier. Autopilot manages nodes for you and bills per-pod (no node pool to size).
resource "google_container_cluster" "this" {
  name             = var.name
  location         = var.region
  enable_autopilot = true
  resource_labels  = var.tags

  # COST GUARD: the Google provider defaults deletion_protection=true, which blocks `terraform
  # destroy`. Set false for the lab so `make tf-destroy` works (destroy-before-close). Flip to true
  # for production.
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
  attribute_mapping = { "google.subject" = "assertion.sub" }
  # TODO(lab-part-a-gcp): add attribute_condition restricting to your repo, + a google_service_account
  # and an IAM binding letting this pool impersonate it.
}

# Your capstone's primary managed data resource (GENERIC placeholder).
# TODO(lab-part-a-gcp): replace with your real resource. Example below = a GCS bucket.
# resource "google_storage_bucket" "capstone" {
#   name     = "${var.name}-data"
#   location = var.region
#   labels   = var.tags
#
#   # TRANSLATION SEAM: OBJECT VERSIONING SEMANTICS.
#   # S3 versioning uses status="Enabled" + delete markers + lifecycle rules. GCS versioning KEEPS
#   # versions INDEFINITELY until a lifecycle_rule removes them — there is no delete-marker concept.
#   # If your AWS design leaned on S3's automatic delete-marker + lifecycle, you MUST add an explicit
#   # lifecycle_rule here or you will silently leak storage cost.
#   versioning { enabled = var.data_layer_config.versioning_enabled }
#   # TODO(lab-part-a-gcp): add lifecycle_rule { } to match your AWS retention intent.
# }

output "cluster_endpoint" { value = google_container_cluster.this.endpoint }
output "workload_identity_pool" { value = google_iam_workload_identity_pool.github.name }
