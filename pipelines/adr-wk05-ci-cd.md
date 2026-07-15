# ADR: W5 CI/CD + Progressive Delivery choices

## Status

`proposed`

<!-- proposed (Mon) -> accepted (after Wed lab) -> superseded (if W6+ revisits). -->

## Context

The Incident Replay System (FastAPI + PostgreSQL, `src/backend/`) runs on GKE Autopilot with Cloud
SQL, provisioned in W4 (see `docs/adr/0002-iac-choices.md`). It has no delivery plane yet: merges to
`main` do not build, test, or deploy anything, and the API's users (SREs reconstructing incidents)
would be silently exposed to any regression pushed straight to the running pods. The specific risk
this ADR addresses is a bad deploy corrupting or blocking incident-replay data mid-investigation —
the one time this system must not be down is exactly when it's needed.

## Decision 1: CI tool + test-gate contract (Outcome 1)

> We will use GitHub Actions with a fail-closed test gate: unit + integration + lint + static
> analysis, OIDC cloud auth (no long-lived creds), JUnit XML published.

- **Test runner:** pytest (`src/backend/tests/`, SQLite-backed, 14 tests covering incident CRUD,
  event ingestion, and out-of-order replay timeline ordering)
- **Lint:** ruff
- **Static analysis:** mypy
- Branch protected: `main` (see `.github/branch-protection.yaml`), status check `test-gate`.

## Decision 2: Canary strategy + analysis SLI (Outcome 2)

> We will use Argo Rollouts canary (20% → analysis → 50% → analysis → 100%) with auto-rollback,
> gated on the following SLI:

- **Canary SLI:** pod-restart count
- **failureCondition:** more than 2 pod restarts across the `incident-replay` pods during the
  analysis window (implemented via the `job` provider's exit code — see
  `deploy/rollouts/analysis-template.yaml`, since there is no metrics endpoint to scrape yet)
- **Why this SLI fits my capstone's failure modes:** this service's dominant failure mode is a bad
  Cloud SQL migration or an unreachable database at startup, which crash-loops the FastAPI
  container (`Base.metadata.create_all` runs in `main.py`'s `lifespan` startup — a failed connection
  there kills the pod). A pod-restart count catches that directly. It would false-negative on a
  service that degrades without crashing (e.g. slow queries), which this SLI does not cover — that
  gap is the reason W6's Prometheus-based SLI work matters.

## Decision 3: Feature-flag layer + wrap location (Outcome 3)

> We will use OpenFeature + flagd (local provider) and wrap the following feature:

- **Feature / handler I will flag-wrap in Part C:** `PATCH /incidents/{incident_id}` in
  `src/backend/main.py` (`update_incident_status`). It currently accepts any string as the new
  `status` with no validation against `{"active", "investigating", "resolved"}`.
- **Flag key (in deploy/flags/flags.json):** `strict-status-validation`
- **Why this feature (what does decoupling deploy-from-release de-risk here?):** shipping stricter
  validation is low-risk in isolation, but if some caller depends on the current permissive behavior
  (e.g. a client sending a status value outside the three known ones), a flag lets the validation
  ship in the deployed artifact while staying off until confirmed safe, and lets it be switched back
  off instantly via `make flag-flip` without a redeploy or a rollback through the canary.

## Consequences

**Positive:**
- A red test/lint/type-check run now blocks merges to `main`, rather than surfacing as a runtime bug.
- The canary + auto-rollback means a startup crash-loop caused by a bad deploy self-heals without
  manual intervention.
- The flag layer separates "is this code safe to ship" from "should users see this behavior yet,"
  which the status-validation change specifically benefits from.

**Negative:**
- The `job`-provider analysis step depends on RBAC (`get`/`list` on pods in `staging`) that is not
  yet provisioned by the W4 Terraform stack — first Wed-lab run will likely fail on permissions
  before it fails on the SLI itself.
- Pod-restart count is a coarse SLI; it will not catch degraded-but-not-crashing failures (slow
  queries, elevated latency), which is an accepted gap until W6.
- 10-replica canary steps add real GKE Autopilot pod-second cost on every deploy, compared to a
  plain rolling-update Deployment.

**Neutral:**
- The `web` provider (HTTP SLI endpoint) was left unused in favor of `job` (kubectl-based); revisiting
  this once the app exposes a real `/metrics`-style endpoint is a natural W6 follow-up, not a rework.
- `deploy/kustomization.yaml` does not yet bundle a Service/Ingress manifest — GKE Autopilot's
  pod-count canary approximation does not require one this week.

## Considered options

### Option A: `web` provider (HTTP SLI endpoint) instead of `job`
- **What it is:** add a small endpoint to the FastAPI app (or a sidecar) that reports an error-rate
  or restart-count as JSON, and have the AnalysisTemplate's `web` provider parse it via `jsonPath`.
- **Why rejected:** the app has no such endpoint today, and building one is a bigger lift than
  reading pod-restart counts directly through `kubectl` from a Job. The `job` provider gets the same
  pod-restart signal for W5 with no new application code; the `web` shape is deferred to W6 when
  Prometheus makes it the natural provider anyway.

### Option B: 5xx-rate as the canary SLI instead of pod-restart count
- **What it is:** gate the canary on the proportion of 5xx responses observed during the analysis
  window, matching the skeleton's recommended default.
- **Why rejected:** without Prometheus or an access-log aggregator running yet, there is no cheap way
  to compute a live 5xx ratio this week. Pod-restart count needs only `kubectl`, which is already
  available to the deploy job, and it directly targets this service's most likely failure mode
  (startup crash-loop on a bad DB connection/migration).

---

<!--
PRE-COMMIT CHECKLIST:
- [x] Status set (proposed Mon; accepted after Wed lab)
- [x] Context names the service + W4 cloud + deploy-safety problem
- [x] Decision 1: CI tool + test runner + lint + static analysis + OIDC
- [x] Decision 2: canary SLI + failureCondition + capstone-specific justification
- [x] Decision 3: feature/handler to wrap + flag key + what it de-risks
- [x] Consequences ≥ 3 bullets; Considered options ≥ 1 rejected alternative

This ADR is a Peer Review 1 acceptance item. Flip Status to `accepted` after the Wed lab confirms (or
revises) these decisions as you build them.
-->
