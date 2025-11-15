# Security & Compliance Guide

**Who this is for**: All developers and security-conscious teams

**What you'll learn**: Security best practices, vulnerability management, and compliance patterns

**Estimated reading time**: 20 minutes

## Table of Contents

- [Overview](#overview)
- [Automated Security Features](#automated-security-features)
- [Dependency Security](#dependency-security)
- [Code Security](#code-security)
- [Secret Management](#secret-management)
- [Security Checklist](#security-checklist)
- [Vulnerability Reporting](#vulnerability-reporting)
- [Compliance](#compliance)
- [Language-Specific Security](#language-specific-security)
- [AI Tool Security](#ai-tool-security)

---

## Overview

This template includes **security by default** with automated scanning, dependency updates, and best-practice enforcement.

### Security Layers

```
┌─────────────────────────────────────────┐
│     Layer 1: Dependency Security        │
│  Dependabot, npm audit, pip audit       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Layer 2: Code Security              │
│  CodeQL, static analysis, linters       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Layer 3: Secret Protection          │
│  GitHub secret scanning, .gitignore     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Layer 4: Runtime Security           │
│  Environment isolation, least privilege │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Layer 5: Human Review               │
│  Code review, security checklist        │
└─────────────────────────────────────────┘
```

### Security Principles

1. **Security by Default**: Secure configurations out of the box
2. **Defense in Depth**: Multiple layers of protection
3. **Least Privilege**: Minimal permissions required
4. **Fail Secure**: Errors don't compromise security
5. **Audit Everything**: Complete audit trail

---

## Automated Security Features

### 1. Dependabot - Automated Dependency Updates

**Configuration**: `.github/dependabot.yml`

**What it does**:
- Checks for outdated dependencies weekly
- Opens pull requests with updates
- Provides changelog and compatibility info
- Groups minor/patch updates

**Ecosystems covered**:
- npm (package.json)
- pip (requirements.txt, pyproject.toml)
- GitHub Actions (workflows)

**Example PR**:
```
Title: Bump axios from 0.27.2 to 1.6.2

Changes:
- axios: 0.27.2 → 1.6.2
- Includes security fixes for CVE-2023-45857

Compatibility: 99% likely compatible
Changelog: https://github.com/axios/axios/blob/main/CHANGELOG.md
```

**Managing Dependabot PRs**:

✅ **Good practices**:
- Review changelog before merging
- Check CI results
- Test locally for major updates
- Merge promptly (security fixes)

❌ **Bad practices**:
- Auto-merging without review
- Ignoring security updates
- Letting PRs pile up

**Configuration options**:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "automated"
    # Group non-security updates
    groups:
      dev-dependencies:
        patterns:
          - "@types/*"
          - "eslint*"
          - "prettier"
```

### 2. CodeQL - Code Security Scanning

**Configuration**: `.github/workflows/codeql.yml`

**What it does**:
- Scans code for security vulnerabilities
- Checks for OWASP Top 10 issues
- Detects SQL injection, XSS, path traversal
- Runs on every push to main/develop
- Weekly scheduled scans

**Languages supported**:
- JavaScript/TypeScript
- Python
- Java
- C/C++
- C#
- Go
- Ruby

**Vulnerability categories**:
- SQL injection
- Cross-site scripting (XSS)
- Command injection
- Path traversal
- Hard-coded credentials
- Insufficient cryptography
- CSRF vulnerabilities

**Viewing results**:
1. Go to repository → Security tab
2. Click "Code scanning alerts"
3. Review findings and severity
4. Click "Show more" for remediation advice

**Dismissing false positives**:
```yaml
# In code, add comment:
// lgtm[js/sql-injection]  # Reason: User input is sanitized upstream
```

**Custom queries**:

```yaml
# .github/workflows/codeql.yml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: javascript-typescript, python
    queries: security-extended  # More thorough scanning
    # Or specify custom query packs
    # queries: ./custom-queries
```

### 3. GitHub Secret Scanning

**Automatic protection**:
- GitHub automatically scans for known secret patterns
- Blocks commits with secrets (if push protection enabled)
- Notifies when secrets found in history

**Enable push protection**:
1. Settings → Code security and analysis
2. Enable "Push protection"
3. Team members can't push commits with secrets

**Supported secret types**:
- AWS access keys
- Google API keys
- Stripe API keys
- Private SSH keys
- OAuth tokens
- Database connection strings
- And 100+ more patterns

**If secret is detected**:
1. Revoke the exposed secret immediately
2. Remove from git history:
   ```bash
   # Use BFG Repo-Cleaner or git-filter-repo
   git filter-repo --path-glob '**/secret.env' --invert-paths
   ```
3. Create new secret
4. Update services to use new secret
5. Audit for unauthorized access

---

## Dependency Security

### npm (Node.js)

**Audit dependencies**:
```bash
# Check for vulnerabilities
npm audit

# Fix automatically (if possible)
npm audit fix

# Fix breaking changes too (risky)
npm audit fix --force
```

**In CI** (already configured):
```yaml
- name: Security audit
  run: npm audit --audit-level=high
```

**Best practices**:

1. **Use package-lock.json**:
   ```bash
   # ✅ Ensures reproducible installs
   npm ci

   # ❌ Ignores lockfile, installs latest
   npm install
   ```

2. **Avoid deprecated packages**:
   ```bash
   npm deprecate <package>@<version> "Use <alternative> instead"
   ```

3. **Minimize dependencies**:
   - Review dependency tree: `npm ls`
   - Remove unused: `npm prune`
   - Use lighter alternatives

4. **Pin versions for security-critical packages**:
   ```json
   {
     "dependencies": {
       "jsonwebtoken": "9.0.2",  // ✅ Exact version
       "express": "^4.18.0"      // ❌ Could update to 4.19.0
     }
   }
   ```

### pip (Python)

**Audit dependencies**:
```bash
# Using pip-audit
pip install pip-audit
pip-audit

# Using safety
pip install safety
safety check
```

**In CI**:
```yaml
- name: Security audit
  run: |
    pip install pip-audit
    pip-audit --strict
```

**Best practices**:

1. **Pin versions in requirements.txt**:
   ```txt
   # ✅ Good: exact versions
   Django==4.2.7
   requests==2.31.0

   # ❌ Bad: unpinned
   Django
   requests>=2.0
   ```

2. **Generate from lockfile**:
   ```bash
   # Poetry
   poetry export -f requirements.txt --output requirements.txt --without-hashes

   # pip-tools
   pip-compile requirements.in
   ```

3. **Separate dev dependencies**:
   ```txt
   # requirements-dev.txt
   pytest==7.4.3
   black==23.11.0

   # requirements.txt (production only)
   Django==4.2.7
   ```

### Docker

**Scan images**:
```bash
# Using Trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image myapp:latest

# In CI
- name: Scan Docker image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:latest
    format: 'sarif'
    output: 'trivy-results.sarif'
```

**Best practices**:

1. **Use minimal base images**:
   ```dockerfile
   # ✅ Good: minimal Alpine image
   FROM node:20-alpine

   # ❌ Bad: full Debian image
   FROM node:20
   ```

2. **Don't run as root**:
   ```dockerfile
   # Create non-root user
   RUN addgroup -g 1001 -S nodejs && \
       adduser -S nodejs -u 1001

   USER nodejs
   ```

3. **Multi-stage builds**:
   ```dockerfile
   # Build stage
   FROM node:20 AS builder
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci
   COPY . .
   RUN npm run build

   # Production stage
   FROM node:20-alpine
   WORKDIR /app
   COPY --from=builder /app/dist ./dist
   COPY --from=builder /app/node_modules ./node_modules
   USER nodejs
   CMD ["node", "dist/index.js"]
   ```

---

## Code Security

### OWASP Top 10 (2021)

#### 1. Broken Access Control

**Vulnerability**: Users access unauthorized resources

**Prevention**:
```javascript
// ❌ Bad: No authorization check
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id);
  res.json(user);
});

// ✅ Good: Check ownership
app.get('/api/users/:id', requireAuth, async (req, res) => {
  const user = await User.findById(req.params.id);
  if (user.id !== req.user.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  res.json(user);
});
```

#### 2. Cryptographic Failures

**Vulnerability**: Weak encryption, hardcoded secrets

**Prevention**:
```javascript
// ❌ Bad: Weak hashing
const hash = crypto.createHash('md5').update(password).digest('hex');

// ✅ Good: Strong hashing with salt
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash(password, 12);

// ❌ Bad: Hardcoded secret
const jwt = sign(payload, 'my-secret-key');

// ✅ Good: Environment variable
const jwt = sign(payload, process.env.JWT_SECRET);
```

#### 3. Injection

**Vulnerability**: SQL injection, command injection, XSS

**Prevention**:

**SQL Injection**:
```javascript
// ❌ Bad: String concatenation
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// ✅ Good: Parameterized query
db.query('SELECT * FROM users WHERE id = $1', [userId]);

// ✅ Good: ORM
User.findOne({ where: { id: userId } });
```

**Command Injection**:
```javascript
// ❌ Bad: Unsanitized input
exec(`ping ${userInput}`);

// ✅ Good: Input validation
const ip = validateIP(userInput);
if (!ip) throw new Error('Invalid IP');
exec(`ping ${ip}`);

// ✅ Better: Use library instead of shell
const ping = require('ping');
await ping.promise.probe(userInput);
```

**Cross-Site Scripting (XSS)**:
```javascript
// ❌ Bad: Unescaped output
res.send(`<h1>Hello ${username}</h1>`);

// ✅ Good: Template engine with auto-escaping
res.render('welcome', { username });

// ✅ Good: Manual escaping
const escape = require('escape-html');
res.send(`<h1>Hello ${escape(username)}</h1>`);
```

#### 4. Insecure Design

**Vulnerability**: Architecture flaws, missing security controls

**Prevention**:
- Threat modeling during design phase
- Security requirements in user stories
- Defense in depth (multiple layers)
- Fail secure (errors don't bypass security)

**Example - Rate limiting**:
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Max 100 requests per window
  message: 'Too many requests, please try again later'
});

app.use('/api/', limiter);
```

#### 5. Security Misconfiguration

**Vulnerability**: Default configs, unnecessary features, verbose errors

**Prevention**:
```javascript
// ❌ Bad: Verbose errors in production
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack });
});

// ✅ Good: Generic errors in production
app.use((err, req, res, next) => {
  console.error(err);  // Log internally
  res.status(500).json({ error: 'Internal server error' });
});

// ✅ Good: Disable unnecessary headers
app.disable('x-powered-by');
app.use(helmet());  // Sets secure headers
```

**Security headers**:
```javascript
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

#### 6. Vulnerable and Outdated Components

**Prevention**: Use Dependabot (already configured)

See [Dependency Security](#dependency-security) section.

#### 7. Identification and Authentication Failures

**Vulnerability**: Weak passwords, session fixation, credential stuffing

**Prevention**:
```javascript
// ✅ Strong password requirements
const passwordSchema = new passwordValidator();
passwordSchema
  .is().min(12)
  .is().max(100)
  .has().uppercase()
  .has().lowercase()
  .has().digits()
  .has().symbols()
  .has().not().spaces();

// ✅ Account lockout after failed attempts
const MAX_ATTEMPTS = 5;
const LOCK_TIME = 15 * 60 * 1000; // 15 minutes

// ✅ Multi-factor authentication
const speakeasy = require('speakeasy');
const verified = speakeasy.totp.verify({
  secret: user.totpSecret,
  encoding: 'base32',
  token: userProvidedToken
});
```

#### 8. Software and Data Integrity Failures

**Vulnerability**: Unsigned updates, insecure CI/CD

**Prevention**:
- Verify dependencies with checksums
- Use signed commits
- Implement code signing
- Secure CI/CD pipeline

```yaml
# Verify action checksums
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4
```

#### 9. Security Logging and Monitoring Failures

**Prevention**:
```javascript
// ✅ Log security events
logger.warn('Failed login attempt', {
  username,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  timestamp: new Date()
});

// ✅ Log access to sensitive resources
logger.info('Accessed user data', {
  userId: req.user.id,
  targetUserId: req.params.id,
  action: 'view_profile'
});

// ❌ Don't log sensitive data
logger.info('Login success', {
  password: req.body.password  // NEVER LOG PASSWORDS
});
```

#### 10. Server-Side Request Forgery (SSRF)

**Vulnerability**: Server makes requests to attacker-controlled URLs

**Prevention**:
```javascript
// ❌ Bad: Unrestricted URL fetching
app.post('/fetch', async (req, res) => {
  const response = await fetch(req.body.url);
  res.send(await response.text());
});

// ✅ Good: Whitelist allowed hosts
const ALLOWED_HOSTS = ['api.example.com', 'cdn.example.com'];

app.post('/fetch', async (req, res) => {
  const url = new URL(req.body.url);
  if (!ALLOWED_HOSTS.includes(url.hostname)) {
    return res.status(400).json({ error: 'Invalid host' });
  }
  const response = await fetch(url.toString());
  res.send(await response.text());
});
```

---

## Secret Management

### Never Commit Secrets

**Add to `.gitignore`**:
```gitignore
# Environment files
.env
.env.local
.env.*.local

# Credentials
*credentials.json
*service-account*.json
*.pem
*.key
id_rsa*

# Config with secrets
config/production.yml
secrets/
```

### Environment Variables

**Development** (.env file, gitignored):
```bash
# .env
DATABASE_URL=postgresql://localhost/myapp_dev
JWT_SECRET=dev-secret-change-in-production
STRIPE_KEY=sk_test_...
```

**Production** (GitHub Secrets):
```yaml
# In workflow
- name: Deploy
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    JWT_SECRET: ${{ secrets.JWT_SECRET }}
    STRIPE_KEY: ${{ secrets.STRIPE_KEY }}
```

### Secrets in Code

**Loading secrets**:
```javascript
// ✅ Good: Load from environment
require('dotenv').config();
const jwtSecret = process.env.JWT_SECRET;
if (!jwtSecret) {
  throw new Error('JWT_SECRET environment variable required');
}

// ❌ Bad: Hardcoded
const jwtSecret = 'my-super-secret-key';
```

**Validating at startup**:
```javascript
// config/env.js
const requiredEnvVars = [
  'DATABASE_URL',
  'JWT_SECRET',
  'STRIPE_KEY',
  'AWS_ACCESS_KEY_ID'
];

for (const varName of requiredEnvVars) {
  if (!process.env[varName]) {
    console.error(`Missing required environment variable: ${varName}`);
    process.exit(1);
  }
}
```

### Rotating Secrets

**Process**:
1. Generate new secret
2. Add to environment (keep old one)
3. Deploy application
4. Update to use new secret
5. Remove old secret

**Supporting rotation**:
```javascript
// Accept multiple JWT secrets during rotation
const jwtSecrets = process.env.JWT_SECRETS.split(',');

function verifyToken(token) {
  for (const secret of jwtSecrets) {
    try {
      return jwt.verify(token, secret);
    } catch (err) {
      continue;
    }
  }
  throw new Error('Invalid token');
}
```

---

## Security Checklist

### Pre-Deployment Checklist

**Code**:
- [ ] No hardcoded secrets or credentials
- [ ] All user input is validated and sanitized
- [ ] SQL queries are parameterized
- [ ] Authentication and authorization implemented
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Error messages don't leak sensitive info

**Dependencies**:
- [ ] `npm audit` / `pip-audit` shows no high/critical vulnerabilities
- [ ] All dependencies are up-to-date
- [ ] No deprecated packages
- [ ] Lockfile is committed

**Infrastructure**:
- [ ] HTTPS is enforced
- [ ] Security headers configured (CSP, HSTS, etc.)
- [ ] Database connections are encrypted
- [ ] Principle of least privilege applied
- [ ] Backups are encrypted

**CI/CD**:
- [ ] All CI checks pass
- [ ] CodeQL shows no issues
- [ ] Branch protection is enabled
- [ ] Secrets are stored in GitHub Secrets, not code

**Monitoring**:
- [ ] Security logging is enabled
- [ ] Alerts configured for suspicious activity
- [ ] Audit logs are retained
- [ ] Incident response plan documented

### Code Review Security Checklist

Use this for every PR:

**Authentication/Authorization**:
- [ ] Are all endpoints properly authenticated?
- [ ] Is authorization checked before accessing resources?
- [ ] Are user permissions validated?

**Input Validation**:
- [ ] Is all user input validated?
- [ ] Are there length limits on inputs?
- [ ] Is input sanitized before use?

**Data Protection**:
- [ ] Is sensitive data encrypted at rest and in transit?
- [ ] Are passwords properly hashed?
- [ ] Is PII handled according to privacy requirements?

**Error Handling**:
- [ ] Do error messages avoid leaking sensitive information?
- [ ] Are errors logged appropriately?
- [ ] Are there proper fallbacks for errors?

**Dependencies**:
- [ ] Are new dependencies from trusted sources?
- [ ] Are dependency versions pinned?
- [ ] Have new dependencies been security audited?

---

## Vulnerability Reporting

### If You Find a Vulnerability

**DO**:
1. Report privately via GitHub Security Advisories
2. Include detailed reproduction steps
3. Assess severity honestly
4. Allow reasonable time for fix (typically 90 days)

**DON'T**:
- Publicly disclose before fix
- Exploit the vulnerability
- Demand compensation

**Reporting template**:
```markdown
## Vulnerability Report

**Affected Component**: [e.g., Authentication API]

**Severity**: [Critical/High/Medium/Low]

**Description**: [What is the vulnerability?]

**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [Observe vulnerability]

**Impact**: [What can an attacker do?]

**Suggested Fix**: [Optional: how to fix]

**Environment**:
- Version: [e.g., v1.2.3]
- Platform: [e.g., Node.js 20]
```

### If Someone Reports to You

**Response timeline**:
- **Within 24 hours**: Acknowledge receipt
- **Within 7 days**: Initial assessment and severity rating
- **Within 30 days**: Fix or mitigation plan
- **Within 90 days**: Public disclosure (coordinated)

**Process**:
1. Acknowledge and thank reporter
2. Reproduce the vulnerability
3. Assess severity using CVSS
4. Develop fix
5. Test thoroughly
6. Prepare security advisory
7. Deploy fix
8. Publish advisory
9. Credit reporter (if desired)

---

## Compliance

### GDPR (General Data Protection Regulation)

**Key requirements**:
- User consent for data collection
- Right to access personal data
- Right to delete personal data
- Data breach notification (72 hours)
- Privacy by design

**Implementation**:
```javascript
// User data export
app.get('/api/user/export', requireAuth, async (req, res) => {
  const userData = await User.exportData(req.user.id);
  res.json(userData);
});

// User data deletion
app.delete('/api/user/account', requireAuth, async (req, res) => {
  await User.deleteAll(req.user.id);
  res.status(204).send();
});

// Consent tracking
await Consent.record({
  userId: user.id,
  type: 'marketing_emails',
  granted: true,
  timestamp: new Date()
});
```

### HIPAA (Health Insurance Portability and Accountability Act)

**If handling health data**:
- Encrypt data at rest and in transit
- Implement access controls
- Audit all access to health records
- Business Associate Agreements (BAAs) required
- Incident response plan

### PCI DSS (Payment Card Industry Data Security Standard)

**If handling payment cards**:
- **Never** store CVV/CVC
- Encrypt card data
- Use tokenization (Stripe, etc.)
- Implement network segmentation
- Regular security testing

**Best practice**: Use payment providers (Stripe, PayPal) instead of handling cards directly.

---

## Language-Specific Security

### JavaScript/TypeScript

**Common vulnerabilities**:
- Prototype pollution
- RegEx DoS
- `eval()` usage
- Unsafe dependencies

**Security tools**:
```json
{
  "devDependencies": {
    "eslint-plugin-security": "^1.7.1",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "npm-audit": "latest"
  }
}
```

**.eslintrc.js**:
```javascript
module.exports = {
  plugins: ['security'],
  extends: ['plugin:security/recommended'],
  rules: {
    'security/detect-eval-with-expression': 'error',
    'security/detect-non-literal-regexp': 'warn',
    'security/detect-object-injection': 'warn'
  }
};
```

### Python

**Common vulnerabilities**:
- Command injection via `os.system()`
- SQL injection
- Deserialization attacks (pickle)
- Path traversal

**Security tools**:
```bash
pip install bandit safety pip-audit
```

**Run bandit**:
```bash
bandit -r . -f json -o bandit-report.json
```

**Common issues**:
```python
# ❌ Bad: Command injection
os.system(f"ping {user_input}")

# ✅ Good: Use subprocess with list
subprocess.run(["ping", user_input], check=True)

# ❌ Bad: Pickle untrusted data
data = pickle.loads(untrusted_data)

# ✅ Good: Use JSON instead
data = json.loads(untrusted_data)
```

---

## AI Tool Security

When using Claude Code or GitHub Copilot, follow security guidelines:

### What NOT to Share with AI

**Never share**:
- API keys, tokens, passwords
- Customer PII
- Proprietary algorithms
- Infrastructure details
- Database credentials
- Private SSH keys

### Sanitize Before Sharing

**Example**:
```javascript
// ❌ Don't share this with AI
const config = {
  dbUrl: 'postgresql://admin:SecretPass123@prod-db.company.com/myapp',
  stripeKey: 'sk_live_51HaH8iL...',
  jwtSecret: 'prod-jwt-secret-2024'
};

// ✅ Sanitize first
const config = {
  dbUrl: 'postgresql://USER:PASSWORD@HOST/DATABASE',
  stripeKey: 'sk_live_REDACTED',
  jwtSecret: 'JWT_SECRET'
};
```

### Review AI-Generated Code

**Always review for**:
- Hardcoded credentials
- Insecure patterns
- Missing validation
- Weak cryptography
- SQL injection risks

**See [AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for detailed AI security guidelines.**

---

## Next Steps

1. **Run Security Audit**:
   ```bash
   make ci-check  # Runs linters and tests
   npm audit     # Check dependencies
   ```

2. **Enable GitHub Security Features**:
   - Settings → Security → Enable Dependabot alerts
   - Settings → Security → Enable secret scanning
   - Settings → Security → Enable push protection

3. **Review SECURITY.md**: Update with your vulnerability reporting process

4. **Train Team**: Share this guide with all developers

5. **Schedule Reviews**: Quarterly security audits

---

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [GitHub Security Features](https://docs.github.com/en/code-security)
- [npm Security Best Practices](https://docs.npmjs.com/packages-and-modules/securing-your-code)
- [Python Security Guide](https://python.readthedocs.io/en/stable/library/security_warnings.html)

---

**Questions?** Open a [Discussion](https://github.com/your-org/your-repo/discussions) or contact your security team.
