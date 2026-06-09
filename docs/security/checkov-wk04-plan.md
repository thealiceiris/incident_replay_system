# W4 Checkov Pre-Lab Prediction (P3)


**Learner:** <Alice Iris Kare Acquah>
**Chosen cloud:** <GCP>

## Rules I expect my Part-A module to FAIL (prediction)

<!--
2-3 rules. Use real Checkov rule IDs for your cloud. Examples:
- CKV_AWS_58 — "EKS cluster has secrets encryption" (AWS)
- CKV_AWS_39 — "EKS cluster endpoint public access is restricted" (AWS)
- CKV_GCP_64 — "GKE cluster uses private nodes" (GCP)
- CKV_GCP_65 — "Manage K8s RBAC users with Google Groups for GKE" (GCP)
Look yours up: https://www.checkov.io/5.Policy%20Index/terraform.html
-->

1. **<CKV_GCP_64>** — <GKE cluster not configured with private nodes.>. Why it's a reasonable default to enforce: <private nodes reduce the attack surface by preventing direct public access to worker nodes.>.
2. **<CKV_GCP_18>** — <GKE control plane is public.c>. Why it's a reasonable default to enforce: <Why it's a reasonable default to enforce: restricting control-plane exposure reduces the risk of unauthorized administrative access and limits internet-facing infrastructure.>.
3. **<RULE_ID (optional)>** — <Shielded GKE Nodes feature disabled>. Why a reasonable default: <why it's a reasonable default to enforce: Shielded Nodes provide secure boot, integrity monitoring, and protection against low-level malware and rootkits.>.

## After the scan (Thu Part C)

<!-- Fill the comparison in docs/security/checkov-wk04.md, not here: which predictions were right?
which findings surprised you? which did you fix vs consciously defer (with rationale)? -->
