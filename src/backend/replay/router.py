from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db
from models import Event, Incident
from schemas import EventResponse, TimelineResponse

router = APIRouter(tags=["replay"])


@router.get("/traces/{trace_id}/timeline", response_model=list[EventResponse])
def get_trace_timeline(trace_id: str, db: Session = Depends(get_db)):
    """Get ordered events sharing a trace ID, across incidents."""
    events = (
        db.query(Event)
        .filter(Event.trace_id == trace_id)
        .order_by(Event.timestamp, Event.received_at, Event.id)
        .all()
    )
    return events


@router.get("/incidents/{incident_id}/timeline", response_model=TimelineResponse)
def get_timeline(incident_id: str, db: Session = Depends(get_db)):
    """Get ordered timeline of events for an incident."""
    db_incident = db.query(Incident).filter(Incident.id == incident_id).first()
    if not db_incident:
        raise HTTPException(status_code=404, detail="Incident not found")

    # Fetch events sorted by actual occurrence time
    events = (
        db.query(Event)
        .filter(Event.incident_id == incident_id)
        .order_by(Event.timestamp, Event.received_at, Event.id)
        .all()
    )

    return TimelineResponse(
        incident_id=db_incident.id,
        incident_name=db_incident.name,
        incident_status=db_incident.status,
        events=events
    )
