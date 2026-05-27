# Hyperion W4 — Provision (IaC): Terraform skeletons + ADR + Checkov + seam + AI journal targets.
#
# These skeletons mirror your FLAT capstone-repo layout (infra/, docs/, ai-journal/). Copy the
# week-04 starter into your capstone repo, then run these targets from the capstone repo root.
#
# Target names follow week-04-provision.md (spec line 270): tf-init / tf-plan / tf-apply / tf-destroy
# / checkov-scan / translate-cloud, plus the per-artifact init helpers.
#
# COST DISCIPLINE: `terraform apply` bills real money. Apply ONE cloud, `make tf-destroy` before you
# close the lab, keep each lab under $10. State files are NEVER committed (infra/terraform/.gitignore).

.PHONY: help env-check starter pre-read-init adr-init checkov-plan-init seam-init ai-journal-init \
        tf-init tf-plan tf-apply tf-destroy validate checkov-scan translate-cloud

PRE_READ      := docs/pre-read-reflection-wk04.md
ADR           := docs/adr/0002-iac-choices.md
CHECKOV_PLAN  := docs/security/checkov-wk04-plan.md
CHECKOV_OUT   := docs/security/checkov-wk04-output.txt
SEAM          := docs/architecture/w3-to-w4-integration-seam.md
AI_JOURNAL    := ai-journal/wk04-cross-cloud-translation.md
TF_DIR        := infra/terraform

help:
	@echo "W4 targets:"
	@echo "  env-check          Check required tooling + W4 deliverable paths."
	@echo "  starter            Copy ALL W4 skeletons to their real (flat) paths."
	@echo "  pre-read-init      -> $(PRE_READ)        adr-init        -> $(ADR)"
	@echo "  checkov-plan-init  -> $(CHECKOV_PLAN)    seam-init       -> $(SEAM)"
	@echo "  ai-journal-init    -> $(AI_JOURNAL)"
	@echo "  tf-init            Strip infra/terraform/*.skeleton, then 'terraform init'."
	@echo "  tf-plan            terraform plan (feedback; no changes)."
	@echo "  tf-apply           terraform apply (provisions real resources - bills money)."
	@echo "  tf-destroy         terraform destroy (COST GUARD - run BEFORE you close the lab)."
	@echo "  validate           terraform fmt -check + terraform validate."
	@echo "  checkov-scan       checkov -d $(TF_DIR) -> $(CHECKOV_OUT) (Thu lab Part C)."
	@echo "  translate-cloud    Print the Claude Code cross-cloud translation prompt (Part B)."

env-check:
	@echo "==> tooling"
	@if command -v terraform >/dev/null 2>&1; then terraform version | head -1; else echo "MISSING: terraform (>= 1.9) — https://developer.hashicorp.com/terraform/install"; fi
	@if command -v aws >/dev/null 2>&1; then echo "OK: aws CLI"; elif command -v gcloud >/dev/null 2>&1; then echo "OK: gcloud CLI"; else echo "MISSING: aws OR gcloud CLI (your chosen cloud)"; fi
	@if command -v checkov >/dev/null 2>&1; then echo "OK: checkov"; else echo "MISSING: checkov — 'pip install checkov' (needed Thu lab Part C)"; fi
	@if command -v kubectl >/dev/null 2>&1; then echo "OK: kubectl"; else echo "MISSING: kubectl"; fi
	@echo "==> W4 deliverable paths"
	@for f in "$(ADR)" "$(TF_DIR)/variables.tf" "$(AI_JOURNAL)"; do \
		if [ -e "$$f" ]; then echo "OK: $$f"; else echo "WARN: $$f missing — see 'make help'"; fi; \
	done

# strip_skeleton: $(call strip_skeleton,<real-path>) — copies <real-path>.skeleton if not present.
define strip_skeleton
	@if [ -e "$(1)" ]; then \
		echo "$(1) already exists. Not overwriting."; \
	elif [ -e "$(1).skeleton" ]; then \
		cp "$(1).skeleton" "$(1)" && echo "Created $(1) from skeleton."; \
	else \
		echo "ERROR: $(1).skeleton not found. Copy the week-04 starter into your capstone repo first."; \
	fi
