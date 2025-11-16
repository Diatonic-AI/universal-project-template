# Windows Development Environment Setup

**Who this is for**: Windows developers who want to contribute to this project

**What you'll achieve**: A fully configured development environment with Git, language runtimes, and AI tools

**Estimated time**: 15-30 minutes

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start: Automated Setup](#quick-start-automated-setup)
- [Recommended Approach: WSL2](#recommended-approach-wsl2)
- [Alternative: Native Windows](#alternative-native-windows)
- [Common Tools](#common-tools)
- [Additional Development Tools](#additional-development-tools)
- [Verification](#verification)
- [IDE Setup](#ide-setup)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)

## Before You Start

**New to development?** Start with the [GETTING-STARTED-BEGINNER.md](GETTING-STARTED-BEGINNER.md) guide for a complete walkthrough.

**Need to enable virtualization?** See [BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md) for detailed BIOS configuration.

**Want to optimize Windows?** Check [WINDOWS-OPTIMIZATION.md](WINDOWS-OPTIMIZATION.md) for performance tuning.

**WSL2 advanced users?** See [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md) for optimization and advanced configuration.

## Prerequisites

- Windows 10 version 2004+ (Build 19041+) or Windows 11
- Administrator access for initial setup
- Stable internet connection
- **Virtualization enabled in BIOS** (see [BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md))

## Quick Start: Automated Setup

For automated installation, run our PowerShell setup script:

```powershell
# Download and run setup script
# From PowerShell as Administrator
.\scripts\setup-dev-env-windows.ps1
```

This script will:
- Install Chocolatey package manager
- Install Git, Make, Node.js, Python
- Configure Git
- Generate SSH keys (optional)
- Install recommended tools

**Or continue below for manual, step-by-step installation.**

---

## Recommended Approach: WSL2

WSL2 (Windows Subsystem for Linux 2) provides better compatibility with Linux-based development tools and closer parity with production environments.

### Why WSL2?

✅ Better compatibility with shell scripts and Make

✅ Faster file I/O for development tools

✅ Same environment as Linux production servers

✅ Native support for Docker without Docker Desktop

### Step 1: Enable WSL2

Open PowerShell as Administrator and run:

```powershell
# Enable WSL and Virtual Machine Platform
wsl --install

# Restart your computer when prompted
```

**Verification**:
```powershell
wsl --status
# Should show "Default Version: 2"
```

### Step 2: Install Ubuntu

```powershell
# Install Ubuntu (recommended distro)
wsl --install -d Ubuntu

# Launch Ubuntu to complete initial setup
wsl

# You'll be prompted to create a Linux username and password
# Remember these credentials!
```

### Step 3: Update Ubuntu

Inside your WSL2 Ubuntu terminal:

```bash
# Update package lists
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y
```

### Step 4: Install Development Tools in WSL2

```bash
# Install essential build tools
sudo apt install -y \
  build-essential \
  git \
  curl \
  wget \
  ca-certificates \
  gnupg \
  lsb-release

# Verify Git installation
git --version
# Expected output: git version 2.x.x
```

### Step 5: Install Language Runtimes (WSL2)

#### Node.js (via nvm - recommended)

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell configuration
source ~/.bashrc

# Install Node.js LTS
nvm install --lts
nvm use --lts

# Verify installation
node --version
npm --version
```

#### Python

```bash
# Install Python 3 and pip
sudo apt install -y python3 python3-pip python3-venv

# Verify installation
python3 --version
pip3 --version

# Optional: Create alias for 'python'
echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc
```

#### Rust (Optional)

```bash
# Install Rust via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Follow prompts (default installation is recommended)
# Reload shell
source ~/.cargo/env

# Verify installation
rustc --version
cargo --version
```

#### Docker Desktop (Recommended for WSL2)

**Option A: Docker Desktop (Easiest)**
1. Download Docker Desktop from https://www.docker.com/products/docker-desktop/
2. Run installer
3. During installation, select "Use WSL 2 instead of Hyper-V"
4. Restart computer
5. Open Docker Desktop
6. Settings → General → "Use the WSL 2 based engine" (should be checked)
7. Settings → Resources → WSL Integration:
   - Enable integration with your WSL2 distro (Ubuntu)

**Verify**:
```bash
# From WSL2
docker --version
docker compose version
docker run hello-world
```

**Option B: Docker Engine only (without Docker Desktop)**

```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add your user to docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo service docker start

# Verify
docker --version
```

#### Windows Terminal (Highly Recommended)

Install Windows Terminal for a better terminal experience:

```powershell
# From PowerShell (Windows)
winget install Microsoft.WindowsTerminal

# Or install from Microsoft Store
```

**Configure Windows Terminal**:
1. Open Windows Terminal
2. Press Ctrl+, to open settings
3. Set "Default profile" to "Ubuntu" (for WSL2 users)
4. Customize appearance, color schemes, etc.

### Step 6: Configure Git in WSL2

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Improve Windows line ending handling
git config --global core.autocrlf input

# Optional: Set VS Code as default editor
git config --global core.editor "code --wait"
```

### Step 7: Set Up SSH for GitHub (WSL2)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"
# Press Enter to accept default location
# Set a passphrase (recommended)

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
# Copy the output
```

Now add the SSH key to GitHub:
1. Go to https://github.com/settings/keys
2. Click "New SSH key"
3. Paste your public key
4. Click "Add SSH key"

**Verify**:
```bash
ssh -T git@github.com
# You should see: "Hi username! You've successfully authenticated..."
```

### Step 8: File System Best Practices

**IMPORTANT**: Keep your projects inside the WSL2 filesystem for best performance.

```bash
# Navigate to your Linux home directory
cd ~

# Create projects folder
mkdir -p ~/projects
cd ~/projects

# Clone repositories here (NOT in /mnt/c/)
git clone git@github.com:your-org/your-repo.git
```

**Why?** Accessing Windows files from WSL2 (`/mnt/c/`) is **significantly slower** than using the native WSL2 filesystem (`~`).

### Step 9: Access WSL2 Files from Windows

You can access your WSL2 files from Windows Explorer:

```
\\wsl$\Ubuntu\home\YOUR_USERNAME\projects
```

Or type `\\wsl$` in File Explorer address bar.

---

## Alternative: Native Windows

If you prefer native Windows development or can't use WSL2:

### Step 1: Install Git for Windows

1. Download from https://git-scm.com/download/win
2. Run the installer
3. **Important selections**:
   - ✅ Git Bash Here
   - ✅ Git from the command line and also from 3rd-party software
   - ✅ Checkout Windows-style, commit Unix-style line endings
   - ✅ Use MinTTY terminal
   - ✅ Enable file system caching

**Verification**:
```powershell
git --version
```

### Step 2: Install GNU Make

**Option A: Via Chocolatey (Recommended)**

```powershell
# Install Chocolatey if not installed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Make
choco install make

# Verify
make --version
```

**Option B: Via MSYS2**

1. Download MSYS2 from https://www.msys2.org/
2. Install and open MSYS2 terminal
3. Run: `pacman -S make`
4. Add MSYS2 to PATH: `C:\msys64\usr\bin`

### Step 3: Install Node.js (Native Windows)

1. Download from https://nodejs.org/ (LTS version)
2. Run installer
3. Accept defaults

**Verification**:
```powershell
node --version
npm --version
```

### Step 4: Install Python (Native Windows)

1. Download from https://www.python.org/downloads/
2. Run installer
3. ✅ **IMPORTANT**: Check "Add Python to PATH"
4. Click "Install Now"

**Verification**:
```powershell
python --version
pip --version
```

### Step 5: Configure Git (Native Windows)

```powershell
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch
git config --global init.defaultBranch main

# Configure line endings
git config --global core.autocrlf true

# Set editor
git config --global core.editor "code --wait"
```

### Step 6: Set Up SSH (Native Windows)

Use Git Bash for SSH key generation:

```bash
# Open Git Bash and run
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key
ssh-add ~/.ssh/id_ed25519

# View public key
cat ~/.ssh/id_ed25519.pub
```

Add the key to GitHub as described in WSL2 section.

---

## Common Tools

These tools work on both WSL2 and native Windows:

### VS Code

1. Download from https://code.visualstudio.com/
2. Install with default options

**For WSL2 users**: Install the "Remote - WSL" extension:
```bash
# From WSL2 terminal
code .
# This will install VS Code Server in WSL2
```

### GitHub CLI

**WSL2**:
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

**Native Windows**:
```powershell
# Via Chocolatey
choco install gh

# Or download from https://cli.github.com/

# Authenticate
gh auth login
```

### Pre-commit

**WSL2**:
```bash
pip3 install pre-commit
```

**Native Windows**:
```powershell
pip install pre-commit
```

---

## Additional Development Tools

### Rust (Native Windows)

```powershell
# Download and run rustup-init.exe from https://rustup.rs/

# Or via Chocolatey
choco install rust-ms

# Verify
rustc --version
cargo --version
```

### Docker Desktop (Native Windows)

1. Download from https://www.docker.com/products/docker-desktop/
2. Run installer
3. Choose WSL 2 backend if available, or Hyper-V (Pro/Enterprise/Education only)
4. Restart computer

**Verify**:
```powershell
docker --version
docker compose version
docker run hello-world
```

### Windows Terminal

```powershell
# Install via winget
winget install Microsoft.WindowsTerminal

# Or from Microsoft Store
```

**Benefits**:
- Tabs and split panes
- GPU-accelerated text rendering
- Customizable color schemes
- Better Unicode support

### Make (via Chocolatey)

```powershell
choco install make
make --version
```

### curl (Usually pre-installed)

```powershell
# Verify
curl --version

# If not installed
choco install curl
```

### jq (JSON processor)

```powershell
choco install jq

# Verify
jq --version
```

### Postman (API testing)

```powershell
choco install postman

# Or download from https://www.postman.com/
```

---

## Verification

Run the following commands to verify your setup:

**WSL2**:
```bash
cd ~/projects/your-repo
make doctor
```

**Native Windows (PowerShell)**:
```powershell
cd C:\Users\YourName\projects\your-repo
make doctor
```

You should see output confirming the presence of required tools.

---

## IDE Setup

### VS Code Extensions (Recommended)

Install these extensions for the best experience:

1. **Remote - WSL** (if using WSL2)
2. **GitLens** - Git supercharger
3. **GitHub Copilot** - AI pair programmer
4. **Claude Code** - AI code assistant
5. **Makefile Tools** - Make support
6. **Python** (if using Python)
7. **ESLint** (if using JavaScript/TypeScript)
8. **Prettier** - Code formatter

**Install via command** (from WSL2 or Git Bash):
```bash
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension eamodio.gitlens
code --install-extension GitHub.copilot
code --install-extension ms-vscode.makefile-tools
```

### Configure Claude Code

1. Install Claude Code from VS Code marketplace
2. Sign in with your Anthropic account
3. See [docs/AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for usage patterns

### Configure GitHub Copilot

1. Install GitHub Copilot from VS Code marketplace
2. Sign in with your GitHub account
3. Verify your organization/account has Copilot enabled
4. See [docs/AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md) for orchestration patterns

---

## Troubleshooting

### WSL2 Issues

**Problem**: WSL2 is slow or unresponsive

**Solution**:
```powershell
# Restart WSL2
wsl --shutdown
wsl
```

**Problem**: Can't access Windows files from WSL2

**Solution**: Windows drives are mounted at `/mnt/`, e.g., `C:\` is `/mnt/c/`

**Problem**: Docker doesn't start in WSL2

**Solution**:
```bash
sudo service docker start

# To start Docker automatically
echo "sudo service docker start > /dev/null 2>&1" >> ~/.bashrc
```

### Native Windows Issues

**Problem**: Make command not found

**Solution**: Ensure Make is in PATH or use the wrapper script:
```powershell
.\scripts\win\make.ps1 help
```

**Problem**: Permission errors with npm

**Solution**: Run as Administrator or configure npm prefix:
```powershell
npm config set prefix %APPDATA%\npm
```

**Problem**: Line ending warnings from Git

**Solution**:
```powershell
git config --global core.autocrlf true
```

### General Issues

**Problem**: SSH authentication fails

**Solution**:
1. Ensure SSH key is added to GitHub
2. Test connection: `ssh -T git@github.com`
3. Check SSH agent is running

**Problem**: Can't run shell scripts

**Solution** (WSL2): Ensure scripts have execute permission:
```bash
chmod +x scripts/*.sh
```

**Solution** (Windows): Use Git Bash or WSL2 to run `.sh` scripts

---

## Next Steps

1. **Clone the repository**: `git clone <repo-url>`
2. **Run setup**: `make setup`
3. **Read the workflow guide**: [docs/GIT-WORKFLOW.md](GIT-WORKFLOW.md)
4. **Configure AI tools**: [docs/AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md)
5. **Start developing!**

---

## Advanced Configuration

### Performance Optimization

For detailed Windows performance tuning for development workloads, see:
**[WINDOWS-OPTIMIZATION.md](WINDOWS-OPTIMIZATION.md)**

Topics covered:
- Windows Features management
- Windows Defender exclusions
- Virtual memory configuration
- Power management settings
- Network optimization
- GPU configuration for AI/ML

### WSL2 Advanced Setup

For advanced WSL2 configuration, memory limits, and performance tuning, see:
**[WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)**

Topics covered:
- .wslconfig configuration (memory, CPU limits)
- wsl.conf settings
- Performance best practices
- Docker Desktop integration
- GPU support (NVIDIA/AMD)
- Networking configuration

### BIOS Configuration

If virtualization features are not working, see:
**[BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md)**

Complete guide for enabling Intel VT-x/VT-d and AMD SVM/IOMMU across all major motherboard manufacturers.

---

## Additional Resources

- [Official WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Git for Windows](https://gitforwindows.org/)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/wsl)
- [GitHub SSH Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Rust on Windows](https://www.rust-lang.org/tools/install)
- [Windows Terminal Documentation](https://learn.microsoft.com/en-us/windows/terminal/)

---

**Having trouble?** Open an issue or check our [Discussions](https://github.com/your-org/your-repo/discussions) for community help.
