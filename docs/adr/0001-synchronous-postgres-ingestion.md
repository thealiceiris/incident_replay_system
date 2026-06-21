# ADR 0001: Synchronous PostgreSQL Ingestion

## Status

`accepted`

## Context

The Incident Replay System is designed for site reliability engineers (SREs) and backend engineers investigating failures across distributed services. These engineers need accurate, ordered event timelines to reconstruct incidents and trace failures across systems. The system must ingest logs from multiple services while preserving timestamps, trace IDs, and metadata required for replay and debugging. 

The main constraint is that the system is currently being built and operated by a single developer, so operational simplicity and low infrastructure overhead are critical while still handling out-of-order events, duplicate ingestion, and moderate load reliably.

## Decision

We will use synchronous ingestion directly into PostgreSQL, where the ingestion service validates incoming events and writes them immediately to the database.

An alternative considered is introducing a queueing layer (e.g., Redis Streams) between ingestion and persistence to buffer load and improve resilience, but this is deferred due to added complexity and operational overhead at the current stage.

## Consequences

**Positive:**
- **Reduced operational complexity:** There is only one persistence layer (PostgreSQL) to deploy, monitor, and manage.
- **Simpler debugging:** Log ingestion and database write actions occur in a single synchronous flow, making it easier to trace failures.
- **Sleeker development cycle:** Simplifies local dockerized orchestration, automated testing, and CI/CD pipelines for a solo developer.

**Negative:**
- **Tight coupling:** The ingestion service availability is directly tied to PostgreSQL database availability and latency.
- **Latency vulnerability:** Sudden traffic spikes will increase client-side request latencies because events are written synchronously.
- **Weaker failure isolation:** A database outage will immediately reject incoming event payloads.

**Neutral:**
- **Buffered ingestion extension:** A queue-based buffering layer (like Redis Streams) can still be introduced upstream later without redesigning the core timeline query logic.
- **Primary dependency:** PostgreSQL becomes the primary operational and performance dependency for both ingestion and replay workflows.
- **Timestamp reliance:** Replay accuracy depends heavily on consistent database indexing and timestamp resolution.

## Considered Options

### Option A — Redis Streams buffering layer
- **What it is:** Log events are first written into a Redis Streams queue, then asynchronously consumed and persisted into PostgreSQL by worker services.
- **Why rejected:** This improves resilience and handles burst traffic, but introduces additional infrastructure, monitoring, retry logic, and operational complexity that is disproportionate to the current solo-developer team structure.

### Option B — Apache Kafka event pipeline
- **What it is:** Services publish logs into Kafka topics, while downstream consumers process and persist events into storage systems.
- **Why rejected:** Kafka provides massive scalability and replay guarantees for large-scale distributed architectures, but requires significant operational expertise, partition planning, and infrastructure management that far exceeds the current capstone scope.

## Team Considerations

- **Solo-pilot scale (today):** As a single developer, minimizing infrastructure and operational overhead is more important than maximizing scalability. Direct PostgreSQL ingestion reduces the number of moving parts that must be monitored, deployed, and debugged.
- **Future-team scale (5 people, 18 months):** A future team could separate ingestion, replay processing, and analytics into independently owned services. Keeping the ingestion contract simple today creates a clean seam where a queueing layer can later be introduced without changing client-facing APIs.
- **DORA archetype target:** The target profile is a “high-stability delivery” archetype focused on reliability, maintainability, and predictable deployments rather than maximum deployment velocity. Direct synchronous persistence supports simpler deployments and faster recovery during failures.
- **Future TT team type:** The likely future ownership model is a stream-aligned team responsible for incident replay and debugging workflows. The current architecture keeps domain ownership clear while avoiding premature platform-team complexity.

## Integration Seam

- **Constrains W4 IaC:** Infrastructure provisioning must include a managed PostgreSQL instance (Cloud SQL) with automated backups, persistent storage volumes, and monitoring because PostgreSQL is a critical synchronous dependency in the ingestion path.
- **Constrains W5 pipeline:** CI/CD pipelines must include database migration validation and integration testing against PostgreSQL because schema incompatibilities would directly break ingestion reliability.
