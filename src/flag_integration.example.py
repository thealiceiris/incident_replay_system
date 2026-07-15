"""W5 OpenFeature + flagd integration example (Python) — Wed lab Part C.

Reference for wiring deploy/flags/flags.json's "strict-status-validation" flag into
src/backend/main.py's PATCH /incidents/{incident_id} handler (see pipelines/adr-wk05-ci-cd.md
Decision 3): main.py currently accepts any string as the new `status` value with no validation,
so this flag lets strict validation ship in the deployed artifact while staying OFF until it's
confirmed safe - flip it on via `make flag-flip`, no redeploy required.

The teaching invariant: OpenFeature's API is provider-agnostic. `get_boolean_value(...)` is identical
whether the provider is flagd (W5 default), LaunchDarkly, or Flagsmith - switching is one config line.

Install:
    pip install openfeature-sdk openfeature-provider-flagd
Run flagd (reads deploy/flags/flags.json; watches it for live flips):
    flagd start --uri f ile:./deploy/flags/flags.json
"""

from openfeature import api
from openfeature.contrib.provider.flagd import FlagdProvider

# Set the provider once at app startup (module import / main()). The default FlagdProvider connects
# to flagd over gRPC at localhost:8013 - for the W5 lab, run the app and `flagd` on the SAME host
# (your laptop / a `kubectl port-forward`), not a remote staging pod.
api.set_provider(FlagdProvider())

_client = api.get_client()

# Must match the key in deploy/flags/flags.json. default_value is the SAFE fallback (permissive,
# matching today's behavior) if flagd is unreachable.
FEATURE_KEY = "strict-status-validation"

VALID_STATUSES = {"active", "investigating", "resolved"}


def handle_status_update(incident_id: str, requested_status: str):
    """Example handler mirroring main.py's update_incident_status.

    TODO(lab-part-c): wire this branch into src/backend/main.py's actual
    PATCH /incidents/{incident_id} handler instead of duplicating it here.
    """
    # The flag decouples DEPLOY from RELEASE: this validation is in the deployed artifact, but it
    # only rejects bad input once the flag is flipped on (no redeploy). `make flag-flip` flips it live.
    if _client.get_boolean_value(FEATURE_KEY, False):
        return new_code_path(incident_id, requested_status)
    return old_code_path(incident_id, requested_status)


def new_code_path(incident_id: str, requested_status: str):  # TODO(lab-part-c): strict validation
    raise NotImplementedError


def old_code_path(incident_id: str, requested_status: str):  # TODO(lab-part-c): today's permissive behavior
    raise NotImplementedError
