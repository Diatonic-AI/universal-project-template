<!--
PR Title Guidelines:
- Use Conventional Commits format: type(scope): description
- Examples:
  - feat(auth): add OAuth2 support
  - fix(api): resolve timeout errors
  - docs: update installation guide

See docs/GIT-WORKFLOW.md for details
-->

## Summary

<!-- Provide a brief overview of what this PR accomplishes.
What problem does it solve? What functionality does it add? -->



## Related Issues

<!-- Link to related issues using keywords:
- Fixes #123
- Closes #456
- Related to #789
-->

Fixes #

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🔧 Configuration change
- [ ] ♻️ Code refactoring (no functional changes)
- [ ] ⚡ Performance improvement
- [ ] ✅ Test update

## Testing

<!-- Describe the tests you ran to verify your changes.
Provide instructions so reviewers can reproduce. -->

### Test Coverage

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] E2E tests added/updated (if applicable)
- [ ] Manual testing completed

### Test Results

<!-- Paste relevant test output or describe manual testing -->

```
# Example:
npm test
# All tests passing (95% coverage)
```

## Screenshots / Videos

<!-- If applicable, add screenshots or videos to help explain your changes -->



## AI Review

<!-- STRONGLY RECOMMENDED: Use Claude Code for self-review before requesting human review -->

### AI Review Checklist

- [ ] **Security**: Ran `@claude Review for security vulnerabilities`
- [ ] **Tests**: Ran `@claude Check test coverage and suggest missing tests`
- [ ] **Performance**: Ran `@claude Identify potential performance issues`
- [ ] **Code Quality**: Ran `@claude Review for code quality and maintainability`

### AI Review Summary

<!-- Paste Claude's findings or write "No issues found by AI review" -->

<details>
<summary>Claude Code Review Results</summary>

```
# Paste Claude's review here or delete this section if not used
```

</details>

**See [AI-AGENT-WORKFLOWS.md](docs/AI-AGENT-WORKFLOWS.md) for AI-assisted review patterns**

## Checklist

### Before Requesting Review

- [ ] PR title follows Conventional Commits format
- [ ] Code follows project style guidelines
- [ ] Self-review completed (reviewed own code line-by-line)
- [ ] Comments added for complex/non-obvious code
- [ ] Documentation updated (README, API docs, etc.)
- [ ] No new warnings generated
- [ ] `make ci-check` passes locally
- [ ] Branch is up-to-date with target branch
- [ ] Commit messages are clear and descriptive

### Security & Quality

- [ ] No secrets or credentials in code
- [ ] Input validation added where needed
- [ ] Error handling is appropriate
- [ ] No obvious security vulnerabilities
- [ ] Dependencies are up-to-date (if changed)

### For Reviewers

**Focus areas for review**:
<!-- Guide reviewers on what to pay attention to -->



**Questions for reviewers**:
<!-- Any specific questions or concerns -->



## Breaking Changes

<!-- If this is a breaking change, describe:
1. What breaks
2. Migration path for users
3. Why the breaking change is necessary
-->



## Additional Context

<!-- Add any other context, implementation notes, or rationale here -->



---

## Reviewer Guide

### Review Checklist

Please verify:

- [ ] Code quality and readability
- [ ] Test coverage is adequate
- [ ] Documentation is complete and clear
- [ ] No security issues introduced
- [ ] Performance implications considered
- [ ] Breaking changes properly documented
- [ ] All conversations resolved

### AI-Assisted Review (Recommended)

Use Claude Code for comprehensive analysis:

```
@claude Review this PR for potential bugs, security issues, and areas for improvement.
Focus on [specific area if needed].
```

**See [AI-AGENT-WORKFLOWS.md](docs/AI-AGENT-WORKFLOWS.md) for detailed review patterns**

---

<!--
Additional Resources:
- Git Workflow: docs/GIT-WORKFLOW.md
- AI Workflows: docs/AI-AGENT-WORKFLOWS.md
- CI/CD Guide: docs/CI-CD-PIPELINE.md
- Security Guide: docs/SECURITY-AND-COMPLIANCE.md
-->
