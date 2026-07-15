# W5 Deploy-Frequency Self-Measurement (Outcome 6)

**Learner:** Alice Iris Kare Acquah
**Date:** 2026-07-14

## Count

> Production (staging this week) deploys via the W5 pipeline, over ≥ 3 days.

- **Deploys this week:** 0 (`git log --since='7 days ago' --oneline --grep='deploy\|release\|ship'` — 0 matches as of 2026-07-14)

This is an honest zero, not an unmeasured gap: `.github/workflows/deploy-staging.yaml` was only just
wired up today (Part A), so no push to `main` has gone through the staging deploy pipeline yet this
week. The count will move once a PR actually merges through the new CI gate.

## DORA 2025 bucket

> Locate your count against the 2025 percentile distribution.

| Bucket | Share | Mine? |
|---|---|---|
| On-demand (multiple/day) | 16.2% | |
| Daily to Weekly | 21.9% | |
| Monthly or less | 23.9% | x |

- **My bucket:** Monthly or less — driven entirely by the pipeline not existing yet at the start of
  the week, not by batch size discipline (or the lack of it).

## One batch-size-discipline change

> Name one change you'd make to move up one bucket.

Today's work landed as one large, mixed commit surface (test suite + a docker-compose merge-conflict
fix + a repo-wide `.gitignore` + the full W5 pipeline/canary/flag scaffolding) instead of several
small PRs each going through the new `ci.yaml` gate on its own. Once `deploy-staging.yaml` is live,
the concrete change is to split future work like this into PR-sized chunks — e.g., the test suite as
one PR, the `.gitignore`/hygiene fix as another — so each one triggers its own staging deploy instead
of accumulating into a single deploy event at the end.
