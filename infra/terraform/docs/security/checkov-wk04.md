

       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.3.0 
Update available 3.3.0 -> 3.3.1
Run pip3 install -U checkov to update 


terraform scan results:

Passed checks: 35, Failed checks: 23, Skipped checks: 0

Check: CKV_AWS_339: "Ensure EKS clusters run on a supported Kubernetes version"
	PASSED for resource: aws_eks_cluster.this
	File: /modules/aws/main.tf:37-46
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-339
Check: CKV_AWS_100: "Ensure AWS EKS node group does not have implicit SSH access from 0.0.0.0/0"
	PASSED for resource: aws_eks_node_group.this
	File: /modules/aws/main.tf:51-63
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-kubernetes-5
Check: CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
	PASSED for resource: aws_iam_role.github_actions
	File: /modules/aws/main.tf:74-90
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-274
Check: CKV_AWS_393: "Ensure AWS GitHub Actions OIDC authorization policies only allow safe claims and claim order on IAM role"
	PASSED for resource: aws_iam_role.github_actions
	File: /modules/aws/main.tf:74-90
Check: CKV_AWS_61: "Ensure AWS IAM policy does not allow assume role permission across all services"
	PASSED for resource: aws_iam_role.github_actions
	File: /modules/aws/main.tf:74-90
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-45
Check: CKV_AWS_60: "Ensure IAM role allows only specific services or principals to assume it"
	PASSED for resource: aws_iam_role.github_actions
	File: /modules/aws/main.tf:74-90
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-44
Check: CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
	PASSED for resource: aws_iam_role.cluster
	File: /modules/aws/main.tf:95-102
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-274
Check: CKV_AWS_393: "Ensure AWS GitHub Actions OIDC authorization policies only allow safe claims and claim order on IAM role"
	PASSED for resource: aws_iam_role.cluster
	File: /modules/aws/main.tf:95-102
Check: CKV_AWS_61: "Ensure AWS IAM policy does not allow assume role permission across all services"
	PASSED for resource: aws_iam_role.cluster
	File: /modules/aws/main.tf:95-102
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-45
Check: CKV_AWS_60: "Ensure IAM role allows only specific services or principals to assume it"
	PASSED for resource: aws_iam_role.cluster
	File: /modules/aws/main.tf:95-102
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-44
Check: CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
	PASSED for resource: aws_iam_role.node
	File: /modules/aws/main.tf:103-110
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-274
Check: CKV_AWS_393: "Ensure AWS GitHub Actions OIDC authorization policies only allow safe claims and claim order on IAM role"
	PASSED for resource: aws_iam_role.node
	File: /modules/aws/main.tf:103-110
Check: CKV_AWS_61: "Ensure AWS IAM policy does not allow assume role permission across all services"
	PASSED for resource: aws_iam_role.node
	File: /modules/aws/main.tf:103-110
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-45
Check: CKV_AWS_60: "Ensure IAM role allows only specific services or principals to assume it"
	PASSED for resource: aws_iam_role.node
	File: /modules/aws/main.tf:103-110
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-44
Check: CKV_GCP_18: "Ensure GKE Control Plane is not public"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-10
Check: CKV_GCP_8: "Ensure Stackdriver Monitoring is set to Enabled on Kubernetes Engine Clusters"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-3
Check: CKV_GCP_70: "Ensure the GKE Release Channel is set"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-the-gke-release-channel-is-set
Check: CKV_GCP_1: "Ensure Stackdriver Logging is set to Enabled on Kubernetes Engine Clusters"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-1
Check: CKV_GCP_21: "Ensure Kubernetes Clusters are configured with Labels"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-13
Check: CKV_GCP_7: "Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-2
Check: CKV_GCP_123: "GKE Don't Use NodePools in the Cluster configuration"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-google-cloud-123
Check: CKV_GCP_71: "Ensure Shielded GKE Nodes are Enabled"
	PASSED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-shielded-gke-nodes-are-enabled
