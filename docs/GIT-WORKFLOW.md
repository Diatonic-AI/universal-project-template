# Git & GitHub Workflow Guide

**Who this is for**: All contributors to this project

**What you'll learn**: Branching strategy, commit conventions, PR process, and code review standards

**Estimated reading time**: 15 minutes

## Table of Contents

- [Overview](#overview)
- [Branching Strategy](#branching-strategy)
- [Commit Message Conventions](#commit-message-conventions)
- [Pull Request Process](#pull-request-process)
- [Code Review Guidelines](#code-review-guidelines)
- [Issue Tracking](#issue-tracking)
- [Branch Protection Rules](#branch-protection-rules)
- [Common Workflows](#common-workflows)
- [Troubleshooting](#troubleshooting)

## Overview

This project follows a **Git Flow-inspired branching model** with **Conventional Commits** for automated versioning and changelog generation. This workflow ensures:

- Clear separation between stable code and development work
- Traceable history through semantic commit messages
- Automated releases via [release-please](https://github.com/googleapis/release-please)
- Quality gates enforced through CI/CD and branch protection

### Key Principles

1. **Never commit directly to `main` or `develop`** - Always use pull requests
2. **Write descriptive commit messages** - Follow Conventional Commits format
3. **Keep branches focused** - One feature/fix per branch
4. **Review before merging** - All PRs require at least one approval
5. **Link PRs to issues** - Use `fixes #123` or `closes #456` in PR descriptions

---

## Branching Strategy

We use a **Git Flow-inspired model** with the following branch types:

### Protected Branches

#### `main` - Production Branch
- **Purpose**: Production-ready code only
- **Protection**: Requires PR approval, passing CI, and code owner review
- **Deploy**: Automatically deploys to production (if configured)
- **Branching**: Only `hotfix/*` and `release/*` branches can merge here

#### `develop` - Integration Branch
- **Purpose**: Integration branch for ongoing development
- **Protection**: Requires PR approval and passing CI
- **Deploy**: May deploy to staging environment
- **Branching**: All feature and bugfix branches merge here first

### Working Branches

#### `feature/*` - New Features
- **Branch from**: `develop`
- **Merge to**: `develop`
- **Naming**: `feature/short-description` or `feature/ISSUE-123-description`
- **Examples**:
  - `feature/user-authentication`
  - `feature/ISSUE-42-add-dark-mode`
- **Lifecycle**: Delete after merging

#### `bugfix/*` - Bug Fixes
- **Branch from**: `develop`
- **Merge to**: `develop`
- **Naming**: `bugfix/short-description` or `bugfix/ISSUE-123-description`
- **Examples**:
  - `bugfix/login-error`
  - `bugfix/ISSUE-89-fix-memory-leak`
- **Lifecycle**: Delete after merging

#### `hotfix/*` - Emergency Production Fixes
- **Branch from**: `main`
- **Merge to**: `main` AND `develop`
- **Naming**: `hotfix/short-description` or `hotfix/ISSUE-123-description`
- **Examples**:
  - `hotfix/security-patch`
  - `hotfix/ISSUE-200-critical-crash`
- **Lifecycle**: Delete after merging to both branches

#### `release/*` - Release Preparation
- **Branch from**: `develop`
- **Merge to**: `main` (then tag) AND back to `develop`
- **Naming**: `release/v1.2.3` or `release/1.2.3`
- **Purpose**: Final testing, version bumps, changelog updates
- **Lifecycle**: Delete after merging and tagging

### Branch Naming Conventions

**Format**: `type/description` or `type/ISSUE-123-description`

**Rules**:
- Use lowercase and hyphens (kebab-case)
- Keep descriptions short but meaningful (2-5 words)
- Optionally include issue number for traceability
- Avoid special characters except hyphens

**Good Examples**:
```
feature/user-dashboard
bugfix/ISSUE-42-fix-validation
hotfix/security-update
release/v2.0.0
```

**Bad Examples**:
```
my-work                    # Too vague
feature_new_stuff          # Use hyphens, not underscores
FEATURE/UserDashboard      # Use lowercase
fix/this-bug-that-appears  # Too long
```

---

## Commit Message Conventions

We follow [**Conventional Commits**](https://www.conventionalcommits.org/) for automated versioning and changelog generation.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Required: Type and Subject

**Minimum format**:
```
<type>: <subject>
```

**Examples**:
```
feat: add user authentication
fix: resolve login timeout issue
docs: update API documentation
```

### Commit Types

| Type | Description | Version Impact | Changelog Section |
|------|-------------|----------------|-------------------|
| `feat` | New feature | Minor (0.X.0) | Features |
| `fix` | Bug fix | Patch (0.0.X) | Bug Fixes |
| `docs` | Documentation only | None | Documentation |
| `style` | Code style changes (formatting) | None | - |
| `refactor` | Code refactoring (no feature/fix) | None | - |
| `perf` | Performance improvements | Patch | Performance |
| `test` | Adding/updating tests | None | - |
| `build` | Build system changes | None | - |
| `ci` | CI/CD changes | None | - |
| `chore` | Maintenance tasks | None | - |
| `revert` | Revert previous commit | Depends | - |

### Breaking Changes

**Format**: Add `!` after type or `BREAKING CHANGE:` in footer

**Examples**:
```
feat!: remove deprecated API endpoints

BREAKING CHANGE: The /v1/users endpoint has been removed. Use /v2/users instead.
```

```
refactor(auth)!: change authentication flow

BREAKING CHANGE: Authentication now requires OAuth 2.0 tokens instead of API keys.
```

**Impact**: Triggers major version bump (X.0.0)

### Optional: Scope

**Purpose**: Specify what part of the codebase is affected

**Examples**:
```
feat(auth): add OAuth2 support
fix(api): handle null responses
docs(readme): add installation steps
```

**Common scopes**:
- Component names: `auth`, `api`, `ui`, `database`
- Package names in monorepos: `@myapp/core`, `@myapp/utils`
- Feature areas: `payments`, `notifications`, `search`

### Optional: Body

**When to use**:
- Explain *why* the change was made (not *what* - code shows that)
- Describe any non-obvious implementation details
- Reference related issues or discussions

**Format**: Separate from subject with blank line

**Example**:
```
feat(auth): implement JWT refresh tokens

Previous implementation required users to re-authenticate every hour.
This adds refresh token support to maintain sessions for up to 30 days
while keeping access tokens short-lived for security.

Related to #234 and discussion in #245
```

### Footer: Issue References

**Purpose**: Link commits to issues for traceability

**Keywords**:
- `Fixes #123` - Closes issue when merged to default branch
- `Closes #123` - Same as Fixes
- `Resolves #123` - Same as Fixes
- `Refs #123` - References issue without closing

**Multiple issues**:
```
Fixes #123, #456
Closes #789
```

**Example**:
```
fix(login): prevent session timeout during file upload

Long file uploads were causing session tokens to expire before
completion, resulting in failed uploads and data loss.

Fixes #342
```

### Full Example

```
feat(payments): add Stripe payment integration

Implement Stripe payment processing for subscription upgrades.
This includes webhook handlers for payment success/failure and
automatic invoice generation.

The integration uses Stripe's latest API version (2023-10-16) and
includes comprehensive error handling for network issues and
invalid payment methods.

Closes #156
Refs #178 (documentation)
```

### Commit Message Tips

**DO**:
- ✅ Use imperative mood: "add feature" not "added feature"
- ✅ Keep subject line under 72 characters
- ✅ Capitalize first letter of subject
- ✅ No period at end of subject
- ✅ Separate subject from body with blank line
- ✅ Wrap body at 72 characters
- ✅ Explain *why* in the body, not *what*

**DON'T**:
- ❌ `git commit -m "stuff"` - Too vague
- ❌ `git commit -m "Fixed bug"` - What bug? Where?
- ❌ `git commit -m "WIP"` - Work-in-progress commits should be squashed
- ❌ `git commit -m "Updates"` - What updates?

### Tools for Conventional Commits

**Commitizen** (Interactive commit helper):
```bash
npm install -g commitizen cz-conventional-changelog
git cz  # Use instead of git commit
```

**Commitlint** (Commit message linter):
```bash
npm install -g @commitlint/cli @commitlint/config-conventional
echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
```

**pre-commit hook** (Already configured in this template):
```bash
make setup  # Installs pre-commit hooks
```

---

## Pull Request Process

### 1. Before Creating a PR

**Checklist**:
- [ ] Branch is up-to-date with target branch (`develop` or `main`)
- [ ] All commits follow Conventional Commits format
- [ ] Code passes local CI checks (`make ci-check`)
- [ ] Tests added for new features or bug fixes
- [ ] Documentation updated (if needed)
- [ ] Self-review completed

**Update your branch**:
```bash
# If merging to develop
git checkout develop
git pull origin develop
git checkout feature/your-feature
git merge develop

# Or use rebase for cleaner history
git rebase develop
```

### 2. Creating the Pull Request

**Title Format**: Use Conventional Commits format
```
feat(auth): add OAuth2 support
fix(api): resolve timeout errors
docs: update installation guide
```

**Description Template**: Use the provided template (`.github/PULL_REQUEST_TEMPLATE.md`)

**Required sections**:
1. **Summary**: What does this PR do?
2. **Related Issues**: Link to issues with `Fixes #123` or `Closes #456`
3. **Type of Change**: Feature, bug fix, breaking change, etc.
4. **Testing**: How was this tested?
5. **Checklist**: Confirm all requirements met

**Example PR Description**:
```markdown
## Summary
Implements OAuth2 authentication flow using the authorization code grant type. This replaces the previous API key authentication system.

## Related Issues
Fixes #156
Related to #178

## Type of Change
- [x] New feature
- [ ] Bug fix
- [x] Breaking change
- [ ] Documentation update

## Testing
- [x] Unit tests added (95% coverage)
- [x] Integration tests pass
- [x] Manual testing completed
- [ ] Performance testing (not applicable)

## Screenshots (if applicable)
![OAuth login flow](https://example.com/screenshot.png)

## Checklist
- [x] Code follows project style guidelines
- [x] Self-review completed
- [x] Comments added for complex code
- [x] Documentation updated
- [x] No new warnings generated
- [x] Tests added and passing
- [x] Branch is up-to-date with target branch
```

### 3. PR Labels

**Auto-applied labels** (via PR quality gate workflow):
- `feature` - New feature PRs
- `bugfix` - Bug fix PRs
- `documentation` - Documentation changes
- `dependencies` - Dependency updates
- `breaking-change` - Breaking changes
- `needs-review` - Awaiting review
- `work-in-progress` - Not ready for review

**Manual labels**:
- `priority:high` / `priority:low` - Priority level
- `good-first-issue` - Good for new contributors
- `help-wanted` - Needs assistance

### 4. PR Review Process

**Automatic checks** (must pass):
- ✅ CI pipeline (lint, test, build)
- ✅ CodeQL security analysis
- ✅ Required status checks

**Human review** (at least 1 approval required):
- Code quality and maintainability
- Test coverage adequacy
- Documentation completeness
- Security considerations
- Performance implications

**Review timeline**:
- Initial review within 24-48 hours
- Address feedback within 1 week
- Stale PRs (>30 days inactive) may be closed

### 5. Addressing Review Feedback

**Process**:
1. Make requested changes in new commits
2. Push to the same branch
3. Respond to each review comment
4. Request re-review when ready

**Squashing commits** (optional):
```bash
# Interactive rebase to squash commits
git rebase -i develop

# Mark commits as 'squash' or 'fixup' in the editor
# Force push (PR only, never on shared branches)
git push --force-with-lease
```

**When to squash**:
- Many small "fix typo" or "address review" commits
- Want cleaner history
- Before final merge

**When NOT to squash**:
- Commits represent logical units of work
- History is valuable for debugging
- Working with others on the same branch

### 6. Merging the PR

**Merge methods** (configured per repository):

1. **Squash and merge** (recommended for features)
   - Combines all commits into one
   - Clean, linear history
   - PR title becomes commit message

2. **Rebase and merge** (for already clean history)
   - Adds commits individually
   - Preserves detailed history
   - No merge commit

3. **Merge commit** (for release branches)
   - Creates explicit merge commit
   - Preserves branch structure
   - Shows PR relationship

**Post-merge**:
- PR is automatically closed
- Related issues closed (if used `Fixes #123`)
- Branch can be deleted (recommended)
- Changelog updated (via release-please)

### 7. Cleaning Up

**Delete merged branches**:
```bash
# Via GitHub UI (recommended)
# Click "Delete branch" button after merge

# Or locally
git checkout develop
git pull origin develop
git branch -d feature/your-feature  # Delete local branch
```

**Auto-cleanup**: Branch maintenance workflow deletes stale branches after 90 days

---

## Code Review Guidelines

### For Authors (PR Creator)

**Before requesting review**:
1. **Self-review first** - Review your own changes line by line
2. **Check diff** - Ensure no unintended changes included
3. **Run CI locally** - `make ci-check` should pass
4. **Add context** - Explain non-obvious decisions in PR description
5. **Keep it focused** - Large PRs (>500 lines) should be split

**Responding to feedback**:
- Be open to suggestions
- Ask questions if feedback is unclear
- Explain your reasoning if you disagree
- Mark conversations as resolved when addressed
- Thank reviewers for their time

### For Reviewers

**Review checklist**:

**Functionality**:
- [ ] Code does what the PR claims
- [ ] Edge cases handled
- [ ] Error handling appropriate
- [ ] No obvious bugs

**Code Quality**:
- [ ] Follows project style guide
- [ ] Names are clear and descriptive
- [ ] Functions are focused (single responsibility)
- [ ] No unnecessary complexity
- [ ] DRY principle followed (Don't Repeat Yourself)

**Testing**:
- [ ] Tests added for new code
- [ ] Tests cover edge cases
- [ ] Existing tests still pass
- [ ] Test names are descriptive

**Security**:
- [ ] No secrets in code
- [ ] Input validation present
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Authentication/authorization correct

**Performance**:
- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] No N+1 query problems
- [ ] Large data sets handled efficiently

**Documentation**:
- [ ] Public APIs documented
- [ ] Complex logic explained
- [ ] README updated (if needed)
- [ ] Breaking changes documented

**Review etiquette**:
- Be respectful and constructive
- Explain *why*, not just *what* to change
- Distinguish between blocking issues and suggestions
- Praise good solutions
- Use conventional comment prefixes:
  - `nit:` - Minor issue, non-blocking
  - `question:` - Asking for clarification
  - `suggestion:` - Optional improvement
  - `blocker:` - Must be addressed before merge

**Example review comments**:

**Good**:
```
suggestion: Consider using a Map instead of an Object here for better performance
with large datasets. Objects have prototype chain lookups, while Maps don't.

Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map
```

**Bad**:
```
This is wrong. Use a Map.
```

**Good**:
```
blocker: This function doesn't handle the case where `user` is null, which
can happen when the session expires. This will cause the application to crash.

Suggested fix:
if (!user) {
  throw new UnauthorizedError('Session expired');
}
```

**Bad**:
```
This will crash if user is null.
```

### Using AI Tools for Code Review

**Claude Code** is excellent for comprehensive PR analysis:

**Example prompt**:
```
Please review this pull request:
- Check for potential bugs and edge cases
- Identify security concerns
- Suggest performance improvements
- Verify test coverage is adequate
- Check if documentation needs updates

Be thorough but concise in your feedback.
```

**See [AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for detailed AI-assisted review patterns.**

---

## Issue Tracking

### Issue Types

We use GitHub Issues with the following templates:

1. **Bug Report** - Report a defect or unexpected behavior
2. **Feature Request** - Propose new functionality
3. **Documentation** - Documentation improvements
4. **Security** - Security vulnerabilities (use private reporting)

### Issue Labels

**Type**:
- `bug` - Something isn't working
- `feature` - New feature request
- `documentation` - Documentation improvement
- `security` - Security vulnerability
- `performance` - Performance issue

**Priority**:
- `priority:critical` - Blocks production, needs immediate attention
- `priority:high` - Important but not blocking
- `priority:medium` - Normal priority
- `priority:low` - Nice to have

**Status**:
- `needs-triage` - Needs initial review
- `needs-reproduction` - Can't reproduce yet
- `needs-investigation` - Requires research
- `ready` - Ready to be worked on
- `in-progress` - Currently being worked on
- `blocked` - Blocked by external factor

**Other**:
- `good-first-issue` - Good for newcomers
- `help-wanted` - Extra attention needed
- `duplicate` - Duplicate of another issue
- `wontfix` - Won't be fixed
- `invalid` - Invalid issue

### Linking PRs to Issues

**In PR description**:
```markdown
Fixes #123
Closes #456, #789
Related to #234
```

**In commit messages**:
```
fix(auth): prevent session timeout

This resolves the issue where long operations would
cause authentication tokens to expire prematurely.

Fixes #123
```

**Keywords** (close issue when PR merges):
- `Fixes #123`
- `Closes #123`
- `Resolves #123`

**Reference only** (doesn't close):
- `Refs #123`
- `Related to #123`
- `See #123`

### Issue Workflow

```
┌─────────────┐
│ New Issue   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Triage    │ ◄── Label, prioritize, assign
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Ready    │ ◄── Picked up by developer
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ In Progress │ ◄── Branch created, work started
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   PR Open   │ ◄── Pull request created
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Merged    │ ◄── Issue auto-closed
└─────────────┘
```

---

## Branch Protection Rules

### Main Branch Protection

**Settings** (`.github/workflows/branch-protection.yml`):
```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["CI", "CodeQL"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "require_code_owner_reviews": true,
    "dismiss_stale_reviews": true
  },
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
```

**What this means**:
- ❌ No direct commits to `main`
- ✅ Requires PR with 1 approval
- ✅ Requires code owner approval (from CODEOWNERS file)
- ✅ Must pass CI and CodeQL checks
- ✅ All review conversations must be resolved
- ❌ No force pushes
- ❌ No branch deletion

### Develop Branch Protection

**Settings**: Same as main, but:
- Code owner review is recommended but not required
- Allows slightly more flexibility for integration testing

### Bypassing Protection (Emergencies Only)

**When allowed**:
- Critical security patches
- Service outages requiring immediate fix
- Automated releases (via service account)

**Process**:
1. Document reason in incident report
2. Get approval from repository admin
3. Create hotfix branch
4. Make minimal necessary changes
5. Create PR for review (even if merged after)
6. Update develop branch immediately after

**Never bypass for**:
- Convenience
- Rushing features
- Avoiding code review

---

## Common Workflows

### Starting a New Feature

```bash
# 1. Ensure develop is up-to-date
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/user-notifications

# 3. Make changes and commit
git add .
git commit -m "feat(notifications): add email notification system"

# 4. Push to remote
git push -u origin feature/user-notifications

# 5. Create PR on GitHub
gh pr create --base develop --title "feat(notifications): add email notification system"
```

### Fixing a Bug

```bash
# 1. Create bugfix branch from develop
git checkout develop
git pull origin develop
git checkout -b bugfix/fix-login-timeout

# 2. Fix the bug and test
# ... make changes ...
make ci-check

# 3. Commit with conventional format
git add .
git commit -m "fix(auth): prevent session timeout during uploads

Long file uploads were causing tokens to expire before completion.
This adds token refresh logic during active uploads.

Fixes #342"

# 4. Push and create PR
git push -u origin bugfix/fix-login-timeout
gh pr create --base develop --title "fix(auth): prevent session timeout" --body "Fixes #342"
```

### Emergency Hotfix

```bash
# 1. Branch from main (not develop!)
git checkout main
git pull origin main
git checkout -b hotfix/security-patch

# 2. Make minimal fix
# ... fix security issue ...
git add .
git commit -m "fix(security)!: patch XSS vulnerability

BREAKING CHANGE: HTML in user input is now escaped by default.
Use {{{ triple braces }}} for trusted HTML.

Fixes #567"

# 3. PR to main
git push -u origin hotfix/security-patch
gh pr create --base main --title "fix(security)!: patch XSS vulnerability" --label "security,priority:critical"

# 4. After merge to main, also merge to develop
git checkout develop
git pull origin develop
git merge main
git push origin develop
```

### Preparing a Release

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Version bumps and changelog (automated by release-please)
# Manual steps if not automated:
# - Update version in package.json / pyproject.toml
# - Update CHANGELOG.md
# - Update any version references in docs

# 3. Final testing
make ci-check
# ... additional release testing ...

# 4. PR to main
git push -u origin release/v1.2.0
gh pr create --base main --title "chore(release): version 1.2.0"

# 5. After merge to main, tag the release
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# 6. Merge back to develop
git checkout develop
git merge main
git push origin develop
```

### Syncing a Long-Running Branch

```bash
# Option 1: Merge (preserves all commits)
git checkout feature/long-running-feature
git merge develop
git push origin feature/long-running-feature

# Option 2: Rebase (cleaner history, but rewrites commits)
git checkout feature/long-running-feature
git rebase develop
# Resolve conflicts if any
git push --force-with-lease origin feature/long-running-feature
```

**⚠️ Warning**: Only use `--force-with-lease` on branches you own. Never force push to shared branches.

---

## Troubleshooting

### Problem: "Protected branch update failed"

**Cause**: Trying to push directly to main or develop

**Solution**: Create a pull request instead
```bash
git checkout -b feature/my-changes
git push -u origin feature/my-changes
gh pr create
```

### Problem: "Merge conflicts"

**Solution**:
```bash
# 1. Update your branch with latest develop
git checkout feature/your-feature
git fetch origin
git merge origin/develop

# 2. Resolve conflicts in your editor
# Git will mark conflicts with <<<<<<< ======= >>>>>>>

# 3. After resolving, mark as resolved
git add <resolved-files>
git commit -m "merge: resolve conflicts with develop"

# 4. Push updated branch
git push origin feature/your-feature
```

### Problem: "CI checks failing"

**Solution**:
```bash
# Run CI checks locally first
make ci-check

# Fix issues, then push
git add .
git commit -m "fix: resolve linting errors"
git push origin feature/your-feature
```

### Problem: "Pre-commit hook preventing commit"

**Cause**: Code doesn't pass pre-commit checks (linting, formatting)

**Solution**:
```bash
# Fix issues automatically if possible
make format

# Or skip hooks temporarily (not recommended)
git commit --no-verify -m "message"

# Better: fix the issues properly
make lint  # See what's failing
```

### Problem: "Accidentally committed to wrong branch"

**Solution**:
```bash
# If not pushed yet
git reset HEAD~1  # Undo last commit, keep changes
git stash  # Save changes
git checkout correct-branch
git stash pop  # Apply changes
git add .
git commit -m "correct commit message"

# If already pushed
# Create PR from wrong branch to correct branch
# Or cherry-pick commits to correct branch
```

### Problem: "Need to update commit message"

**Solution**:
```bash
# If last commit and not pushed
git commit --amend -m "new message"

# If already pushed (creates new commit hash)
git commit --amend -m "new message"
git push --force-with-lease origin feature/your-branch

# If commit is not the last one
git rebase -i HEAD~3  # Edit last 3 commits
# Mark commit as 'reword' in editor
```

### Problem: "PR has too many commits"

**Solution**: Squash commits before merge
```bash
# Interactive rebase
git rebase -i develop

# In editor, change 'pick' to 'squash' for commits to combine
# Save and close editor
# Edit combined commit message
# Force push
git push --force-with-lease origin feature/your-branch
```

### Problem: "Forgot to link PR to issue"

**Solution**: Edit PR description to include:
```markdown
Fixes #123
```
Or add a comment:
```markdown
This PR fixes #123
```

---

## Next Steps

1. **Read AI Workflows**: See [AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for using Claude Code and GitHub Copilot with this workflow
2. **Review CI/CD Guide**: See [CI-CD-PIPELINE.md](CI-CD-PIPELINE.md) for automation details
3. **Check Security Guide**: See [SECURITY-AND-COMPLIANCE.md](SECURITY-AND-COMPLIANCE.md) for security best practices
4. **Start Contributing**: Create your first branch and PR!

---

## Additional Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Semantic Versioning](https://semver.org/)
- [release-please](https://github.com/googleapis/release-please)
- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

---

**Questions?** Open a [Discussion](https://github.com/your-org/your-repo/discussions) or ask in your team's chat channel.
