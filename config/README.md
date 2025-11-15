# Configuration Examples

This directory contains example configurations for customizing the CI/CD pipeline for different technology stacks.

## Available Examples

- [node-ci-example.md](node-ci-example.md) - Node.js/TypeScript CI configuration
- [python-ci-example.md](python-ci-example.md) - Python CI configuration
- [docker-ci-example.md](docker-ci-example.md) - Docker build CI configuration
- [multi-language-example.md](multi-language-example.md) - Monorepo/multi-language configuration

## How to Use

1. Review the example that matches your stack
2. Copy relevant sections to `.github/workflows/ci.yml`
3. Customize for your specific needs
4. Test locally with `make ci-check`

## See Also

- [CI/CD Pipeline Guide](../docs/CI-CD-PIPELINE.md) - Complete CI/CD documentation
- [Security Guide](../docs/SECURITY-AND-COMPLIANCE.md) - Security best practices
