# W4 starter — the SHARED, CLOUD-NEUTRAL variable contract.
# Copy into your capstone repo as infra/terraform/variables.tf.
#
# This file IS the week's named skill: one contract, two cloud-specific implementations.
# Rule: every name here describes your CAPSTONE'S INTENT, never a cloud's resource type.
# Write "node_size", not "instance_type". Write "data_layer_config", not "s3_bucket".
# If a name only makes sense on one cloud, it does not belong in the shared contract.

variable "name" {
  description = "Capstone service slug; prefixes every resource."
  type        = string
  default    = "incident-replay-system"
  # TODO(lab-part-a): your capstone slug, e.g. "vuln-monitor".
}

variable "region" {
  description = "Cloud region (neutral). Each module maps it to the provider's region argument."
  type        = string
  default     = "us-east-1"
  # TODO(lab-part-a): e.g. "us-east-1" (AWS) or "us-central1" (GCP) for your chosen cloud.
}

variable "tags" {
  description = "Neutral key/value metadata. AWS maps to tags; GCP maps to labels (a translation seam)."
  type        = map(string)
  default     = {
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
