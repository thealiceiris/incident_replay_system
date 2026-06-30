# ADR 0003: FastAPI For Incident APIs

## Status

`accepted`

## Context

The Incident Replay System needs HTTP APIs for two core workflows: ingesting incident events from distributed services and replaying ordered incident timelines for engineers investigating failures. These APIs must validate structured JSON payloads, preserve timestamps and trace metadata, expose clear contracts for review, and remain simple enough for a solo developer to build and operate within the capstone timeline.

The API layer also sits directly on the system's most important architectural decision: synchronous writes to PostgreSQL. That means request validation, error handling, and database interaction need to be explicit and testable. If malformed event payloads or timestamp formats are accepted too loosely, replay accuracy will suffer even if the database schema is correct.

## Decision

We will use **Python with FastAPI** for the ingestion and replay APIs.

FastAPI will define the HTTP endpoints, Pydantic models will validate request and response payloads, and PostgreSQL access will remain explicit in the service layer. The initial implementation may use synchronous database calls to match ADR 0001, while keeping the option to introduce async database access later if load or concurrency requirements justify it.

## Consequences

**Positive:**
- **Stronger API contracts:** Pydantic models make required fields, timestamp formats, severity values, trace IDs, and event metadata explicit at the API boundary.
- **Built-in review artifact:** FastAPI generates OpenAPI documentation automatically, which gives reviewers a clear view of the ingestion and replay contracts.
- **Good fit for Python data workflows:** Python works well for event parsing, timestamp handling, seed scripts, test fixtures, and future AI-ops extensions.
- **Focused testing surface:** FastAPI's test client makes it straightforward to test request validation, error responses, and replay endpoints without standing up a full production server.

**Negative:**
- **Dependency discipline required:** The project must manage Python package versions carefully so local development, CI, and container builds stay consistent.
- **Async temptation:** FastAPI supports async handlers, but mixing async HTTP code with synchronous PostgreSQL access can create confusion if the boundary is not kept deliberate.
- **Learning curve:** Pydantic validation patterns and FastAPI dependency injection may take more setup effort than a minimal Flask application.

**Neutral:**
- **Synchronous first, async later:** FastAPI can run synchronous handlers today and still support async endpoints later if the replay workload grows.
- **Framework does not solve persistence:** FastAPI improves API structure, but correctness still depends on PostgreSQL schema design, transaction handling, indexing, and replay query ordering.
- **Deployment remains container friendly:** FastAPI can be packaged with Uvicorn/Gunicorn in Docker and deployed to GKE Autopilot without changing the infrastructure direction from ADR 0002.

## Considered Options

### Option A - Flask

- **What it is:** A lightweight Python web framework with minimal built-in structure.
- **Why rejected:** Flask is simple and familiar, but this project benefits from stronger request validation and automatic API documentation. Without adding extra libraries, Flask would require more manual validation code for incident events, timestamps, metadata, and replay responses.

### Option B - Node.js With Express

- **What it is:** A JavaScript/TypeScript HTTP API stack commonly used for lightweight services.
- **Why rejected:** Express is flexible, but the rest of this capstone leans toward Python-friendly workflows: seed scripts, data validation, timestamp processing, testing, and future AI-ops work. TypeScript could provide strong contracts, but it would add another toolchain without a clear benefit for this solo-developer project.

### Option C - Django REST Framework

- **What it is:** A batteries-included Python web framework with ORM, admin tools, authentication, and REST APIs.
- **Why rejected:** Django REST Framework is powerful, but it is heavier than this MVP needs. The Incident Replay System currently needs a small set of ingestion and replay endpoints, not a full application framework with admin, templates, and broad built-in conventions.

## Team Considerations

- **Solo-pilot scale (today):** FastAPI provides enough structure to reduce custom validation work while staying lightweight for one developer.
- **Future-team scale (5 people, 18 months):** A future team could split ingestion, replay, and analytics into separate services while keeping shared Pydantic schemas or OpenAPI contracts as the boundary between them.
- **DORA archetype target:** The target remains high-stability delivery. FastAPI supports this by making API contracts explicit and testable before deployment.
- **Future TT team type:** A future stream-aligned team could own the incident replay domain end to end. FastAPI keeps the service boundary understandable without requiring a separate platform team to manage complex framework conventions.

## Integration Seam

- **Constrains W4 IaC:** The runtime container must expose FastAPI through an ASGI server such as Uvicorn, with environment variables for PostgreSQL connectivity and health checks for deployment readiness.
- **Constrains W5 pipeline:** CI/CD must run API validation tests, database integration tests, and container build checks before deployment because API schema regressions can break ingestion and replay workflows.
- **Constrains future async buffering:** If Redis Streams or Kafka are introduced later, FastAPI request models can remain stable while the service layer changes from direct database writes to enqueue-and-consume behavior.

