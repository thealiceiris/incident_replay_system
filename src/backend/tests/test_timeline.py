def _create_incident(client, name="Failed deploy causing 500s"):
    return client.post("/incidents", json={"name": name}).json()


def _ingest_event(client, incident_id, *, occurred_at, source="api-service", event_type="log"):
    response = client.post(
        f"/incidents/{incident_id}/events",
        json={
            "event_type": event_type,
            "timestamp": occurred_at,
            "source": source,
            "data": {"message": f"event at {occurred_at}"},
        },
    )
    assert response.status_code == 201
    return response.json()


def test_timeline_orders_events_by_occurrence_time_not_ingestion_order(client):
    incident = _create_incident(client)

    # Ingest out of order: the "middle" event arrives first, "first" arrives last.
    _ingest_event(client, incident["id"], occurred_at="2026-07-13T10:05:00Z")
    _ingest_event(client, incident["id"], occurred_at="2026-07-13T10:00:00Z")
    _ingest_event(client, incident["id"], occurred_at="2026-07-13T10:10:00Z")

    response = client.get(f"/incidents/{incident['id']}/timeline")
    assert response.status_code == 200
    body = response.json()

    timestamps = [event["timestamp"] for event in body["events"]]
    assert timestamps == sorted(timestamps)
    assert len(body["events"]) == 3


def test_timeline_for_missing_incident_returns_404(client):
    response = client.get("/incidents/does-not-exist/timeline")
    assert response.status_code == 404


def test_timeline_includes_incident_metadata(client):
    incident = _create_incident(client, name="Payment API outage")

    response = client.get(f"/incidents/{incident['id']}/timeline")
    assert response.status_code == 200
    body = response.json()
    assert body["incident_id"] == incident["id"]
    assert body["incident_name"] == "Payment API outage"
    assert body["incident_status"] == "active"
    assert body["events"] == []
