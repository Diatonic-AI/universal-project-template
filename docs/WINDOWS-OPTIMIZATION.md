# Windows Optimization for Development and AI Workloads

**Complete guide to optimizing Windows 10/11 for software development, AI/ML workloads, and WSL2**

## Table of Contents

- [Overview](#overview)
- [Windows Features for Development](#windows-features-for-development)
  - [Essential Features](#essential-features)
  - [Enable Features via GUI](#enable-features-via-gui)
  - [Enable Features via PowerShell](#enable-features-via-powershell)
  - [Enable Features via DISM](#enable-features-via-dism)
- [Windows 11 AI Features (2024 Update)](#windows-11-ai-features-2024-update)
- [System Performance Optimization](#system-performance-optimization)
- [Development-Specific Settings](#development-specific-settings)
- [Power Management](#power-management)
- [Security Settings for Development](#security-settings-for-development)
- [Windows Defender Exclusions](#windows-defender-exclusions)
- [Network Optimization](#network-optimization)
- [Storage Optimization](#storage-optimization)
- [GPU Configuration](#gpu-configuration)
- [Troubleshooting](#troubleshooting)

---

## Overview

This guide covers Windows optimizations specifically for:
- Software development (Node.js, Python, Rust, etc.)
- WSL2 and Docker Desktop workflows
- AI/ML development with GPU acceleration
- Container-based development
- High-performance development environments

### Target Audience
- Developers using Windows as primary development platform
- Users running WSL2 for Linux development on Windows
- AI/ML engineers training models locally
- DevOps engineers managing containerized workflows

---

## Windows Features for Development

### Essential Features

For modern development on Windows, you'll need these features:

| Feature | Purpose | Required For |
|---------|---------|--------------|
| WSL (Windows Subsystem for Linux) | Run Linux distributions natively | WSL2, Linux development |
| Virtual Machine Platform | Lightweight VM support | WSL2, Docker Desktop |
| Hyper-V | Full virtualization platform | VirtualBox alternative, advanced scenarios |
| Windows Hypervisor Platform | Virtualization API | Docker Desktop (Hyper-V backend) |
| Containers | Windows container support | Windows containers (optional) |

### Enable Features via GUI

1. Press **Win+R**, type `optionalfeatures`, press Enter
2. Check the following:
   - ☑ Virtual Machine Platform
   - ☑ Windows Subsystem for Linux
   - ☑ Windows Hypervisor Platform (if needed)
   - ☑ Hyper-V (if using Hyper-V instead of WSL2 backend)
3. Click **OK**
4. Restart when prompted

### Enable Features via PowerShell

**Run PowerShell as Administrator**

```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform (required for WSL2)
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Enable Windows Hypervisor Platform
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart

# Enable Hyper-V (if needed - requires Pro/Enterprise/Education)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All

# Restart computer
Restart-Computer
```

#### Verify Installation

```powershell
# Check enabled features
Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "*Hyper*" -or $_.FeatureName -like "*Virtual*" -or $_.FeatureName -like "*Linux*"} | Select-Object FeatureName, State

# Check specific features
Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

### Enable Features via DISM

DISM (Deployment Image Servicing and Management) provides command-line feature management.

**Run Command Prompt or PowerShell as Administrator**

```cmd
# List all available features
dism /online /get-features

# List enabled features only
dism /online /get-features /format:table | findstr "Enabled"

# Enable Virtual Machine Platform
dism /online /Enable-Feature /FeatureName:VirtualMachinePlatform /All

# Enable WSL
dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All

# Check feature status
dism /online /get-featureinfo /featurename:VirtualMachinePlatform
```

---

## Windows 11 AI Features (2024 Update)

Windows 11 24H2 (2024 Update) introduces significant AI-focused enhancements for developers.

### Windows Copilot Runtime

The **Windows Copilot Runtime** is a layer in the OS that integrates 40+ AI models capable of running locally:

- **Phi Silica**: Small Language Model (SLM) from Microsoft
- **Screen Region Detector**: Analyzes screen regions
- **Optical Character Recognizer**: On-device OCR
- **Natural Language Parser**: NLP capabilities
- **Image Encoder**: Image processing

**Benefits for Developers**:
- Local AI inference (no cloud dependency)
- Lower latency
- Better privacy (data stays on device)
- Reduced costs (no API calls)

### Auto Super Resolution (Auto SR)

Uses NPU (Neural Processing Unit) to upscale applications and games automatically.

**For Developers**:
- Improves performance of graphics-intensive applications
- Offloads work from GPU to NPU
- Similar to NVIDIA DLSS, AMD FSR, Intel XeSS but automatic

**Enabling Auto SR**:
1. Settings → System → Display → Graphics
2. Select application
3. Enable "Auto Super Resolution"

### NPU (Neural Processing Unit) Support

Modern CPUs (Intel Core Ultra, AMD Ryzen AI, Qualcomm Snapdragon X) include NPUs.

**Optimize for NPU**:
- Use DirectML for hardware acceleration
- Leverage ONNX Runtime for cross-platform AI
- Use Windows AI Studio for local AI development

### Development Tools for AI

**Windows AI Studio**:
- Jumpstart local AI development and deployment
- Model optimization for Windows devices
- Supports varied Windows hardware (CPU, GPU, NPU, hybrid)

**ONNX Runtime**:
- Gateway to Windows AI
- Run AI models across CPU, GPU, NPU, or hybrid configurations
- Compatible with TensorFlow and PyTorch models

**Olive Toolchain**:
- Eases model optimization for varied Windows devices
- Converts models to ONNX format
- Optimizes for specific hardware

**DirectML**:
- Hardware acceleration API for GPUs and accelerators
- Efficiently utilizes GPU resources
- Compatible with NVIDIA, AMD, and Intel GPUs

**Installation**:
```powershell
# Install ONNX Runtime
pip install onnxruntime-directml

# Install Windows AI tools
winget install Microsoft.WindowsAIStudio

# Install DirectML (if needed)
pip install tensorflow-directml-plugin
```

---

## System Performance Optimization

### Disable Unnecessary Startup Programs

```powershell
# List startup programs
Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-Table

# Disable via Task Manager:
# Ctrl+Shift+Esc → Startup tab → Right-click unwanted programs → Disable
```

### Disable Visual Effects for Performance

**Via GUI**:
1. Win+R → `sysdm.cpl` → Advanced tab
2. Performance → Settings
3. Select "Adjust for best performance" or customize:
   - Keep "Smooth edges of screen fonts"
   - Keep "Show thumbnails instead of icons"
   - Disable animations and transparency

**Via PowerShell**:
```powershell
# Disable animations
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2

# Disable transparency
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
```

### Optimize Virtual Memory (Page File)

For development workloads with large memory requirements:

**Recommended Settings**:
- **If you have 16GB+ RAM**: Set to system-managed OR 1.5x RAM size
- **If you have 32GB+ RAM**: Can set to smaller size or system-managed

**Configure**:
1. Win+R → `sysdm.cpl` → Advanced
2. Performance → Settings → Advanced → Virtual memory → Change
3. Uncheck "Automatically manage paging file size for all drives"
4. Select drive, choose "Custom size"
   - Initial size: 1.5 × RAM (MB)
   - Maximum size: 3 × RAM (MB)
5. Click Set → OK → Restart

**Via PowerShell** (requires admin):
```powershell
# Disable automatic management
$cs = Get-WmiObject -Class Win32_ComputerSystem
$cs.AutomaticManagedPagefile = $false
$cs.Put()

# Set custom page file (example for 16GB RAM = 16384MB)
$pagefile = Get-WmiObject -Class Win32_PageFileSetting
$pagefile.InitialSize = 24576  # 1.5 × 16GB
$pagefile.MaximumSize = 49152  # 3 × 16GB
$pagefile.Put()
```

### Disable Windows Search Indexing for Code Directories

Windows Search indexing can slow down file operations in project directories.

**Selective Exclusion**:
1. Settings → Privacy & Security → Searching Windows
2. Click "Exclude folders"
3. Add project directories (e.g., `C:\Dev`, `C:\Projects`, WSL directories)

**PowerShell Method**:
```powershell
# Disable indexing for specific folder
$path = "C:\Dev"
$folder = Get-Item $path
$folder.Attributes = $folder.Attributes -bor [System.IO.FileAttributes]::NotContentIndexed
```

### Disable Windows Update During Development

**Pause Updates Temporarily**:
```powershell
# Pause updates for 5 weeks (max)
Pause-WUUpdate -Days 35

# Or via Settings:
# Settings → Windows Update → Pause updates → Select duration
```

**Active Hours (Recommended)**:
```powershell
# Set active hours (8 AM - 11 PM)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "ActiveHoursStart" -Value 8
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "ActiveHoursEnd" -Value 23
```

---

## Development-Specific Settings

### Enable Developer Mode

**Via Settings**:
1. Settings → Privacy & Security → For developers
2. Turn on **Developer Mode**

**Via PowerShell**:
```powershell
# Enable Developer Mode
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
```

**Benefits**:
- Install apps from any source
- Enable device discovery
- SSH access to device
- Device Portal access

### Enable Long Path Support

Windows has a 260-character path limit by default. Enable long paths for modern development:

```powershell
# Enable long path support (requires admin)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# Enable for Git
git config --system core.longpaths true

# Enable for specific applications
reg add "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
```

### Set Environment Variables

**System-Wide** (requires admin):
```powershell
# Set permanent environment variable
[System.Environment]::SetEnvironmentVariable("VARIABLE_NAME", "value", [System.EnvironmentVariableTarget]::Machine)

# Common development variables
[System.Environment]::SetEnvironmentVariable("NODE_OPTIONS", "--max-old-space-size=4096", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PYTHONIOENCODING", "utf-8", [System.EnvironmentVariableTarget]::Machine)
```

**User-Specific**:
```powershell
[System.Environment]::SetEnvironmentVariable("VARIABLE_NAME", "value", [System.EnvironmentVariableTarget]::User)
```

### Configure Windows Terminal

**Install**:
```powershell
winget install Microsoft.WindowsTerminal
```

**Optimize Settings** (`settings.json`):
```json
{
  "defaultProfile": "{guid-of-PowerShell-or-WSL}",
  "copyOnSelect": true,
  "copyFormatting": false,
  "profiles": {
    "defaults": {
      "fontFace": "Cascadia Code",
      "fontSize": 10,
      "cursorShape": "bar",
      "historySize": 9001
    }
  },
  "schemes": [
    // Use your preferred color scheme
  ],
  "actions": [
    { "command": "paste", "keys": "ctrl+v" },
    { "command": "copy", "keys": "ctrl+c" },
    { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" }
  ]
}
```

---

## Power Management

For desktop development workloads, optimize power settings for performance.

### Set High Performance Power Plan

**Via GUI**:
1. Control Panel → Power Options
2. Select "High performance" (or create custom plan)

**Via PowerShell**:
```powershell
# List available power plans
powercfg /list

# Set to High Performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Create custom plan
powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable sleep
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 30

# Disable hibernate (frees up disk space)
powercfg /hibernate off
```

### USB Selective Suspend

Disable for development peripherals:

```powershell
# Disable USB selective suspend
powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setactive scheme_current
```

---

## Security Settings for Development

### Windows Defender Exclusions

Exclude development directories to improve build performance:

**Via PowerShell (Admin)**:
```powershell
# Add folder exclusions
Add-MpPreference -ExclusionPath "C:\Dev"
Add-MpPreference -ExclusionPath "C:\Projects"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.npm"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.cargo"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.rustup"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Local\node_modules"

# Exclude WSL2 directories
Add-MpPreference -ExclusionPath "\\wsl$\"

# Exclude Docker
Add-MpPreference -ExclusionPath "C:\ProgramData\Docker"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.docker"

# Add process exclusions (if needed)
Add-MpPreference -ExclusionProcess "node.exe"
Add-MpPreference -ExclusionProcess "python.exe"
Add-MpPreference -ExclusionProcess "code.exe"

# List current exclusions
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
Get-MpPreference | Select-Object -ExpandProperty ExclusionProcess
```

**⚠️ Security Warning**: Only exclude trusted directories. Never exclude system directories.

### Controlled Folder Access

If using Controlled Folder Access, add development tools:

```powershell
# Add allowed applications
Add-MpPreference -ControlledFolderAccessAllowedApplications "C:\Program Files\Microsoft VS Code\Code.exe"
Add-MpPreference -ControlledFolderAccessAllowedApplications "C:\Program Files\nodejs\node.exe"
Add-MpPreference -ControlledFolderAccessAllowedApplications "C:\Program Files\Python311\python.exe"

# Verify
Get-MpPreference | Select-Object -ExpandProperty ControlledFolderAccessAllowedApplications
```

---

## Network Optimization

### TCP/IP Optimization

For high-throughput development (Docker, file transfers, etc.):

```powershell
# Reset TCP/IP stack
netsh int ip reset
netsh winsock reset

# Optimize TCP for throughput
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled

# Disable bandwidth throttling
netsh int tcp set global congestionprovider=ctcp

# Restart after changes
Restart-Computer
```

### DNS Configuration

Use fast DNS servers for package downloads:

**Via PowerShell**:
```powershell
# Set DNS to Cloudflare (1.1.1.1) and Google (8.8.8.8)
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("1.1.1.1","8.8.8.8")

# Or for Wi-Fi
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses ("1.1.1.1","8.8.8.8")

# Verify
Get-DnsClientServerAddress -InterfaceAlias "Ethernet"
```

### Firewall Rules for Development

```powershell
# Allow Node.js development server
New-NetFirewallRule -DisplayName "Node.js Dev Server" -Direction Inbound -Program "C:\Program Files\nodejs\node.exe" -Action Allow

# Allow Python development
New-NetFirewallRule -DisplayName "Python Dev" -Direction Inbound -Program "C:\Program Files\Python311\python.exe" -Action Allow

# Allow Docker Desktop
New-NetFirewallRule -DisplayName "Docker Desktop" -Direction Inbound -Program "C:\Program Files\Docker\Docker\Docker Desktop.exe" -Action Allow

# Allow WSL2 (if needed)
New-NetFirewallRule -DisplayName "WSL2" -Direction Inbound -Program "C:\Windows\System32\wsl.exe" -Action Allow
```

---

## Storage Optimization

### Enable TRIM for SSDs

Ensure TRIM is enabled for optimal SSD performance:

```powershell
# Check TRIM status
fsutil behavior query DisableDeleteNotify

# Should return:
# NTFS DisableDeleteNotify = 0 (Enabled)
# ReFS DisableDeleteNotify = 0 (Enabled)

# If disabled, enable it:
fsutil behavior set DisableDeleteNotify 0
```

### Disable Disk Defragmentation for SSDs

SSDs don't need defragmentation (but optimization is OK):

```powershell
# Disable scheduled defragmentation (SSD only)
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Defrag\ScheduledDefrag"

# Re-enable if needed
Enable-ScheduledTask -TaskName "\Microsoft\Windows\Defrag\ScheduledDefrag"
```

### Clean Up Disk Space

```powershell
# Clean temp files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clean Windows Update cache
Stop-Service wuauserv
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
Start-Service wuauserv

# Run Disk Cleanup utility
cleanmgr /sagerun:1

# Clean Docker (if installed)
docker system prune -a --volumes

# Clean npm cache
npm cache clean --force

# Clean pip cache
pip cache purge
```

---

## GPU Configuration

### NVIDIA GPU Optimization for AI/ML

**Install Latest Drivers**:
```powershell
# Check current driver
nvidia-smi

# Update via NVIDIA website or GeForce Experience
```

**CUDA Toolkit Installation**:
```powershell
# Download from NVIDIA website and install, then verify:
nvcc --version

# Install cuDNN (for TensorFlow/PyTorch)
# Download from NVIDIA Developer portal
```

**Configure for WSL2**:
```bash
# In WSL2, install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verify GPU access in Docker
docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
```

### AMD GPU Optimization

**ROCm for AI/ML**:
```powershell
# Install AMD Software: Adrenalin Edition
# Download from AMD website

# For WSL2, follow AMD ROCm documentation
# https://rocm.docs.amd.com/en/latest/deploy/linux/quick_start.html
```

### Intel GPU (for NPU/AI workloads)

**Install Intel oneAPI**:
```powershell
# Download Intel oneAPI Base Toolkit
# https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html

# Verify installation
dpcpp --version
```

---

## Troubleshooting

### High CPU Usage by Windows Processes

**Windows Search (SearchIndexer.exe)**:
```powershell
# Stop and disable Windows Search
Stop-Service WSearch -Force
Set-Service WSearch -StartupType Disabled
```

**Windows Defender**:
- Add exclusions (see Security Settings section above)
- Schedule scans during off-hours

**Windows Update**:
- Pause updates during development
- Use active hours settings

### WSL2 Performance Issues

See [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md) for detailed optimization.

**Quick fixes**:
```powershell
# Restart WSL2
wsl --shutdown

# Limit WSL2 memory (.wslconfig)
# Create C:\Users\<YourUsername>\.wslconfig:
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
```

### Docker Desktop Performance

**Best practices**:
- Store project files in WSL2 filesystem (not `/mnt/c/`)
- Use WSL2 backend instead of Hyper-V
- Limit Docker Desktop resources in settings
- Enable BuildKit: `export DOCKER_BUILDKIT=1`

### Slow File Operations

**If using WSL2**:
- Move projects to WSL2 filesystem (`\\wsl$\Ubuntu\home\username\projects`)
- Avoid working from `/mnt/c/` (Windows filesystem)
- See [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)

**General**:
- Disable real-time protection for project directories
- Enable Developer Mode
- Check disk health: `wmic diskdrive get status`

### Memory Issues

**Check memory usage**:
```powershell
# Current memory usage
Get-Counter '\Memory\Available MBytes'

# Memory by process
Get-Process | Sort-Object WS -Descending | Select-Object -First 10 Name, WS

# WSL2 memory usage
wsl --shutdown
# Check after restart
```

**Solutions**:
- Increase virtual memory
- Limit WSL2 memory (.wslconfig)
- Close unnecessary applications
- Add more physical RAM if possible

---

## Next Steps

After optimizing Windows:

1. **Install WSL2**: Follow [DEV-ENV-WINDOWS.md](DEV-ENV-WINDOWS.md)
2. **Configure WSL2**: See [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)
3. **Set up development tools**: Run setup scripts from this repository
4. **Configure BIOS**: Check [BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md) if needed

---

## Additional Resources

- [Microsoft Windows for Developers](https://learn.microsoft.com/en-us/windows/dev-environment/)
- [Windows 11 AI Features](https://blogs.windows.com/windowsdeveloper/)
- [WSL2 Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Docker Desktop Best Practices](https://docs.docker.com/desktop/features/wsl/best-practices/)
- [Visual Studio Code on Windows](https://code.visualstudio.com/docs/setup/windows)

---

**Last Updated**: November 2024
**Applies To**: Windows 10 21H2+, Windows 11 21H2+, Windows 11 24H2 (2024 Update)
