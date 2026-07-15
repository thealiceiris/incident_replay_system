# Hyperion W5 — Deliver (CI/CD + progressive delivery): pipeline + canary + feature-flag skeletons,
# ADR / deploy-frequency / AI-journal init helpers, and the lab demo targets.
#
# These skeletons mirror your FLAT capstone-repo layout (.github/, pipelines/, deploy/, src/, docs/,
# ai-journal/). Copy the week-05 starter into your capstone repo, then run these targets from the
# capstone repo root.
#
# Target names follow week-05-deliver.md (spec line 259): ci-local / canary-demo-good /
# canary-demo-bad / flag-flip / measure-deploys, plus the per-artifact init helpers.
#
# COST: W5 deploys INTO the W4 cluster; it does not provision new infra. Deploy to `staging` only.
# OIDC always — no long-lived cloud credentials in git (the CI gate hard-fails on them).

.PHONY: help env-check starter pre-read-init adr-init flags-init flag-integration-init \
        workflows-init deploy-freq-init reflection-init ai-journal-init \
        ci-local canary-demo-good canary-demo-bad flag-flip measure-deploys creds-check tf-destroy

PRE_READ        := docs/pre-read-reflection-wk05.md
ADR             := pipelines/adr-wk05-ci-cd.md
ROLLOUT         := deploy/rollouts/capstone-rollout.yaml
ANALYSIS        := deploy/rollouts/analysis-template.yaml
KUSTOMIZE       := deploy/kustomization.yaml
ROLLOUT_REFL    := deploy/rollouts/reflection.md
FLAGS           := deploy/flags/flags.json
FLAGS_REFL      := deploy/flags/reflection.md
DEPLOY_FREQ     := docs/deploy-frequency-wk05.md
AI_JOURNAL      := ai-journal/wk05-ci-cd-build.md
# Flag key the demo wraps; rename in Part C to your capstone-specific feature.
FLAG_KEY        := strict-status-validation

help:
	@echo "W5 targets:"
	@echo "  env-check             Check required tooling + W5 deliverable paths."
	@echo "  starter               Place ALL W5 skeletons at their real (flat) paths."
	@echo "  pre-read-init         -> $(PRE_READ)"
	@echo "  adr-init              -> $(ADR)            (Mon deliverable)"
	@echo "  flags-init            -> $(FLAGS) + $(KUSTOMIZE)"
	@echo "  flag-integration-init Place src/flag_integration.example.{py,ts} (keep the one for your stack)."
	@echo "  workflows-init        Strip .github/workflows/*.yaml + branch-protection skeletons."
	@echo "  deploy-freq-init      -> $(DEPLOY_FREQ)    (Sun deliverable, Outcome 6)"
	@echo "  reflection-init       -> $(ROLLOUT_REFL) + $(FLAGS_REFL)"
	@echo "  ai-journal-init       -> $(AI_JOURNAL)     (Sun deliverable, CI-gated)"
	@echo "  ci-local              Run the same test gate locally (Part A)."
	@echo "  canary-demo-bad       Deploy a deliberately-broken image; analysis trips; auto-rollback (Part B)."
	@echo "  canary-demo-good      Deploy a good image; canary promotes 20->50->100 (Part B)."
	@echo "  flag-flip             Toggle $(FLAG_KEY) in $(FLAGS); flagd reloads, NO redeploy (Part C)."
	@echo "  measure-deploys       Count this week's production deploys from git log (Outcome 6)."
	@echo "  creds-check           Fail if any long-lived cloud credential is committed (mirrors CI gate)."
	@echo "  tf-destroy            COST GUARD: destroy the W4 Terraform stack (carried forward from W4)."

