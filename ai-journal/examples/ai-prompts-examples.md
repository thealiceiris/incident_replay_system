# W4 Lab — AI Prompt Examples (learner-facing reference)

This file teaches you HOW to use AI well during the W4 lab — especially the **Part B cross-cloud
translation**, which is W4's named skill (Outcome 3 + 6). It complements
`wk04-cross-cloud-translation.md.skeleton` (your blank journal).

**The week's AI skill is not "generate Terraform faster." It's "use AI to translate + name the
seams."** Translation is NOT 1-in-1-out; the discipline is making the semantic gaps visible in the
code as `# TRANSLATION SEAM:` comments, verified against the Terraform Registry.

---

## Quick reference — where AI shows up this week

| Part | AI usage | Journaled? |
|---|---|---|
| Mon Concept Socratic | — | — |
| Thu Part A — single-cloud module | OPTIONAL — scaffold help AFTER you've structured your own `variables.tf` | NO — sandbox |
| **Thu Part B — cross-cloud translation** | **REQUIRED** (Outcome 3 + 6) — AI translates module + you critique against the Registry, multi-turn | YES — `ai-journal/wk04-cross-cloud-translation.md` (CI hard-fail Sun) |
| Thu Part C — Checkov triage | OPTIONAL — help reading/triaging findings; YOU decide fix vs defer | NO — sandbox |

**Single-turn AI use in Part B does NOT count toward Outcome 6.** The journaled gate is the
multi-turn translate→critique→refine loop.

---

## Cross-cutting principles

1. **Tool-agnostic.** Claude / ChatGPT / Cursor — whatever you use. Sensei demos with one; no mandate.
2. **Capture verbatim BEFORE critique.** Paste the AI's translation into your journal exactly as
   received. Edits invalidate the audit trail.
3. **The Terraform Registry is ground truth.** AI invents plausible-but-wrong resource types under
   time pressure (e.g. `google_eks_cluster` — does not exist; the real type is
   `google_container_cluster`). Verify every translated resource against
   https://registry.terraform.io before you trust it.
4. **Specific scope beats generic prompt.** Paste your actual module + your variable contract. "Convert
   this to GCP" with no module produces a generic stereotype, not your translation.
5. **Make AI name the cost-model difference.** AI defaults to claiming cost-parity. EKS ($0.10/hr
   control plane, no free tier) and GKE Autopilot (free-tier-covered for one cluster, per-pod billing)
   are NOT equivalent — make AI quantify the difference.

---

## Part B — cross-cloud translation (REQUIRED — Outcome 3 + 6)

### The prompt template

> *"Here is my AWS Terraform module [paste `modules/aws/main.tf`]. Produce the GCP equivalent as
> `modules/gcp/main.tf`, preserving my shared variable contract (name / region / tags / node_size /
> replicas / data_layer_config). For every place the translation is NOT 1-in-1, add a
> `# TRANSLATION SEAM:` comment naming the semantic gap."*

### Worked example — EKS + S3 → GKE + GCS

**Domain (synthetic; structurally adjacent to all capstones — K8s + a managed object store):** your
Part-A module stands up EKS + an S3 bucket (versioning on) + an IAM OIDC provider. You ask AI to
translate it to GCP.

#### Step 1 — Expected 1st response shape

**A GOOD 1st response:**

> "Translated `aws_eks_cluster` → `google_container_cluster`; `aws_eks_node_group` →
> `google_container_node_pool` (node_size `small`→`e2-medium`). Seams flagged:
> `# TRANSLATION SEAM: S3 versioning uses status=Enabled + delete markers; GCS versioning keeps
> versions indefinitely until a lifecycle_rule removes them.`
> `# TRANSLATION SEAM: AWS OIDC + IRSA (pod assumes an IAM role) → GCP workload identity pool (K8s SA
> bound to a GCP SA) — not a 1-in-1 mapping.`
> Cost note: GKE Autopilot's one-cluster management fee is free-tier-covered; EKS control plane is
> ~$0.10/hr with no free tier. Verified resource names against registry.terraform.io/providers/hashicorp/google/latest/docs."

