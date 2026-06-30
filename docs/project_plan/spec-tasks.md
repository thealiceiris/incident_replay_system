# Incident Replay System — Spec Task Breakdown

Small, atomic tasks derived from the 3-week project plan.
Each task has a clear input, a clear done state, and fits inside one sitting.
Work top to bottom. Week 1 must be complete before Week 2 tasks are meaningful.

---

## How To Use This File

- Pick one block per work session.
- A task is done when you can verify it with a command, a passing test, or a visible file.
- Mark `[ ]` → `[x]` as you go.
- Do not skip a task without writing a one-line reason next to it.

---

## Week 1 — Core Local System

### W1-1 Repository Skeleton

- [ ] Create `app/__init__.py` (empty, marks package root).
- [ ] Create `app/ingestion/__init__.py`.
- [ ] Create `app/replay/__init__.py`.
- [ ] Create `app/shared/__init__.py`.
- [ ] Create `app/db/__init__.py`.
- [ ] Create `app/tests/__init__.py`.
- [ ] Create `db/migrations/` directory with a `.gitkeep`.
- [ ] Create `db/seed/` directory with a `.gitkeep`.
- [ ] Verify: `find app -name "*.py" | sort` returns all six `__init__.py` files.

### W1-2 Python Dependencies

- [ ] Create `pyproject.toml` at the repo root.
- [ ] Add `fastapi>=0.111,<0.112` to dependencies.
- [ ] Add `uvicorn[standard]>=0.29,<0.30` to dependencies.
- [ ] Add `psycopg2-binary>=2.9,<3.0` to dependencies.
- [ ] Add `alembic>=1.13,<2.0` to dependencies.
- [ ] Add `pydantic>=2.7,<3.0` to dependencies.
- [ ] Add `python-dotenv>=1.0,<2.0` to dependencies.
- [ ] Add `pytest>=8.2,<9.0`, `httpx>=0.27,<0.28`, `pytest-cov>=5.0,<6.0` as dev dependencies.
- [ ] Add `ruff>=0.4,<0.5` as a dev dependency for linting and formatting.
- [ ] Verify: `pip install -e ".[dev]"` completes without errors.

### W1-3 Docker Compose

- [ ] Create `docker-compose.yml` at the repo root.
- [ ] Add a `postgres` service using image `postgres:16`.
- [ ] Set `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` in the postgres service.
- [ ] Mount a named volume `pgdata` so the database survives restarts.
- [ ] Add an `api` service that builds from `.` and depends on `postgres`.
- [ ] Pass `DATABASE_URL` as an environment variable to the api service.
- [ ] Expose port `8000` on the api service.
- [ ] Create `.env.example` documenting all required environment variables.
- [ ] Verify: `docker compose up postgres -d` starts without errors.
- [ ] Verify: `docker compose ps` shows postgres as healthy.

### W1-4 Database Connection Helper

- [ ] Create `app/db/connection.py`.
- [ ] Read `DATABASE_URL` from environment using `os.environ` or `python-dotenv`.
- [ ] Expose a `get_connection()` function that returns a `psycopg2` connection.
- [ ] Expose a `get_db()` generator for FastAPI dependency injection.
- [ ] Raise a clear error if `DATABASE_URL` is not set.
- [ ] Verify: importing the module with no env var set raises `RuntimeError` or `KeyError`, not a silent `None`.

### W1-5 Alembic Setup And Migrations

- [ ] Run `alembic init db/migrations` to generate the alembic scaffold.
- [ ] Edit `db/migrations/env.py` to read `DATABASE_URL` from the environment.
- [ ] Create migration `0001_create_incidents`:
  - `id` UUID primary key, default `gen_random_uuid()`.
  - `title` VARCHAR(255) NOT NULL.
  - `severity` VARCHAR(20) NOT NULL, check in `('sev1','sev2','sev3')`.
  - `status` VARCHAR(20) NOT NULL DEFAULT `'open'`, check in `('open','investigating','resolved')`.
  - `started_at` TIMESTAMPTZ NOT NULL.
  - `resolved_at` TIMESTAMPTZ NULL.
  - `created_at` TIMESTAMPTZ NOT NULL DEFAULT `now()`.
