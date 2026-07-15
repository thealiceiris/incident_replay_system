# W5 AI Journal: Arc-2 LOCKED 6-Point Entry (CI/CD Build + Test Generation)

**Learner:** Alice Iris Kare Acquah
**Date:** <YYYY-MM-DD>

---

## 1. The prompt you gave the AI

<The final iterated prompt to draft your GitHub Actions CI workflow for the capstone. Paste it exactly.>

## 2. The first response (verbatim)

<Paste the AI's first-draft YAML before any iteration. The verbatim response is your audit trail.>

## 3. Your critique against ground truth

<Two grounds:

(a) **GitHub Actions docs:** cite the official doc section (e.g. `actions/checkout@v4` usage; the
OIDC cloud-auth pattern; `permissions:` scoping). Name one thing AI got right that the docs confirm,
or one thing wrong/soft/missing.

(b) **One AI-generated test, run for real:** did it pass on first `pytest` run? If it failed, was it
a *real* failure (catches a real behavior/edge case) or a *fabricated* failure (asserts a
non-existent API / a tautology)? Quote the test + the run output.

NOT acceptable: "the workflow looked correct." Cite the source + name the catch.>

## 4. Your second prompt(s) refining the output

<One refining prompt for the workflow + one for the test generation. Paste the prompts; note whether
the AI self-corrected, you overruled it, or it held firm.>

## 5. Final artifacts committed (paths + commit hashes)

- **Workflow:** `.github/workflows/ci.yaml`, commit hash <`git log -1 --format=%h .github/workflows/ci.yaml`>
- **AI-validated tests:** `src/backend/tests/`, commit hash; note which tests were valid and why.

## 6. Calibration close: TWO sentences

- **AI strength + your fix (one sentence):** <one concrete thing AI did well + one concrete fix.>
- **What Peer Review 1 revealed that your own review didn't (one sentence):** <the integration seam
  between your W4 IaC and W5 CI/CD that your partner saw and you, as author of both, didn't.>

---

## Outcome 8: Peer Review 1 feedback exchange (REQUIRED)

<Three actionable items each, specific and file-path-cited.>

**Three most actionable items I RECEIVED (from my partner):**
1. <...>
2. <...>
3. <...>

**Three most actionable items I GAVE (to my partner):**
1. <...>
2. <...>
3. <...>

---

## Outcome 7: DORA 2024 → 2025 evolution (REQUIRED paragraph)

<One paragraph. From the 2024 "AI paradox" (25% AI adoption → +3.1% review speed, but −1.5%
throughput, −7.2% stability; cause = larger batch sizes) to the 2025 "partial reversal" (throughput
correlation reversed positive; instability still negative). Locate W5's CI/CD + progressive delivery
as the discipline that resolved the throughput side; name the *unresolved stability side* as why your
canary-analysis + rollback are not cosmetic. Cite ≥ 2 specific numbers.>

---

<!--
This file is a scaffold, not a completed entry. Points 1-6 and Outcome 8 need your actual prompts,
the AI's actual verbatim first response, a real `pytest` run, and real Peer Review 1 feedback from a
partner — none of which exist yet at scaffold time. Fill these in honestly once you've done the Wed
lab and the peer-review exchange; that is what week-05-check's CI gate is verifying.

PRE-COMMIT CHECKLIST (Sun deliverable):
- [ ] Points 1-2: final prompt + first response verbatim
- [ ] Point 3: GitHub Actions docs citation + one real test run critiqued (real vs fabricated failure)
- [ ] Point 4: refining prompt(s) for workflow + test generation
- [ ] Point 5: ci.yaml path + hash; AI-test paths + which tests were valid
- [ ] Point 6: TWO sentences (AI strength+fix; Peer Review 1 revelation)
- [ ] Outcome 8: three feedback items received + three given
- [ ] Outcome 7: DORA 2024 → 2025 paragraph with ≥ 2 cited numbers

week-05-check CI gates on this file. Green CI = W5 ready.
-->
