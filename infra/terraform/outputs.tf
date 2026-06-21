
output "ci_auth" {
  description = "Handle W5's GitHub Actions pipeline uses for keyless cloud auth."
  value       = module.cluster.workload_identity_pool
}