endef

pre-read-init:
	$(call strip_skeleton,$(PRE_READ))
adr-init:
	@mkdir -p docs/adr
	$(call strip_skeleton,$(ADR))
	@echo "Mon: fill Status + Context + Decision. Thu Part A: full MADR + team + seam."
checkov-plan-init:
	@mkdir -p docs/security
	$(call strip_skeleton,$(CHECKOV_PLAN))
seam-init:
	@mkdir -p docs/architecture
	$(call strip_skeleton,$(SEAM))
ai-journal-init:
	@mkdir -p ai-journal
	$(call strip_skeleton,$(AI_JOURNAL))

starter: pre-read-init adr-init checkov-plan-init seam-init ai-journal-init tf-init
	@echo "All W4 skeletons placed. Edit, then commit to your capstone repo."

tf-init:
	@for f in versions variables main outputs; do \
		if [ ! -e "$(TF_DIR)/$$f.tf" ] && [ -e "$(TF_DIR)/$$f.tf.skeleton" ]; then \
			cp "$(TF_DIR)/$$f.tf.skeleton" "$(TF_DIR)/$$f.tf" && echo "Created $(TF_DIR)/$$f.tf"; fi; \
	done
	@for c in aws gcp; do \
		if [ ! -e "$(TF_DIR)/modules/$$c/main.tf" ] && [ -e "$(TF_DIR)/modules/$$c/main.tf.skeleton" ]; then \
			cp "$(TF_DIR)/modules/$$c/main.tf.skeleton" "$(TF_DIR)/modules/$$c/main.tf" && echo "Created $(TF_DIR)/modules/$$c/main.tf"; fi; \
	done
	@if [ ! -e "$(TF_DIR)/.gitignore" ] && [ -e "$(TF_DIR)/.gitignore.skeleton" ]; then cp "$(TF_DIR)/.gitignore.skeleton" "$(TF_DIR)/.gitignore"; fi
	@if [ ! -e "$(TF_DIR)/.terraform-version" ] && [ -e "$(TF_DIR)/.terraform-version.skeleton" ]; then cp "$(TF_DIR)/.terraform-version.skeleton" "$(TF_DIR)/.terraform-version"; fi
	@echo "Fill the TODO(lab-part-a) markers, then:" ; terraform -chdir=$(TF_DIR) init

tf-plan:
	terraform -chdir=$(TF_DIR) plan
tf-apply:
	@echo "COST: this provisions real resources. Remember 'make tf-destroy' before you close the lab."
	terraform -chdir=$(TF_DIR) apply
tf-destroy:
	@echo "COST GUARD: destroying the cluster + resources so they stop billing."
	terraform -chdir=$(TF_DIR) destroy
validate:
	terraform -chdir=$(TF_DIR) fmt -check -recursive
	terraform -chdir=$(TF_DIR) validate

checkov-scan:
	@mkdir -p docs/security
	checkov -d $(TF_DIR) | tee $(CHECKOV_OUT)
	@echo "Scan written to $(CHECKOV_OUT). Now write up docs/security/checkov-wk04.md (>=1 fix + >=1 conscious-defer)."

translate-cloud:
	@echo "Paste this into Claude Code (Part B cross-cloud translation):"
	@echo "---"
	@echo "Here is my AWS module [paste infra/terraform/modules/aws/main.tf]. Produce the GCP"
	@echo "equivalent as modules/gcp/main.tf, preserving the shared variable contract"
	@echo "(name/region/tags/node_size/replicas/data_layer_config). For every place the translation"
	@echo "is NOT 1-in-1, add a '# TRANSLATION SEAM:' comment naming the semantic gap. Verify every"
	@echo "resource type exists in the Terraform Registry before you output it."
	@echo "---"
