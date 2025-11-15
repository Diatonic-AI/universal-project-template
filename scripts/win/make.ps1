param(
  [Parameter(ValueFromRemainingArguments=$true)]
  [string[]]$Args
)
$make = Get-Command make -ErrorAction SilentlyContinue
if (-not $make) {
  Write-Host "GNU make not found. Install via 'choco install make' or MSYS2: 'pacman -S make'."
  exit 1
}
& make @Args
exit $LASTEXITCODE
