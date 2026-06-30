## Status

`accepted`

## Context

The primary users of the Incident Replay System are software engineers and platform teams who need to investigate production incidents quickly and accurately. The infrastructure decision being made is the selection of a cloud platform, state management approach, and Terraform configuration that will realize the target architecture defined in the W3 C4 Container diagram. GCP has been selected because GKE provides a managed Kubernetes platform with reduced operational overhead, while Cloud SQL provides managed PostgreSQL for persistent storage of incidents, replay metadata, and audit information. This decision is constrained by a lab budget of less than $10 per session, a solo-pilot development model, and the requirement to establish infrastructure that can support later work on CI/CD, observability, and security.

## Decision

> We will provision on GCP with local state, Terraform >= 1.9, and the Google provider pinned to `~> 7.0`. Local state is sufficient for the current solo-developer workflow, while provider version pinning ensures reproducible deployments and protects the project from unexpected breaking changes introduced by future provider releases.


## Consequences


**Positive:**
- TODO

**Negative:**
- TODO

**Neutral:**
- TODO

## Considered options



### Option A — TODO
- **What it is:** TODO
- **Why rejected:** TODO

### Option B — TODO
- **What it is:** TODO
- **Why rejected:** TODO

## Team considerations

<!--
Mon: SKIP. Thu lab Part A: FOUR distinct beats (not collapsible) — carries the W3 structure.
1. Solo-pilot scale (today) — what does being one person constrain/simplify in this IaC choice?
2. Future-team scale (5 people, 18 months) — which infra seam would they own separately?
3. DORA archetype — which 2025 archetype is this service targeting; why is the IaC choice compatible?
4. TT team type — if a 5-person team owned this, which type (stream-aligned / platform / enabling /
   complicated-subsystem); why does the IaC choice support that ownership?
Reverse Conway lens: your module structure (shared contract + cloud modules) is the first draft of
the future team's boundaries.
-->

- **Solo-pilot scale (today):** TODO
- **Future-team scale (5 people, 18 months):** TODO
- **DORA archetype target:** TODO
- **Future TT team type:** TODO

## Data-layer capability tie (Outcome 7 — DORA AI Capability #2)

<!--
Mon: SKIP. Thu lab Part A: name >= 1 data-layer property your infra/terraform/ configures that
DOWNSTREAM AI-ops work (W9) will consume. Examples: RDS parameter group with query logging on;
S3/GCS versioning for an audit trail; BigQuery time-partitioning; a managed vector/embedding store.
Name the property + which Terraform resource sets it + how W9 will consume it.
-->

- **Data-layer property + Terraform resource:** TODO
- **How W9 AI-ops will consume it:** TODO

## Integration seam (W3 -> W4 realization + W5 pre-provision)

<!--
Mon: SKIP. Thu lab Part A. Outcome 8 — two required rows:
1. W3 seam realized — take the seam from docs/architecture/tradeoffs.md + name the Terraform line(s)
   that pre-provision its infrastructure side.
2. W5 OIDC pre-provision — name the OIDC provider (AWS) / workload identity pool (GCP) your module
   creates, which W5's GitHub Actions pipeline consumes for cloud auth.
-->

- **W3 seam -> W4 Terraform realization:** TODO — <one sentence; the specific resource/attribute>
- **W5 auth pre-provision (OIDC / workload identity):** TODO — <the resource your module creates>

---