**A SHALLOW / hallucinated 1st response:**

> "Here's your GCP module. Used `google_eks_cluster` and `google_s3_bucket`; the translation is
> 1-in-1, cost is the same on both clouds."

What's wrong: `google_eks_cluster` and `google_s3_bucket` **do not exist** (real:
`google_container_cluster`, `google_storage_bucket`); "1-in-1" is false (versioning + IAM semantics
differ); "cost is the same" is false. **Do not accept this.** Re-prompt:

> *"`google_eks_cluster` is not a real resource — verify every type against the Terraform Registry.
> Re-translate, and for each resource name confirm it exists in the hashicorp/google provider docs."*

#### Step 2 — Critique against the Registry (journal point 3)

Open the actual Registry page. Confirm (or falsify) each resource + behavior the AI claimed.

> *Example point-3 entry: "Per registry.terraform.io/providers/hashicorp/google/latest/docs, the
> bucket resource is `google_storage_bucket`, not the AI's `google_s3_bucket`. The provider's
> `versioning` block only toggles `enabled` — there is no delete-marker concept, confirming the
> AI's first response wrongly implied S3-equivalent lifecycle. I added a `# TRANSLATION SEAM:` for
> the versioning gap."*

#### Step 3 — 2nd-turn self-audit (journal point 4, REQUIRED form)

Your refined prompt MUST include the self-audit ask, verbatim:

> *"List the semantic gaps you did NOT explicitly name in translation seams."*

Then capture one of: (a) refined prompt + AI's 2nd response verbatim, (b) AI self-corrected — what
changed, (c) AI held firm — you overruled with reasoning.

#### Step 4 — Final artifact + hash (journal point 5)

```bash
git add infra/terraform/modules/<other-cloud>/main.tf
git commit -m "W4 cross-cloud translation (Part B)"
git log -1 --format=%h infra/terraform/modules/<other-cloud>/main.tf   # paste this into point 5
```

The file must carry **≥2 `# TRANSLATION SEAM:`** comments.

#### Step 5 — Calibration sentence (point 6)

ONE concrete AI strength + ONE concrete fix. NOT "AI was helpful."

> *Good: "AI correctly mapped the node-pool resource + carried the node_size enum; I had to fix its
> claim that S3 and GCS versioning are equivalent — it missed the indefinite-retention seam, which is
> now my load-bearing data-layer note."*

---

## Part A — single-cloud module (OPTIONAL — sandbox)

AI can scaffold **after** you've structured your own `variables.tf` (the cloud-neutral contract is
YOUR design — don't let AI invent it). Good use: "given this `variables.tf`, scaffold an
`aws_eks_node_group` that maps `var.node_size` to instance types." Verify against the Registry.

**Anti-pattern:** "write me a Terraform EKS module" before you've designed the contract — defeats
Outcome 2 (the shared-contract discipline is the point).

---

## Part C — Checkov triage (OPTIONAL — sandbox)

AI can help you READ a finding ("what does CKV_AWS_58 want and why?") and weigh fix-vs-defer. But the
fix and the conscious-defer rationale are YOURS — Outcome 5 is about your triage judgment, not AI's.

**Anti-pattern:** "fix all Checkov findings" — you must consciously decide which to fix and which to
defer with rationale; blindly applying AI fixes can break `terraform apply` or over-restrict the lab cluster.

---

## Cross-cutting anti-patterns (sweep before commit)

1. **Accepting "1-in-1-out" translation** — it never is; name the seams.
2. **Trusting AI resource names** — `google_eks_cluster` doesn't exist; verify every type on the Registry.
3. **Vague scope** — paste your actual module + contract, not "convert to GCP."
4. **Ignoring cost-model differences** — make AI quantify EKS-vs-GKE; they are not equivalent.
5. **Single-turn Part B** — breaks Outcome 6; the calibration loop is multi-turn.
6. **Skipping the self-audit prompt** — point 4 requires "list the semantic gaps you did not name."

If you catch yourself doing any of these mid-prompt, stop and re-prompt with the corrected shape.
