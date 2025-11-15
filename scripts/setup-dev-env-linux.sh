#!/usr/bin/env bash
#
# Linux Development Environment Setup Script
#
# This script automates the setup process documented in docs/DEV-ENV-LINUX.md
# Supports: Ubuntu/Debian and Fedora/RHEL
#
# Usage: ./scripts/setup-dev-env-linux.sh
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        info "$1 is already installed"
        return 0
    else
        return 1
    fi
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        DISTRO="$ID"
    else
        error "Cannot detect Linux distribution"
    fi
}

# Update system packages
update_system() {
    info "Updating system packages..."
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update && sudo apt upgrade -y
            ;;
        fedora|rhel|centos)
            sudo dnf update -y
            ;;
        *)
            warn "Unknown distribution: $DISTRO. Skipping system update."
            ;;
    esac
}

# Install build tools
install_build_tools() {
    info "Installing build tools..."
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y build-essential git curl wget ca-certificates gnupg pkg-config libssl-dev
            ;;
        fedora|rhel|centos)
            sudo dnf groupinstall -y "Development Tools"
            sudo dnf install -y git curl wget openssl-devel
            ;;
        *)
            warn "Unknown distribution. Please install build tools manually."
            ;;
    esac
}

# Install Node.js via nvm
install_nodejs() {
    if check_command nvm; then
        return 0
    fi

    info "Installing nvm (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
}

# Install Python
install_python() {
    if check_command python3; then
        return 0
    fi

    info "Installing Python..."
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y python3 python3-pip python3-venv python3-dev
            ;;
        fedora|rhel|centos)
            sudo dnf install -y python3 python3-pip python3-devel
            ;;
    esac

    # Create aliases
    if ! grep -q "alias python=python3" ~/.bashrc; then
        echo 'alias python=python3' >> ~/.bashrc
        echo 'alias pip=pip3' >> ~/.bashrc
    fi
}

# Configure Git
configure_git() {
    info "Configuring Git..."

    read -rp "Enter your Git name: " git_name
    read -rp "Enter your Git email: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor "code --wait"

    info "Git configured successfully"
}

# Generate SSH key
generate_ssh_key() {
    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        info "SSH key already exists"
        return 0
    fi

    read -rp "Generate SSH key for GitHub? (y/n): " generate_key
    if [[ "$generate_key" != "y" ]]; then
        return 0
    fi

    read -rp "Enter your email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email"

    # Start SSH agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519

    info "SSH key generated. Add this public key to GitHub:"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    read -rp "Press Enter when you've added the key to GitHub..."

    # Test connection
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        info "GitHub SSH authentication successful!"
    else
        warn "GitHub SSH authentication may have failed. Test with: ssh -T git@github.com"
    fi
}

# Install GitHub CLI
install_gh_cli() {
    if check_command gh; then
        return 0
    fi

    info "Installing GitHub CLI..."
    case "$DISTRO" in
        ubuntu|debian)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
            sudo apt update
            sudo apt install -y gh
            ;;
        fedora|rhel|centos)
            sudo dnf install -y gh
            ;;
    esac

    read -rp "Authenticate with GitHub CLI? (y/n): " auth_gh
    if [[ "$auth_gh" == "y" ]]; then
        gh auth login
    fi
}

# Install pre-commit
install_precommit() {
    if check_command pre-commit; then
        return 0
    fi

    info "Installing pre-commit..."
    pip3 install --user pre-commit

    # Add to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
}

# Main setup function
main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║   Linux Development Environment Setup     ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""

    detect_distro
    info "Detected distribution: $DISTRO"
    echo ""

    read -rp "Continue with setup? (y/n): " continue_setup
    if [[ "$continue_setup" != "y" ]]; then
        info "Setup cancelled"
        exit 0
    fi

    update_system
    install_build_tools
    install_nodejs
    install_python
    configure_git
    generate_ssh_key
    install_gh_cli
    install_precommit

    echo ""
    info "✓ Development environment setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Reload your shell: source ~/.bashrc"
    echo "2. Clone this repository: git clone <repo-url>"
    echo "3. Run project setup: make setup"
    echo "4. Read the workflow guide: docs/GIT-WORKFLOW.md"
    echo "5. Configure AI tools: docs/AI-AGENT-WORKFLOWS.md"
    echo ""
}

main "$@"
