# Incident Replay System

## Small Actionable Task Lists

Use these lists as working checklists. Each block is sized to be achievable in one focused session.

## Session Board

| Week | Sessions | Main Outcome |
| --- | --- | --- |
| Week 1 | 1-7 | Local ingestion and replay flow |
| Week 2 | 8-13 | CI, infrastructure, security, ADR completion |
| Week 3 | 14-19 | README, examples, demo, final cleanup |

## Week 1: Core Local System

### Session 1: Project Skeleton

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Create `app/ingestion/`. |
| <input type="checkbox"> | Create `app/replay/`. |
| <input type="checkbox"> | Create `app/shared/`. |
| <input type="checkbox"> | Create `app/tests/`. |
| <input type="checkbox"> | Add Python dependency file. |
| <input type="checkbox"> | Add a minimal FastAPI app entrypoint. |
| <input type="checkbox"> | Add `GET /health` returning JSON. |
| <input type="checkbox"> | Run the app locally. |

### Session 2: Local Database

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add Docker Compose with PostgreSQL. |
| <input type="checkbox"> | Add database environment variables. |
| <input type="checkbox"> | Add database connection helper. |
| <input type="checkbox"> | Verify the app can connect to PostgreSQL. |
| <input type="checkbox"> | Add a failing test for database connectivity. |
| <input type="checkbox"> | Make the database connectivity test pass. |

### Session 3: Migrations

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Choose migration tool. |
| <input type="checkbox"> | Create `incidents` migration. |
| <input type="checkbox"> | Create `incident_events` migration. |
| <input type="checkbox"> | Create `replay_notes` migration. |
| <input type="checkbox"> | Run migrations against local PostgreSQL. |
| <input type="checkbox"> | Add command documentation for migrations. |

### Session 4: Incident API

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Define incident request JSON. |
| <input type="checkbox"> | Validate `title`. |
| <input type="checkbox"> | Validate `severity`. |
| <input type="checkbox"> | Validate `started_at`. |
| <input type="checkbox"> | Implement `POST /incidents`. |
| <input type="checkbox"> | Add test for valid incident creation. |
| <input type="checkbox"> | Add test for missing required fields. |

### Session 5: Event Ingestion API

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Define event request JSON. |
| <input type="checkbox"> | Validate `incident_id`. |
| <input type="checkbox"> | Validate `service_name`. |
| <input type="checkbox"> | Validate `event_type`. |
| <input type="checkbox"> | Validate `severity`. |
| <input type="checkbox"> | Validate `message`. |
| <input type="checkbox"> | Validate `occurred_at`. |
| <input type="checkbox"> | Implement `POST /events`. |
| <input type="checkbox"> | Add test for valid event ingestion. |
| <input type="checkbox"> | Add test for invalid timestamp rejection. |

### Session 6: Replay API

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Implement timeline query by incident ID. |
| <input type="checkbox"> | Sort by `occurred_at`, `received_at`, then `id`. |
| <input type="checkbox"> | Implement `GET /incidents/{incident_id}/timeline`. |
| <input type="checkbox"> | Implement trace query by trace ID. |
| <input type="checkbox"> | Implement `GET /traces/{trace_id}/timeline`. |
| <input type="checkbox"> | Add test for out-of-order event arrival. |
| <input type="checkbox"> | Add test for trace replay across services. |

### Session 7: Seed Demo Data

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Create one incident seed file. |
| <input type="checkbox"> | Add at least six events across three services. |
| <input type="checkbox"> | Include one deploy event. |
| <input type="checkbox"> | Include one alert event. |
| <input type="checkbox"> | Include one error event. |
| <input type="checkbox"> | Include shared trace IDs. |
| <input type="checkbox"> | Add script or command to load seed data. |
| <input type="checkbox"> | Confirm replay output tells a coherent incident story. |

## Week 2: CI, Infrastructure, Security

### Session 8: Docker

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add Dockerfile. |
| <input type="checkbox"> | Add `.dockerignore`. |
| <input type="checkbox"> | Build image locally. |
| <input type="checkbox"> | Run container against local PostgreSQL. |
| <input type="checkbox"> | Document Docker command in README. |

### Session 9: CI Basics

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add GitHub Actions workflow for Python setup. |
| <input type="checkbox"> | Add install dependencies step. |
| <input type="checkbox"> | Add test step. |
| <input type="checkbox"> | Add lint or formatting check. |
| <input type="checkbox"> | Push and confirm workflow result. |

### Session 10: Terraform Cleanup

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Replace hardcoded GCP project ID with a variable. |
| <input type="checkbox"> | Remove default plaintext database password. |
| <input type="checkbox"> | Check `.gitignore` covers `*.tfstate`. |
| <input type="checkbox"> | Run `terraform fmt`. |
| <input type="checkbox"> | Run `terraform validate`. |
| <input type="checkbox"> | Fix validation errors. |

