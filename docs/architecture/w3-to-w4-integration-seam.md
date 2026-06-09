## The W3 seam

Integration boundary between application deployment (CI/CD pipeline) and infrastructure provisioning (Terraform-managed cloud resources).

## How W4 Terraform realizes its infrastructure side

W4 Terraform pre-provisions the runtime environment so the CI/CD pipeline only performs deployment actions. The module defines the core infrastructure resources (for example a managed Kubernetes cluster or compute service, plus its networking layer) and locks down configuration drift by enforcing immutable defaults at the module level. Access is constrained through pre-created service roles and attachable policies, ensuring that deployment jobs do not create or modify infrastructure directly. The seam is realized by exposing only stable endpoints (cluster API endpoint / service URL / load balancer DNS) as Terraform outputs, while all underlying provisioning logic (VPC/networking, compute nodes, and security boundaries) remains encapsulated inside the module.

## W5 auth pre-provision (carried for the W5 pipeline)

An OIDC-based identity provider (e.g., GitHub Actions → cloud OIDC trust configuration) is pre-provisioned via Terraform using an identity federation resource (such as `aws_iam_openid_connect_provider` or equivalent). W5 consumes this to allow CI pipelines to assume scoped roles without static credentials, enabling short-lived, auditable authentication for deployments and infrastructure actions.
