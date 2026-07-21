from openfeature import api as feature_api
from openfeature.contrib.provider.flagd import FlagdProvider

# Feature flags (flagd, local provider - see deploy/flags/flags.json).
# default_value stays permissive: if flagd is unreachable, behavior matches pre-flag main.py.
feature_api.set_provider(FlagdProvider())
_flags = feature_api.get_client()
VALID_INCIDENT_STATUSES = {"active", "investigating", "resolved"}