env-check:
	@echo "==> tooling"
	@if command -v gh >/dev/null 2>&1; then echo "OK: gh (GitHub CLI)"; else echo "WARN: gh not found (helpful for PR flow; not required)"; fi
	@if command -v kubectl >/dev/null 2>&1; then echo "OK: kubectl"; else echo "MISSING: kubectl"; fi
	@if command -v kubectl-argo-rollouts >/dev/null 2>&1; then echo "OK: kubectl argo rollouts plugin"; else echo "MISSING: argo rollouts kubectl plugin — https://argo-rollouts.readthedocs.io/en/stable/installation/"; fi
	@if command -v helm >/dev/null 2>&1; then echo "OK: helm (for argo-rollouts install)"; else echo "MISSING: helm"; fi
	@if command -v flagd >/dev/null 2>&1; then echo "OK: flagd"; else echo "MISSING: flagd — https://flagd.dev/ (Part C feature-flag provider)"; fi
	@echo "==> W5 deliverable paths"
	@for f in "$(ADR)" "$(ROLLOUT)" "$(FLAGS)" "$(AI_JOURNAL)"; do \
		if [ -e "$$f" ]; then echo "OK: $$f"; else echo "WARN: $$f missing — see 'make help'"; fi; \
	done

# strip_skeleton: $(call strip_skeleton,<real-path>) — copies <real-path>.skeleton if not present.
define strip_skeleton
	@if [ -e "$(1)" ]; then \
		echo "$(1) already exists. Not overwriting."; \
	elif [ -e "$(1).skeleton" ]; then \
		cp "$(1).skeleton" "$(1)" && echo "Created $(1) from skeleton."; \
	else \
		echo "ERROR: $(1).skeleton not found. Copy the week-05 starter into your capstone repo first."; \
	fi
endef

pre-read-init:
	@mkdir -p docs
	$(call strip_skeleton,$(PRE_READ))
adr-init:
	@mkdir -p pipelines
	$(call strip_skeleton,$(ADR))
	@echo "Mon: fill CI tool + test-gate contract, canary SLI, feature-flag wrap location."
flags-init:
	@mkdir -p deploy/flags
	$(call strip_skeleton,$(FLAGS))
	$(call strip_skeleton,$(KUSTOMIZE))
flag-integration-init:
	@mkdir -p src
	@for ext in py ts; do \
		if [ ! -e "src/flag_integration.example.$$ext" ] && [ -e "src/flag_integration.example.$$ext.skeleton" ]; then \
			cp "src/flag_integration.example.$$ext.skeleton" "src/flag_integration.example.$$ext" && echo "Created src/flag_integration.example.$$ext"; fi; \
	done
	@echo "Keep the file matching your capstone stack; delete the other."
deploy-freq-init:
	@mkdir -p docs
	$(call strip_skeleton,$(DEPLOY_FREQ))
reflection-init:
	@mkdir -p deploy/rollouts deploy/flags
	$(call strip_skeleton,$(ROLLOUT_REFL))
	$(call strip_skeleton,$(FLAGS_REFL))
ai-journal-init:
	@mkdir -p ai-journal
	$(call strip_skeleton,$(AI_JOURNAL))
workflows-init:
	@mkdir -p .github/workflows
	@for f in ci deploy-staging; do \
		if [ ! -e ".github/workflows/$$f.yaml" ] && [ -e ".github/workflows/$$f.yaml.skeleton" ]; then \
			cp ".github/workflows/$$f.yaml.skeleton" ".github/workflows/$$f.yaml" && echo "Created .github/workflows/$$f.yaml"; fi; \
	done
	@if [ ! -e ".github/branch-protection.yaml" ] && [ -e ".github/branch-protection.yaml.skeleton" ]; then \
		cp ".github/branch-protection.yaml.skeleton" ".github/branch-protection.yaml" && echo "Created .github/branch-protection.yaml"; fi

