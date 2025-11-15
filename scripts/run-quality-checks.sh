#!/usr/bin/env bash
#
# Quality Checks Runner
#
# This script runs language-agnostic quality checks
# Auto-detects project type and runs appropriate tools
#
# Usage: ./scripts/run-quality-checks.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Counters
CHECKS_RUN=0
CHECKS_PASSED=0
CHECKS_FAILED=0

# Helper functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

run_check() {
    local check_name=$1
    shift
    local check_command=("$@")

    CHECKS_RUN=$((CHECKS_RUN + 1))
    echo ""
    info "Running: $check_name"

    if "${check_command[@]}"; then
        info "✓ $check_name passed"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        error "✗ $check_name failed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
        return 1
    fi
}

# Detect project type
detect_project_type() {
    HAS_NODE=false
    HAS_PYTHON=false
    HAS_DOCKER=false

    [ -f "package.json" ] && HAS_NODE=true
    [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] && HAS_PYTHON=true
    [ -f "Dockerfile" ] && HAS_DOCKER=true

    info "Project detection:"
    [ "$HAS_NODE" = true ] && info "  ✓ Node.js project detected"
    [ "$HAS_PYTHON" = true ] && info "  ✓ Python project detected"
    [ "$HAS_DOCKER" = true ] && info "  ✓ Docker configuration detected"
}

# Markdown linting
check_markdown() {
    if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
        warn "markdownlint-cli2 not installed, skipping"
        return 0
    fi

    run_check "Markdown linting" markdownlint-cli2 "**/*.md" "#node_modules" "#.git"
}

# Shell script linting
check_shell() {
    if ! command -v shellcheck >/dev/null 2>&1; then
        warn "shellcheck not installed, skipping"
        return 0
    fi

    local shell_files
    shell_files=$(git ls-files '*.sh' 2>/dev/null || find . -name "*.sh" -not -path "*/node_modules/*" -not -path "*/.git/*")

    if [ -z "$shell_files" ]; then
        info "No shell scripts found, skipping"
        return 0
    fi

    run_check "Shell script linting" shellcheck -x $shell_files
}

# GitHub Actions validation
check_actions() {
    if ! command -v actionlint >/dev/null 2>&1; then
        warn "actionlint not installed, skipping"
        return 0
    fi

    if [ ! -d ".github/workflows" ]; then
        info "No GitHub Actions workflows found, skipping"
        return 0
    fi

    run_check "GitHub Actions validation" actionlint
}

# Node.js checks
check_nodejs() {
    if [ "$HAS_NODE" = false ]; then
        return 0
    fi

    info "Running Node.js checks..."

    # Install dependencies
    if [ -f "package-lock.json" ]; then
        run_check "npm install" npm ci
    elif [ -f "yarn.lock" ]; then
        run_check "yarn install" yarn install --frozen-lockfile
    elif [ -f "pnpm-lock.yaml" ]; then
        run_check "pnpm install" pnpm install --frozen-lockfile
    fi

    # Linting
    if grep -q '"lint"' package.json; then
        run_check "npm lint" npm run lint
    fi

    # Type checking
    if grep -q '"type-check"' package.json; then
        run_check "Type checking" npm run type-check
    fi

    # Tests
    if grep -q '"test"' package.json; then
        run_check "npm test" npm test
    fi

    # Build
    if grep -q '"build"' package.json; then
        run_check "npm build" npm run build
    fi

    # Security audit
    if command -v npm >/dev/null 2>&1; then
        run_check "Security audit" npm audit --audit-level=high || warn "Security vulnerabilities found"
    fi
}

# Python checks
check_python() {
    if [ "$HAS_PYTHON" = false ]; then
        return 0
    fi

    info "Running Python checks..."

    # Install dependencies
    if [ -f "requirements.txt" ]; then
        run_check "pip install" pip install -q -r requirements.txt
    fi

    # Linting (ruff)
    if command -v ruff >/dev/null 2>&1; then
        run_check "Ruff linting" ruff check .
    fi

    # Formatting (black)
    if command -v black >/dev/null 2>&1; then
        run_check "Black formatting" black --check .
    fi

    # Type checking (mypy)
    if command -v mypy >/dev/null 2>&1; then
        run_check "Type checking (mypy)" mypy . || warn "Type checking found issues"
    fi

    # Tests (pytest)
    if command -v pytest >/dev/null 2>&1; then
        run_check "pytest" pytest -q
    fi

    # Security audit
    if command -v pip-audit >/dev/null 2>&1; then
        run_check "Security audit" pip-audit || warn "Security vulnerabilities found"
    fi
}

# Docker checks
check_docker() {
    if [ "$HAS_DOCKER" = false ]; then
        return 0
    fi

    if ! command -v docker >/dev/null 2>&1; then
        warn "Docker not installed, skipping Docker checks"
        return 0
    fi

    info "Running Docker checks..."

    run_check "Docker build" docker build -t test-build . || warn "Docker build failed"

    # Clean up
    docker rmi test-build 2>/dev/null || true
}

# Print summary
print_summary() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "            Quality Checks Summary          "
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Total checks run:    $CHECKS_RUN"
    echo -e "${GREEN}Checks passed:       $CHECKS_PASSED${NC}"
    [ "$CHECKS_FAILED" -gt 0 ] && echo -e "${RED}Checks failed:       $CHECKS_FAILED${NC}" || echo "Checks failed:       0"
    echo ""

    if [ "$CHECKS_FAILED" -gt 0 ]; then
        error "Some quality checks failed"
        return 1
    else
        info "All quality checks passed! ✓"
        return 0
    fi
}

# Main
main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║       Running Quality Checks              ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""

    detect_project_type

    # Language-agnostic checks
    check_markdown
    check_shell
    check_actions

    # Language-specific checks
    check_nodejs
    check_python
    check_docker

    print_summary
}

main "$@"
