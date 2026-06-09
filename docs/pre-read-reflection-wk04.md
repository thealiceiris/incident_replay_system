# W4 Pre-Read Reflection

<

**Learner:** Alice Iris Kare Acquah
**Date:** <YYYY-MM-DD>
**Due:** before the W4 Concept Socratic (delivered 2026-05-26; pre-read closes 08:00 GMT that day —
4bdu1 confirms the exact pin)

---

## Pre-read sources

~2.5 hr core (items 1-4) + 20 min DORA 2014 recap (item 5) + 30 min capstone prep (item 6) =
~3 hr core; ~4 hr with optional items 7+8. Deliberately lighter end of the range — W4 is build-heavy
(the Thu lab is tight), so keep energy for `terraform apply`.

| # | Source | Link | Time |
|---|---|---|---|
| 1 | HashiCorp — Terraform "Build infrastructure" tutorials (your chosen cloud) | https://developer.hashicorp.com/terraform/tutorials/aws-get-started OR /gcp-get-started | 60 min |
| 2 | Terraform Registry — chosen-cloud K8s module README + variables.tf + outputs.tf | terraform-aws-modules/eks/aws OR terraform-google-modules/kubernetes-engine/google | 30 min |
| 3 | HashiCorp — "Module Composition" + "Module Structure" tutorials | https://developer.hashicorp.com/terraform/tutorials/modules | 30 min |
| 4 | Checkov — Getting Started + Scanning Terraform + rule taxonomy | https://www.checkov.io/1.Welcome/Quick%20Start.html | 30 min |
| 5 | DORA 2014 — "Version Control for All Production Artifacts" (pp. 14-18) | recap from W1 | 20 min |
| 6 | Capstone cloud-path prep (cohort task) | review approved-scope-wk02 + W3 ADR(s); draft docs/adr/0002-iac-choices-draft.md (Status + Context + Decision) | 30 min |
| 7 | [OPTIONAL] HashiCorp — "Protect Sensitive Input Variables" | https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables | 20 min |
| 8 | [OPTIONAL] Kim "Three Ways" + Debois silo-friction recap | one-page refresher | 15 min |

---

## P1 — Cloud + capstone managed resource

> For your approved scope (docs/approved-scope-wk02.md), name the cloud you'll use (AWS or GCP) AND
> one cloud-specific managed resource beyond K8s you'll provision this week (managed Postgres /
> Redis / object store / secrets store / queue). One sentence on WHY your scope requires it — tie to
> real-users / persistent-state / meaningful-failure-surface from the W2 rubric.

<Cloud: GCP
Managed Resource: Cloud SQL for PostgreSQL
The incident replay system requires durable storage of ingested events so that incidents can be reconstructed after service failures or restarts. Cloud SQL provides persistent state and creates a meaningful failure surface because the system depends on accurate storage and retrieval of historical event data.
>
---

## P2 — W3 seam -> W4 Terraform realization

> Read your W3 tradeoff doc (docs/architecture/tradeoffs.md) section "Integration seams to watch."
> Name one seam you wrote at W3; then one sentence on HOW your W4 Terraform module will realize
> (pre-provision) the infrastructure side of it.
> Example: "W3 seam — service-to-service auth via OIDC. W4 realization — Terraform provisions the AWS
> IAM OIDC identity provider for GitHub Actions."

<W3 seam: The synchronous PostgreSQL dependency requires persistent storage, automated backups, and database monitoring to support reliable event ingestion.
W4 realization: Terraform provisions a Cloud SQL PostgreSQL instance with persistent storage and backup configuration alongside the GKE Autopilot cluster, establishing the infrastructure required for synchronous event ingestion and durable storage of incident events.
>

---

## P3 — Thu lab hook: Checkov prediction

> Read Checkov Getting Started + the 2-3 rules that apply to your chosen cloud's K8s resource (e.g.
> CKV_AWS_58 "EKS cluster has secrets encryption"; CKV_GCP_64 "GKE cluster uses private nodes").
> Draft a 3-line docs/security/checkov-wk04-plan.md naming the 2-3 rules you expect your module to
> FAIL on + one sentence each on why the rule is a reasonable default to enforce. You'll compare
> these predictions to the actual scan output in lab Part C.


<Rules I expect my Part-A module to FAIL (prediction)
CKV_GCP_64 — GKE cluster not configured with private nodes. Why it's a reasonable default to enforce: private nodes reduce the attack surface by preventing direct public access to worker nodes.
CKV_GCP_18 — GKE control plane is public. Why it's a reasonable default to enforce: restricting control-plane exposure reduces the risk of unauthorized administrative access and limits internet-facing infrastructure.
CKV_GCP_71 — Shielded GKE Nodes feature disabled. Why it's a reasonable default to enforce: Shielded Nodes provide secure boot, integrity monitoring, and protection against low-level malware and rootkits.>
- **Path to your committed prediction:** docs/security/checkov-wk04-plan.md

---

**Commit + push** on main. week-04-check CI does NOT gate on this file — it's a 4bdu1-review
artifact. CI gates on ai-journal/wk04-cross-cloud-translation.md (Sun-deliverable).