- [ ] Create migration `0002_create_incident_events`:
  - `id` UUID primary key.
  - `incident_id` UUID NOT NULL, foreign key → `incidents(id)`.
  - `trace_id` VARCHAR(128) NULL.
  - `span_id` VARCHAR(128) NULL.
  - `service_name` VARCHAR(128) NOT NULL.
  - `event_type` VARCHAR(32) NOT NULL, check in `('log','metric','deploy','alert','error')`.
  - `severity` VARCHAR(20) NOT NULL.
  - `message` TEXT NOT NULL.
  - `occurred_at` TIMESTAMPTZ NOT NULL.
  - `received_at` TIMESTAMPTZ NOT NULL DEFAULT `now()`.
  - `metadata` JSONB NULL DEFAULT `'{}'`.
  - `dedupe_key` VARCHAR(255) NULL UNIQUE.
  - Index on `(incident_id, occurred_at)`.
  - Index on `trace_id`.
- [ ] Create migration `0003_create_replay_notes`:
  - `id` UUID primary key.
  - `incident_id` UUID NOT NULL, foreign key → `incidents(id)`.
  - `author` VARCHAR(128) NOT NULL.
  - `note` TEXT NOT NULL.
  - `created_at` TIMESTAMPTZ NOT NULL DEFAULT `now()`.
- [ ] Verify: `alembic upgrade head` against local postgres applies all three migrations with no errors.
- [ ] Verify: `alembic downgrade base` reverts all three migrations cleanly.

### W1-6 Shared Pydantic Models

- [ ] Create `app/shared/models.py`.
- [ ] Add `IncidentCreate` model: `title` (str, required), `severity` (literal `sev1|sev2|sev3`), `started_at` (datetime).
- [ ] Add `IncidentResponse` model: all fields from schema plus `id`, `status`, `created_at`.
- [ ] Add `EventCreate` model: `incident_id` (UUID), `service_name`, `event_type` (literal), `severity` (literal), `message`, `occurred_at` (datetime), optional `trace_id`, `span_id`, `metadata` (dict), `dedupe_key`.
- [ ] Add `EventResponse` model: all fields from schema plus `id`, `received_at`.
- [ ] Add `NoteCreate` model: `author`, `note`.
- [ ] Add `NoteResponse` model: all fields plus `id`, `created_at`.
- [ ] Add `TimelineResponse` model: `incident_id` (optional), `trace_id` (optional), `events` (list of `EventResponse`).
- [ ] Add `HealthResponse` model: `status` (str), `database` (str), `version` (str).
- [ ] Add `BatchEventRequest` model: `events` list with max length 500.
- [ ] Add `BatchEventResponse` model: `accepted` (int), `rejected` (int), `errors` (list of str).
- [ ] Verify: `python -c "from app.shared.models import IncidentCreate"` runs without error.

### W1-7 FastAPI Application Entrypoint

- [ ] Create `app/main.py`.
- [ ] Instantiate a `FastAPI` app with `title="Incident Replay API"` and `version="0.1.0"`.
- [ ] Register ingestion router with prefix `/`.
- [ ] Register replay router with prefix `/`.
- [ ] Add a startup log line that prints the database URL host (not the password).
- [ ] Create `app/ingestion/router.py` and register it.
- [ ] Create `app/replay/router.py` and register it.
- [ ] Verify: `uvicorn app.main:app --reload` starts and `/docs` loads in a browser.

### W1-8 Health Endpoint

- [ ] Add `GET /health` to `app/ingestion/router.py` (or a dedicated `app/shared/router.py`).
- [ ] Execute a `SELECT 1` against postgres in the handler.
- [ ] Return `{"status": "ok", "database": "ok", "version": "0.1.0"}` on success.
- [ ] Return `{"status": "ok", "database": "error", "version": "0.1.0"}` with HTTP 200 if postgres is unreachable (degraded, not down).
- [ ] Verify: `curl http://localhost:8000/health` returns JSON with `"status": "ok"`.

### W1-9 Incident API