Check: CKV_GCP_118: "Ensure IAM workload identity pool provider is restricted"
	PASSED for resource: module.cluster.google_iam_workload_identity_pool_provider.github
	File: /modules/gcp/main.tf:66-76
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-iam-policies/bc-google-cloud-118
Check: CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
	PASSED for resource: module.cluster.google_storage_bucket.capstone
	File: /modules/gcp/main.tf:92-115
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/ensure-gcp-cloud-storage-has-versioning-enabled
Check: CKV_GCP_52: "Ensure PostgreSQL database 'log_connections' flag is set to 'on'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-3
Check: CKV_GCP_11: "Ensure that Cloud SQL database Instances are not open to the world"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-networking-policies/bc-gcp-networking-4
Check: CKV_GCP_56: "Ensure PostgreSQL database 'log_temp_files flag is set to '0'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-7
Check: CKV_GCP_51: "Ensure PostgreSQL database 'log_checkpoints' flag is set to 'on'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-2
Check: CKV_GCP_53: "Ensure PostgreSQL database 'log_disconnections' flag is set to 'on'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-4
Check: CKV_GCP_60: "Ensure Cloud SQL database does not have public IP"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-11
Check: CKV_GCP_55: "Ensure PostgreSQL database 'log_min_messages' flag is set to a valid value"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-6
Check: CKV_GCP_111: "Ensure GCP PostgreSQL logs SQL statements"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/logging-policies-1/bc-google-cloud-111
Check: CKV_GCP_57: "Ensure PostgreSQL database 'log_min_duration_statement' flag is set to '-1'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-8
Check: CKV_GCP_54: "Ensure PostgreSQL database 'log_lock_waits' flag is set to 'on'"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/cloud-sql-policies/bc-gcp-sql-5
Check: CKV_GCP_14: "Ensure all Cloud SQL database instance have backup configuration enabled"
	PASSED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/bc-gcp-general-2
Check: CKV_AWS_39: "Ensure Amazon EKS public endpoint disabled"
	FAILED for resource: aws_eks_cluster.this
	File: /modules/aws/main.tf:37-46
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-kubernetes-2

		37 | resource "aws_eks_cluster" "this" {
		38 |   name     = var.name
		39 |   version  = local.k8s_version
		40 |   role_arn = aws_iam_role.cluster.arn
		41 |   vpc_config {
		42 |     subnet_ids             = data.aws_subnets.default.ids
		43 |     endpoint_public_access = true
		44 |   }
		45 |   tags = var.tags
		46 | }

Check: CKV_AWS_58: "Ensure EKS Cluster has Secrets Encryption Enabled"
	FAILED for resource: aws_eks_cluster.this
	File: /modules/aws/main.tf:37-46
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-kubernetes-3

		37 | resource "aws_eks_cluster" "this" {
		38 |   name     = var.name
		39 |   version  = local.k8s_version
		40 |   role_arn = aws_iam_role.cluster.arn
		41 |   vpc_config {
		42 |     subnet_ids             = data.aws_subnets.default.ids
		43 |     endpoint_public_access = true
		44 |   }
		45 |   tags = var.tags
		46 | }

Check: CKV_AWS_38: "Ensure Amazon EKS public endpoint not accessible to 0.0.0.0/0"
	FAILED for resource: aws_eks_cluster.this
	File: /modules/aws/main.tf:37-46
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-kubernetes-1

		37 | resource "aws_eks_cluster" "this" {
		38 |   name     = var.name
		39 |   version  = local.k8s_version
		40 |   role_arn = aws_iam_role.cluster.arn
		41 |   vpc_config {
		42 |     subnet_ids             = data.aws_subnets.default.ids
		43 |     endpoint_public_access = true
		44 |   }
		45 |   tags = var.tags
		46 | }

Check: CKV_AWS_37: "Ensure Amazon EKS control plane logging is enabled for all log types"
	FAILED for resource: aws_eks_cluster.this
	File: /modules/aws/main.tf:37-46
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-kubernetes-policies/bc-aws-kubernetes-4

		37 | resource "aws_eks_cluster" "this" {
		38 |   name     = var.name
		39 |   version  = local.k8s_version
		40 |   role_arn = aws_iam_role.cluster.arn
		41 |   vpc_config {
		42 |     subnet_ids             = data.aws_subnets.default.ids
		43 |     endpoint_public_access = true
		44 |   }
		45 |   tags = var.tags
		46 | }

