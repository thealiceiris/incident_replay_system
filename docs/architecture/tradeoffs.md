# Tradeoffs — INCIDENT REPLAY SYSTEM



## Tradeoff 1 — Synchronous writes vs queue buffering

**Chosen option:** Synchronous PostgreSQL writes.

**Sacrificed:** Burst-load resilience and failure isolation. If PostgreSQL becomes slow or unavailable, ingestion latency increases immediately because writes occur synchronously in the request path.

**Reversal cost:** Introducing Redis Streams later would require adding queue consumers, retry handling, dead-letter logic, observability metrics, and re-testing ingestion ordering guarantees across the replay pipeline.

---

## Tradeoff 2 — Single database architecture vs polyglot persistence

**Chosen option:** PostgreSQL as the only persistence layer.

**Sacrificed:** Specialized storage optimization for analytics and high-volume event streaming workloads. Large-scale replay analytics may eventually become slower compared to dedicated event stores.

**Reversal cost:** Migrating to a polyglot persistence model would require data replication pipelines, schema synchronization, and replay-query redesign across multiple storage systems.


---
## Tradeoff 3 — Operational simplicity vs horizontal scalability

**Chosen option:** Simplicity-first architecture optimized for a solo developer.

**Sacrificed:** Immediate horizontal scalability and independent scaling of ingestion and replay components.

**Reversal cost:** Separating ingestion, processing, and replay into independently scalable services would require infrastructure orchestration changes, service discovery, distributed tracing expansion, and CI/CD pipeline restructuring.


---

## Integration seams to watch (W3 → W4 / W5 pre-vision)


- The synchronous PostgreSQL dependency requires W4 Terraform infrastructure to provision persistent storage, automated backups, and database monitoring from the start.

- W5 CI/CD pipelines must include database migration validation because schema incompatibilities can directly break ingestion requests.

- Future migration to asynchronous buffering will require new deployment orchestration and queue observability in both infrastructure and delivery pipelines.


### Seam 1 — Direct PostgreSQL dependency

- **W3 decision:** Use synchronous ingestion directly into PostgreSQL without an intermediate queueing layer.
- **W4 IaC implication:** Terraform infrastructure must provision a highly available PostgreSQL instance with persistent storage, automated backups, and monitoring because the database is part of the synchronous request path.
- **W5 pipeline implication:** CI/CD pipelines must run database migration validation and integration tests before deployment because schema mismatches can immediately break ingestion requests.

### Seam 2 — Deferred asynchronous buffering

- **W3 decision:** Defer Redis Streams or Kafka buffering until future scaling requirements justify the added complexity.
- **W4 IaC implication:** Current infrastructure does not provision Redis or Kafka clusters, reducing infrastructure overhead but limiting burst-load buffering capability.
- **W5 pipeline implication:** Deployment pipelines currently avoid queue-consumer orchestration and replay testing, but future migration to asynchronous processing will require queue-lag monitoring, retry validation, and event-ordering integration tests.
---
