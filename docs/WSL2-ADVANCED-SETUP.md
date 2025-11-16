# WSL2 Advanced Setup and Configuration

**Complete guide to installing, configuring, and optimizing WSL2 for maximum development performance**

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Install WSL2](#install-wsl2)
  - [Install Linux Distributions](#install-linux-distributions)
- [Advanced Configuration (.wslconfig)](#advanced-configuration-wslconfig)
- [Distribution-Specific Configuration (wsl.conf)](#distribution-specific-configuration-wslconf)
- [Performance Optimization](#performance-optimization)
- [Docker Desktop Integration](#docker-desktop-integration)
- [GPU Support (NVIDIA/AMD)](#gpu-support-nvidiaand)
- [Networking Configuration](#networking-configuration)
- [File System Best Practices](#file-system-best-practices)
- [Development Workflow Optimization](#development-workflow-optimization)
- [VS Code Integration](#vs-code-integration)
- [Backup and Migration](#backup-and-migration)
- [Troubleshooting](#troubleshooting)

---

## Overview

WSL2 (Windows Subsystem for Linux 2) provides a full Linux kernel running in a lightweight virtual machine, offering:
- Near-native Linux performance
- Full system call compatibility
- Direct access to Windows files and network
- GPU acceleration support
- Seamless Docker Desktop integration

### WSL2 vs WSL1

| Feature | WSL1 | WSL2 |
|---------|------|------|
| Full system call compatibility | ❌ | ✅ |
| Performance (file I/O in Linux) | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| Performance (cross-OS file I/O) | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| Docker Desktop support | Limited | Full |
| Memory usage | Lower | Higher |
| Boot time | Instant | ~1-2 seconds |
| GPU support | ❌ | ✅ |

**Recommendation**: Use WSL2 for all modern development workflows.

---

## Installation

### Prerequisites

1. **Windows Version**:
   - Windows 10 version 2004+ (Build 19041+)
   - Windows 11 (any version)

2. **Check Windows Version**:
   ```powershell
   # Check Windows version
   winver

   # Detailed version info
   Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber
   ```

3. **Hardware Virtualization**:
   - Must be enabled in BIOS
   - See [BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md)

4. **Verify Virtualization is Enabled**:
   ```powershell
   # Check if virtualization is enabled
   Get-ComputerInfo | Select-Object HyperV*

   # Should show:
   # HyperVRequirementVirtualizationFirmwareEnabled : True
   ```

### Install WSL2

**Method 1: Simple Installation (Windows 10 2004+ / Windows 11)**

Open PowerShell or Windows Terminal as **Administrator**:

```powershell
# Install WSL2 with default Ubuntu
wsl --install

# This will:
# 1. Enable WSL and Virtual Machine Platform features
# 2. Download and install latest Linux kernel
# 3. Set WSL2 as default
# 4. Install Ubuntu (default distribution)

# Restart computer
Restart-Computer
```

**Method 2: Manual Installation (More Control)**

```powershell
# Step 1: Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Step 2: Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Step 3: Restart
Restart-Computer

# Step 4: Download and install WSL2 kernel update (after restart)
# Download from: https://aka.ms/wsl2kernel
# Or use winget:
winget install Microsoft.WSL

# Step 5: Set WSL2 as default version
wsl --set-default-version 2
```

**Verify Installation**:
```powershell
# Check WSL version
wsl --status

# Should show:
# Default Version: 2
# Virtualization: Enabled

# List installed distributions
wsl --list --verbose
```

### Install Linux Distributions

**Available Distributions**:
```powershell
# List available distributions
wsl --list --online

# Output:
# Ubuntu
# Debian
# kali-linux
# Ubuntu-20.04
# Ubuntu-22.04
# Ubuntu-24.04
# And more...
```

**Install Distribution**:
```powershell
# Install Ubuntu (latest)
wsl --install -d Ubuntu

# Install specific version
wsl --install -d Ubuntu-22.04

# Install Debian
wsl --install -d Debian

# Install multiple distributions
wsl --install -d Ubuntu-22.04
wsl --install -d Debian
```

**Set Default Distribution**:
```powershell
# List installed distributions
wsl --list --verbose

# Set default
wsl --setdefault Ubuntu-22.04
```

**First Time Setup**:
When you first launch the distribution, you'll be prompted to create a user:

```bash
# Enter new UNIX username (lowercase, no spaces)
username

# Enter password (won't display while typing)
# Confirm password
```

**Upgrade WSL1 to WSL2** (if needed):
```powershell
# Check current version
wsl --list --verbose

# If showing version 1, upgrade:
wsl --set-version Ubuntu-22.04 2

# Verify
wsl --list --verbose
# Should show: VERSION = 2
```

---

## Advanced Configuration (.wslconfig)

The `.wslconfig` file controls WSL2 VM settings globally (affects all distributions).

**Location**: `C:\Users\<YourUsername>\.wslconfig`

### Create .wslconfig File

```powershell
# Create .wslconfig file
New-Item -Path "$env:USERPROFILE\.wslconfig" -ItemType File -Force

# Open with notepad
notepad $env:USERPROFILE\.wslconfig
```

### Recommended Configuration

```ini
[wsl2]
# Memory allocation
# Default: 50% of total RAM or 8GB (whichever is smaller)
# Recommended: 40-60% of total RAM
memory=8GB

# Number of virtual processors
# Default: All available
# Recommended: Leave 1-2 cores for Windows
processors=6

# Swap size
# Default: 25% of memory size
# Set to 0 to disable (if you have sufficient RAM)
swap=4GB

# Swap file location
# Default: %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapFile=C:\\Users\\<YourUsername>\\AppData\\Local\\Temp\\swap.vhdx

# Enable localhost forwarding
# Allows accessing WSL2 services from Windows via localhost
localhostForwarding=true

# Kernel command line options
# kernelCommandLine=

# Enable nested virtualization (for running VMs inside WSL2)
nestedVirtualization=true

# Enable page reporting (free up memory to Windows)
pageReporting=true

# Network mode
# Default: NAT
# Options: NAT, bridged, mirrored (Windows 11 23H2+)
# networkingMode=mirrored

# Enable DNS tunneling (Windows 11 23H2+)
# dnsTunneling=true

# Enable auto proxy (Windows 11 23H2+)
# autoProxy=true

# Firewall mode (Windows 11 23H2+)
# firewallMode=HNS

# Default console window mode (for distros without GUI)
# guiApplications=true

# Enable systemd (Ubuntu 21.04+, Debian 11+)
# Set in wsl.conf, not here
```

### Configuration Examples

**For 16GB RAM System**:
```ini
[wsl2]
memory=10GB
processors=4
swap=2GB
localhostForwarding=true
nestedVirtualization=true
pageReporting=true
```

**For 32GB RAM System (AI/ML Development)**:
```ini
[wsl2]
memory=20GB
processors=8
swap=4GB
localhostForwarding=true
nestedVirtualization=true
pageReporting=true
```

**For 64GB RAM System (Maximum Performance)**:
```ini
[wsl2]
memory=32GB
processors=12
swap=0GB  # Disable swap with high RAM
localhostForwarding=true
nestedVirtualization=true
pageReporting=true
```

**Minimal Resource Usage (for Battery Life)**:
```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
localhostForwarding=true
pageReporting=true
```

### Apply Configuration Changes

```powershell
# Shutdown all WSL2 distributions
wsl --shutdown

# Wait 8 seconds for VM to fully terminate
Start-Sleep -Seconds 8

# Restart your distribution
wsl -d Ubuntu

# Verify settings from inside WSL
# Check memory:
free -h

# Check processors:
nproc
```

---

## Distribution-Specific Configuration (wsl.conf)

The `wsl.conf` file controls settings for individual distributions.

**Location** (inside WSL): `/etc/wsl.conf`

### Create wsl.conf

```bash
# From within WSL distribution
sudo nano /etc/wsl.conf
```

### Recommended Configuration

```ini
[boot]
# Run commands on distribution start
# command = service docker start
systemd=true  # Enable systemd (Ubuntu 21.04+, Debian 11+)

[automount]
# Enable automatic mounting of Windows drives
enabled=true

# Mount location for Windows drives
root=/mnt/

# DrvFs mount options
# metadata: Linux permissions on Windows files
# umask=022: Default permissions for mounted files
options="metadata,umask=22,fmask=11"

# Mount Windows drives at boot
mountFsTab=true

[network]
# Generate /etc/hosts file
generateHosts=true

# Generate /etc/resolv.conf
generateResolvConf=true

# Set hostname
hostname=wsl-dev

[interop]
# Enable Windows executable launching from WSL
enabled=true

# Append Windows PATH to WSL PATH
appendWindowsPath=true

[user]
# Default user (optional, if different from Windows username)
# default=username
```

### Configuration Examples

**Docker Development**:
```ini
[boot]
systemd=true
command="service docker start"

[automount]
enabled=true
options="metadata,umask=22,fmask=11"

[network]
generateHosts=true
generateResolvConf=true

[interop]
enabled=true
appendWindowsPath=false  # Cleaner PATH for Docker
```

**Web Development**:
```ini
[boot]
systemd=true

[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"

[network]
generateHosts=true
generateResolvConf=true
hostname=dev-machine

[interop]
enabled=true
appendWindowsPath=true  # Access Windows tools from WSL
```

**Apply wsl.conf Changes**:
```bash
# Exit WSL
exit

# From PowerShell, shutdown WSL
wsl --shutdown

# Restart distribution
wsl
```

---

## Performance Optimization

### Critical Performance Rule: File Location Matters

**🚀 20-100x Performance Improvement**

The #1 performance tip: **Store project files in the WSL2 filesystem**, not Windows filesystem.

**❌ Slow** (Windows filesystem mounted in WSL):
```bash
# Projects in Windows
cd /mnt/c/Users/YourName/Projects
npm install  # SLOW (can take 10-20 minutes)
```

**✅ Fast** (WSL2 native filesystem):
```bash
# Projects in WSL2
cd ~/projects
npm install  # FAST (takes 1-2 minutes)
```

**Why?**
- Windows filesystem is accessed via network protocol
- WSL2 filesystem is native ext4 with direct access
- Docker bind mounts from `/mnt/c/` are extremely slow

**Migration**:
```bash
# From Windows PowerShell, access WSL2 filesystem
explorer.exe \\wsl$\Ubuntu\home\username\projects

# Or from WSL, copy projects:
mkdir -p ~/projects
cp -r /mnt/c/Users/YourName/Projects/* ~/projects/
```

### Memory Management

**Monitor Memory Usage**:
```bash
# In WSL
free -h
htop  # Install: sudo apt install htop

# From PowerShell
# Check WSL2 process (vmmem)
Get-Process vmmem
```

**Limit Memory** (.wslconfig):
```ini
[wsl2]
memory=8GB  # Adjust based on your needs
```

**⚠️ Warning**: Don't allocate too much. If WSL2 uses all allocated memory and system runs out of physical RAM, it will page to disk (very slow).

**Best Practice**: Allocate 40-60% of total RAM.

### Reclaim Memory from WSL2

WSL2 doesn't automatically release memory back to Windows:

```bash
# From within WSL (requires sudo)
sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'

# Or from PowerShell
wsl -e sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'

# Complete memory reclaim (shuts down WSL2)
wsl --shutdown
```

**Automatic Memory Reclaim** (.wslconfig):
```ini
[wsl2]
pageReporting=true  # Enables automatic memory release
```

### CPU Usage Optimization

**Limit CPU Cores** (.wslconfig):
```ini
[wsl2]
processors=4  # Leave some cores for Windows
```

**Monitor CPU**:
```bash
# In WSL
top
htop

# Check CPU usage per process
ps aux --sort=-%cpu | head -10
```

### Disk I/O Optimization

**Use WSL2 Filesystem**:
- Projects: `~/projects/` ✅
- Docker volumes: WSL2 filesystem ✅
- Build artifacts: WSL2 filesystem ✅

**Access Windows files only when needed**:
```bash
# ✅ Good: Occasional access
cat /mnt/c/Users/YourName/Documents/config.txt

# ❌ Bad: Running projects from /mnt/c/
cd /mnt/c/Users/YourName/Projects/myapp
npm run dev  # SLOW!
```

**Optimize Virtual Disk**:
```powershell
# Find WSL2 virtual disk location
# Typically: C:\Users\<YourName>\AppData\Local\Packages\<DistroPackage>\LocalState\ext4.vhdx

# Compact virtual disk (when WSL is shut down)
wsl --shutdown
Optimize-VHD -Path "C:\Users\<YourName>\AppData\Local\Packages\<DistroPackage>\LocalState\ext4.vhdx" -Mode Full

# Or use diskpart:
diskpart
# select vdisk file="C:\Users\<YourName>\AppData\Local\Packages\<DistroPackage>\LocalState\ext4.vhdx"
# compact vdisk
# exit
```

---

## Docker Desktop Integration

### Setup

**Install Docker Desktop**:
1. Download from [docker.com](https://www.docker.com/products/docker-desktop/)
2. During installation, select "Use WSL2 instead of Hyper-V"
3. Install and restart

**Configure Docker Desktop**:
1. Open Docker Desktop Settings
2. **General** → Check "Use the WSL 2 based engine"
3. **Resources** → **WSL Integration**:
   - Enable integration with default distribution
   - Enable for additional distributions as needed
4. Click "Apply & Restart"

**Verify Docker**:
```bash
# From WSL
docker --version
docker compose version

# Test Docker
docker run hello-world

# Check Docker is using WSL2 backend
docker context ls
```

### Performance Best Practices

**1. Store Docker Data in WSL2**:
```bash
# ✅ Good: Projects in WSL2
cd ~/projects/myapp
docker-compose up

# ❌ Bad: Projects in Windows filesystem
cd /mnt/c/Users/YourName/Projects/myapp
docker-compose up  # VERY SLOW!
```

**2. Enable BuildKit**:
```bash
# In ~/.bashrc or ~/.zshrc
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Or in docker-compose.yml:
version: "3.8"
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
```

**3. Use Docker Volumes (Not Bind Mounts to Windows)**:
```yaml
# ✅ Good: Docker volume
version: "3.8"
services:
  db:
    image: postgres:15
    volumes:
      - pgdata:/var/lib/postgresql/data  # Docker volume

volumes:
  pgdata:

# ❌ Slow: Bind mount to Windows
# volumes:
#   - /mnt/c/Users/YourName/data:/var/lib/postgresql/data
```

**4. Configure Docker Resource Limits** (if needed):

Docker Desktop → Settings → Resources:
- Memory: 4-8GB (or adjust based on workload)
- CPUs: 4-6 (leave some for host)
- Disk image size: Increase if needed

---

## GPU Support (NVIDIA/AMD)

### NVIDIA GPU (CUDA)

**Prerequisites**:
- Windows 10 21H2+ or Windows 11
- NVIDIA GPU (GTX 10-series or newer)
- Latest NVIDIA drivers on Windows (do NOT install in WSL)

**Install NVIDIA Drivers** (Windows):
```powershell
# Download and install latest GeForce or Studio drivers
# From: https://www.nvidia.com/Download/index.aspx
```

**Verify GPU Access in WSL**:
```bash
# Check if GPU is detected
nvidia-smi

# Should show your GPU and driver version
```

**Install CUDA Toolkit** (in WSL):
```bash
# Ubuntu/Debian
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-3

# Verify CUDA
nvcc --version
```

**Install cuDNN** (for TensorFlow/PyTorch):
```bash
# Download cuDNN from NVIDIA Developer portal
# Requires NVIDIA account

# Or use pip packages that include cuDNN:
pip install tensorflow[and-cuda]
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

**Test GPU in Docker**:
```bash
# Install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Test GPU in container
docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi
```

### AMD GPU (ROCm)

**Prerequisites**:
- AMD GPU (RX 6000-series, Radeon VII, or newer)
- Windows AMD drivers installed

**Install ROCm** (in WSL):
```bash
# Follow AMD ROCm installation guide
# https://rocm.docs.amd.com/en/latest/deploy/linux/quick_start.html

# Ubuntu 22.04 example:
wget https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_latest_all.deb
sudo dpkg -i amdgpu-install_latest_all.deb
sudo amdgpu-install --usecase=rocm
```

---

## Networking Configuration

### Access WSL2 from Windows

**Localhost Forwarding** (Enabled by default):
```bash
# Start a web server in WSL
python3 -m http.server 8000

# Access from Windows browser:
# http://localhost:8000
```

**If localhost doesn't work**:

1. Check `.wslconfig`:
   ```ini
   [wsl2]
   localhostForwarding=true
   ```

2. Get WSL2 IP address:
   ```bash
   # From WSL
   ip addr show eth0 | grep inet

   # From Windows PowerShell
   wsl hostname -I
   ```

3. Access via WSL2 IP: `http://<wsl2-ip>:8000`

### Access Windows from WSL2

**Windows host is accessible** at special IP (Windows 11 22H2+):
```bash
# Ping Windows host
ping $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Or use direct IP (172.x.x.1 typically)
ping 172.24.48.1  # Example IP
```

**Access Windows services from WSL**:
```bash
# If SQL Server runs on Windows localhost:1433
# Connect from WSL using Windows IP
mysql -h $(grep nameserver /etc/resolv.conf | awk '{print $2}') -P 1433
```

### Custom DNS Configuration

**Option 1: Disable generateResolvConf** (in `/etc/wsl.conf`):
```ini
[network]
generateResolvConf=false
```

Then manually create `/etc/resolv.conf`:
```bash
sudo rm /etc/resolv.conf  # Remove existing file
sudo nano /etc/resolv.conf

# Add custom DNS servers
nameserver 1.1.1.1
nameserver 8.8.8.8
```

**Option 2: Use Windows DNS** (default, recommended).

### VPN Considerations

WSL2 uses NAT networking, which can cause issues with VPNs.

**Solutions**:

1. **Use Windows 11 23H2+ with mirrored networking**:
   ```ini
   # In .wslconfig
   [wsl2]
   networkingMode=mirrored
   dnsTunneling=true
   autoProxy=true
   ```

2. **Configure VPN to allow WSL2 traffic**:
   - Consult VPN documentation
   - May need split-tunnel configuration

---

## File System Best Practices

### Where to Store Files

| Location | Speed | Use Case |
|----------|-------|----------|
| `~/projects/` (WSL) | ⭐⭐⭐⭐⭐ | **ALL development projects** |
| `/mnt/c/Users/...` (Windows) | ⭐⭐ | Windows documents, occasional access |
| `\\wsl$\Ubuntu\...` (from Windows) | ⭐⭐⭐⭐ | Accessing WSL files from Windows |

### Accessing Files Cross-Platform

**From Windows → WSL2**:
```powershell
# Open File Explorer to WSL2 home
explorer.exe \\wsl$\Ubuntu\home\username

# Or add to Quick Access
```

**From WSL2 → Windows**:
```bash
# Access Windows files
cd /mnt/c/Users/YourName/Documents

# Open Windows Explorer from WSL
explorer.exe .

# Open VS Code on Windows
code .
```

### Permissions on Windows Files

**Enable metadata** (in `/etc/wsl.conf`):
```ini
[automount]
options="metadata,umask=22,fmask=11"
```

This allows setting Linux permissions on Windows files:
```bash
chmod +x /mnt/c/Users/YourName/script.sh
```

### Backup WSL2 Distribution

**Export Distribution**:
```powershell
# Export to tar file
wsl --export Ubuntu C:\Backups\ubuntu-backup.tar

# Optionally compress
Compress-Archive -Path C:\Backups\ubuntu-backup.tar -DestinationPath C:\Backups\ubuntu-backup.zip
```

**Import Distribution**:
```powershell
# Import from backup
wsl --import UbuntuRestored C:\WSL\UbuntuRestored C:\Backups\ubuntu-backup.tar

# Set as default
wsl --setdefault UbuntuRestored
```

**Clone Distribution**:
```powershell
# Duplicate distribution
wsl --export Ubuntu C:\Temp\ubuntu.tar
wsl --import UbuntuClone C:\WSL\UbuntuClone C:\Temp\ubuntu.tar
```

---

## Development Workflow Optimization

### Shell Configuration

**Install Zsh (optional but recommended)**:
```bash
sudo apt install zsh -y

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugins to enable (in ~/.zshrc):
plugins=(git docker docker-compose npm node python pip rust cargo)
```

**Optimize Bash**:
```bash
# In ~/.bashrc, add:

# History settings
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Enable colors
export CLICOLOR=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
```

### Development Tools Setup

**Common Tools**:
```bash
# Update package lists
sudo apt update

# Build essentials
sudo apt install -y build-essential git curl wget

# Node.js (via nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

# Python
sudo apt install -y python3 python3-pip python3-venv

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Docker (if not using Docker Desktop)
# Follow official Docker installation guide

# Go
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
```

---

## VS Code Integration

**Install VS Code Remote - WSL Extension**:
```powershell
# From Windows
code --install-extension ms-vscode-remote.remote-wsl
```

**Open Project in VS Code from WSL**:
```bash
# Navigate to project
cd ~/projects/myapp

# Open in VS Code (Windows)
code .

# VS Code will automatically connect via Remote - WSL extension
```

**Benefits**:
- IntelliSense for WSL tools
- Integrated terminal runs in WSL
- Extensions run in WSL context
- Full access to WSL filesystem

---

## Troubleshooting

### WSL2 Won't Start

```powershell
# Check WSL status
wsl --status

# Shutdown and restart
wsl --shutdown
wsl

# Update WSL
wsl --update

# Check Windows version
winver  # Must be 2004+

# Verify virtualization is enabled
Get-ComputerInfo | Select-Object HyperV*
```

### High Memory Usage (vmmem)

**Limit memory** in `.wslconfig`:
```ini
[wsl2]
memory=8GB
```

**Reclaim memory**:
```powershell
wsl --shutdown
```

### Slow Performance

**Check file location**:
```bash
pwd
# Should be under ~/ not /mnt/c/
```

**Move projects to WSL2 filesystem**:
```bash
mkdir -p ~/projects
cp -r /mnt/c/Users/YourName/Projects/myapp ~/projects/
```

### Network Issues

**Reset network**:
```powershell
# Restart WSL
wsl --shutdown
wsl

# From WSL, restart networking
sudo service networking restart
```

**Fix DNS**:
```bash
# Temporarily
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Permanently (in /etc/wsl.conf)
[network]
generateResolvConf=false

# Then create /etc/resolv.conf manually
```

### Docker Issues

**Restart Docker**:
```bash
# From WSL
sudo service docker restart

# Or restart Docker Desktop from Windows
```

**Check Docker is using WSL2 backend**:
- Docker Desktop → Settings → General → "Use WSL 2 based engine" ✓

### Can't Access WSL Files from Windows

**Verify path**:
```powershell
# Should work:
explorer.exe \\wsl$\Ubuntu\home\username

# Check distribution name
wsl --list
```

---

## Next Steps

After configuring WSL2:

1. **Install development tools**: Follow [DEV-ENV-LINUX.md](DEV-ENV-LINUX.md)
2. **Optimize Windows**: See [WINDOWS-OPTIMIZATION.md](WINDOWS-OPTIMIZATION.md)
3. **Set up Docker**: Configure Docker Desktop for WSL2
4. **Configure VS Code**: Install Remote - WSL extension

---

## Additional Resources

- [Microsoft WSL Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Docker Desktop WSL2 Backend](https://docs.docker.com/desktop/features/wsl/)
- [VS Code Remote - WSL](https://code.visualstudio.com/docs/remote/wsl)
- [NVIDIA CUDA on WSL2](https://docs.nvidia.com/cuda/wsl-user-guide/index.html)
- [WSL GitHub Repository](https://github.com/microsoft/WSL)

---

**Last Updated**: November 2024
**Applies To**: Windows 10 2004+, Windows 11, WSL2
