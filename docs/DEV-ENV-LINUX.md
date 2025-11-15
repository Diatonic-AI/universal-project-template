# Linux Development Environment Setup

**Who this is for**: Linux developers (Ubuntu, Fedora, Debian, etc.)

**What you'll achieve**: A fully configured development environment

**Estimated time**: 10-20 minutes

## Prerequisites

- Linux distribution (Ubuntu 20.04+, Fedora 35+, or equivalent)
- sudo access
- Internet connection

## Quick Setup (Ubuntu/Debian)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential git curl wget ca-certificates gnupg

# Verify
git --version
make --version
```

## Quick Setup (Fedora/RHEL)

```bash
# Update system
sudo dnf update -y

# Install essential tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git curl wget

# Verify
git --version
make --version
```

## Step 1: Install Git

Git is usually pre-installed. If not:

**Ubuntu/Debian**:
```bash
sudo apt install -y git
```

**Fedora/RHEL**:
```bash
sudo dnf install -y git
```

**Configure Git**:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"  # or vim, nano, etc.
```

## Step 2: Install Build Tools

**Ubuntu/Debian**:
```bash
sudo apt install -y build-essential pkg-config libssl-dev
```

**Fedora/RHEL**:
```bash
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y openssl-devel
```

## Step 3: Install Language Runtimes

### Node.js (via nvm - recommended)

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell
source ~/.bashrc  # or ~/.zshrc if using zsh

# Install Node.js LTS
nvm install --lts
nvm use --lts

# Verify
node --version
npm --version
```

### Python

**Ubuntu/Debian**:
```bash
sudo apt install -y python3 python3-pip python3-venv python3-dev
```

**Fedora/RHEL**:
```bash
sudo dnf install -y python3 python3-pip python3-devel
```

**Verify**:
```bash
python3 --version
pip3 --version
```

**Optional aliases**:
```bash
echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc
```

### Docker (Optional)

**Ubuntu**:
```bash
# Add Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Install
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
```

**Fedora**:
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

## Step 4: Set Up SSH for GitHub

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub
# Copy the output and add to GitHub: https://github.com/settings/keys
```

**Verify**:
```bash
ssh -T git@github.com
# Should see: "Hi username! You've successfully authenticated..."
```

## Step 5: Install Development Tools

### GitHub CLI

**Ubuntu/Debian**:
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt update
sudo apt install gh

gh auth login
```

**Fedora**:
```bash
sudo dnf install -y gh
gh auth login
```

### Pre-commit

```bash
pip3 install --user pre-commit

# Add to PATH if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### VS Code

**Ubuntu/Debian**:
```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install code
```

**Fedora**:
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo
sudo dnf check-update
sudo dnf install code
```

## Step 6: Install AI Tools

### Claude Code

Install from VS Code marketplace:
```bash
code --install-extension Anthropic.claude-code
```

### GitHub Copilot

Install from VS Code marketplace:
```bash
code --install-extension GitHub.copilot
```

## Step 7: Clone and Setup Repository

```bash
# Create projects directory
mkdir -p ~/projects
cd ~/projects

# Clone repository
git clone git@github.com:your-org/your-repo.git
cd your-repo

# Run setup
make setup

# Verify environment
make doctor
```

## Verification

Run these commands to verify your setup:

```bash
git --version          # Git 2.x+
node --version         # Node 18+ or 20+
npm --version          # npm 9+
python3 --version      # Python 3.10+
pip3 --version         # pip 23+
make --version         # GNU Make 4.x+
docker --version       # Docker 20+
gh --version           # GitHub CLI 2.x+
```

## Shell Configuration

Add these helpful aliases to `~/.bashrc` or `~/.zshrc`:

```bash
# Project shortcuts
alias projects='cd ~/projects'
alias repo='cd ~/projects/your-repo'

# Git shortcuts
alias gs='git status'
alias gp='git pull'
alias gco='git checkout'
alias gcm='git checkout main'
alias gcd='git checkout develop'

# Make shortcuts
alias m='make'
alias mh='make help'
alias md='make doctor'
alias mc='make ci-check'
```

Reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

## IDE Extensions (VS Code)

Install recommended extensions:

```bash
code --install-extension eamodio.gitlens
code --install-extension GitHub.copilot
code --install-extension Anthropic.claude-code
code --install-extension ms-vscode.makefile-tools
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
```

## Troubleshooting

### Permission denied (publickey)

```bash
# Ensure SSH key is added to GitHub
ssh-add -l

# If empty, add your key
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
```

### npm permission errors

```bash
# Configure npm to install global packages in user directory
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Docker permission denied

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run
newgrp docker
```

### make: command not found

```bash
# Ubuntu/Debian
sudo apt install make

# Fedora
sudo dnf install make
```

## Next Steps

1. Read [docs/GIT-WORKFLOW.md](GIT-WORKFLOW.md) for Git best practices
2. Review [docs/AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for AI tool usage
3. Check [docs/CI-CD-PIPELINE.md](CI-CD-PIPELINE.md) for automation details
4. Start developing!

## Additional Resources

- [Ubuntu Documentation](https://help.ubuntu.com/)
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [GitHub SSH Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [VS Code on Linux](https://code.visualstudio.com/docs/setup/linux)