- [ ] Create `app/ingestion/incidents.py` with `POST /incidents` handler.
- [ ] Validate request body with `IncidentCreate`.
- [ ] Insert row into `incidents`, return `IncidentResponse` with HTTP 201.
- [ ] Return HTTP 422 with field details on validation failure (FastAPI default).
- [ ] Return HTTP 409 if the same `title` + `started_at` already exists (optional deduplication guard).
- [ ] Add `GET /incidents/{incident_id}` returning the incident or HTTP 404.
- [ ] Register both routes in `app/ingestion/router.py`.
- [ ] Verify: `POST /incidents` with valid body returns 201 and a UUID `id`.
- [ ] Verify: `POST /incidents` with missing `title` returns 422.

### W1-10 Event Ingestion API

- [ ] Create `app/ingestion/events.py` with `POST /events` handler.
- [ ] Validate with `EventCreate`.
- [ ] Reject `incident_id` that does not exist in `incidents` → HTTP 404 with clear message.
- [ ] On duplicate `dedupe_key`, return HTTP 200 with `{"deduplicated": true}` instead of inserting.
- [ ] Insert event, return `EventResponse` with HTTP 201.
- [ ] Add `POST /events/batch` accepting `BatchEventRequest` (max 500 events).
- [ ] Process each event independently; collect successes and failures.
- [ ] Return `BatchEventResponse` with `accepted`, `rejected`, `errors` list.
- [ ] Register both routes in `app/ingestion/router.py`.
- [ ] Verify: valid `POST /events` returns 201.
- [ ] Verify: `POST /events` with unknown `incident_id` returns 404.
- [ ] Verify: second `POST /events` with same `dedupe_key` returns 200 with `"deduplicated": true`.
- [ ] Verify: `POST /events/batch` with 3 valid + 1 invalid returns `accepted: 3, rejected: 1`.

### W1-11 Replay API

- [ ] Create `app/replay/timeline.py`.
- [ ] Implement `GET /incidents/{incident_id}/timeline`.
  - Query `incident_events` where `incident_id = ?`.
  - Order by `occurred_at ASC, received_at ASC, id ASC`.
  - Return `TimelineResponse`.
  - Return HTTP 404 if incident does not exist.
- [ ] Implement `GET /traces/{trace_id}/timeline`.
  - Query `incident_events` where `trace_id = ?`.
  - Same ordering.
  - Return HTTP 404 if no events found for trace.
- [ ] Register both routes in `app/replay/router.py`.
- [ ] Verify: after seeding, `GET /incidents/{id}/timeline` returns events oldest-first.
- [ ] Verify: events inserted out of order are returned in `occurred_at` order, not insertion order.

### W1-12 Replay Notes API

- [ ] Create `app/replay/notes.py`.
- [ ] Implement `POST /incidents/{incident_id}/notes`.
  - Validate with `NoteCreate`.
  - Return 404 if incident does not exist.
  - Return `NoteResponse` with HTTP 201.
- [ ] Implement `GET /incidents/{incident_id}/notes`.
  - Return list of `NoteResponse` ordered by `created_at ASC`.
  - Return empty list (not 404) if no notes exist.
- [ ] Register both routes in `app/replay/router.py`.
- [ ] Verify: `POST /incidents/{id}/notes` returns 201.
- [ ] Verify: `GET /incidents/{id}/notes` returns the note just created.

### W1-13 Seed Data Script

- [ ] Create `db/seed/incident_scenario.py`.
- [ ] Define one incident: `"Payment service degradation — elevated 500s after deploy"`, severity `sev2`, `started_at` set to a fixed past timestamp.
- [ ] Define at least 8 events across 3 services (`payments-api`, `order-service`, `gateway`):
  - 1 `deploy` event on `payments-api` (the trigger).
  - 2 `metric` events showing error rate rising.
  - 2 `error` events with stack trace snippets.
  - 1 `alert` event from a PagerDuty analogue.
  - 1 `log` event showing the first investigator note.
  - 1 `log` event showing the rollback command.
