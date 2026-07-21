from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


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
    trace_id: Optional[str] = None  # correlates this event to others across incidents
    span_id: Optional[str] = None


class EventResponse(BaseModel):
    id: str
    incident_id: str
    event_type: str
    timestamp: datetime
    received_at: datetime
    source: str
    data: dict
    trace_id: Optional[str] = None
    span_id: Optional[str] = None

    class Config:
        from_attributes = True


class TimelineResponse(BaseModel):
    incident_id: str
    incident_name: str
    incident_status: str
    events: list[EventResponse]
