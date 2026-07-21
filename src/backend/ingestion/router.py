from datetime import datetime
from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import desc
from sqlalchemy.orm import Session

from database import get_db
from flags import _flags, VALID_INCIDENT_STATUSES
from models import Event, Incident
from schemas import EventCreate, EventResponse, IncidentCreate, IncidentResponse

router = APIRouter(tags=["ingestion"])


@router.post("/incidents", response_model=IncidentResponse, status_code=status.HTTP_201_CREATED)
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


@router.post("/incidents/{incident_id}/events", response_model=EventResponse, status_code=status.HTTP_201_CREATED)
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
        data=event.data,
        trace_id=event.trace_id,
        span_id=event.span_id
    )
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event


@router.get("/incidents", response_model=list[IncidentResponse])
def list_incidents(db: Session = Depends(get_db)):
    """List all incidents."""
    incidents = db.query(Incident).order_by(desc(Incident.created_at)).all()
    return incidents


@router.patch("/incidents/{incident_id}", response_model=IncidentResponse)
def update_incident_status(incident_id: str, status: str, db: Session = Depends(get_db)):
    """Update incident status (e.g., active → resolved)."""
    db_incident = db.query(Incident).filter(Incident.id == incident_id).first()
    if not db_incident:
        raise HTTPException(status_code=404, detail="Incident not found")

    strict = _flags.get_boolean_value("strict-status-validation", default_value=False)
    if strict and status not in VALID_INCIDENT_STATUSES:
        raise HTTPException(
            status_code=422,
            detail=f"status must be one of {sorted(VALID_INCIDENT_STATUSES)}",
        )

    db_incident.status = status
    db.commit()
    db.refresh(db_incident)
    return db_incident
