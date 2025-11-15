# Windows bootstrap: install make, git, node, python, pre-commit (guided)
Write-Host "This script suggests commands; review before running."
Write-Host "Install Git:"; Write-Host "winget install --id Git.Git -e"
Write-Host "Install Make via Chocolatey (requires admin):"; Write-Host "choco install make"
Write-Host "or via MSYS2:"; Write-Host "winget install MSYS2.MSYS2 ; then run pacman -S make"
Write-Host "Install Node:"; Write-Host "winget install OpenJS.NodeJS.LTS"
Write-Host "Install Python:"; Write-Host "winget install Python.Python.3"
Write-Host "Pre-commit:"; Write-Host "python -m pip install --user pre-commit"
