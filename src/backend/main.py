import os
from contextlib import asynccontextmanager
from datetime import datetime
from typing import Optional
from uuid import uuid4

from fastapi import FastAPI, HTTPException, status, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from sqlalchemy import create_engine, desc
from sqlalchemy.orm import Session, sessionmaker

from models import Base, Incident, Event

# Database setup
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/incident_replay")
engine = create_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Request/Response models
class IncidentCreate(BaseModel):
    name: str
    metadata: Optional[dict] = None


class IncidentResponse(BaseModel):
    id: str
    name: str
    status: str
    created_at: datetime
    # Incident.metadata is SQLAlchemy's own MetaData registry, not the JSON
    # column (named incident_metadata to avoid that clash) - alias it back.
    metadata: Optional[dict] = Field(default=None, validation_alias="incident_metadata")

    class Config:
        from_attributes = True
        populate_by_name = True


class EventCreate(BaseModel):
    event_type: str  # log, metric, alert, deploy
    timestamp: datetime  # when the event actually occurred
    source: str  # service name
    data: dict  # arbitrary JSON payload


class EventResponse(BaseModel):
    id: str
    incident_id: str
    event_type: str
    timestamp: datetime
    received_at: datetime
    source: str
    data: dict

    class Config:
        from_attributes = True


class TimelineResponse(BaseModel):
    incident_id: str
    incident_name: str
    incident_status: str
    events: list[EventResponse]


# FastAPI app
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    Base.metadata.create_all(bind=engine)
    print("Starting Incident Replay System")
    yield
    # Shutdown
    print("Shutting down Incident Replay System")


app = FastAPI(
    title="Incident Replay System",
    description="Event store and timeline reconstruction for incident analysis",
    version="0.1.0",
    lifespan=lifespan
)

# CORS for React frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Health check
@app.get("/health")
def health():
    return {"status": "ok"}


# Endpoints
@app.post("/incidents", response_model=IncidentResponse, status_code=status.HTTP_201_CREATED)
def create_incident(incident: IncidentCreate, db: Session = Depends(get_db)):
    """Create a new incident container."""
    db_incident = Incident(
        id=str(uuid4()),
        name=incident.name,
        status="active",
        incident_metadata=incident.metadata or {}
    )
    db.add(db_incident)
    db.commit()
    db.refresh(db_incident)
    return db_incident


@app.post("/incidents/{incident_id}/events", response_model=EventResponse, status_code=status.HTTP_201_CREATED)
def ingest_event(incident_id: str, event: EventCreate, db: Session = Depends(get_db)):
    """Ingest a structured event for an incident."""
    # Verify incident exists
    db_incident = db.query(Incident).filter(Incident.id == incident_id).first()
    if not db_incident:
        raise HTTPException(status_code=404, detail="Incident not found")

    db_event = Event(
        id=str(uuid4()),
        incident_id=incident_id,
        event_type=event.event_type,
        timestamp=event.timestamp,
        received_at=datetime.utcnow(),
        source=event.source,
        data=event.data
    )
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event


@app.get("/incidents/{incident_id}/timeline", response_model=TimelineResponse)
def get_timeline(incident_id: str, db: Session = Depends(get_db)):
    """Get ordered timeline of events for an incident."""
    db_incident = db.query(Incident).filter(Incident.id == incident_id).first()
    if not db_incident:
        raise HTTPException(status_code=404, detail="Incident not found")

    # Fetch events sorted by actual occurrence time
    events = db.query(Event).filter(Event.incident_id == incident_id).order_by(Event.timestamp).all()

    return TimelineResponse(
        incident_id=db_incident.id,
        incident_name=db_incident.name,
        incident_status=db_incident.status,
        events=events
    )


@app.get("/incidents", response_model=list[IncidentResponse])
def list_incidents(db: Session = Depends(get_db)):
    """List all incidents."""
    incidents = db.query(Incident).order_by(desc(Incident.created_at)).all()
    return incidents


@app.patch("/incidents/{incident_id}", response_model=IncidentResponse)
def update_incident_status(incident_id: str, status: str, db: Session = Depends(get_db)):
    """Update incident status (e.g., active → resolved)."""
    db_incident = db.query(Incident).filter(Incident.id == incident_id).first()
    if not db_incident:
        raise HTTPException(status_code=404, detail="Incident not found")

    db_incident.status = status
    db.commit()
    db.refresh(db_incident)
    return db_incident


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