- [ ] Use a shared `trace_id` across at least 3 events.
- [ ] Insert events intentionally out of chronological order to prove replay sorting works.
- [ ] Add a `if __name__ == "__main__"` block so the script runs with `python db/seed/incident_scenario.py`.
- [ ] Verify: running the script populates the database and `GET /incidents/{id}/timeline` returns events in the correct order.

### W1-14 Tests

- [ ] Create `app/tests/conftest.py`:
  - Provide a `test_client` fixture using FastAPI `TestClient`.
  - Provide a `db_conn` fixture that connects to a test database.
  - Add a `setup`/`teardown` that runs migrations before the test suite and rolls back after.
- [ ] Create `app/tests/test_incidents.py`:
  - `test_create_incident_valid` — POST valid body, assert 201 + UUID in response.
  - `test_create_incident_missing_title` — POST without title, assert 422.
  - `test_create_incident_invalid_severity` — POST with `severity="critical"`, assert 422.
  - `test_get_incident_not_found` — GET unknown UUID, assert 404.
- [ ] Create `app/tests/test_events.py`:
  - `test_ingest_event_valid` — POST valid event, assert 201.
  - `test_ingest_event_unknown_incident` — POST with non-existent `incident_id`, assert 404.
  - `test_ingest_event_invalid_event_type` — POST with `event_type="crash"`, assert 422.
  - `test_ingest_event_deduplicated` — POST same `dedupe_key` twice, second returns 200 with `"deduplicated": true`.
  - `test_batch_ingest_mixed` — POST batch with 3 valid + 1 invalid, assert `accepted=3, rejected=1`.
- [ ] Create `app/tests/test_replay.py`:
  - `test_timeline_ordering` — Insert 3 events with `occurred_at` out of order, assert timeline returns them sorted ascending.
  - `test_timeline_unknown_incident` — GET timeline for unknown UUID, assert 404.
  - `test_trace_timeline` — Insert 2 events sharing a `trace_id`, assert trace endpoint returns both.
  - `test_trace_timeline_not_found` — GET trace timeline for unknown trace, assert 404.
- [ ] Verify: `pytest app/tests/ -v` shows all tests passing.
- [ ] Verify: `pytest app/tests/ --cov=app --cov-report=term-missing` shows coverage ≥ 70%.

### W1-15 README — Week 1 Section

- [ ] Add a `## Local Setup` section with exact commands:
  - Clone repo.
  - Copy `.env.example` to `.env`.
  - `docker compose up -d`.
  - `alembic upgrade head`.
  - `python db/seed/incident_scenario.py`.
  - `uvicorn app.main:app --reload` (for development outside Docker).
- [ ] Add a `## Running Tests` section with the exact pytest command.
- [ ] Add a `## API Quick Reference` table listing all endpoints with method, path, and one-line description.
- [ ] Add a `## Demo Flow` section: 3 curl commands that create an incident, ingest an event, and replay the timeline.
- [ ] Verify: someone following only the README can run the demo with no extra context.

---

## Week 2 — CI, Infrastructure, Security

### W2-1 Dockerfile

- [ ] Create `Dockerfile` at the repo root.
- [ ] Use `python:3.12-slim` as base.
- [ ] Set `WORKDIR /app`.
- [ ] Copy `pyproject.toml` first and install dependencies (layer cache).
- [ ] Copy `app/` source.
- [ ] Set `CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]`.
- [ ] Add `EXPOSE 8000`.
- [ ] Create `.dockerignore` excluding `.git`, `__pycache__`, `*.pyc`, `.env`, `infra/`, `docs/`.
- [ ] Verify: `docker build -t incident-replay:local .` completes without errors.
- [ ] Verify: `docker run --rm --env-file .env incident-replay:local` starts the API.

### W2-2 GitHub Actions CI Workflow

- [ ] Create `.github/workflows/ci.yml`.
- [ ] Trigger on `push` to any branch and `pull_request` to `main`.
- [ ] Add a `test` job:
  - Check out code.
  - Set up Python 3.12.
  - Install dependencies with `pip install -e ".[dev]"`.
  - Start postgres using a service container (`postgres:16`).
  - Run `alembic upgrade head`.
  - Run `pytest app/tests/ -v --cov=app`.
- [ ] Add a `lint` job:
  - Run `ruff check app/`.
  - Run `ruff format --check app/`.
