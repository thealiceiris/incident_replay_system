# Incident Replay System

## 3 Week Project Plan

| Planning Item | Decision |
| --- | --- |
| Delivery window | 3 weeks |
| Primary outcome | Working incident ingestion and replay API |
| Core stack | FastAPI, PostgreSQL, Docker Compose |
| Cloud path | GCP, GKE Autopilot, Cloud SQL, GCS |
| Delivery style | Local-first MVP, deploy-ready infrastructure |
| Deferred scope | Redis Streams, Kafka, full frontend, advanced AI summaries |

## Weekly Milestones

| Week | Focus | Exit Criteria |
| --- | --- | --- |
| Week 1 | Core local system | Local API, PostgreSQL, migrations, ingestion, replay, tests |
| Week 2 | CI, infrastructure, security | Docker, CI, Terraform validation, Checkov notes, completed IaC ADR |
| Week 3 | Polish and demo | Final README, examples, demo script, clean docs, final verification |

## Purpose

The Incident Replay System helps SREs, backend engineers, and platform teams reconstruct production incidents from ordered logs, trace IDs, timestamps, service metadata, and replay annotations.

The project should prove one clear workflow:

1. A service sends incident or trace events to an ingestion API.
2. The ingestion API validates and stores events synchronously in PostgreSQL.
3. A replay API returns an ordered incident timeline.
4. The system is deployable through Terraform-managed GCP infrastructure and a GitHub Actions pipeline.
5. Security, observability, and operational tradeoffs are documented well enough for capstone review.

## Current Decisions From ADRs

- Architecture uses synchronous PostgreSQL ingestion rather than Redis Streams or Kafka.
- PostgreSQL is the primary dependency for both ingestion and replay.
- The system is optimized for a solo developer and moderate load, not high-volume streaming.
- GCP is the selected cloud platform.
- Terraform provisions GKE Autopilot, Cloud SQL PostgreSQL, a GCS data bucket, and GitHub Actions Workload Identity Federation.
- CI/CD should use keyless GCP auth through Workload Identity Federation rather than static cloud keys.
- Future async buffering remains a known extension seam, but it is out of scope for this 3 week delivery window.

## Target MVP Scope

### In Scope

- FastAPI ingestion API.
- FastAPI replay API.
- PostgreSQL schema for incidents, events, services, and replay metadata.
- Local Docker Compose environment for API and PostgreSQL.
- Terraform validation and Checkov scanning.
- GCP infrastructure documentation and deploy path.
- GitHub Actions workflow for tests, linting, Terraform validation, image build, and deploy readiness.
- Basic observability: structured logs, health endpoints, and database query logging.
- Seed data and a repeatable demo scenario.
- Capstone documentation: README, ADRs, architecture diagrams, tradeoffs, security notes, and final demo script.

### Out Of Scope For This Delivery

- Redis Streams, Kafka, or asynchronous workers.
- Multi-tenant authorization.
- Full frontend dashboard.
- Advanced AI incident summarization.
- Production-grade autoscaling and high availability.
- Long-term data warehouse analytics.

## Acceptance Criteria

The project is complete when these are true:

- A reviewer can run the app locally with one documented command.
- The ingestion API accepts valid events and rejects malformed payloads.
- The replay API returns a correctly ordered incident timeline by incident ID or trace ID.
- PostgreSQL migrations are repeatable from a clean database.
- Automated tests cover validation, persistence, ordering, and replay queries.
- CI passes on pull requests.
- Terraform runs `fmt`, `validate`, and Checkov scan locally.
- The GCP infrastructure plan is documented with cost and security tradeoffs.
- The README explains the system, architecture, setup, API examples, test commands, and demo flow.
- The final demo shows ingestion, storage, replay, and operational reasoning.

## System Shape

### Containers

- Ingestion API Service: FastAPI service that receives events, validates payloads, deduplicates where practical, and writes to PostgreSQL.
- Replay API Service: FastAPI service that queries PostgreSQL and returns ordered incident timelines.
- PostgreSQL: Stores incidents, events, trace IDs, timestamps, metadata, and replay notes.
- GCP Infrastructure: GKE Autopilot for runtime, Cloud SQL for PostgreSQL, GCS for retained incident artifacts, and Workload Identity Federation for CI/CD.

### Suggested Repository Structure

```text
app/
  ingestion/
  replay/
  shared/
  tests/
db/
  migrations/
  seed/
infra/
  terraform/
docs/
  adr/
  architecture/
  project_plan/
  security/
scripts/
```

## Data Model

### incidents

- `id`: UUID primary key.
- `title`: short incident title.
- `severity`: enum or constrained string, such as `sev1`, `sev2`, `sev3`.
- `status`: `open`, `investigating`, `resolved`.
- `started_at`: timestamp with timezone.
- `resolved_at`: nullable timestamp with timezone.
- `created_at`: timestamp with timezone.

### incident_events

