## Status

`accepted`

## Context

The primary users of the Incident Replay System are software engineers and platform teams who need to investigate production incidents quickly and accurately. The infrastructure decision being made is the selection of a cloud platform, state management approach, and Terraform configuration that will realize the target architecture defined in the W3 C4 Container diagram. GCP has been selected because GKE provides a managed Kubernetes platform with reduced operational overhead, while Cloud SQL provides managed PostgreSQL for persistent storage of incidents, replay metadata, and audit information. This decision is constrained by a lab budget of less than $10 per session, a solo-pilot development model, and the requirement to establish infrastructure that can support later work on CI/CD, observability, and security.

## Decision

> We will provision on GCP with local state, Terraform >= 1.9, and the Google provider pinned to `~> 7.0`. Local state is sufficient for the current solo-developer workflow, while provider version pinning ensures reproducible deployments and protects the project from unexpected breaking changes introduced by future provider releases.

## Consequences

**Positive:**

* Infrastructure is fully version-controlled, making deployments reproducible and reducing configuration drift.
* GKE and Cloud SQL reduce operational overhead by providing managed Kubernetes and managed database services.
* Version pinning improves deployment stability and makes troubleshooting more predictable.

**Negative:**

* Local Terraform state does not support collaboration or state locking, making it unsuitable for a multi-developer workflow.
* Using managed cloud services introduces provider-specific dependencies that reduce portability.
* Provisioning managed infrastructure incurs cloud costs if resources are not destroyed after use.

**Neutral:**

* A remote Terraform backend will likely be introduced as the project grows beyond a solo-developer workflow.
* Cross-cloud portability is achieved through separate Terraform modules rather than identical cloud resources.
* Additional infrastructure hardening (private networking, encryption policies, and security controls) will be implemented in later iterations.

## Considered options

### Option A — AWS (EKS + RDS)

* **What it is:** Provision the infrastructure using GKE's equivalent services in AWS, namely EKS for Kubernetes and RDS for PostgreSQL.
* **Why rejected:** While AWS provides comparable capabilities, GCP offers a simpler managed Kubernetes experience and lower expected operational complexity for a solo developer working within the course budget.

### Option B — Remote Terraform State

* **What it is:** Store Terraform state remotely using a shared backend such as Google Cloud Storage instead of a local state file.
* **Why rejected:** The project is currently maintained by a single developer, so a local backend provides a simpler setup. Remote state will become more appropriate when collaboration, state locking, and shared infrastructure management are required.

## Team considerations

* **Solo-pilot scale (today):** Local Terraform state, managed cloud services, and a single GCP environment minimize operational overhead and allow rapid iteration without additional infrastructure management.
* **Future-team scale (5 people, 18 months):** Infrastructure responsibilities can be separated into networking, Kubernetes platform, IAM, and database ownership, with remote Terraform state and CI/CD supporting collaborative development.
* **DORA archetype target:** This project targets a high-performing software delivery workflow by treating infrastructure as code, automating provisioning, and enabling repeatable deployments with minimal manual intervention.
* **Future TT team type:** A stream-aligned team owning the Incident Replay System would benefit from reusable Terraform modules and managed platform services while collaborating with a platform team responsible for shared cloud infrastructure.

## Data-layer capability tie (Outcome 7 — DORA AI Capability #2)

* **Data-layer property + Terraform resource:** Cloud SQL (PostgreSQL) configured through Terraform provides durable relational storage for incidents, replay metadata, timestamps, and audit records.
* **How W9 AI-ops will consume it:** The stored incident history and replay metadata provide structured operational data that can be queried and analyzed to identify recurring failures, detect operational trends, and support AI-assisted incident analysis.

## Integration seam (W3 -> W4 realization + W5 pre-provision)

* **W3 seam -> W4 Terraform realization:** Terraform provisions the GKE cluster, Cloud SQL instance, networking, IAM configuration, and Workload Identity resources that establish the infrastructure required for secure communication between application services and managed cloud resources.
* **W5 auth pre-provision (OIDC / workload identity):** Terraform provisions a Workload Identity Pool and its associated service account bindings so that the GitHub Actions pipeline in W5 can authenticate securely to GCP using short-lived federated credentials instead of long-lived service account keys.
