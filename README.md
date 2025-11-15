# Universal Project Template

A universal, language-agnostic template to kickstart new projects with:
- Cross-platform automation (GNU Make) with Windows support
- CI (linting + placeholders for Node/Python tests)
- Security (CodeQL), Dependabot, Conventional Commits, release-please
- Clear branch strategy and contribution guidelines

## Use this template
1. Click "Use this template" in GitHub.
2. Create your repo and clone it locally.
3. Run `make setup` to install hooks and local tooling.
4. Start coding in `src/` and add tests under `test/`.

## Local development
- Run `make help` to see available tasks.
- `make doctor` checks required tools.
- `make lint` runs markdownlint, shellcheck, actionlint.
- `make test` auto-detects Node (npm test) and Python (pytest) if configured.
- `make ci-check` runs doctor + lint + test (non-interactive).

## Branch strategy (Git Flow-style)
- Long-lived: `main` (protected), `develop` (protected)
- Working: `feature/*`, `bugfix/*`, `chore/*` from develop
- Releases: `release/*` from develop → merge to main and develop
- Hotfixes: `hotfix/*` from main → merge to main and develop
- Tagging: SemVer tags (vX.Y.Z) on merges to main

## Release workflow
- Conventional Commits drive release-please.
- Merging to main creates or updates a release PR; upon merge, a GitHub release and tag vX.Y.Z are created.

## Windows setup
- If GNU make is not installed, run `scripts/win/bootstrap.ps1` to see install commands.
- You can invoke `scripts/win/make.ps1 <target>` as a wrapper.
