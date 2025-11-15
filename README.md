# Universal Project Template

A comprehensive, language-agnostic repository template for modern software development with built-in CI/CD, AI-assisted workflows, and cross-platform support.

## What's Included

- **Cross-Platform Development**: Windows (native + WSL2) and Linux support
- **AI Agent Orchestration**: Integrated workflows for Claude Code (@claude) and GitHub Copilot
- **Automated CI/CD**: Linting, testing, building, and deployment pipelines
- **Git Workflow Engine**: Branch management, PR quality gates, and automated maintenance
- **Security & Compliance**: Dependency scanning, CodeQL analysis, and security best practices
- **Developer Guides**: Step-by-step setup instructions for all platforms
- **Make-Based Automation**: Cross-platform build and development tasks

## Quick Start

### 1. Use This Template

Click **"Use this template"** on GitHub to create a new repository from this template.

### 2. Clone and Setup

```bash
# Clone your new repository
git clone https://github.com/your-org/your-repo.git
cd your-repo

# Run initial setup
make setup
```

### 3. Choose Your Platform

**Windows Developers**: See [docs/DEV-ENV-WINDOWS.md](docs/DEV-ENV-WINDOWS.md)

**Linux Developers**: See [docs/DEV-ENV-LINUX.md](docs/DEV-ENV-LINUX.md)

### 4. Customize for Your Stack

See [docs/CI-CD-PIPELINE.md](docs/CI-CD-PIPELINE.md) for language-specific configuration examples.

## Documentation

### Developer Environment Setup

- **[Windows Setup Guide](docs/DEV-ENV-WINDOWS.md)** - Native Windows and WSL2 configuration
- **[Linux Setup Guide](docs/DEV-ENV-LINUX.md)** - Ubuntu, Fedora, and other distributions

### Workflows & Processes

- **[Git Workflow Guide](docs/GIT-WORKFLOW.md)** - Branching, commits, PRs, and code review
- **[AI Agent Workflows](docs/AI-AGENT-WORKFLOWS.md)** - Using Claude Code and GitHub Copilot together
- **[CI/CD Pipeline Guide](docs/CI-CD-PIPELINE.md)** - Automation patterns and customization
- **[Security & Compliance](docs/SECURITY-AND-COMPLIANCE.md)** - Security checks and best practices

### Getting Started Guides

- **[Getting Started](docs/getting-started.md)** - Quick overview of available make targets
- **[Architecture Decisions](docs/decisions/)** - ADR templates and examples

## Features

### Automated Workflows

- **CI Pipeline**: Lint, test, and build on every push and PR
- **PR Quality Gate**: Automated code quality checks and review assistance
- **Branch Maintenance**: Automated cleanup of stale and merged branches
- **Security Scanning**: CodeQL, Dependabot, and dependency audits
- **Release Automation**: Conventional Commits → automatic releases with release-please

### AI-Assisted Development

- **Claude Code Integration**: Deep code analysis, PR reviews, and architectural guidance
- **GitHub Copilot**: In-editor code completion and generation
- **Orchestrated Workflows**: Defined patterns for using both AI tools effectively
- **Example Prompts**: Ready-to-use prompts for common development tasks

### Cross-Platform Support

- **Make Targets**: Unified commands across all platforms
- **WSL2 Integration**: Seamless Windows/Linux development environment
- **Platform-Specific Scripts**: Setup automation for Windows and Linux
- **Dev Containers**: VS Code Dev Container configuration included

## Local Development

### Available Make Targets

```bash
make help              # List all available targets
make doctor            # Check required toolchain availability
make setup             # Install pre-commit hooks and prepare environment
make lint              # Run linters (markdownlint, shellcheck, actionlint)
make test              # Run tests (auto-detects Node/Python projects)
make ci-check          # Run doctor + lint + test (CI simulation)
make install-tools     # Install local linters and development tools
```

### Quick Commands

```bash
# Check your environment
make doctor

# Run all quality checks (like CI does)
make ci-check

# Install development tools
make install-tools
```

## Branch Strategy

This template follows a Git Flow-inspired branching model:

- **`main`** - Production-ready code (protected)
- **`develop`** - Integration branch for features (protected)
- **`feature/*`** - New features (branch from develop)
- **`bugfix/*`** - Bug fixes (branch from develop)
- **`hotfix/*`** - Emergency fixes (branch from main)
- **`release/*`** - Release preparation (branch from develop)

See [docs/GIT-WORKFLOW.md](docs/GIT-WORKFLOW.md) for detailed workflow instructions.

## Adoption Guide

### Adding This Template to an Existing Repository

1. **Copy Core Files**:
   ```bash
   # Copy workflow definitions
   cp -r .github/ /path/to/your/repo/

   # Copy documentation
   cp -r docs/ /path/to/your/repo/

   # Copy scripts
   cp -r scripts/ /path/to/your/repo/

   # Copy Makefile
   cp Makefile /path/to/your/repo/
   ```

2. **Customize for Your Stack**:
   - Edit `.github/workflows/ci.yml` with your build/test commands
   - Update `scripts/run-quality-checks.sh` for your linters
   - Add language-specific configuration from `config/` examples

3. **Enable GitHub Features**:
   - Turn on branch protection for `main` and `develop`
   - Enable required status checks (CI, PR Quality Gate)
   - Configure Dependabot and CodeQL in repository settings

4. **Configure AI Tools**:
   - Install Claude Code extension in your IDE
   - Enable GitHub Copilot for your organization/account
   - Review [docs/AI-AGENT-WORKFLOWS.md](docs/AI-AGENT-WORKFLOWS.md) for usage patterns

### Customization Checklist

- [ ] Update repository name and description in README
- [ ] Customize CODEOWNERS with your team/individuals
- [ ] Configure branch protection rules
- [ ] Add language-specific linters and tests to CI
- [ ] Update issue and PR templates for your project
- [ ] Configure secrets for deployment (if needed)
- [ ] Enable AI tools (Claude Code, GitHub Copilot)

## Technology Support

This template is designed to work with:

- **JavaScript/TypeScript**: Node.js projects with npm/pnpm/yarn
- **Python**: Projects with pip, poetry, or uv
- **Multi-language**: Monorepos with multiple tech stacks
- **Static Sites**: Documentation, marketing sites, etc.

Language-specific examples available in `config/` directory.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Code of conduct
- Pull request process
- Commit message conventions
- Code review guidelines

## Security

See [SECURITY.md](SECURITY.md) for:

- Reporting vulnerabilities
- Security update process
- Supported versions

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- **Documentation**: Check the `docs/` folder
- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions

---

**Estimated Setup Time**: 10-30 minutes (depending on platform and customization needs)

**Maintained By**: [Diatonic AI](https://github.com/Diatonic-AI)
