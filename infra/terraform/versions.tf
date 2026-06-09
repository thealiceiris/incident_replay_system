# W4 starter — Terraform + provider version pins.
# Copy into your capstone repo as infra/terraform/versions.tf (drop the .skeleton suffix).
#
# VERSION/COST DISCIPLINE: pin your K8s cluster to a STANDARD-SUPPORT version. On EKS, extended
# support costs $0.60/hr — 6x the $0.10/hr standard fee — and IaC defaults drift into it silently.
# Check the lifecycle docs and bump before your version ages out.

terraform {
  # Spec pins v1.9.x (moved/import/check blocks); the exact patch lives in .terraform-version (1.9.8).
  # ">= 1.9" here is the module's floor. (Upstream stable is newer; version currency is a Sensei call.)
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # major 6 as of 2026
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0" # major 7 as of 2026
    }
    # W5 adds the Kubernetes + Helm providers (Argo Rollouts deploys THROUGH this infra). Enabled then.
    # kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" } # TODO(week-05)
    # helm       = { source = "hashicorp/helm",       version = "~> 3.0" } # TODO(week-05)
  }

  # State backend: LOCAL for the pilot. The state file is NEVER committed (see .gitignore.skeleton).
  # Remote state (S3+DynamoDB / GCS) is stretch SA1 only — do NOT enable it for the lab.
}