- `id`: UUID primary key.
- `incident_id`: foreign key to `incidents`.
- `trace_id`: nullable string.
- `span_id`: nullable string.
- `service_name`: required string.
- `event_type`: constrained string, such as `log`, `metric`, `deploy`, `alert`, `error`.
- `severity`: constrained string.
- `message`: event message.
- `occurred_at`: timestamp with timezone used for replay ordering.
- `received_at`: timestamp with timezone used for ingestion auditing.
- `metadata`: JSONB.
- `dedupe_key`: nullable unique key for duplicate suppression.

### replay_notes

- `id`: UUID primary key.
- `incident_id`: foreign key to `incidents`.
- `author`: string.
- `note`: text.
- `created_at`: timestamp with timezone.

## API Plan

### Health

- `GET /health`
- Returns service status and database connectivity.

### Create Incident

- `POST /incidents`
- Creates an incident record.
- Required fields: `title`, `severity`, `started_at`.

### Ingest Event

- `POST /events`
- Validates and stores one incident event.
- Required fields: `incident_id`, `service_name`, `event_type`, `severity`, `message`, `occurred_at`.
- Optional fields: `trace_id`, `span_id`, `metadata`, `dedupe_key`.

### Batch Ingest Events

- `POST /events/batch`
- Accepts a bounded list of events.
- Returns accepted and rejected counts.

### Replay Timeline

- `GET /incidents/{incident_id}/timeline`
- Returns events ordered by `occurred_at`, then `received_at`, then `id`.

### Trace Replay

- `GET /traces/{trace_id}/timeline`
- Returns events across incidents for one trace ID.

### Replay Notes

- `POST /incidents/{incident_id}/notes`
- `GET /incidents/{incident_id}/notes`

## Delivery Plan

## Week 1: Core Local System

### Goal

Have a working local system that can create incidents, ingest events, persist them in PostgreSQL, and replay an ordered timeline.

### Deliverables

- Local app skeleton.
- PostgreSQL schema and migrations.
- Ingestion endpoint.
- Replay endpoint.
- Docker Compose setup.
- Unit and integration tests for the core flow.

### Work Checklist

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Create `app/` package structure for ingestion, replay, shared config, database, and tests. |
| <input type="checkbox"> | Add Python project metadata and dependencies for FastAPI, PostgreSQL driver, migrations, testing, and linting. |
| <input type="checkbox"> | Add Docker Compose with PostgreSQL and local API service. |
| <input type="checkbox"> | Create database migration for `incidents`. |
| <input type="checkbox"> | Create database migration for `incident_events`. |
| <input type="checkbox"> | Create database migration for `replay_notes`. |
| <input type="checkbox"> | Add database connection helper using environment variables. |
| <input type="checkbox"> | Add request validation helpers for required fields, timestamps, severity, and event type. |
| <input type="checkbox"> | Implement `GET /health`. |
| <input type="checkbox"> | Implement `POST /incidents`. |
| <input type="checkbox"> | Implement `POST /events`. |
| <input type="checkbox"> | Implement `POST /events/batch` with a safe maximum batch size. |
| <input type="checkbox"> | Implement `GET /incidents/{incident_id}/timeline`. |
| <input type="checkbox"> | Implement `GET /traces/{trace_id}/timeline`. |
| <input type="checkbox"> | Add seed data for one realistic incident scenario. |
| <input type="checkbox"> | Add tests for incident creation. |
| <input type="checkbox"> | Add tests for valid event ingestion. |
| <input type="checkbox"> | Add tests for invalid event rejection. |
| <input type="checkbox"> | Add tests for replay ordering when events arrive out of order. |
| <input type="checkbox"> | Add tests for duplicate `dedupe_key` behavior. |
| <input type="checkbox"> | Update README with local setup and API examples. |

### Week 1 Definition Of Done

- `docker compose up` starts the database and API.
- A seed incident can be loaded.
- A replay timeline returns events in the correct order.
- Tests pass locally.
- README has enough detail for a reviewer to run the core workflow.

## Week 2: Infrastructure, CI/CD, And Security

### Goal

Turn the local system into a deployable capstone with CI checks, container build, Terraform validation, and security documentation.

### Deliverables

- Dockerfile.
- GitHub Actions CI workflow.
- Terraform cleanup and validation.
- Checkov scan results and remediation notes.
- GCP deployment readiness documentation.
- Completed IaC ADR.

