from datetime import datetime
from sqlalchemy import Column, String, DateTime, JSON, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()


class Incident(Base):
    __tablename__ = "incidents"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    status = Column(String, default="active")  # active, resolved, investigating
    created_at = Column(DateTime, default=datetime.utcnow)
    incident_metadata = Column(JSON, nullable=True)

    # Relationship
    events = relationship("Event", back_populates="incident", cascade="all, delete-orphan")


class Event(Base):
    __tablename__ = "events"

    id = Column(String, primary_key=True, index=True)
    incident_id = Column(String, ForeignKey("incidents.id"), nullable=False, index=True)
    event_type = Column(String, nullable=False)  # log, metric, alert, deploy
    timestamp = Column(DateTime, nullable=False, index=True)  # when event actually occurred
    received_at = Column(DateTime, default=datetime.utcnow)  # when system received it
    source = Column(String, nullable=False)  # service name
    data = Column(JSON, nullable=False)
    trace_id = Column(String, nullable=True, index=True)  # correlates events across incidents
    span_id = Column(String, nullable=True)

    # Relationship
    incident = relationship("Incident", back_populates="events")