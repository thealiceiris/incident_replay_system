# W5 Pre-Read Reflection

**Learner:** Alice Iris Kare Acquah
**Date:** 2026-07-09
**Due:** before the W5 Concept Socratic (pre-read closes Mon 08:00 GMT; 4bdu1 confirms the pin)

---

## Pre-read sources

~2.0 hr core (items 1-6) + 15 min optional (item 7) = ~2.25 hr. Lighter end of the range because the
Wed lab is load-bearing (CI + canary + feature flag in 90 min is tight) and Friday's Peer Review 1
needs no new reading; your partner's artifacts are the reading.

| #   | Source                                                                                         | Link                                                                                                                | Time   |
| --- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------ |
| 1   | Allspaw & Hammond, "10+ Deploys Per Day" (Velocity 2009) + Debois, DevOpsDays '09 announcement | https://www.youtube.com/watch?v=LdOe18KhtT4 + https://groups.google.com/g/agile-system-administration/c/hp7WBg4uCJI | 45 min |
| 2   | Gene Kim, "The Three Ways: The Principles Underpinning DevOps" (2012)                          | https://itrevolution.com/articles/the-three-ways-principles-underpinning-devops/                                    | 20 min |
| 3   | DORA 2024 Accelerate State of DevOps announcement (the AI paradox)                             | https://cloud.google.com/blog/products/devops-sre/announcing-the-2024-dora-report                                   | 15 min |
| 4   | DORA 2025 State of AI-assisted Software Development announcement (the partial reversal)        | https://cloud.google.com/blog/products/ai-machine-learning/announcing-the-2025-dora-report                          | 15 min |
| 5   | Argo Rollouts: How it works + Canary + Analysis Template concept pages                         | https://argo-rollouts.readthedocs.io/en/stable/concepts/ (+ /features/canary/ + /features/analysis/)                | 25 min |
| 6   | Google SRE Workbook Ch. 4: Monitoring                                                          | https://sre.google/workbook/monitoring/                                                                             | 20 min |
| 7   | [OPTIONAL] Charity Majors, "Deploy Is Not Release"                                             | charity.wtf (or Honeycomb blog excerpt)                                                                             | 15 min |

---

## P1: Your deploy rhythm + the W4 substrate

> Watch Allspaw & Hammond's Velocity 2009 talk. They claim **"10+ deploys per day"** as the catalyst
> for the DevOps movement. For your capstone as it stands at end of W4, **how often will you deploy
> this week?** And name **one thing about your W4 Terraform stack that would break or grow painful
> at 10 deploys/day.**

I expect to deploy frequently this week, likely 10-20 times, as I build and iterate on the CI/CD pipeline, canary analysis, and feature flagging for the lab.
The most painful part of my W4 Terraform stack at 10+ deploys/day would be the synchronous dependency on Cloud SQL schema migrations. Every `terraform apply` that touches the database instance is slow. If I were also changing the database schema with each application deploy, the risk of a slow or failed migration blocking the pipeline would be high, directly contradicting the goal of fast, reliable deployments.

---

## P2: DORA 2024 → 2025, what moved and what didn't

> Read the DORA 2024 announcement (item 3) AND the 2025 announcement (item 4) back-to-back. In one
> paragraph: **what changed between 2024 and 2025 in DORA's story about AI?** Name the specific number
> that moved (hint: the throughput correlation). Name the number that _didn't_ move (hint: stability).
> **Which of the two do you expect W5's pipeline to help with? Which will it NOT solve?**

Between the 2024 and 2025 DORA reports, the story around AI's impact on software delivery shifted significantly. In 2024, AI-assisted development correlated with a 1.5% _decrease_ in throughput and a 7.2% _decrease_ in stability. By 2025, the narrative reversed for throughput, which saw a positive correlation with AI use. However, the stability number did not improve; instability persisted as a challenge. The W5 pipeline, with its focus on Argo Rollouts and canary analysis, is designed to directly address the _stability_ problem by providing a safety net that catches issues before they reach all users. It will help improve stability by automating rollbacks on failure. However, this pipeline will _not_ by itself solve the throughput problem; it adds safety but also introduces steps that can slow down a deployment compared to a simple "all-at-once" push.

---

## P3: Wed lab hook, pick your canary SLI

> Read the Argo Rollouts "How it works" + "Canary" + "Analysis Template" concept pages (item 5). For
> your capstone service: **what SLI would you put in the analysis template's success condition?** You
> have no Prometheus yet (that's W6), so what's the _simplest_ signal a canary-analysis step could
> use this week: HTTP 5xx-rate from ingress logs? pod-restart count? `/healthz` 200-count over a
> window?

- **My canary SLI choice (5xx-rate / pod-restart / healthz):** pod-restart count
- **One sentence why it fits my capstone's failure modes:** A primary failure mode for my service is a database connection failure or a bad migration, which would cause the FastAPI application to fail on startup, leading to a pod crash loop that is easily and quickly detectable as a pod-restart count SLI.

---

**Commit + push** on main. week-05-check CI does NOT gate on this file; it's a 4bdu1-review artifact.
CI gates on `ai-journal/wk05-ci-cd-build.md` (Sun-deliverable).