### Work Checklist

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add production-oriented Dockerfile for the FastAPI service. |
| <input type="checkbox"> | Add `.dockerignore`. |
| <input type="checkbox"> | Add GitHub Actions workflow for tests and linting. |
| <input type="checkbox"> | Add GitHub Actions workflow step for Docker image build. |
| <input type="checkbox"> | Add GitHub Actions workflow step for Terraform fmt and validate. |
| <input type="checkbox"> | Confirm Terraform state files are ignored and not tracked. |
| <input type="checkbox"> | Replace hardcoded Terraform project ID with a variable. |
| <input type="checkbox"> | Remove default plaintext database password from Terraform variables. |
| <input type="checkbox"> | Confirm Cloud SQL flags match the observability plan. |
| <input type="checkbox"> | Confirm GCS lifecycle rules match the retention plan. |
| <input type="checkbox"> | Confirm Workload Identity Federation repository condition matches the GitHub repository. |
| <input type="checkbox"> | Run Terraform `fmt`. |
| <input type="checkbox"> | Run Terraform `validate`. |
| <input type="checkbox"> | Run Checkov against `infra/terraform`. |
| <input type="checkbox"> | Document at least one security finding fixed. |
| <input type="checkbox"> | Document at least one security finding consciously deferred with rationale. |
| <input type="checkbox"> | Complete ADR 0002 consequences, options, team considerations, data-layer tie, and integration seam. |
| <input type="checkbox"> | Update `docs/architecture/w3-to-w4-integration-seam.md` with GCP-specific wording instead of generic AWS/GCP examples. |
| <input type="checkbox"> | Add deployment runbook draft for GCP. |
| <input type="checkbox"> | Add rollback notes for application deployment and database migrations. |

### Week 2 Definition Of Done

- CI runs tests and infrastructure checks.
- Terraform configuration is clean enough for review.
- ADR 0002 has no TODO placeholders.
- Security plan uses real Checkov IDs and clean wording.
- GCP deployment path is documented even if the final app is demonstrated locally.

## Week 3: Polish, Demo, And Capstone Readiness

### Goal

Make the project easy to review, easy to demo, and coherent as a capstone artifact.

### Deliverables

- Final README.
- Demo script.
- API examples.
- Final architecture documentation.
- Test evidence.
- Final project checklist.

### Work Checklist

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add a realistic incident replay demo scenario, such as failed deploy causing elevated 500 errors. |
| <input type="checkbox"> | Add seed script or fixture for the demo incident. |
| <input type="checkbox"> | Add curl examples for creating an incident. |
| <input type="checkbox"> | Add curl examples for ingesting normal, warning, and error events. |
| <input type="checkbox"> | Add curl examples for replay by incident ID. |
| <input type="checkbox"> | Add curl examples for replay by trace ID. |
| <input type="checkbox"> | Add sample JSON response files under `docs/examples/`. |
| <input type="checkbox"> | Add screenshots or terminal transcript for the demo flow if required by the course. |
| <input type="checkbox"> | Add final C4 context and container diagrams in reviewer-friendly markdown. |
| <input type="checkbox"> | Add final tradeoffs summary connected to the ADRs. |
| <input type="checkbox"> | Add operational notes for health checks, logging, database dependency, and failure behavior. |
| <input type="checkbox"> | Add known limitations section. |
| <input type="checkbox"> | Add future roadmap section covering Redis Streams or Kafka, frontend dashboard, auth, and AI summaries. |
| <input type="checkbox"> | Run the full local test suite from a clean checkout state. |
| <input type="checkbox"> | Run Docker Compose from scratch and verify the demo flow. |
| <input type="checkbox"> | Run Terraform fmt, validate, and Checkov one final time. |
| <input type="checkbox"> | Fix stale TODOs, skeleton comments, placeholder angle brackets, and duplicated wording. |
| <input type="checkbox"> | Record final commands and expected outputs in README. |
| <input type="checkbox"> | Create final submission checklist. |

### Week 3 Definition Of Done

- A reviewer can understand the system in under 5 minutes from the README.
- The demo can be completed without improvising missing setup.
- All required docs connect to the same architecture story.
- The capstone shows both implementation ability and operational judgment.

## Daily Work Rhythm

Use this lightweight loop each work session:

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Pick no more than three tasks from the current week. |
| <input type="checkbox"> | Create or update one small feature branch. |
| <input type="checkbox"> | Run the narrowest relevant test before committing. |
| <input type="checkbox"> | Update docs while the implementation context is fresh. |
| <input type="checkbox"> | End the session by writing the next exact command or task in a note. |

## Risk Register

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Scope expands into queues, AI, or frontend | Core delivery slips | Keep MVP API-first and defer async buffering |
| Terraform/GCP issues consume too much time | App implementation suffers | Treat GCP deploy as documented readiness unless full deploy is required |
| PostgreSQL schema changes late | Replay behavior breaks | Add migrations and integration tests in Week 1 |
| README is left until the end | Reviewer cannot run the app | Update README each week |
| Checkov findings pile up | Security docs look unfinished | Run scan in Week 2 and document fix/defer decisions |
| Demo depends on manual data entry | Demo becomes unreliable | Use seed scripts and checked-in JSON examples |

## Priority Order If Time Gets Tight

1. Local ingestion and replay flow.
2. PostgreSQL schema, migrations, and tests.
3. README with setup, API examples, and demo.
4. CI test workflow.
5. Terraform validation and security docs.
6. Full GCP deployment.
7. Extra polish, screenshots, and stretch features.

## Stretch Goals

- Add simple API key authentication.
- Add OpenAPI specification.
- Add pagination and filtering for timelines.
- Add basic frontend timeline view.
- Add incident summary generation as a documented future AI-ops capability.
- Add Redis Streams design note as an ADR extension, without implementing it.
