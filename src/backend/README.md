# Incident Replay System - FastAPI Backend

Event store and timeline reconstruction for incident analysis.

## Quick Start (Local Development)

### 1. Prerequisites
- Docker & Docker Compose installed
- Python 3.11+ (optional, for local dev without Docker)

### 2. Start the stack
```bash
docker-compose up
```

This starts:
- **PostgreSQL** at `localhost:5432`
- **FastAPI** at `http://localhost:8000`

### 3. Test it
```bash
# Health check
curl http://localhost:8000/health

# Create an incident
curl -X POST http://localhost:8000/incidents \
  -H "Content-Type: application/json" \
  -d '{"name": "Database connection pool exhausted"}'

# Copy the incident ID from response, then ingest an event
curl -X POST http://localhost:8000/incidents/{INCIDENT_ID}/events \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "log",
    "timestamp": "2024-01-15T10:05:00Z",
    "source": "api-service",
    "data": {"level": "ERROR", "message": "Connection pool exhausted"}
  }'

# Get the ordered timeline
curl http://localhost:8000/incidents/{INCIDENT_ID}/timeline
```

### 4. Docs
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Core Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/incidents` | Create incident |
| `POST` | `/incidents/{id}/events` | Ingest event (out-of-order OK) |
| `GET` | `/incidents/{id}/timeline` | Get ordered timeline for one incident |
| `GET` | `/traces/{trace_id}/timeline` | Get ordered events sharing a trace ID, across incidents |
| `GET` | `/incidents` | List all incidents |
| `PATCH` | `/incidents/{id}` | Update incident status (gated by the `strict-status-validation` flag) |
| `GET` | `/health` | Health check |

## Event Schema

```json
{
  "event_type": "log|metric|alert|deploy",
  "timestamp": "2024-01-15T10:05:00Z",
  "source": "service-name",
  "data": { /* arbitrary JSON */ }
}
```

**Key:** `timestamp` is when the event *actually occurred*, not when the system received it. This enables replay to work even if events arrive out of order.

`trace_id`/`span_id` are optional. Setting `trace_id` on events ingested against different
incidents lets `GET /traces/{trace_id}/timeline` reconstruct a single ordered timeline across all
of them - useful when one root cause (e.g. a bad deploy) triggers events in several services'
incidents at once.

## Migrations

Schema is managed by Alembic, not `create_all` - `docker-compose up` runs `alembic upgrade head`
automatically before starting the server.

```bash
alembic upgrade head                              # apply pending migrations
alembic downgrade -1                               # roll back one migration
alembic revision --autogenerate -m "description"   # after changing models.py
```

`alembic.ini` and `alembic/env.py` read `DATABASE_URL` the same way `main.py` does, so migrations
target whatever database the app itself is configured for.

## Deploying to GCP

### 1. Update DATABASE_URL
In your Cloud SQL connection details:
```bash
export DATABASE_URL="postgresql://postgres:<PASSWORD>@/<DB_NAME>?host=/cloudsql/<PROJECT>:<REGION>:<INSTANCE>"
```

### 2. Build and push image
```bash
docker build -t gcr.io/<PROJECT>/incident-replay-api:latest .
docker push gcr.io/<PROJECT>/incident-replay-api:latest
```

### 3. Update your GKE deployment manifest to use the image

### 4. Set Cloud SQL connection string in your secrets/ConfigMap

See your Terraform files for integration details.

## Development

### Install locally (without Docker)
```bash
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/incident_replay
alembic upgrade head
uvicorn main:app --reload
```

### Database reset (local)
```bash
docker-compose down -v
docker-compose up
```

This wipes the database and starts fresh.

## Next Steps

1. **Wire React frontend** to these endpoints
2. **Add authentication** (JWT, API keys, etc.)
3. **Add observability** (logging, tracing)
4. **Replace `create_all`-on-startup with real migrations** (e.g. Alembic) before a second
   environment or teammate touches the schema
