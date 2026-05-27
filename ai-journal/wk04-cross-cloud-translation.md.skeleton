# W4 AI Journal — Arc-2 LOCKED 6-Point Entry (Cross-Cloud Translation)

<!--
Skeleton for cohort-7 W4. Copy this file (`make ai-journal-init` from hyperion/week-04/) to
ai-journal/wk04-cross-cloud-translation.md in your capstone repo, fill the 6 points, commit, push.

SAME LOCKED FORMAT as W3 — the 6-point structure does not change for the rest of the curriculum.
W4's activity is the Thu Lab Part-B AI-assisted CROSS-CLOUD TRANSLATION: take your Part-A module
(one cloud) and have AI produce the OTHER cloud's module, then critique it + name the seams.

W4 LOCKED requirements (W3 shape, W4 content):
1. Point 3 cites a named primary source — a Terraform Registry resource list (URL), a Checkov rule
   doc (ID + URL), or a cloud-provider canonical module. If AI hallucinated a resource type, cite
   the authoritative list that falsifies it.
2. Point 4 MUST include the self-audit prompt, verbatim: "list the semantic gaps you did not
   explicitly name in translation seams."
3. Point 6 names ONE concrete AI strength + ONE concrete fix ("AI was helpful" does not count).

Due: Sun 2026-05-31 23:59 GMT (4bdu1 confirms). week-04-check CI gates on this file — green CI is
your W4 cohort-readiness signal.

Maps to DORA AI Capabilities: #3 (AI-accessible internal data — the Terraform Registry is the
authoritative ground truth) + #4 (strong VCS — AI prompts in git; cohort norm 100% vs industry ~21%)
+ #2 (healthy data ecosystems — your Outcome-7 data-layer config).
-->

**Learner:** <your name>
**Date:** <YYYY-MM-DD>

---

## 1. The prompt you gave the AI

<The Thu Part-B translation request — final iterated version. Shape:

> "Here is my AWS Terraform module [paste modules/aws/main.tf]. Produce the GCP equivalent as
> modules/gcp/main.tf, preserving the shared variable contract (name / region / tags / node_size /
> replicas / data_layer_config). For every place the translation is NOT 1-in-1, add a
> `# TRANSLATION SEAM:` comment naming the semantic gap."

Paste the exact prompt you gave.>

## 2. The first response (verbatim)

<Paste AI's initial cross-cloud translation exactly as received. The verbatim response is your audit
trail — calibration without it is hand-waving.>

## 3. Your critique against a NAMED PRIMARY-SOURCE as ground truth

<W4 LOCKED: cite ONE, specifically:

- Terraform Registry — the chosen provider's actual resource list + version (URL), e.g.
  https://registry.terraform.io/providers/hashicorp/google/latest/docs
- Checkov — a rule ID + its official doc (e.g. CKV_GCP_64 + the checkov.io page)
- A cloud-provider canonical module (terraform-aws-modules / terraform-google-modules)

THEN name either (a) one thing AI got right that the source confirms, or (b) one thing AI got
wrong / soft / missing. IF AI HALLUCINATED A RESOURCE (e.g. invented `google_eks_cluster`, which
does not exist — the real type is `google_container_cluster`), cite the authoritative resource list
that falsifies it.

NOT acceptable: "the translation looked correct." Quote the source + name the catch.>

## 4. Your second prompt refining the AI's output

<W4 LOCKED: the critique must drive a refined prompt, and it MUST include the self-audit ask,
verbatim:

> "List the semantic gaps you did NOT explicitly name in translation seams."

Then pick one: (a) your full refined prompt + AI's second response verbatim, OR (b) AI self-corrected
— what changed, OR (c) AI held firm and you overruled it — why your judgment was stronger.>

## 5. Final artifact committed (path + commit hash)

<Per W4 Outcome 6 — point 5 is the TRANSLATED MODULE, not this journal entry.

- **Path:** `infra/terraform/modules/<other-cloud>/main.tf` — committed with >= 2
  `# TRANSLATION SEAM:` comments.
- **Short commit hash:** capture from `git log -1 --format=%h infra/terraform/modules/<other-cloud>/main.tf`.>

## 6. One sentence on calibration: AI strength + your fix

<W4 LOCKED: ONE concrete AI strength + ONE concrete fix. Be specific:

- "AI correctly mapped aws_eks_node_group -> google_container_node_pool and carried the node_size
  enum; I had to fix its claim that S3 versioning == GCS versioning — it missed that GCS keeps
  versions indefinitely until a lifecycle rule removes them."

NOT "AI was helpful" / "AI got X wrong.">

---

<!--
PRE-COMMIT CHECKLIST (Sun deliverable):
- [ ] Point 1 — final translation prompt pasted
- [ ] Point 2 — first response verbatim
- [ ] Point 3 — named primary source (Registry / Checkov / provider) + a concrete catch
- [ ] Point 4 — includes the "semantic gaps you did not name" self-audit prompt
- [ ] Point 5 — modules/<other-cloud>/main.tf path + commit hash; >= 2 seams in that file
- [ ] Point 6 — concrete AI strength + concrete fix

week-04-check CI gates on this file. Green CI = W4 ready. Same locked format runs every lab week.
-->