starter: workflows-init pre-read-init adr-init flags-init flag-integration-init deploy-freq-init reflection-init ai-journal-init
	@mkdir -p deploy/rollouts deploy/evidence
	@for f in $(ROLLOUT) $(ANALYSIS); do \
		if [ ! -e "$$f" ] && [ -e "$$f.skeleton" ]; then cp "$$f.skeleton" "$$f" && echo "Created $$f"; fi; \
	done
	@echo "All W5 skeletons placed (workflows, rollouts, flags, docs). Also copy week-05-check.yaml into .github/workflows/ (the course readiness check ships from the hyperion root, not week-05/)."

ci-local:
	@echo "Runs the same gate as .github/workflows/ci.yaml. Uncomment your stack's block in ci.yaml first."
	@echo "Python:  pytest --cov && ruff check . && mypy ."
	@echo "JS/TS:   npm ci && npx jest --coverage && npx eslint . && npx tsc --noEmit"

canary-demo-bad:
	@echo "Part B demo run 1 (deliberately bad): builds an image with a 500-handler, triggers the canary."
	@echo "Expect: 20% traffic -> analysis evaluates -> failureCondition trips -> Argo Rollouts auto-rolls-back."
	@echo "Screenshot each step into deploy/evidence/canary-rollback-\$$(date +%F).png"
	@echo "TODO(lab-part-b): wire your capstone's deliberately-broken image build + 'kubectl argo rollouts get rollout <name> --watch'."

canary-demo-good:
	@echo "Part B demo run 2 (good): builds the current good image, triggers the canary."
	@echo "Expect: 20% -> analysis passes -> 50% -> analysis passes -> 100% (full promotion)."
	@echo "Screenshot the promotion steps into deploy/evidence/canary-success-\$$(date +%F).png"
	@echo "TODO(lab-part-b): wire your capstone's image build + 'kubectl argo rollouts promote <name>' if manual-pause is set."

flag-flip:
	@if [ ! -e "$(FLAGS)" ]; then echo "ERROR: $(FLAGS) not found. Run 'make flags-init' first."; exit 1; fi
	@python3 -c 'import json; p="$(FLAGS)"; d=json.load(open(p)); f=d["flags"]["$(FLAG_KEY)"]; cur=f.get("defaultVariant","off"); new="on" if cur!="on" else "off"; f["defaultVariant"]=new; json.dump(d, open(p,"w"), indent=2); open(p,"a").write("\n"); print("$(FLAG_KEY): %s -> %s  (flagd watches the file and reloads live; NO redeploy)" % (cur,new))'
	@echo "TODO(lab-part-c): after renaming the flag in $(FLAGS), set FLAG_KEY at the top of this Makefile to match."

measure-deploys:
	@echo "==> Production deploys this week (Outcome 6)"
	@echo "Counts commits on main that triggered a staging/prod deploy. Adjust the grep to your deploy-marker convention."
	@count=$$(git log --since='7 days ago' --oneline --grep='deploy\|release\|ship' | wc -l | tr -d ' '); \
		echo "Approx deploy-related commits in the last 7 days: $$count"; \
		echo "Now write docs/deploy-frequency-wk05.md: the count + your DORA 2025 bucket + one batch-size change."

creds-check:
	@echo "==> Scanning for committed long-lived cloud credentials (mirrors the CI hard gate)"
	@if git grep -nE 'AKIA[0-9A-Z]{16}|ya29\.[0-9A-Za-z_-]+|-----BEGIN [A-Z ]*PRIVATE KEY-----|"private_key":' -- . ':!*.skeleton' ':!Makefile' >/dev/null 2>&1; then \
		echo "FAIL: a long-lived cloud credential pattern is committed. Remove it, rotate it, switch to OIDC."; exit 1; \
	else echo "OK: no long-lived cloud credentials committed."; fi

# Carried forward from W4: copying the W5 Makefile to your capstone root overwrites W4's, so the one
# cost-critical W4 target lives here too. A forgotten EKS cluster bills ~$75/month — never close a
# session on a non-empty `terraform -chdir=infra/terraform state list`.
tf-destroy:
	@echo "COST GUARD: destroying the W4 Terraform stack so it stops billing."
	terraform -chdir=infra/terraform destroy