Check: CKV_GCP_61: "Enable VPC Flow Logs and Intranode Visibility"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/enable-vpc-flow-logs-and-intranode-visibility

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_25: "Ensure Kubernetes Cluster is created with Private cluster enabled"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-6

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_23: "Ensure Kubernetes Cluster is created with Alias IP ranges enabled"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-15

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_20: "Ensure master authorized networks is set to enabled in GKE clusters"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-12

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_13: "Ensure client certificate authentication to Kubernetes Engine Clusters is disabled"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-8

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_65: "Manage Kubernetes RBAC users with Google Groups for GKE"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/manage-kubernetes-rbac-users-with-google-groups-for-gke

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_64: "Ensure clusters are created with Private Nodes"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-clusters-are-created-with-private-nodes

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_66: "Ensure use of Binary Authorization"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-use-of-binary-authorization

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_69: "Ensure the GKE Metadata Server is Enabled"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/ensure-the-gke-metadata-server-is-enabled

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_12: "Ensure Network Policy is enabled on Kubernetes Engine Clusters"
	FAILED for resource: module.cluster.google_container_cluster.this
	File: /modules/gcp/main.tf:27-39
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-kubernetes-policies/bc-gcp-kubernetes-7

		27 | resource "google_container_cluster" "this" {
		28 |   name                = var.name
		29 |   location            = var.region
		30 |   enable_autopilot    = true
		31 |   resource_labels     = var.tags
		32 |   deletion_protection = false
		33 | 
		34 |   # TRANSLATION SEAM: K8S VERSION MANAGEMENT.
		35 |   # EKS pins an explicit version and you upgrade manually (6x cost if you forget). GKE uses RELEASE
		36 |   # CHANNELS with auto-upgrade — you pick a channel, not a version. Same "which K8s" intent; opposite
		37 |   # operational model. You cannot 1-in-1 translate `version = "1.34"`.
		38 |   release_channel { channel = "REGULAR" }
		39 | }

Check: CKV_GCP_125: "Ensure GCP GitHub Actions OIDC trust policy is configured securely"
	FAILED for resource: module.cluster.google_iam_workload_identity_pool_provider.github
	File: /modules/gcp/main.tf:66-76
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-iam-policies/gcp-iam-125

		66 | resource "google_iam_workload_identity_pool_provider" "github" {
		67 |   workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
		68 |   workload_identity_pool_provider_id = "github"
		69 |   oidc { issuer_uri = "https://token.actions.githubusercontent.com" }
		70 |   attribute_mapping = {
		71 |     "google.subject"       = "assertion.sub"
		72 |     "attribute.repository" = "assertion.repository"
		73 |   }
		74 |   # Restrict workload identity to your GitHub repository
		75 |   attribute_condition = "attribute.repository == 'thealiceiris/incident_replay_system'"
		76 | }

Check: CKV_GCP_114: "Ensure public access prevention is enforced on Cloud Storage bucket"
	FAILED for resource: module.cluster.google_storage_bucket.capstone
	File: /modules/gcp/main.tf:92-115
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/bc-google-cloud-114

		92  | resource "google_storage_bucket" "capstone" {
		93  |   name     = "${var.name}-data"
		94  |   location = var.region
		95  |   labels   = var.tags
		96  | 
		97  |   # TRANSLATION SEAM: OBJECT VERSIONING SEMANTICS.
		98  |   # S3 versioning uses status="Enabled" + delete markers + lifecycle rules. GCS versioning KEEPS
		99  |   # versions INDEFINITELY until a lifecycle_rule removes them — there is no delete-marker concept.
		100 |   # If your AWS design leaned on S3's automatic delete-marker + lifecycle, you MUST add an explicit
		101 |   # lifecycle_rule here or you will silently leak storage cost.
		102 |   versioning {
		103 |     enabled = var.data_layer_config.versioning_enabled
		104 |   }
		105 | 
		106 |   # Automatically delete old versions after retention_days to manage storage cost
		107 |   lifecycle_rule {
		108 |     condition {
		109 |       age = var.data_layer_config.retention_days
		110 |     }
		111 |     action {
		112 |       type = "Delete"
		113 |     }
		114 |   }
		115 | }

Check: CKV_GCP_62: "Bucket should log access"
	FAILED for resource: module.cluster.google_storage_bucket.capstone
	File: /modules/gcp/main.tf:92-115
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-storage-gcs-policies/bc-gcp-logging-2

		92  | resource "google_storage_bucket" "capstone" {
		93  |   name     = "${var.name}-data"
		94  |   location = var.region
		95  |   labels   = var.tags
		96  | 
		97  |   # TRANSLATION SEAM: OBJECT VERSIONING SEMANTICS.
		98  |   # S3 versioning uses status="Enabled" + delete markers + lifecycle rules. GCS versioning KEEPS
		99  |   # versions INDEFINITELY until a lifecycle_rule removes them — there is no delete-marker concept.
		100 |   # If your AWS design leaned on S3's automatic delete-marker + lifecycle, you MUST add an explicit
		101 |   # lifecycle_rule here or you will silently leak storage cost.
		102 |   versioning {
		103 |     enabled = var.data_layer_config.versioning_enabled
		104 |   }
		105 | 
		106 |   # Automatically delete old versions after retention_days to manage storage cost
		107 |   lifecycle_rule {
		108 |     condition {
		109 |       age = var.data_layer_config.retention_days
		110 |     }
		111 |     action {
		112 |       type = "Delete"
		113 |     }
		114 |   }
		115 | }