- [ ] Add a `docker-build` job:
  - Run `docker build -t incident-replay:ci .`.
- [ ] Verify: push a branch and confirm all three jobs pass in GitHub Actions.

### W2-3 CI Terraform Validation Step

- [ ] Add a `terraform-check` job to `ci.yml`:
  - Set up Terraform 1.9.x using `hashicorp/setup-terraform@v3`.
  - Run `terraform -chdir=infra/terraform fmt -check -recursive`.
  - Run `terraform -chdir=infra/terraform validate` (with `TF_TOKEN_app_terraform_io` or equivalent if needed).
- [ ] Make `terraform-check` a warning-only job (`continue-on-error: true`) until Terraform is clean.
- [ ] Verify: the job appears in CI and its output is visible in the Actions log.

### W2-4 Terraform Cleanup

- [ ] Replace hardcoded `project = "incident-replay-system"` in `infra/terraform/main.tf` with `var.project_id`.
- [ ] Add `project_id` variable to `infra/terraform/variables.tf` with no default.
- [ ] Remove the `default = "incident-replay-dev-pw"` from the `db_password` variable.
- [ ] Document: "set `TF_VAR_db_password` in your shell or use a `terraform.tfvars` file (git-ignored)".
- [ ] Confirm `infra/terraform/.gitignore` includes `*.tfvars`, `*.tfstate`, `*.tfstate.backup`.
- [ ] Run `terraform -chdir=infra/terraform fmt -recursive`.
- [ ] Run `terraform -chdir=infra/terraform validate`.
- [ ] Verify: both commands exit 0.

### W2-5 Workload Identity Review

- [ ] Confirm `attribute_condition` in `google_iam_workload_identity_pool_provider` matches your actual GitHub `owner/repo`.
- [ ] If the repository name changed, update it.
- [ ] Confirm the service account `account_id` is ≤ 28 characters (GCP limit).
- [ ] Confirm `google_service_account_iam_member` uses the correct project number from `data.google_project.current`.
- [ ] Add `output "github_actions_sa_email"` to `infra/terraform/modules/gcp/main.tf`.
- [ ] Add `output "workload_identity_provider"` exposing the full provider resource name.
- [ ] Verify: `terraform plan` shows no unintended changes after cleanup.

### W2-6 Checkov Scan

- [ ] Run `checkov -d infra/terraform --output cli --output json --output-file-path docs/security/` and save results.
- [ ] Identify at least one HIGH or MEDIUM finding to fix (e.g. missing SSL enforcement on Cloud SQL).
- [ ] Fix the finding in Terraform code.
- [ ] Identify at least one finding to consciously defer with rationale.
- [ ] Update `docs/security/checkov-wk04.md`:
  - List the finding ID, description, and what you changed to fix it.
  - List the deferred finding ID, description, and one sentence rationale.
- [ ] Verify: running Checkov again shows the fixed finding no longer triggers.

### W2-7 Complete ADR 0002

- [ ] Fill in `## Consequences` with at least 2 positive, 2 negative, 1 neutral points (replace all TODOs).
- [ ] Fill in `## Considered Options`:
  - Option A: Remote Terraform state (Terraform Cloud or GCS backend) — explain why local state is acceptable now but not at team scale.
  - Option B: AWS path — reference the existing AI journal cross-cloud translation and why GCP was chosen.
- [ ] Fill in `## Team Considerations` — all four beats: solo, future team, DORA archetype, TT team type.
- [ ] Fill in `## Data-layer capability tie` — name the Cloud SQL flag or GCS versioning property and how a future AI-ops step would consume it.
- [ ] Fill in `## Integration seam` — W3 seam realized (name the Terraform resource), W5 auth pre-provision (name the workload identity resource).
- [ ] Change `Status` from TODO to `accepted`.
- [ ] Verify: `grep -i "TODO" docs/adr/0002-iac-choices.md` returns no matches.

---

## Week 3 — Polish And Demo

### W3-1 Demo Scenario

