# Windows Development Environment Setup Script
#
# This script automates the setup process documented in docs/DEV-ENV-WINDOWS.md
# Run this in PowerShell as Administrator
#
# Usage: .\scripts\setup-dev-env-windows.ps1
#

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Check prerequisites
function Test-Prerequisites {
    Write-Info "Checking prerequisites..."

    # Check Windows version
    $osVersion = [System.Environment]::OSVersion.Version
    if ($osVersion.Build -lt 19041) {
        Write-Error-Custom "Windows 10 version 2004+ (Build 19041+) or Windows 11 is required"
    }

    Write-Info "Prerequisites check passed"
}

# Install Chocolatey
function Install-Chocolatey {
    if (Test-Command choco) {
        Write-Info "Chocolatey is already installed"
        return
    }

    Write-Info "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Refresh environment
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Install Git
function Install-Git {
    if (Test-Command git) {
        Write-Info "Git is already installed"
        return
    }

    Write-Info "Installing Git..."
    choco install git -y

    # Refresh environment
    refreshenv
}

# Install Make
function Install-Make {
    if (Test-Command make) {
        Write-Info "Make is already installed"
        return
    }

    Write-Info "Installing Make..."
    choco install make -y
}

# Install Node.js
function Install-NodeJS {
    if (Test-Command node) {
        Write-Info "Node.js is already installed"
        return
    }

    Write-Info "Installing Node.js LTS..."
    choco install nodejs-lts -y
}

# Install Python
function Install-Python {
    if (Test-Command python) {
        Write-Info "Python is already installed"
        return
    }

    Write-Info "Installing Python..."
    choco install python -y
}

# Configure Git
function Configure-Git {
    Write-Info "Configuring Git..."

    $gitName = Read-Host "Enter your Git name"
    $gitEmail = Read-Host "Enter your Git email"

    git config --global user.name "$gitName"
    git config --global user.email "$gitEmail"
    git config --global init.defaultBranch main
    git config --global core.autocrlf true
    git config --global core.editor "code --wait"

    Write-Info "Git configured successfully"
}

# Generate SSH key
function New-SSHKey {
    if (Test-Path "$env:USERPROFILE\.ssh\id_ed25519") {
        Write-Info "SSH key already exists"
        return
    }

    $generateKey = Read-Host "Generate SSH key for GitHub? (y/n)"
    if ($generateKey -ne "y") {
        return
    }

    $sshEmail = Read-Host "Enter your email for SSH key"

    # Generate key
    ssh-keygen -t ed25519 -C "$sshEmail"

    # Start SSH agent
    Start-Service ssh-agent
    ssh-add "$env:USERPROFILE\.ssh\id_ed25519"

    Write-Info "SSH key generated. Add this public key to GitHub:"
    Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"

    Read-Host "Press Enter when you've added the key to GitHub"

    # Test connection
    $testResult = ssh -T git@github.com 2>&1 | Out-String
    if ($testResult -match "successfully authenticated") {
        Write-Info "GitHub SSH authentication successful!"
    }
    else {
        Write-Warn "GitHub SSH authentication may have failed. Test with: ssh -T git@github.com"
    }
}

# Install GitHub CLI
function Install-GitHubCLI {
    if (Test-Command gh) {
        Write-Info "GitHub CLI is already installed"
        return
    }

    Write-Info "Installing GitHub CLI..."
    choco install gh -y

    $authGH = Read-Host "Authenticate with GitHub CLI? (y/n)"
    if ($authGH -eq "y") {
        gh auth login
    }
}

# Install pre-commit
function Install-PreCommit {
    if (Test-Command pre-commit) {
        Write-Info "pre-commit is already installed"
        return
    }

    Write-Info "Installing pre-commit..."
    pip install pre-commit
}

# Recommend WSL2
function Recommend-WSL2 {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       WSL2 Recommendation                 ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "For the best development experience, we recommend using WSL2." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Benefits:" -ForegroundColor Yellow
    Write-Host "  ✓ Better compatibility with Linux-based tools" -ForegroundColor Yellow
    Write-Host "  ✓ Faster file I/O for development" -ForegroundColor Yellow
    Write-Host "  ✓ Same environment as production servers" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "See docs/DEV-ENV-WINDOWS.md for WSL2 setup instructions" -ForegroundColor Yellow
    Write-Host ""

    $installWSL = Read-Host "Would you like to enable WSL2 now? (y/n)"
    if ($installWSL -eq "y") {
        Write-Info "Enabling WSL2..."
        wsl --install

        Write-Warn "You need to restart your computer to complete WSL2 installation"
        $restart = Read-Host "Restart now? (y/n)"
        if ($restart -eq "y") {
            Restart-Computer
        }
    }
}

# Main setup function
function Main {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  Windows Development Environment Setup    ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    $continue = Read-Host "Continue with native Windows setup? (y/n)"
    if ($continue -ne "y") {
        Write-Info "Setup cancelled"
        exit 0
    }

    Test-Prerequisites
    Install-Chocolatey
    Install-Git
    Install-Make
    Install-NodeJS
    Install-Python
    Configure-Git
    New-SSHKey
    Install-GitHubCLI
    Install-PreCommit

    Write-Host ""
    Write-Info "✓ Development environment setup complete!"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Restart PowerShell to refresh environment variables"
    Write-Host "2. Clone this repository: git clone <repo-url>"
    Write-Host "3. Run project setup: make setup"
    Write-Host "4. Read the workflow guide: docs\GIT-WORKFLOW.md"
    Write-Host "5. Configure AI tools: docs\AI-AGENT-WORKFLOWS.md"
    Write-Host ""

    Recommend-WSL2
}

Main
