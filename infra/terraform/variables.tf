

variable "name" {
  description = "Capstone service slug; prefixes every resource."
  type        = string
  default     = "incident-replay-system"
  # TODO(lab-part-a): your capstone slug, e.g. "vuln-monitor".
}

variable "region" {
  description = "Cloud region (neutral). Each module maps it to the provider's region argument."
  type        = string
  default     = "us-central1"
  # TODO(lab-part-a): e.g. "us-east-1" (AWS) or "us-central1" (GCP) for your chosen cloud.
}

variable "tags" {
  description = "Neutral key/value metadata. AWS maps to tags; GCP maps to labels (a translation seam)."
  type        = map(string)
  default = {
    env     = "dev"
    project = "capstone"
    owner   = "student"
  }
}

variable "node_size" {
  description = "Abstract node size. Each module translates it to a provider machine type."
  type        = string
  default     = "small"
  validation {
    condition     = contains(["small", "medium", "large"], var.node_size)
    error_message = "node_size must be one of: small, medium, large."
  }
}

variable "replicas" {
  description = "Desired worker node count for the capstone's node pool."
  type        = number
  default     = 2
}

variable "data_layer_config" {
  description = "Incident Replay System data-layer behavior (event retention, auditability, versioning)."
  type = object({
    versioning_enabled = bool
    retention_days     = number
    audit_logging      = bool
    query_logging      = bool
  })

  default = {
    versioning_enabled = true
    retention_days     = 30
    audit_logging      = true
    query_logging      = true
  }
}

variable "db_username" {
  description = "PostgreSQL database username for the Incident Replay System."
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "db_password" {
  description = "PostgreSQL database password for the Incident Replay System."
  type        = string
  sensitive   = true
  default     = "incident-replay-dev-pw"
  # TODO(lab-part-a): change to a secure password and use environment variable TF_VAR_db_password or terraform.tfvars (git-ignored)
}
