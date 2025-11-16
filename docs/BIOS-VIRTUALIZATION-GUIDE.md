# BIOS Virtualization Configuration Guide

**Complete guide to enabling hardware virtualization across all major motherboard manufacturers**

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Intel Virtualization (VT-x/VT-d)](#intel-virtualization-vt-xvt-d)
- [AMD Virtualization (AMD-V/SVM)](#amd-virtualization-amd-vsvm)
- [Brand-Specific Instructions](#brand-specific-instructions)
  - [ASUS Motherboards](#asus-motherboards)
  - [MSI Motherboards](#msi-motherboards)
  - [GIGABYTE Motherboards](#gigabyte-motherboards)
  - [ASRock Motherboards](#asrock-motherboards)
  - [Intel Motherboards](#intel-motherboards)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Common Use Cases](#common-use-cases)

---

## Overview

Hardware virtualization is a CPU feature that enables running multiple operating systems simultaneously through virtual machines (VMs). This technology is essential for:

- **WSL2** (Windows Subsystem for Linux 2)
- **Docker Desktop** (when using WSL2 or Hyper-V backend)
- **Virtual Machines** (VMware, VirtualBox, Hyper-V)
- **Emulators** (Android Studio, BlueStacks)
- **AI/ML Development** (containerized workloads, Kubernetes)

### Virtualization Technologies

#### Intel Platforms

- **VT-x (Virtualization Technology)**: CPU-level virtualization
  - Enables running virtual machines
  - Required for WSL2, Docker, Hyper-V
  - Usually found in BIOS under "Intel Virtualization Technology" or "VMX"

- **VT-d (Virtualization Technology for Directed I/O)**: I/O virtualization (IOMMU)
  - Enables PCI passthrough (GPU, network cards to VMs)
  - Improves VM performance
  - Optional but recommended for advanced virtualization

- **VT-c (Virtualization Technology for Connectivity)**: Network I/O virtualization
  - Improves network performance in VMs
  - Less common, not required for most use cases

#### AMD Platforms

- **AMD-V (AMD Virtualization)**: CPU-level virtualization
  - Equivalent to Intel VT-x
  - Also called **SVM (Secure Virtual Machine)**
  - Usually found in BIOS under "SVM Mode" or "AMD-V"

- **AMD-Vi (AMD I/O Virtualization Technology)**: I/O virtualization (IOMMU)
  - Equivalent to Intel VT-d
  - Enables PCI passthrough
  - Optional but recommended

---

## Prerequisites

### Before You Start

1. **Know your CPU**:
   - Intel or AMD?
   - Generation (older CPUs may not support virtualization)
   - Use CPU-Z or check manufacturer website to verify support

2. **Backup Important Data**:
   - BIOS changes rarely cause issues, but better safe than sorry

3. **Have Access**:
   - Physical access to the computer
   - Administrator/BIOS password (if set)

4. **Know Your BIOS Key**:
   - Most common keys: **Del**, **F2**, **F10**, **Esc**
   - Look for boot message like "Press DEL to enter SETUP"
   - Consult your motherboard manual

---

## Intel Virtualization (VT-x/VT-d)

### What You Need to Enable

**Minimum (required for WSL2/Docker)**:
- Intel Virtualization Technology (VT-x)

**Recommended (for better performance)**:
- Intel VT-x ✓
- Intel VT-d ✓

### Common BIOS Menu Locations

VT-x is typically found under:
- `Advanced → CPU Configuration → Intel Virtualization Technology`
- `Advanced → System Agent Configuration`
- `Chipset → Northbridge → Intel VT-x`
- `Processor → Virtualization Technology`

VT-d is typically found under:
- `Advanced → System Agent (SA) Configuration → VT-d`
- `Advanced → Chipset → Northbridge → Intel VT-d`
- `Advanced → Processor → VT for Directed I/O`

---

## AMD Virtualization (AMD-V/SVM)

### What You Need to Enable

**Minimum (required for WSL2/Docker)**:
- SVM Mode (Secure Virtual Machine)

**Recommended (for better performance)**:
- SVM Mode ✓
- IOMMU ✓

### Common BIOS Menu Locations

SVM Mode is typically found under:
- `Advanced → CPU Configuration → SVM Mode`
- `Advanced → CPU Features → AMD Virtualization`
- `Overclocking → CPU Features → SVM Mode`
- `MIT → Advanced Frequency Settings → Advanced CPU Settings → SVM Mode`

IOMMU is typically found under:
- `Advanced → AMD CBS → IOMMU`
- `Advanced → Northbridge → IOMMU`

---

## Brand-Specific Instructions

### ASUS Motherboards

#### Entering BIOS
- Restart computer and press **DEL** or **F2** during boot
- Press **F7** to enter Advanced Mode (ROG series may enter Advanced Mode directly)

#### Intel CPUs

**Enable VT-x:**
1. Navigate to `Advanced` page
2. Click `CPU Configuration`
3. Find `Intel(VMX) Virtualization Technology`
4. Set to **Enabled**
5. Press **F10** and click **OK** to save and reboot

**Enable VT-d:**
1. After enabling VT-x, go to `Advanced` tab
2. Click `System Agent (SA) Configuration`
3. Find `Intel® VT for Directed I/O (VT-d)`
4. Set to **Enabled**
5. Press **F10** and click **OK**

#### AMD CPUs

1. Navigate to `Advanced` page
2. Click `CPU Configuration`
3. Find `SVM Mode` (or `AMD Virtualization` or `AMD-V`)
4. Set to **Enabled**
5. Press **F10** and click **OK**

#### Verification
After reboot, open Task Manager → Performance → CPU and confirm "Virtualization" shows as **Enabled**

---

### MSI Motherboards

#### Entering BIOS
- Press **DEL** or **F2** immediately after pressing power button
- If in "EZ Mode", press **F7** to switch to "Advanced Mode"

#### Intel CPUs

1. In Advanced Mode, navigate to `OC settings` (or `Overclocking`)
2. Scroll down to `CPU Features` and press Enter
3. Find `Intel Virtualization Technology`
4. Set to **Enabled**

**Optional - Enable VT-d:**
- In same `CPU Features` section
- Find `Intel VT-d`
- Set to **Enabled**

5. Press **F10** to save changes and exit

#### AMD CPUs

1. In Advanced Mode, navigate to `Overclocking`
2. Click `CPU Features`
3. Find `SVM Mode`
4. Set to **Enabled**
5. Press **F10** to save

#### Alternate Locations
Some MSI boards (especially 2019+):
- `Advanced` tab → `Advanced CPU Configuration` → Virtualization settings

---

### GIGABYTE Motherboards

#### Entering BIOS
- Press **DEL** or **F2** repeatedly during boot
- Modern GIGABYTE boards use orange/yellow UI (2020+)
- Older boards use black-and-red UI

#### Intel CPUs

1. Select `BIOS Features` from main menu
2. Find `Intel Virtualization Technology`
3. Change from **Disabled** to **Enabled**

**Optional - Enable VT-d:**
- In same `BIOS Features` section
- Find `VT-d`
- Change from **Disabled** to **Enabled**

4. Press **F10** to save and exit

#### AMD CPUs

**Path 1** (Common):
1. Go to `Advanced Frequency Settings`
2. Navigate to `Advanced CPU Settings`
3. Find `SVM Mode`
4. Set to **Enabled**

**Path 2** (Alternate):
1. Go to `MIT` (M.I.T.)
2. Navigate to `Advanced Frequency Settings`
3. Click `Advanced CPU Settings`
4. Find `SVM Mode`
5. Set to **Enabled**

6. Press **F10** to save

---

### ASRock Motherboards

#### Entering BIOS
- Press **DEL** or **F2** during boot
- May require pressing key multiple times

#### Intel CPUs

1. Navigate to `Advanced` tab
2. Click `CPU Configuration`
3. Find `Intel VT-x`
4. Set to **Enabled**

**Optional - Enable VT-d:**
- In same configuration area
- Find `Intel VT-d`
- Set to **Enabled**

5. Press **F10** to save

#### AMD CPUs

1. Navigate to `Advanced` tab
2. Click `CPU Configuration`
3. Find `SVM Mode`
4. Set to **Enabled**
5. Press **F10** to save

---

### Intel Motherboards

#### Entering BIOS
- Press **F2** during boot (most common)
- Some models use **DEL** or **F10**

#### Enabling Virtualization

1. Navigate to `Advanced` menu
2. Click `Processor Configuration`
3. Find `Intel® Virtualization Technology`
4. Set to **Enabled**

**Optional - Enable VT-d:**
- Look for `Intel® VT for Directed I/O`
- Set to **Enabled**

5. Press **F10** to save and exit

---

## Verification

### Windows

#### Method 1: Task Manager
1. Press **Ctrl+Shift+Esc** to open Task Manager
2. Go to `Performance` tab
3. Click `CPU`
4. Check **Virtualization**: Should show **Enabled**

#### Method 2: System Information
1. Press **Win+R**, type `msinfo32`, press Enter
2. Look for these entries:
   - `Hyper-V - VM Monitor Mode Extensions`: **Yes**
   - `Hyper-V - Second Level Address Translation Extensions`: **Yes**
   - `Hyper-V - Virtualization Enabled in Firmware`: **Yes**

#### Method 3: PowerShell (Detailed)
```powershell
# Check virtualization status
Get-ComputerInfo | Select-Object HyperV*

# Check CPU features
Get-WmiObject Win32_Processor | Select-Object Name, VirtualizationFirmwareEnabled, VMMonitorModeExtensions, SecondLevelAddressTranslationExtensions
```

### Linux

```bash
# Check if virtualization is enabled
# Intel CPUs:
lscpu | grep Virtualization
# Should show: Virtualization: VT-x

# AMD CPUs:
lscpu | grep Virtualization
# Should show: Virtualization: AMD-V

# Check for vmx (Intel) or svm (AMD) flag
grep -E '(vmx|svm)' /proc/cpuinfo

# Check if KVM modules are available (indicates virtualization support)
lsmod | grep kvm
```

### WSL2

```bash
# From Windows PowerShell
wsl --status

# Should show:
# Default Version: 2
# Virtualization: Enabled
```

---

## Troubleshooting

### Virtualization Option is Grayed Out

**Cause**: Trusted Execution Technology or similar security feature is enabled

**Solution**:
1. Find `Intel Trusted Execution Technology` in BIOS
2. Set to **Disabled**
3. Save and reboot
4. Re-enter BIOS and enable virtualization
5. (Optional) Re-enable Trusted Execution after virtualization is enabled

### Cannot Find Virtualization Option

**Possible Causes**:
1. **CPU doesn't support virtualization**: Check manufacturer website
2. **Wrong BIOS menu**: Try searching all Advanced submenus
3. **Outdated BIOS**: Update BIOS to latest version
4. **OEM limitation**: Some pre-built systems hide this option

**Solutions**:
1. Verify CPU supports virtualization (use CPU-Z or manufacturer website)
2. Update BIOS to latest version
3. Search BIOS for keywords: "Virtualization", "SVM", "VT", "VMX"
4. Check all tabs: Advanced, Chipset, CPU, Processor, Overclocking

### Virtualization Shows Disabled in Windows After Enabling in BIOS

**Causes**:
1. Hyper-V or Device Guard is disabled in Windows
2. Windows features not enabled

**Solution**:
1. Open PowerShell as Administrator:
   ```powershell
   # Enable Hyper-V Platform
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All

   # Enable Virtual Machine Platform (for WSL2)
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

   # Enable WSL (if needed)
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   ```

2. Restart computer

### Docker/WSL2 Still Not Working

**Check**:
1. Virtualization enabled in BIOS ✓
2. WSL2 installed ✓
3. Virtual Machine Platform enabled ✓
4. BIOS up to date ✓

**Additional Steps**:
```powershell
# Verify WSL version
wsl --list --verbose

# Set default to WSL2
wsl --set-default-version 2

# Update WSL
wsl --update

# Verify virtualization from Windows
bcdedit /enum | findstr hypervisor
# Should show: hypervisorlaunchtype    Auto
```

### Performance Issues After Enabling

**Unlikely but Possible**:
- Enabling virtualization has minimal performance impact on native OS
- If you experience issues:
  1. Update chipset drivers
  2. Update BIOS to latest version
  3. Check for conflicting security software
  4. Verify CPU temperature (ensure proper cooling)

---

## Common Use Cases

### For WSL2 Development

**Required**:
- ✓ VT-x (Intel) or SVM Mode (AMD)
- ✓ Virtual Machine Platform (Windows feature)
- ✓ WSL2

**Not Required**:
- ✗ VT-d / IOMMU (unless doing PCI passthrough)
- ✗ Hyper-V (WSL2 uses Virtual Machine Platform, not full Hyper-V)

### For Docker Desktop

**WSL2 Backend (Recommended)**:
- ✓ VT-x (Intel) or SVM Mode (AMD)
- ✓ WSL2
- ✓ Virtual Machine Platform

**Hyper-V Backend (Legacy)**:
- ✓ VT-x (Intel) or SVM Mode (AMD)
- ✓ Hyper-V feature
- ⚠️ Requires Windows Pro/Enterprise/Education

### For VirtualBox

**Basic Usage**:
- ✓ VT-x (Intel) or SVM Mode (AMD)

**Advanced (PCI passthrough, GPU passthrough)**:
- ✓ VT-x or SVM Mode
- ✓ VT-d or IOMMU

### For AI/ML Development with Containers

**Recommended Configuration**:
- ✓ VT-x (Intel) or SVM Mode (AMD)
- ✓ VT-d or IOMMU (for GPU passthrough to containers)
- ✓ WSL2 with Docker Desktop
- ✓ NVIDIA Container Toolkit (for GPU workloads)

---

## Additional Resources

### Official Documentation
- [Intel Virtualization Technology](https://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html)
- [AMD Virtualization](https://www.amd.com/en/technologies/virtualization)
- [Microsoft WSL Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Docker Desktop WSL2 Backend](https://docs.docker.com/desktop/features/wsl/)

### Manufacturer Resources
- [ASUS Support](https://www.asus.com/support/)
- [MSI Support](https://www.msi.com/support/)
- [GIGABYTE Support](https://www.gigabyte.com/Support)
- [ASRock Support](https://www.asrock.com/support/)

### Tools
- [CPU-Z](https://www.cpuid.com/softwares/cpu-z.html) - Check CPU virtualization support
- [HWiNFO](https://www.hwinfo.com/) - Detailed hardware information
- [Intel Processor Identification Utility](https://www.intel.com/content/www/us/en/download/12136/intel-processor-identification-utility-windows-version.html)

---

## Quick Reference Table

| Manufacturer | BIOS Key | VT-x/SVM Location | Notes |
|-------------|----------|------------------|--------|
| ASUS | DEL/F2 | Advanced → CPU Configuration | Press F7 for Advanced Mode |
| MSI | DEL/F2 | OC Settings → CPU Features | Press F7 for Advanced Mode |
| GIGABYTE | DEL/F2 | BIOS Features or MIT → Advanced CPU | UI varies by age |
| ASRock | DEL/F2 | Advanced → CPU Configuration | Straightforward layout |
| Intel | F2 | Advanced → Processor Configuration | Simple menu structure |

---

## Next Steps

After successfully enabling virtualization:

1. **Install WSL2**: Follow [DEV-ENV-WINDOWS.md](DEV-ENV-WINDOWS.md)
2. **Optimize Windows**: See [WINDOWS-OPTIMIZATION.md](WINDOWS-OPTIMIZATION.md)
3. **Configure WSL2**: Check [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)
4. **Set up development environment**: Run setup scripts from this repository

---

**Last Updated**: November 2024
**Applies To**: Windows 10/11, Linux, WSL2, Docker Desktop