### Session 11: Workload Identity Check

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Confirm repository name in Terraform matches GitHub repository. |
| <input type="checkbox"> | Confirm Workload Identity Pool resource exists. |
| <input type="checkbox"> | Confirm Workload Identity Provider resource exists. |
| <input type="checkbox"> | Confirm service account impersonation binding exists. |
| <input type="checkbox"> | Add output needed by deployment workflow. |
| <input type="checkbox"> | Document how CI will authenticate to GCP. |

### Session 12: Security Scan

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Run Checkov against `infra/terraform`. |
| <input type="checkbox"> | Save scan output. |
| <input type="checkbox"> | Pick one finding to fix. |
| <input type="checkbox"> | Fix it. |
| <input type="checkbox"> | Pick one finding to defer. |
| <input type="checkbox"> | Write defer rationale. |
| <input type="checkbox"> | Clean up `docs/security/checkov-wk04-plan.md` placeholders. |

### Session 13: ADR Completion

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Complete ADR 0002 positive consequences. |
| <input type="checkbox"> | Complete ADR 0002 negative consequences. |
| <input type="checkbox"> | Complete ADR 0002 neutral consequences. |
| <input type="checkbox"> | Add rejected option for AWS path. |
| <input type="checkbox"> | Add rejected option for remote state today. |
| <input type="checkbox"> | Complete team considerations. |
| <input type="checkbox"> | Complete data-layer capability tie. |
| <input type="checkbox"> | Complete integration seam. |
| <input type="checkbox"> | Change status when decision is final. |

## Week 3: Finalization And Demo

### Session 14: README Pass

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add project purpose. |
| <input type="checkbox"> | Add architecture overview. |
| <input type="checkbox"> | Add local setup. |
| <input type="checkbox"> | Add migration commands. |
| <input type="checkbox"> | Add test commands. |
| <input type="checkbox"> | Add API examples. |
| <input type="checkbox"> | Add demo flow. |
| <input type="checkbox"> | Add known limitations. |

### Session 15: API Examples

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Add example create incident request. |
| <input type="checkbox"> | Add example create incident response. |
| <input type="checkbox"> | Add example ingest event request. |
| <input type="checkbox"> | Add example timeline response. |
| <input type="checkbox"> | Add example trace timeline response. |
| <input type="checkbox"> | Store examples under `docs/examples/`. |

### Session 16: Demo Script

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Write exact setup command. |
| <input type="checkbox"> | Write exact migration command. |
| <input type="checkbox"> | Write exact seed command. |
| <input type="checkbox"> | Write exact replay command. |
| <input type="checkbox"> | Write expected output summary. |
| <input type="checkbox"> | Practice demo from a clean terminal. |

### Session 17: Architecture Docs

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Remove skeleton-only comments from final diagrams if they distract review. |
| <input type="checkbox"> | Add markdown wrapper for Mermaid diagrams if GitHub rendering is needed. |
| <input type="checkbox"> | Confirm C4 context matches current scope. |
| <input type="checkbox"> | Confirm C4 container diagram matches actual app services. |
| <input type="checkbox"> | Update tradeoffs if implementation changed. |

### Session 18: Final Test Run

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Start from a clean local database. |
| <input type="checkbox"> | Run migrations. |
| <input type="checkbox"> | Run seed data. |
| <input type="checkbox"> | Run all tests. |
| <input type="checkbox"> | Run Docker Compose. |
| <input type="checkbox"> | Run replay demo. |
| <input type="checkbox"> | Run Terraform fmt. |
| <input type="checkbox"> | Run Terraform validate. |
| <input type="checkbox"> | Run Checkov. |

### Session 19: Submission Cleanup

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Search for `TODO`. |
| <input type="checkbox"> | Search for `<`. |
| <input type="checkbox"> | Search for `skeleton`. |
| <input type="checkbox"> | Remove stale placeholder text. |
| <input type="checkbox"> | Confirm no secrets are tracked. |
| <input type="checkbox"> | Confirm no Terraform state is tracked. |
| <input type="checkbox"> | Confirm final README points to plan, ADRs, diagrams, and security docs. |

## Fifteen Minute Tasks

Use these when you have a small amount of time:

| Done | Task |
| --- | --- |
| <input type="checkbox"> | Fix one README section. |
| <input type="checkbox"> | Add one test. |
| <input type="checkbox"> | Add one curl example. |
| <input type="checkbox"> | Clean one TODO. |
| <input type="checkbox"> | Rename one unclear variable. |
| <input type="checkbox"> | Add one seed event. |
| <input type="checkbox"> | Verify one endpoint manually. |
| <input type="checkbox"> | Update one ADR paragraph. |
| <input type="checkbox"> | Run one formatter. |
| <input type="checkbox"> | Commit one coherent change. |
