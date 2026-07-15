def _create_incident(client, name="Elevated error rate"):
    return client.post("/incidents", json={"name": name}).json()


def test_ingest_event_for_existing_incident(client):
    incident = _create_incident(client)

    response = client.post(
        f"/incidents/{incident['id']}/events",
        json={
            "event_type": "log",
            "timestamp": "2026-07-13T10:05:00Z",
            "source": "api-service",
            "data": {"level": "ERROR", "message": "Connection pool exhausted"},
        },
    )
    assert response.status_code == 201
    body = response.json()
    assert body["incident_id"] == incident["id"]
    assert body["source"] == "api-service"
    assert body["data"]["level"] == "ERROR"
    assert "received_at" in body


def test_ingest_event_for_missing_incident_returns_404(client):
    response = client.post(
        "/incidents/does-not-exist/events",
        json={
            "event_type": "log",
            "timestamp": "2026-07-13T10:05:00Z",
            "source": "api-service",
            "data": {"message": "should not be stored"},
        },
    )
    assert response.status_code == 404


def test_ingest_event_missing_required_field_is_rejected(client):
    incident = _create_incident(client)

    # Missing required "source" field.
    response = client.post(
        f"/incidents/{incident['id']}/events",
        json={
            "event_type": "log",
            "timestamp": "2026-07-13T10:05:00Z",
            "data": {"message": "no source given"},
        },
    )
    assert response.status_code == 422


def test_ingest_event_bad_timestamp_is_rejected(client):
    incident = _create_incident(client)

    response = client.post(
        f"/incidents/{incident['id']}/events",
        json={
            "event_type": "log",
            "timestamp": "not-a-timestamp",
            "source": "api-service",
            "data": {},
        },
    )
    assert response.status_code == 422