Check: CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
	FAILED for resource: module.cluster.google_storage_bucket.capstone
	File: /modules/gcp/main.tf:92-115
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-storage-gcs-policies/bc-gcp-gcs-2

		92  | resource "google_storage_bucket" "capstone" {
		93  |   name     = "${var.name}-data"
		94  |   location = var.region
		95  |   labels   = var.tags
		96  | 
		97  |   # TRANSLATION SEAM: OBJECT VERSIONING SEMANTICS.
		98  |   # S3 versioning uses status="Enabled" + delete markers + lifecycle rules. GCS versioning KEEPS
		99  |   # versions INDEFINITELY until a lifecycle_rule removes them — there is no delete-marker concept.
		100 |   # If your AWS design leaned on S3's automatic delete-marker + lifecycle, you MUST add an explicit
		101 |   # lifecycle_rule here or you will silently leak storage cost.
		102 |   versioning {
		103 |     enabled = var.data_layer_config.versioning_enabled
		104 |   }
		105 | 
		106 |   # Automatically delete old versions after retention_days to manage storage cost
		107 |   lifecycle_rule {
		108 |     condition {
		109 |       age = var.data_layer_config.retention_days
		110 |     }
		111 |     action {
		112 |       type = "Delete"
		113 |     }
		114 |   }
		115 | }

Check: CKV_GCP_108: "Ensure hostnames are logged for GCP PostgreSQL databases"
	FAILED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/logging-policies-1/bc-google-cloud-108

		123 | resource "google_sql_database_instance" "instance" {
		124 |   name                = "${var.name}-pg-instance"
		125 |   region              = var.region
		126 |   database_version    = "POSTGRES_15"
		127 |   deletion_protection = false
		128 |   settings {
		129 |     tier              = "db-g1-small"
		130 |     availability_type = "ZONAL"
		131 | 
		132 |     backup_configuration {
		133 |       enabled = true
		134 |     }
		135 | 
		136 |     # PostgreSQL logging flags
		137 |     database_flags {
		138 |       name  = "log_connections"
		139 |       value = "on"
		140 |     }
		141 |     database_flags {
		142 |       name  = "log_disconnections"
		143 |       value = "on"
		144 |     }
		145 |     database_flags {
		146 |       name  = "log_checkpoints"
		147 |       value = "on"
		148 |     }
		149 |     database_flags {
		150 |       name  = "log_lock_waits"
		151 |       value = "on"
		152 |     }
		153 |     database_flags {
		154 |       name  = "log_statement"
		155 |       value = "all"
		156 |     }
		157 |     database_flags {
		158 |       name  = "cloudsql_iam_authentication"
		159 |       value = "on"
		160 |     }
		161 |   }
		162 | }

Check: CKV_GCP_6: "Ensure all Cloud SQL database instance requires all incoming connections to use SSL"
	FAILED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/bc-gcp-general-1

		123 | resource "google_sql_database_instance" "instance" {
		124 |   name                = "${var.name}-pg-instance"
		125 |   region              = var.region
		126 |   database_version    = "POSTGRES_15"
		127 |   deletion_protection = false
		128 |   settings {
		129 |     tier              = "db-g1-small"
		130 |     availability_type = "ZONAL"
		131 | 
		132 |     backup_configuration {
		133 |       enabled = true
		134 |     }
		135 | 
		136 |     # PostgreSQL logging flags
		137 |     database_flags {
		138 |       name  = "log_connections"
		139 |       value = "on"
		140 |     }
		141 |     database_flags {
		142 |       name  = "log_disconnections"
		143 |       value = "on"
		144 |     }
		145 |     database_flags {
		146 |       name  = "log_checkpoints"
		147 |       value = "on"
		148 |     }
		149 |     database_flags {
		150 |       name  = "log_lock_waits"
		151 |       value = "on"
		152 |     }
		153 |     database_flags {
		154 |       name  = "log_statement"
		155 |       value = "all"
		156 |     }
		157 |     database_flags {
		158 |       name  = "cloudsql_iam_authentication"
		159 |       value = "on"
		160 |     }
		161 |   }
		162 | }

