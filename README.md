# Incident Replay System

A small FastAPI + PostgreSQL service that captures everything that happens during a production
incident — logs, metrics, alerts, deploys — and replays it back as a single, correctly-ordered
timeline, even when the underlying signals arrive out of order.

## Why

During an outage, an SRE reconstructing what happened is working against signals that are
scattered across tools and often arrive late or out of sequence. This system exists to solve one
problem well: store every event tied to an incident, and answer "what actually happened, and in
what order?" reliably.

## Architecture

- **API:** FastAPI, single service (ingestion and replay share one deployable — see
  [`docs/adr/0004-consolidate-ingestion-and-replay-into-single-service.md`](docs/adr/0004-consolidate-ingestion-and-replay-into-single-service.md)).
- **Storage:** PostgreSQL, written to synchronously in the request path (no queue) — see
  [`docs/adr/0001-synchronous-postgres-ingestion.md`](docs/adr/0001-synchronous-postgres-ingestion.md).
- **Framework choice:** FastAPI over Flask/Express/Django — see
  [`docs/adr/0003-api-framework.md`](docs/adr/0003-api-framework.md).
- **Cloud:** GKE Autopilot + Cloud SQL on GCP, provisioned with Terraform — see
  [`docs/adr/0002-iac-choices.md`](docs/adr/0002-iac-choices.md).
- **Delivery:** GitHub Actions CI, Argo Rollouts canary deploys, OpenFeature/flagd feature flags —
  see [`pipelines/adr-wk05-ci-cd.md`](pipelines/adr-wk05-ci-cd.md).
- Full tradeoff writeups and the C4 diagrams live under [`docs/architecture/`](docs/architecture/).

The core design choice throughout: everything is optimized for a solo developer at moderate load,
not for horizontal scale. Every ADR above names what that costs and what the reversal path looks
like.

## Data model

Two tables ([`src/backend/models.py`](src/backend/models.py)):

- **`Incident`** — one row per tracked incident: `name`, `status`
  (`active` / `investigating` / `resolved`), `created_at`.
- **`Event`** — one row per thing that happened during an incident, linked by `incident_id`. Each
  event carries two timestamps: `timestamp` (when it actually occurred) and `received_at` (when
  this system found out about it) — the replay timeline sorts on the former, which is what makes
  out-of-order ingestion safe.

## Local setup

Requires Docker and Docker Compose.

```bash
docker-compose up
```

This starts PostgreSQL on `localhost:5432`, applies pending Alembic migrations, and starts the
API on `http://localhost:8000` (interactive docs at `/docs`) — one command, no manual migration
step. See [`src/backend/README.md`](src/backend/README.md) for running the API without Docker,
resetting the local database, and deploying the image to GCP.

### Migrations

Schema changes are managed with Alembic (`src/backend/alembic/`), not `create_all` — this is
what makes `docker-compose up` repeatable from a clean database.

```bash
cd src/backend
alembic upgrade head                              # apply pending migrations
alembic revision --autogenerate -m "description"   # generate a new migration after a models.py change
```

## Running the tests

```bash
cd src/backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements-dev.txt
pytest tests/ -v
```

14+ tests cover incident creation, event ingestion and validation, out-of-order replay ordering,
and the `strict-status-validation` feature-flag behavior (flag off = permissive, matching
pre-flag behavior; flag on = rejects unknown status values).

## API examples

```bash
# Create an incident
curl -X POST http://localhost:8000/incidents \
  -H "Content-Type: application/json" \
  -d '{"name": "Database connection pool exhausted"}'

# Ingest an event (timestamp = when it actually happened, not when it arrived)
curl -X POST http://localhost:8000/incidents/{INCIDENT_ID}/events \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "log",
    "timestamp": "2024-01-15T10:05:00Z",
    "source": "api-service",
    "data": {"level": "ERROR", "message": "Connection pool exhausted"}
  }'

# Replay the ordered timeline for one incident
curl http://localhost:8000/incidents/{INCIDENT_ID}/timeline

# Replay events sharing a trace ID, across incidents
curl http://localhost:8000/traces/{TRACE_ID}/timeline
```

`trace_id`/`span_id` are optional on event ingestion; when set, `GET /traces/{trace_id}/timeline`
correlates events across incidents by trace, ordered by when they actually occurred. Full endpoint
reference (including `PATCH` status updates and `GET /incidents`) is in
[`src/backend/README.md`](src/backend/README.md).

## Delivery pipeline

- **CI** (`.github/workflows/ci.yaml`): test + lint + type-check gate on every push/PR.
- **Deploy** (`.github/workflows/deploy-staging.yaml`): OIDC-authenticated (no static cloud
  credentials) deploy to GKE staging.
- **Progressive delivery** (`deploy/rollouts/`): Argo Rollouts canary — 20% → analysis → 50% →
  analysis → 100%, auto-rollback on failed analysis.
- **Feature flags** (`deploy/flags/`): OpenFeature + flagd, decoupling "deployed" from "released"
  for risky changes like stricter status validation.

## Known limitations

- No authentication or authorization on any endpoint.
- No queue/buffer in front of PostgreSQL — a slow or unavailable database directly increases
  ingestion latency (a deliberate tradeoff for solo-developer simplicity; see
  [`docs/architecture/tradeoffs.md`](docs/architecture/tradeoffs.md)).
- Canary analysis currently gates on pod-restart count only (no Prometheus yet), so it catches
  crash-loops but not degraded-without-crashing failures — see Decision 2 in
  [`pipelines/adr-wk05-ci-cd.md`](pipelines/adr-wk05-ci-cd.md).
- `deploy-staging.yaml`'s OIDC auth step still has a literal `<GCP_PROJECT_NUMBER>` placeholder
  pending a real Terraform/`gcloud` value.

## Project planning

Session-by-session task breakdown and the 3-week delivery plan live under
[`docs/project_plan/`](docs/project_plan/).
