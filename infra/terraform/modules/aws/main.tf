# W4 starter — AWS implementation of the shared variable contract (EKS).
# Copy into your capstone repo as infra/terraform/modules/aws/main.tf.
# Apply ONLY if AWS is your chosen cloud.

variable "name" { type = string }
variable "region" { type = string }
variable "tags" { type = map(string) }
variable "node_size" { type = string }
variable "replicas" { type = number }
variable "data_layer_config" { type = object({ versioning_enabled = bool }) }

locals {
  # The contract translates here: node_size -> an AWS instance type.
  instance_type = {
    small  = "t3.medium"
    medium = "t3.large"
    large  = "t3.xlarge"
  }[var.node_size]

  # COST GUARD: pin a STANDARD-SUPPORT K8s version. Extended support = $0.60/hr (6x).
  # Standard-support versions as of 2026: 1.33 / 1.34 / 1.35 (1.33 ages out 2026-07). Re-check:
  # https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-standard.html
  k8s_version = "1.34"
}

# Networking: the LAB uses the default VPC's PUBLIC subnets so there is NO NAT Gateway.
# Production seam: private subnets + a NAT Gateway (~$0.045/hr + data egress). Skipped to stay
# under the <$10/lab budget. # TODO(lab-part-a-aws): switch to private subnets + NAT for production.
data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  version  = local.k8s_version
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids             = data.aws_subnets.default.ids
    endpoint_public_access = true
  }
  tags = var.tags
}

# Managed node group — the contract's node_size + replicas land here.
# No LoadBalancer is provisioned in the lab; reach your service with `kubectl port-forward`.
# Production seam: an ingress controller + an ALB/NLB (~$0.0225/hr + LCUs).
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-ng"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types  = [local.instance_type]
  scaling_config {
    desired_size = var.replicas
    min_size     = 1
    max_size     = var.replicas
  }
  tags = var.tags
}

# W5 PIPELINE AUTH (Outcome 8): GitHub Actions OIDC federation — keyless CI -> AWS. W5's GitHub
# Actions workflow assumes the role below via OIDC; NO long-lived AWS keys in CI. This is the
# Outcome-8 pre-provision. (Distinct from EKS IRSA — the cluster's own issuer for in-cluster pods —
# which is an optional later add, not the W5-pipeline dependency.)
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub OIDC root; modern AWS may not validate it. TODO(lab-part-a-aws): verify.
}
resource "aws_iam_role" "github_actions" {
  name = "${var.name}-gha-deploy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRoleWithWebIdentity"
      Principal = { Federated = aws_iam_openid_connect_provider.github_actions.arn }
      Condition = {
        StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }
        # TODO(lab-part-a-aws): restrict to YOUR repo + branch — the security-critical line:
        StringLike = { "token.actions.githubusercontent.com:sub" = "repo:TODO-owner/TODO-repo:ref:refs/heads/main" }
      }
    }]
  })
  tags = var.tags
}

# IAM roles for the cluster + nodes (service trusts). TODO(lab-part-a-aws): attach the AWS-managed
# EKS policies (AmazonEKSClusterPolicy on cluster; AmazonEKSWorkerNodePolicy + AmazonEKS_CNI_Policy +
# AmazonEC2ContainerRegistryReadOnly on node) via aws_iam_role_policy_attachment. Verify names on the registry.
resource "aws_iam_role" "cluster" {
  name = "${var.name}-eks-cluster"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = "sts:AssumeRole", Principal = { Service = "eks.amazonaws.com" } }]
  })
  tags = var.tags
}
resource "aws_iam_role" "node" {
  name = "${var.name}-eks-node"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = "sts:AssumeRole", Principal = { Service = "ec2.amazonaws.com" } }]
  })
  tags = var.tags
}

# Your capstone's primary managed data resource (GENERIC placeholder — every capstone differs).
# TODO(lab-part-a-aws): replace with your real resource. Example below = an S3 bucket + versioning.
# resource "aws_s3_bucket" "capstone" {
#   bucket = "${var.name}-data"
#   tags   = var.tags
# }
# resource "aws_s3_bucket_versioning" "capstone" {
#   bucket = aws_s3_bucket.capstone.id
#   versioning_configuration {
#     status = var.data_layer_config.versioning_enabled ? "Enabled" : "Suspended"
#   }
# }

output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
output "github_actions_role_arn" { value = aws_iam_role.github_actions.arn }
