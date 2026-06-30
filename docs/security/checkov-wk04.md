# W4 Checkov Scan — Output + Triage (Thu lab Part C)

**Learner:** Alice Iris Kare Acquah
**Chosen cloud:** GCP
**Scan command:** `make checkov-scan` (raw output in docs/security/checkov-wk04-output.txt)

## Scan summary

<TODO: paste the passed/failed counts + the failed check IDs (CKV*AWS*_ / CKV*GCP*_). Don't paste all
50 lines — summarize: N passed, M failed; list the failed rule Imkdir -p docs/security
cp alice-w4-checkov-acceptance.md docs/security/checkov-wk04.md
Ds.>

## Prediction vs actual

<TODO: compare to your checkov-wk04-plan.md. Which rules did you correctly predict would fail? Which
surprised you? That gap is the learning.>

## Fixed (>= 1 required)

<TODO: name >= 1 HIGH/MEDIUM finding you FIXED. The rule ID + what you changed in the HCL + why.>

- **Rule:** <CKV*...*..>
- **Fix:** <the HCL change>
- **Why:** <one sentence>

## Consciously deferred (>= 1 required)

<TODO: name >= 1 finding you chose NOT to fix, with rationale. A conscious defer is a judgment call,
not an oversight — say why it's acceptable for this lab/pilot scope.>

- **Rule:** <CKV*...*..>
- **Deferred because:** <rationale — e.g. "private nodes (CKV_GCP_64) needs a NAT/Cloud-NAT the lab
  budget excludes; documented as a production seam, not a lab requirement.">
