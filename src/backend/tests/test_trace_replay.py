def _create_incident(client, name="Distributed failure"):
    return client.post("/incidents", json={"name": name}).json()


def _ingest_event(client, incident_id, *, occurred_at, trace_id=None, span_id=None, source="api-service"):
    response = client.post(
        f"/incidents/{incident_id}/events",
        json={
            "event_type": "log",
            "timestamp": occurred_at,
            "source": source,
            "data": {"message": f"event at {occurred_at}"},
            "trace_id": trace_id,
            "span_id": span_id,
        },
    )
    assert response.status_code == 201
    return response.json()


def test_event_stores_trace_and_span_id(client):
    incident = _create_incident(client)

    event = _ingest_event(
        client, incident["id"], occurred_at="2026-07-13T10:00:00Z", trace_id="trace-1", span_id="span-1"
    )
    assert event["trace_id"] == "trace-1"
    assert event["span_id"] == "span-1"


def test_trace_timeline_spans_multiple_incidents_ordered_by_occurrence_time(client):
    incident_a = _create_incident(client, name="Checkout service errors")
    incident_b = _create_incident(client, name="Payment service errors")

    # Same trace, two different incidents, ingested out of order.
    _ingest_event(client, incident_b["id"], occurred_at="2026-07-13T10:05:00Z", trace_id="trace-shared")
    _ingest_event(client, incident_a["id"], occurred_at="2026-07-13T10:00:00Z", trace_id="trace-shared")
    # Different trace - must not show up.
    _ingest_event(client, incident_a["id"], occurred_at="2026-07-13T10:02:00Z", trace_id="trace-other")

    response = client.get("/traces/trace-shared/timeline")
    assert response.status_code == 200
    body = response.json()

    assert len(body) == 2
    assert {event["incident_id"] for event in body} == {incident_a["id"], incident_b["id"]}
    timestamps = [event["timestamp"] for event in body]
    assert timestamps == sorted(timestamps)


def test_trace_timeline_for_unknown_trace_returns_empty_list(client):
    response = client.get("/traces/does-not-exist/timeline")
    assert response.status_code == 200
    assert response.json() == []