Check: CKV_GCP_79: "Ensure SQL database is using latest Major version"
	FAILED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/ensure-gcp-sql-database-uses-the-latest-major-version

		123 | resource "google_sql_database_instance" "instance" {
		124 |   name                = "${var.name}-pg-instance"
		125 |   region              = var.region
		126 |   database_version    = "POSTGRES_15"
		127 |   deletion_protection = false
		128 |   settings {
		129 |     tier              = "db-g1-small"
		130 |     availability_type = "ZONAL"
		131 | 
		132 |     backup_configuration {
		133 |       enabled = true
		134 |     }
		135 | 
		136 |     # PostgreSQL logging flags
		137 |     database_flags {
		138 |       name  = "log_connections"
		139 |       value = "on"
		140 |     }
		141 |     database_flags {
		142 |       name  = "log_disconnections"
		143 |       value = "on"
		144 |     }
		145 |     database_flags {
		146 |       name  = "log_checkpoints"
		147 |       value = "on"
		148 |     }
		149 |     database_flags {
		150 |       name  = "log_lock_waits"
		151 |       value = "on"
		152 |     }
		153 |     database_flags {
		154 |       name  = "log_statement"
		155 |       value = "all"
		156 |     }
		157 |     database_flags {
		158 |       name  = "cloudsql_iam_authentication"
		159 |       value = "on"
		160 |     }
		161 |   }
		162 | }

Check: CKV_GCP_110: "Ensure pgAudit is enabled for your GCP PostgreSQL database"
	FAILED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/logging-policies-1/bc-google-cloud-110

		123 | resource "google_sql_database_instance" "instance" {
		124 |   name                = "${var.name}-pg-instance"
		125 |   region              = var.region
		126 |   database_version    = "POSTGRES_15"
		127 |   deletion_protection = false
		128 |   settings {
		129 |     tier              = "db-g1-small"
		130 |     availability_type = "ZONAL"
		131 | 
		132 |     backup_configuration {
		133 |       enabled = true
		134 |     }
		135 | 
		136 |     # PostgreSQL logging flags
		137 |     database_flags {
		138 |       name  = "log_connections"
		139 |       value = "on"
		140 |     }
		141 |     database_flags {
		142 |       name  = "log_disconnections"
		143 |       value = "on"
		144 |     }
		145 |     database_flags {
		146 |       name  = "log_checkpoints"
		147 |       value = "on"
		148 |     }
		149 |     database_flags {
		150 |       name  = "log_lock_waits"
		151 |       value = "on"
		152 |     }
		153 |     database_flags {
		154 |       name  = "log_statement"
		155 |       value = "all"
		156 |     }
		157 |     database_flags {
		158 |       name  = "cloudsql_iam_authentication"
		159 |       value = "on"
		160 |     }
		161 |   }
		162 | }

Check: CKV_GCP_109: "Ensure the GCP PostgreSQL database log levels are set to ERROR or lower"
	FAILED for resource: module.cluster.google_sql_database_instance.instance
	File: /modules/gcp/main.tf:123-162
	Calling File: /main.tf:28-38
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/logging-policies-1/bc-google-cloud-109

		123 | resource "google_sql_database_instance" "instance" {
		124 |   name                = "${var.name}-pg-instance"
		125 |   region              = var.region
		126 |   database_version    = "POSTGRES_15"
		127 |   deletion_protection = false
		128 |   settings {
		129 |     tier              = "db-g1-small"
		130 |     availability_type = "ZONAL"
		131 | 
		132 |     backup_configuration {
		133 |       enabled = true
		134 |     }
		135 | 
		136 |     # PostgreSQL logging flags
		137 |     database_flags {
		138 |       name  = "log_connections"
		139 |       value = "on"
		140 |     }
		141 |     database_flags {
		142 |       name  = "log_disconnections"
		143 |       value = "on"
		144 |     }
		145 |     database_flags {
		146 |       name  = "log_checkpoints"
		147 |       value = "on"
		148 |     }
		149 |     database_flags {
		150 |       name  = "log_lock_waits"
		151 |       value = "on"
		152 |     }
		153 |     database_flags {
		154 |       name  = "log_statement"
		155 |       value = "all"
		156 |     }
		157 |     database_flags {
		158 |       name  = "cloudsql_iam_authentication"
		159 |       value = "on"
		160 |     }
		161 |   }
		162 | }