- [ ] Create `docs/demo/demo-script.md`.
- [ ] Write the exact terminal session: start, seed, three API calls, expected output.
- [ ] Ensure the scenario narrative makes sense: deploy → errors → alert → replay → resolution.
- [ ] Run through the script once from a clean database and record actual output.
- [ ] Fix any command that does not work exactly as written.

### W3-2 API Examples

- [ ] Create `docs/examples/create-incident.json` — request body.
- [ ] Create `docs/examples/create-incident-response.json` — response body.
- [ ] Create `docs/examples/ingest-event.json` — request body.
- [ ] Create `docs/examples/timeline-response.json` — response from `GET /incidents/{id}/timeline` after seeding.
- [ ] Create `docs/examples/trace-timeline-response.json` — response from `GET /traces/{trace_id}/timeline`.
- [ ] Create `docs/examples/batch-ingest.json` — batch request with 3 events.
- [ ] Verify: each JSON file is valid (`python -m json.tool docs/examples/*.json`).

### W3-3 Architecture Docs Tidy

- [ ] Open `docs/architecture/c4-context.mmd` and confirm it shows: User, Ingestion API, Replay API, PostgreSQL, GCP.
- [ ] Open `docs/architecture/c4-container.mmd` and confirm containers match actual services.
- [ ] Update `docs/architecture/w3-to-w4-integration-seam.md`: replace generic AWS/GCP wording with GCP-specific resource names (e.g. `google_iam_workload_identity_pool`, `google_sql_database_instance`).
- [ ] Update `docs/architecture/tradeoffs.md` if any implementation tradeoff changed during build.

### W3-4 Final README Pass

- [ ] Confirm the README has: purpose, architecture overview, local setup, migration commands, test commands, API reference, demo flow, known limitations, future roadmap.
- [ ] Add `## Known Limitations` section: no auth, single-region, synchronous writes, no pagination.
- [ ] Add `## Future Roadmap` section: Redis Streams buffering, frontend timeline, API key auth, AI incident summaries.
- [ ] Add badges for CI status and Python version at the top.
- [ ] Verify: a fresh reader can run the full demo in under 10 minutes using only the README.

### W3-5 Full Verification Run

- [ ] From a clean checkout, run: `docker compose down -v && docker compose up -d`.
- [ ] Run: `alembic upgrade head`.
- [ ] Run: `python db/seed/incident_scenario.py`.
- [ ] Run: `pytest app/tests/ -v`.
- [ ] Run: `curl http://localhost:8000/health` and confirm `"database": "ok"`.
- [ ] Run: the three demo curl commands from the demo script.
- [ ] Run: `terraform -chdir=infra/terraform fmt -check -recursive`.
- [ ] Run: `terraform -chdir=infra/terraform validate`.
- [ ] Run: `checkov -d infra/terraform`.
- [ ] Confirm: all steps exit 0 or produce expected output with no surprises.

### W3-6 Submission Cleanup

- [ ] `grep -rn "TODO" app/ db/ docs/` — fix or delete every hit.
- [ ] `grep -rn "<.*>" docs/` — replace every placeholder angle bracket.
- [ ] `grep -rn "skeleton" docs/` — remove or rewrite skeleton commentary in final docs.
- [ ] `git ls-files | grep ".tfstate"` — confirm result is empty.
- [ ] `git ls-files | grep ".env"` — confirm no `.env` file is tracked (`.env.example` is fine).
- [ ] Create `docs/project_plan/submission-checklist.md` with one checkbox per acceptance criterion from the project plan.
- [ ] Check every box in the submission checklist.
- [ ] Commit with message: `chore: final submission cleanup`.

---

## Quick Tasks (15 Minutes Or Less)

Pick any of these when you have a short window:

- [ ] Add one missing docstring to a router handler.
- [ ] Add one example to the README API reference.
- [ ] Add one assertion to an existing test.
- [ ] Fix one ruff lint warning.
- [ ] Add one curl example to the demo script.
- [ ] Add one sentence to an ADR consequences section.
- [ ] Verify one endpoint manually and note the result.
- [ ] Add one seed event to make the incident narrative clearer.
- [ ] Run `alembic history` and confirm migration chain is linear.
- [ ] Rename one unclear variable in the codebase.
