# CI/CD Pipeline Guide

**Who this is for**: Developers customizing the CI/CD automation

**What you'll learn**: How to configure, extend, and optimize the CI/CD pipeline

**Estimated reading time**: 25 minutes

## Table of Contents

- [Overview](#overview)
- [Current CI/CD Setup](#current-cicd-setup)
- [Customizing for Your Stack](#customizing-for-your-stack)
- [Workflow Reference](#workflow-reference)
- [Adding Deployment](#adding-deployment)
- [Environment Variables & Secrets](#environment-variables--secrets)
- [Caching Strategies](#caching-strategies)
- [Matrix Builds](#matrix-builds)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Overview

This template includes a **comprehensive CI/CD pipeline** that automatically runs on every push and pull request. The pipeline is designed to be:

- **Language-agnostic**: Works with Node.js, Python, and other ecosystems
- **Fast**: Uses caching and parallel jobs
- **Reliable**: Enforces quality gates before merge
- **Extensible**: Easy to add deployment, notifications, and more

### What's Automated

Out of the box, the pipeline provides:

✅ **Code Quality**:
- Markdown linting (markdownlint-cli2)
- Shell script checking (shellcheck)
- GitHub Actions validation (actionlint)

✅ **Testing**:
- Auto-detects Node.js and Python projects
- Runs tests if present
- Fails build if tests fail

✅ **Security**:
- CodeQL analysis for vulnerabilities
- Dependabot for dependency updates
- Secret scanning (if enabled)

✅ **Release Management**:
- Automated version bumps via release-please
- Changelog generation
- GitHub releases

✅ **Branch Protection**:
- Enforces passing CI before merge
- Requires code review
- Prevents force pushes

### Pipeline Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    GitHub Event                         │
│              (push, pull_request, schedule)             │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ┌────────┐  ┌─────────┐  ┌──────────┐
   │   CI   │  │ CodeQL  │  │  Other   │
   │        │  │         │  │ Workflows│
   └───┬────┘  └────┬────┘  └────┬─────┘
       │            │            │
       ▼            ▼            ▼
   ┌────────────────────────────────┐
   │    Quality Gates Passed?       │
   └────────┬───────────────────────┘
            │
            ▼
      ┌──────────┐
      │  Merge   │
      │ Allowed  │
      └──────────┘
```

---

## Current CI/CD Setup

### 1. CI Workflow (.github/workflows/ci.yml)

**Purpose**: Run quality checks on every push and PR

**Triggers**:
```yaml
on:
  push:      # Every commit to any branch
  pull_request:  # Every PR opened/updated
```

**Jobs**:

#### lint-test Job

**Runs on**: `ubuntu-latest`

**Steps**:
1. **Checkout code** - Gets your repository
2. **Setup Node.js** (conditional) - If `package.json` exists
3. **Setup Python** (conditional) - If `pyproject.toml` or `requirements.txt` exists
4. **Install linters** - markdownlint, prettier, actionlint
5. **Lint Markdown** - Check all `.md` files
6. **Lint Shell** - Check all `.sh` scripts
7. **Lint GitHub Actions** - Validate workflow files
8. **Node tests** (conditional) - Run `npm test` if Node project
9. **Python tests** (conditional) - Run `pytest` if Python project

**Duration**: ~2-5 minutes (depending on test suite size)

**Cost**: Free on GitHub's free tier (2,000 minutes/month)

### 2. CodeQL Workflow (.github/workflows/codeql.yml)

**Purpose**: Security vulnerability scanning

**Triggers**:
```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '37 12 * * 5'  # Weekly on Fridays
```

**Languages Analyzed**:
- JavaScript/TypeScript
- Python

**How it works**:
1. Builds your code
2. Analyzes for security vulnerabilities
3. Reports findings in Security tab

**Duration**: ~3-10 minutes

### 3. Release Please Workflow (.github/workflows/release-please.yml)

**Purpose**: Automated versioning and releases

**Triggers**:
```yaml
on:
  push:
    branches: [main]
```

**How it works**:
1. Analyzes commit messages (Conventional Commits)
2. Determines version bump (major/minor/patch)
3. Creates release PR with changelog
4. On merge, creates GitHub release and tag

**Output**:
- Automated changelog
- Version bumps in package.json/pyproject.toml
- GitHub releases

### 4. Dependabot (.github/dependabot.yml)

**Purpose**: Automated dependency updates

**Ecosystems**:
- npm (package.json)
- pip (requirements.txt)
- GitHub Actions (workflows)

**Schedule**: Weekly checks

**Behavior**:
- Opens PRs for outdated dependencies
- Groups minor updates together
- Provides changelog and compatibility info

---

## Customizing for Your Stack

### Node.js / TypeScript Project

**Existing support**: ✅ Already configured

**What works out of the box**:
- Auto-detects `package.json`
- Runs `npm ci` to install dependencies
- Runs `npm test --if-present`

**Customization needed**:

#### Add Build Step

Edit `.github/workflows/ci.yml`:

```yaml
- name: Node tests (if present)
  if: ${{ hashFiles('**/package.json') != '' }}
  run: |
    npm ci
    npm run build  # Add this line
    npm test --if-present
```

#### Add Linting (ESLint, Prettier)

```yaml
- name: "Lint: JavaScript/TypeScript"
  if: ${{ hashFiles('**/package.json') != '' }}
  run: |
    npm ci
    npm run lint  # Assumes "lint" script in package.json
```

**package.json scripts**:
```json
{
  "scripts": {
    "lint": "eslint . --ext .js,.ts,.tsx",
    "format": "prettier --check .",
    "test": "jest",
    "build": "tsc"
  }
}
```

#### Add Type Checking

```yaml
- name: "Type Check: TypeScript"
  if: ${{ hashFiles('**/tsconfig.json') != '' }}
  run: |
    npm ci
    npm run type-check
```

**package.json**:
```json
{
  "scripts": {
    "type-check": "tsc --noEmit"
  }
}
```

#### Add Coverage Reporting

```yaml
- name: Run tests with coverage
  run: |
    npm ci
    npm run test:coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage/coverage-final.json
    fail_ci_if_error: true
```

### Python Project

**Existing support**: ✅ Already configured

**What works out of the box**:
- Auto-detects `pyproject.toml` or `requirements.txt`
- Installs dependencies
- Runs `pytest` if available

**Customization needed**:

#### Add Linting (Ruff, Black, mypy)

Edit `.github/workflows/ci.yml`:

```yaml
- name: Python tests (if present)
  if: ${{ hashFiles('**/pyproject.toml','**/requirements.txt') != '' }}
  run: |
    python -m pip install -U pip
    pip install -r requirements.txt
    pip install ruff black mypy pytest  # Add linters

    # Linting
    ruff check .
    black --check .
    mypy .

    # Testing
    pytest -v --cov --cov-report=xml
```

#### Add Multiple Python Versions

Use matrix strategy:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install and test
        run: |
          pip install -r requirements.txt
          pytest
```

#### Add Poetry Support

```yaml
- name: Install Poetry
  run: |
    curl -sSL https://install.python-poetry.org | python3 -
    echo "$HOME/.local/bin" >> $GITHUB_PATH

- name: Install dependencies
  run: poetry install --no-interaction

- name: Run tests
  run: poetry run pytest
```

### Docker Project

**Add Dockerfile build verification**:

```yaml
- name: Build Docker image
  run: docker build -t my-app:test .

- name: Run container tests
  run: |
    docker run --rm my-app:test npm test

- name: Security scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: my-app:test
    format: 'sarif'
    output: 'trivy-results.sarif'

- name: Upload scan results
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: 'trivy-results.sarif'
```

### Go Project

**Add Go support**:

```yaml
- name: Setup Go
  if: ${{ hashFiles('**/go.mod') != '' }}
  uses: actions/setup-go@v5
  with:
    go-version: '1.21'

- name: Build and test Go
  if: ${{ hashFiles('**/go.mod') != '' }}
  run: |
    go build -v ./...
    go test -v ./...
    go vet ./...
```

### Rust Project

**Add Rust support**:

```yaml
- name: Setup Rust
  if: ${{ hashFiles('**/Cargo.toml') != '' }}
  uses: actions-rs/toolchain@v1
  with:
    toolchain: stable
    override: true

- name: Build and test Rust
  if: ${{ hashFiles('**/Cargo.toml') != '' }}
  run: |
    cargo build --verbose
    cargo test --verbose
    cargo clippy -- -D warnings
```

### Monorepo / Multi-Language

**Strategy**: Combine multiple language setups

```yaml
jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Setup all languages
      - name: Setup Node.js
        if: ${{ hashFiles('**/package.json') != '' }}
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Setup Python
        if: ${{ hashFiles('**/pyproject.toml') != '' }}
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Setup Go
        if: ${{ hashFiles('**/go.mod') != '' }}
        uses: actions/setup-go@v5
        with:
          go-version: '1.21'

      # Test each component
      - name: Test frontend
        working-directory: ./frontend
        run: |
          npm ci
          npm test

      - name: Test backend
        working-directory: ./backend
        run: |
          pip install -r requirements.txt
          pytest

      - name: Test API
        working-directory: ./api
        run: |
          go test ./...
```

---

## Workflow Reference

### Common GitHub Actions Syntax

#### Conditional Steps

**Based on file existence**:
```yaml
- name: Only if package.json exists
  if: ${{ hashFiles('**/package.json') != '' }}
  run: npm ci
```

**Based on branch**:
```yaml
- name: Only on main branch
  if: github.ref == 'refs/heads/main'
  run: echo "Deploying to production"
```

**Based on event type**:
```yaml
- name: Only on pull requests
  if: github.event_name == 'pull_request'
  run: echo "PR validation"
```

#### Environment Variables

**Set for all steps**:
```yaml
env:
  NODE_ENV: test
  DATABASE_URL: postgresql://localhost/test_db

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Run tests
        run: npm test
```

**Set for specific step**:
```yaml
- name: Build production
  env:
    NODE_ENV: production
  run: npm run build
```

#### Working Directory

```yaml
- name: Build frontend
  working-directory: ./packages/frontend
  run: npm run build
```

#### Timeouts

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # Fail if exceeds 10 minutes
    steps:
      - name: Long running test
        timeout-minutes: 5  # Fail this step after 5 minutes
        run: npm test
```

#### Artifacts

**Upload**:
```yaml
- name: Upload build artifacts
  uses: actions/upload-artifact@v3
  with:
    name: build-output
    path: dist/
    retention-days: 7
```

**Download** (in another job):
```yaml
- name: Download build artifacts
  uses: actions/download-artifact@v3
  with:
    name: build-output
    path: dist/
```

---

## Adding Deployment

### Deploy to Production (after merge to main)

**Create `.github/workflows/deploy-production.yml`**:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://myapp.com

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install and build
        run: |
          npm ci
          npm run build

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

### Deploy to Staging (on PRs)

```yaml
name: Deploy to Staging

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging-pr-${{ github.event.pull_request.number }}.myapp.com

    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: |
          npm ci
          npm run build

      - name: Deploy to staging
        run: |
          # Your deployment script
          ./scripts/deploy-staging.sh
        env:
          DEPLOY_KEY: ${{ secrets.STAGING_DEPLOY_KEY }}
          PR_NUMBER: ${{ github.event.pull_request.number }}
```

### Deploy to Cloud Providers

#### AWS (S3 + CloudFront)

```yaml
- name: Deploy to S3
  uses: jakejarvis/s3-sync-action@master
  with:
    args: --delete
  env:
    AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_REGION: 'us-east-1'
    SOURCE_DIR: 'dist'

- name: Invalidate CloudFront
  uses: chetan/invalidate-cloudfront-action@v2
  env:
    DISTRIBUTION: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
    PATHS: '/*'
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

#### Google Cloud Platform (Cloud Run)

```yaml
- name: Authenticate to Google Cloud
  uses: google-github-actions/auth@v1
  with:
    credentials_json: ${{ secrets.GCP_SA_KEY }}

- name: Deploy to Cloud Run
  uses: google-github-actions/deploy-cloudrun@v1
  with:
    service: my-service
    image: gcr.io/${{ secrets.GCP_PROJECT_ID }}/my-app:${{ github.sha }}
    region: us-central1
```

#### Azure (App Service)

```yaml
- name: Deploy to Azure App Service
  uses: azure/webapps-deploy@v2
  with:
    app-name: my-app
    publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
    package: ./dist
```

#### Netlify

```yaml
- name: Deploy to Netlify
  uses: nwtgck/actions-netlify@v2
  with:
    publish-dir: './dist'
    production-branch: main
    production-deploy: ${{ github.ref == 'refs/heads/main' }}
  env:
    NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
    NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

---

## Environment Variables & Secrets

### Repository Secrets

**Adding secrets** (Settings → Secrets and variables → Actions):

1. Click "New repository secret"
2. Name: `API_KEY` (use UPPER_SNAKE_CASE)
3. Value: Your secret value
4. Click "Add secret"

**Using in workflows**:
```yaml
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
  run: ./deploy.sh
```

**⚠️ Security**: Never echo secrets to logs!

```yaml
# ❌ DON'T DO THIS
- run: echo "Secret is ${{ secrets.API_KEY }}"

# ✅ DO THIS
- run: |
    # Use secrets without printing them
    deploy --api-key="$API_KEY"
  env:
    API_KEY: ${{ secrets.API_KEY }}
```

### Environment Secrets

**For different environments** (staging, production):

1. Settings → Environments
2. Create environment (e.g., "production")
3. Add protection rules (required reviewers, wait timer)
4. Add environment-specific secrets

**Using in workflow**:
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Uses production environment secrets
    steps:
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}  # Comes from production environment
        run: ./deploy.sh
```

### Environment Variables

**Default variables** (always available):

| Variable | Description | Example |
|----------|-------------|---------|
| `github.sha` | Commit SHA | `ffac537e6cbbf934b08745a378932722df287a53` |
| `github.ref` | Full ref | `refs/heads/main` |
| `github.repository` | Repo name | `owner/repo` |
| `github.actor` | User who triggered | `username` |
| `github.event_name` | Event type | `push`, `pull_request` |

**Using in workflows**:
```yaml
- name: Print info
  run: |
    echo "Commit: ${{ github.sha }}"
    echo "Branch: ${{ github.ref }}"
    echo "Actor: ${{ github.actor }}"
```

---

## Caching Strategies

### npm Cache

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'  # Automatically caches npm dependencies

- name: Install dependencies
  run: npm ci  # Uses cache if available
```

**Speedup**: 30-60 seconds saved per build

### pip Cache

```yaml
- name: Setup Python
  uses: actions/setup-python@v5
  with:
    python-version: '3.12'
    cache: 'pip'  # Automatically caches pip dependencies

- name: Install dependencies
  run: pip install -r requirements.txt
```

### Custom Cache

```yaml
- name: Cache build outputs
  uses: actions/cache@v3
  with:
    path: |
      dist/
      .next/cache
    key: ${{ runner.os }}-build-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-build-
```

**When cache invalidates**:
- When `key` changes (e.g., package-lock.json modified)
- When cache is older than 7 days
- When cache size exceeds 10GB total

---

## Matrix Builds

### Test Multiple Versions

**Node.js example**:
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [18, 20, 22]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Test
        run: |
          npm ci
          npm test
```

**Result**: 9 jobs (3 OS × 3 Node versions)

### Fail-Fast Strategy

```yaml
strategy:
  fail-fast: true  # Stop all jobs if one fails
  matrix:
    node-version: [18, 20, 22]
```

### Include/Exclude Specific Combinations

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]
    node-version: [18, 20, 22]
    exclude:
      - os: windows-latest
        node-version: 18  # Don't test Node 18 on Windows
    include:
      - os: ubuntu-latest
        node-version: 16
        experimental: true  # Add extra config for specific combo
```

---

## Troubleshooting

### Problem: Workflow not triggering

**Check**:
1. Workflow file is in `.github/workflows/`
2. YAML syntax is valid (use YAML linter)
3. Trigger events are configured correctly
4. Branch protection isn't blocking

**Debug**:
```yaml
on:
  push:
    branches:
      - '**'  # Trigger on all branches for debugging
  workflow_dispatch:  # Allow manual trigger
```

### Problem: Tests failing in CI but passing locally

**Common causes**:
1. **Environment differences**
   - Local: macOS, CI: Linux
   - Solution: Test locally with Docker

2. **Missing dependencies**
   - Solution: Ensure all deps in package.json/requirements.txt

3. **Timezone issues**
   - Solution: Set TZ environment variable

4. **Race conditions**
   - Solution: Add delays or better synchronization

**Debug steps**:
```yaml
- name: Debug environment
  run: |
    node --version
    npm --version
    pwd
    ls -la
    env | sort
```

### Problem: Slow CI runs

**Optimization strategies**:

1. **Use caching**:
   ```yaml
   - uses: actions/setup-node@v4
     with:
       cache: 'npm'
   ```

2. **Parallelize jobs**:
   ```yaml
   jobs:
     lint:
       runs-on: ubuntu-latest
       steps: [...]

     test:
       runs-on: ubuntu-latest
       steps: [...]
   ```

3. **Reduce test scope**:
   ```yaml
   - name: Run only changed tests
     run: npm test -- --onlyChanged
   ```

4. **Use faster runners** (paid):
   ```yaml
   runs-on: ubuntu-latest-4-cores  # GitHub-hosted larger runners
   ```

### Problem: Secrets not accessible

**Check**:
1. Secret name matches exactly (case-sensitive)
2. Secret is in correct scope (repository/environment)
3. Using correct syntax: `${{ secrets.SECRET_NAME }}`
4. Environment protection rules are met

**Debug** (without exposing secret):
```yaml
- name: Check if secret exists
  run: |
    if [ -z "$API_KEY" ]; then
      echo "SECRET_NAME is not set"
      exit 1
    else
      echo "SECRET_NAME is set (length: ${#API_KEY})"
    fi
  env:
    API_KEY: ${{ secrets.SECRET_NAME }}
```

### Problem: Dependency conflicts

**Solution**: Use lockfiles
```yaml
# ✅ Good: uses lockfile
- run: npm ci  # or pip install -r requirements.txt

# ❌ Bad: ignores lockfile
- run: npm install  # or pip install package
```

---

## Best Practices

### 1. Use Lockfiles

**Always commit**:
- `package-lock.json` (npm)
- `yarn.lock` (Yarn)
- `pnpm-lock.yaml` (pnpm)
- `poetry.lock` (Poetry)
- `requirements.txt` with pinned versions (pip)

**Why**: Reproducible builds

### 2. Pin Action Versions

```yaml
# ✅ Good: pinned to specific version
- uses: actions/checkout@v4

# ❌ Bad: uses latest (could break)
- uses: actions/checkout@main
```

### 3. Set Timeouts

```yaml
jobs:
  test:
    timeout-minutes: 10  # Prevent hanging jobs
    steps:
      - name: Run tests
        timeout-minutes: 5
        run: npm test
```

### 4. Use Conditional Steps

```yaml
# Only run expensive steps on main branch
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh
```

### 5. Separate Lint and Test

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [lint steps...]

  test:
    runs-on: ubuntu-latest
    needs: lint  # Only run if lint passes
    steps: [test steps...]
```

**Benefits**: Fail fast if linting fails, save CI minutes

### 6. Use Concurrency Control

```yaml
# Cancel previous runs when new commit pushed
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

### 7. Add Status Badges

**In README.md**:
```markdown
![CI](https://github.com/owner/repo/actions/workflows/ci.yml/badge.svg)
![CodeQL](https://github.com/owner/repo/actions/workflows/codeql.yml/badge.svg)
```

### 8. Monitor CI Performance

**Track**:
- Average build time
- Success rate
- Most common failures

**Optimize** when builds exceed 5-10 minutes

---

## Next Steps

1. **Customize for your stack**: Use examples in "Customizing for Your Stack"
2. **Add deployment**: Follow "Adding Deployment" section
3. **Configure secrets**: Add necessary secrets for deployment
4. **Monitor performance**: Track build times and optimize
5. **Review security**: Read [SECURITY-AND-COMPLIANCE.md](SECURITY-AND-COMPLIANCE.md)

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Awesome Actions](https://github.com/sdras/awesome-actions)
- [Action Examples](https://github.com/actions/starter-workflows)

---

**Questions?** Open a [Discussion](https://github.com/your-org/your-repo/discussions) or check GitHub Actions documentation.
