# W4 starter — root outputs. Copy into your capstone repo as infra/terraform/outputs.tf.
# W5's pipeline + later weeks consume these. Values come from your chosen-cloud module.

output "cluster_endpoint" {
  description = "Kubernetes API endpoint of the provisioned cluster."
  value       = module.cluster.cluster_endpoint
}

# W5 CI auth handle. The module output name differs by cloud:
#   AWS -> module.cluster.github_actions_role_arn   (the IAM role GitHub Actions assumes)
#   GCP -> module.cluster.workload_identity_pool     (the WIF pool GitHub Actions federates into)
# TODO(lab-part-a): uncomment the one your chosen cloud module exposes.
# output "ci_auth" {
#   description = "Handle W5's GitHub Actions pipeline uses for keyless cloud auth."
#   value       = module.cluster.github_actions_role_arn   # AWS
#   # value     = module.cluster.workload_identity_pool    # GCP
# }
