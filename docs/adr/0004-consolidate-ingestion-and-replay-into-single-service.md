# ADR 0004: Consolidate Ingestion and Replay Into a Single Service

## Status

`accepted`

## Context

The Incident Replay System has two primary functions: ingesting events and replaying incident timelines. The initial C4 container diagram modeled these as two separate logical components: an "Ingestion API" and a "Replay API." The core architectural constraint for this project is operational simplicity for a solo developer, as established in ADR 0001 and ADR 0002. We must decide whether to deploy these two logical components as one physical service or two.

At this stage, there is no evidence to suggest that the read (replay) and write (ingestion) paths have different scaling requirements. The expected load is moderate, and the primary goal is to deliver a working end-to-end system with minimal operational overhead.

## Decision

We will deploy the Ingestion and Replay APIs as a single physical service. The logical separation will be maintained within the FastAPI application using separate routers (`app/ingestion/` and `app/replay/`), but they will be packaged into a single container image and deployed as one service on GKE Autopilot.

## Consequences

**Positive:**

- **Reduced operational overhead:** A single service is simpler to deploy, monitor, configure, and debug, which aligns with the solo-developer constraint.
- **Faster iteration:** Changes to shared models or database logic only require one service to be tested and deployed.
- **Lower resource footprint:** A single container running on GKE Autopilot is more cost-effective than running two separate services that may be underutilized.

**Negative:**

- **Coupled scaling:** The ingestion and replay APIs cannot be scaled independently. A spike in ingestion traffic will scale the entire service, including the idle replay endpoints.
- **Coupled failure domains:** A bug or performance issue in one logical component (e.g., a complex replay query) could impact the performance and availability of the other.

**Neutral:**

- **Future refactoring is possible:** The logical separation in the codebase (via routers) makes it easier to split the service into two separate deployments in the future if scaling needs change. The decision can be revisited if load testing reveals a bottleneck.

## Considered Options

### Option A — Split Ingestion and Replay Services

- **What it is:** Deploy the Ingestion API and Replay API as two separate container images and two distinct GKE services.
- **Why rejected:** This approach introduces unnecessary operational complexity for the current project stage. It would require managing two deployment pipelines, separate monitoring, and more complex configuration for service-to-service communication if ever needed. The benefits of independent scaling do not outweigh the costs for a solo developer with moderate load requirements.

## Team Considerations

- **Solo-pilot scale (today):** A single deployable unit is ideal. It minimizes context switching and reduces the number of components that need to be managed, which is critical for a single developer.
- **Future-team scale (5 people, 18 months):** A future team could decide to split the services if data shows a clear need for independent scaling. The initial logical separation in the code provides a clean seam for this future work.
- **DORA archetype target:** This decision supports a high-stability delivery archetype by reducing the number of moving parts, simplifying deployments, and making the system easier to reason about.
- **Future TT team type:** A stream-aligned team owning the incident replay domain would still benefit from the simplicity of a single service until performance data proves a split is necessary.

## Integration Seam

- **Constrains W4 IaC:** The Terraform infrastructure only needs to define a single GKE Autopilot service, a single load balancer, and a single health check for the application. This simplifies the `infra/terraform` configuration.
- **Constrains W5 pipeline:** The GitHub Actions CI/CD pipeline will only need to build, test, and deploy one Docker container image, simplifying the `ci.yml` workflow.
