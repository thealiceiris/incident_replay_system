## The W3 seam

The integration boundary between the application (W1-W3) and the cloud infrastructure (W4). This is where the Python/FastAPI application, which runs locally in Docker Compose, is prepared for deployment into a cloud environment managed by Terraform.

## How W4 Terraform realizes its infrastructure side

W4 Terraform pre-provisions the entire runtime environment on GCP so the W5 CI/CD pipeline only has to deploy the application container. The Terraform configuration defines specific GCP resources:

- **Compute:** A `google_container_cluster` for GKE Autopilot, which will run the FastAPI application containers.
- **Database:** A `google_sql_database_instance` for the managed PostgreSQL database, which stores all incident and event data.
- **Storage:** A `google_storage_bucket` for storing related artifacts.
- **Networking:** The necessary VPC, subnets, and firewall rules to connect these services securely.

The seam is realized by Terraform creating these resources and exposing stable connection details (like the Cloud SQL instance connection name) as outputs. The application code remains unaware of this infrastructure until it's deployed and configured with the correct environment variables (e.g., `DATABASE_URL`).

## W5 auth pre-provision (carried for the W5 pipeline)

Terraform pre-provisions the authentication trust between GitHub Actions and GCP so the W5 pipeline can deploy code without needing static, long-lived secret keys. This is achieved with two key GCP resources defined in Terraform:

- **`google_iam_workload_identity_pool`**: Creates a pool to trust external identities, in this case, from GitHub.
- **`google_iam_workload_identity_pool_provider`**: Configures the pool to trust GitHub Actions, specifically allowing authentication from your repository.

The W5 GitHub Actions workflow will use this trust relationship to get short-lived GCP credentials, assume a service account, and perform actions like deploying a new container image to GKE. This is the "keyless" authentication method mentioned in your project plan.
