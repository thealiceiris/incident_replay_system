# deploy/evidence/

Commit your Part B canary demo-run screenshots here:

- `canary-rollback-YYYY-MM-DD.png` from `make canary-demo-bad`: the canary at 20%, the analysis
  evaluating, the failureCondition tripping, and Argo Rollouts rolling back to the previous
  version. Annotate which metric-point tripped (Proficient).
- `canary-success-YYYY-MM-DD.png` from `make canary-demo-good`: the promotion steps 20% → 50% → 100%.

Both screenshots are a Peer Review 1 acceptance item. For the cleanest view to screenshot, run
`kubectl argo rollouts get rollout <name> --watch -n staging`.
