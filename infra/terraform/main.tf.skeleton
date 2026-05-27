# W4 starter — root entrypoint. Calls exactly ONE chosen-cloud module.
# Copy into your capstone repo as infra/terraform/main.tf.
#
# COST RULE: apply ONE cloud only. The other module is your Part-B READING ARTIFACT (the AI
# translation) — committed, but never applied in the lab. Applying both doubles your cloud spend.

# --- Chosen cloud: AWS path --------------------------------------------------
# provider "aws" {
#   region = var.region
#   default_tags { tags = var.tags }
# }
# module "cluster" {
#   source            = "./modules/aws"
#   name              = var.name
#   region            = var.region
#   tags              = var.tags
#   node_size         = var.node_size
#   replicas          = var.replicas
#   data_layer_config = var.data_layer_config
# }
# TODO(lab-part-a-aws): uncomment the block above if AWS is your chosen cloud.

# --- Chosen cloud: GCP path --------------------------------------------------
# provider "google" {
#   project = "TODO-your-gcp-project-id"
#   region  = var.region
# }
# module "cluster" {
#   source            = "./modules/gcp"
#   name              = var.name
#   region            = var.region
#   tags              = var.tags
#   node_size         = var.node_size
#   replicas          = var.replicas
#   data_layer_config = var.data_layer_config
# }
# TODO(lab-part-a-gcp): uncomment the block above if GCP is your chosen cloud.

# output "cluster_endpoint" { value = module.cluster.cluster_endpoint }
