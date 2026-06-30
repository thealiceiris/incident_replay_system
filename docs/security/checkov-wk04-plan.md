# W4 Checkov Pre-Lab Prediction (P3)

**Learner:** Alice Iris Kare Acquah
**Chosen cloud:** GCP

## Rules I expect my Part-A module to FAIL (prediction)

1. **CKV_GCP_64** — GKE cluster not configured with private nodes.
**Why it's a reasonable default to enforce**: private nodes reduce the attack surface by preventing direct public access to worker nodes.
2. **CKV_GCP_18** — GKE control plane is public. 
**Why it's a reasonable default to enforce**: restricting control-plane exposure reduces the risk of unauthorized administrative access and limits internet-facing infrastructure.
3. **CKV_GCP_71** — Shielded GKE Nodes feature disabled. 
**Why a reasonable default**: Shielded Nodes provide secure boot, integrity monitoring, and protection against low-level malware and rootkits.

## After the scan (Thu Part C)

<!-- Fill the comparison in docs/security/checkov-wk04.md, not here: which predictions were right?
which findings surprised you? which did you fix vs consciously defer (with rationale)? -->
