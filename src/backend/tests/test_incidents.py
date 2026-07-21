def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_create_incident(client):
    response = client.post("/incidents", json={"name": "Database connection pool exhausted"})
    assert response.status_code == 201
    body = response.json()
    assert body["name"] == "Database connection pool exhausted"
    assert body["status"] == "active"
    assert "id" in body and body["id"]
    assert "created_at" in body


def test_create_incident_with_metadata(client):
    response = client.post(
        "/incidents",
        json={"name": "Elevated 500s", "metadata": {"service": "checkout", "region": "us-east1"}},
    )
    assert response.status_code == 201
    assert response.json()["metadata"] == {"service": "checkout", "region": "us-east1"}


def test_create_incident_missing_name_is_rejected(client):
    response = client.post("/incidents", json={})
    assert response.status_code == 422


def test_list_incidents_returns_created_incidents(client):
    client.post("/incidents", json={"name": "First incident"})
    client.post("/incidents", json={"name": "Second incident"})

    response = client.get("/incidents")
    assert response.status_code == 200
    names = {incident["name"] for incident in response.json()}
    assert names == {"First incident", "Second incident"}


def test_update_incident_status(client):
    created = client.post("/incidents", json={"name": "Flaky deploy"}).json()

    response = client.patch(f"/incidents/{created['id']}", params={"status": "resolved"})
    assert response.status_code == 200
    assert response.json()["status"] == "resolved"


def test_update_incident_status_not_found(client):
    response = client.patch("/incidents/does-not-exist", params={"status": "resolved"})
    assert response.status_code == 404


def test_update_incident_status_permissive_when_flag_off(client):
    # strict-status-validation defaults off (no flagd reachable in tests) - any string is accepted,
    # matching the app's pre-flag behavior.
    created = client.post("/incidents", json={"name": "Flag off"}).json()

    response = client.patch(f"/incidents/{created['id']}", params={"status": "bogus-status"})
    assert response.status_code == 200
    assert response.json()["status"] == "bogus-status"


def test_update_incident_status_rejects_invalid_when_flag_on(client, monkeypatch):
    import main

    monkeypatch.setattr(main._flags, "get_boolean_value", lambda *a, **k: True)
    created = client.post("/incidents", json={"name": "Flag on"}).json()

    response = client.patch(f"/incidents/{created['id']}", params={"status": "bogus-status"})
    assert response.status_code == 422

    response = client.patch(f"/incidents/{created['id']}", params={"status": "resolved"})
    assert response.status_code == 200
