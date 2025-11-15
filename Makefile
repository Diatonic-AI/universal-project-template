# Make-based automation (cross-platform; POSIX-friendly)
# Use 'make help' to list targets.

SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

# Colors
YELLOW := \033[33m
GREEN := \033[32m
NC := \033[0m

# Detect tools
HAS_NODE := $(shell command -v node >/dev/null 2>&1 && echo 1 || echo 0)
HAS_NPM  := $(shell command -v npm  >/dev/null 2>&1 && echo 1 || echo 0)
HAS_PY   := $(shell command -v python3 >/dev/null 2>&1 && echo 1 || echo 0)
HAS_PIP  := $(shell command -v pip3 >/dev/null 2>&1 && echo 1 || echo 0)
HAS_PREC := $(shell command -v pre-commit >/dev/null 2>&1 && echo 1 || echo 0)
HAS_DOCK := $(shell command -v docker >/dev/null 2>&1 && echo 1 || echo 0)
HAS_GH   := $(shell command -v gh >/dev/null 2>&1 && echo 1 || echo 0)

.PHONY: help
help: ## List available targets
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?##' $(MAKEFILE_LIST) | sed 's/:.*##/: /' | sort

.PHONY: doctor
doctor: ## Check required toolchain availability
	@echo "$(YELLOW)Toolchain check$(NC)"
	@for t in git gh jq make; do command -v $$t >/dev/null || echo "Missing: $$t"; done
	@if [ "$(HAS_NODE)" = "1" ]; then echo "node: $$(node -v)"; else echo "node: missing"; fi
	@if [ "$(HAS_PY)" = "1" ]; then echo "python3: $$(python3 -V)"; else echo "python3: missing"; fi
	@if [ "$(HAS_PREC)" = "1" ]; then echo "pre-commit: present"; else echo "pre-commit: missing"; fi
	@echo "$(GREEN)doctor complete$(NC)"

.PHONY: setup
setup: ## Install pre-commit hooks and prepare environment
	@if [ "$(HAS_PIP)" = "1" ]; then pip3 install --user pre-commit || true; fi
	@if [ "$(HAS_PREC)" = "1" ]; then pre-commit install; else echo "pre-commit not available"; fi
	@echo "$(GREEN)setup done$(NC)"

.PHONY: install-tools
install-tools: ## Install local linters (markdownlint, prettier, actionlint) if Node present
	@if [ "$(HAS_NPM)" = "1" ]; then npm i -g markdownlint-cli2 prettier; else echo "npm not available"; fi
	@./scripts/install-actionlint.sh || true 2>/dev/null || true
	@echo "$(GREEN)install-tools complete$(NC)"

.PHONY: format
format: ## Run formatters (Prettier for Markdown/JSON/YAML)
	@if command -v prettier >/dev/null 2>&1; then prettier --write "**/*.{md,json,yml,yaml}" || true; else echo "prettier not installed"; fi

.PHONY: lint
lint: ## Run linters: markdownlint, shellcheck, actionlint
	@if command -v markdownlint-cli2 >/dev/null 2>&1; then markdownlint-cli2 "**/*.md" "#node_modules" "#.git"; else echo "markdownlint-cli2 not installed"; fi
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck -x $$(git ls-files '*.sh'); else echo "shellcheck not installed"; fi
	@if command -v actionlint >/dev/null 2>&1; then actionlint; else echo "actionlint not installed"; fi

.PHONY: test
test: ## Run tests if Node or Python projects detected
	@if [ -f package.json ] && [ "$(HAS_NPM)" = "1" ]; then npm test --if-present; else echo "No Node tests"; fi
	@if [ -f requirements.txt ] || [ -f pyproject.toml ]; then \
		if command -v pytest >/dev/null; then pytest -q || true; else echo "pytest not installed"; fi; \
	else echo "No Python tests"; fi

.PHONY: build
build: ## Build project (placeholder; customize per language)
	@echo "No generic build. If Node: run npm run build. If Python: build via your tool."

.PHONY: clean
clean: ## Clean build artifacts and caches
	@rm -rf dist build .cache coverage .pytest_cache || true
	@find . -name "__pycache__" -type d -prune -exec rm -rf {} +

.PHONY: docs
docs: ## Generate docs (placeholder)
	@echo "Add your doc generation here."

.PHONY: ci-check
ci-check: doctor lint test ## Run doctor + lint + test (non-interactive)
	@echo "$(GREEN)ci-check complete$(NC)"

.PHONY: release
release: ## Run release-please locally (manifest mode)
	@if command -v npx >/dev/null 2>&1; then npx release-please release-pr --repo-url=$$(git config --get remote.origin.url | sed 's#^git@github.com:#https://github.com/#' | sed 's#\.git$$##') --token=$${GITHUB_TOKEN:-} --config-file=release-please-config.json --manifest-file=release-please-manifest.json; else echo "npx not available"; fi

.PHONY: devcontainer-build
devcontainer-build: ## Build devcontainer (VS Code)
	@echo "Open in VS Code with Dev Containers extension to build."

.PHONY: docker-build
docker-build: ## Build Docker image (placeholder tag)
	@if [ "$(HAS_DOCK)" = "1" ]; then docker build -t universal-template:dev .; else echo "docker not available"; fi

.PHONY: docker-run
docker-run: ## Run Docker image (placeholder)
	@if [ "$(HAS_DOCK)" = "1" ]; then docker run --rm -it universal-template:dev; else echo "docker not available"; fi
