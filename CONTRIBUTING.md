# Contributing

## Branching and PRs
- Branch from `develop` using `feature/*`, `bugfix/*`, or `chore/*`.
- Open PRs into `develop`. Use squash merge and keep a linear history.

## Conventional Commits
- feat: add a new feature
- fix: bug fix
- chore/docs/refactor/test/build/ci: as needed
- BREAKING CHANGE: in body

## Reviews and DCO (optional)
- At least one code owner review required.
- You may sign commits with a Developer Certificate of Origin using `-s`.

## Run checks locally
- `make setup` (installs pre-commit hooks)
- `make ci-check` (doctor + lint + test)
