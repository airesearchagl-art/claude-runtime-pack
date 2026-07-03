<#
.SYNOPSIS
    Installs Claude Runtime Pack files into a Claude Code user-level config folder.

.DESCRIPTION
    Copies only these items from this repository into the target folder
    (default: $env:USERPROFILE\.claude):

        CLAUDE.md
        agents\
        rules\
        bootstrap\

    Nothing else is touched. In particular this script never reads, writes, or
    inspects settings.json, settings.local.json, credentials, environment
    variables, or GitHub authentication.

    Safety model:
      - If an item already exists at the target, it is copied to a
        timestamped backup (e.g. CLAUDE.md.backup.20260703-121500) before
        being overwritten. Nothing is deleted.
      - Pass -DryRun (or the built-in -WhatIf) to preview every action
        without changing anything on disk.
      - The target root must end in ".claude" as a basic guard against
        pointing this script at the wrong folder.

.PARAMETER TargetRoot
    Destination Claude Code config folder. Defaults to $env:USERPROFILE\.claude.
    Must end in ".claude".

.PARAMETER SourceRoot
    Root of the claude-runtime-pack repository (the folder that directly
    contains CLAUDE.md, agents\, rules\, bootstrap\). Defaults to the parent
    folder of this script, assuming the standard scripts\install.ps1 layout.

.PARAMETER DryRun
    Preview only. Equivalent to passing -WhatIf. No files are created,
    backed up, or overwritten.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -DryRun

    Preview what would be installed into %USERPROFILE%\.claude without
    changing anything.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1

    Install CLAUDE.md, agents\, rules\, bootstrap\ into %USERPROFILE%\.claude,
    backing up any existing items first.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 `
        -TargetRoot "D:\test\.claude" -DryRun

    Preview an install against a non-default target, e.g. for testing in a
    scratch folder before touching a real profile.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$TargetRoot = (Join-Path $env:USERPROFILE '.claude'),
    [string]$SourceRoot,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if ($DryRun) {
    $WhatIfPreference = $true
}

# $PSScriptRoot is not reliably populated while parameter defaults are
# evaluated on Windows PowerShell 5.1, so resolve this default here instead.
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
    $SourceRoot = Split-Path -Parent $PSScriptRoot
}

# --- Safety checks ---------------------------------------------------------

$targetLeaf = Split-Path -Leaf $TargetRoot
if ($targetLeaf -ne '.claude') {
    throw "TargetRoot '$TargetRoot' does not end in '.claude'. Refusing to run for safety. Pass -TargetRoot explicitly if this is really what you want."
}

$itemsToCopy = @(
    [pscustomobject]@{ Name = 'CLAUDE.md'; IsDirectory = $false }
    [pscustomobject]@{ Name = 'agents';    IsDirectory = $true  }
    [pscustomobject]@{ Name = 'rules';     IsDirectory = $true  }
    [pscustomobject]@{ Name = 'bootstrap'; IsDirectory = $true  }
)

$missing = @()
foreach ($item in $itemsToCopy) {
    $srcPath = Join-Path $SourceRoot $item.Name
    if (-not (Test-Path -LiteralPath $srcPath)) {
        $missing += $item.Name
    }
}
if ($missing.Count -gt 0) {
    throw "Source is missing required item(s): $($missing -join ', '). Expected them directly under '$SourceRoot'. Run this script from inside a full clone of claude-runtime-pack, or pass -SourceRoot explicitly."
}

# --- Report the plan before touching anything -------------------------------

Write-Host 'Claude Runtime Pack installer' -ForegroundColor Cyan
Write-Host "  Source root : $SourceRoot"
Write-Host "  Target root : $TargetRoot"
if ($DryRun) {
    Write-Host '  Mode        : DRY RUN (no files will be changed)' -ForegroundColor Yellow
}
else {
    Write-Host '  Mode        : LIVE (existing items are backed up, then overwritten)' -ForegroundColor Yellow
}
Write-Host '  Items to copy:'
foreach ($item in $itemsToCopy) {
    Write-Host "    - $($item.Name)"
}
Write-Host ''
Write-Host 'This script does not read, write, or touch settings.json, settings.local.json,' -ForegroundColor DarkGray
Write-Host 'credentials, environment variables, or GitHub authentication.' -ForegroundColor DarkGray
Write-Host ''

if (-not (Test-Path -LiteralPath $TargetRoot)) {
    if ($PSCmdlet.ShouldProcess($TargetRoot, 'Create target folder')) {
        New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null
        Write-Host "Created target folder: $TargetRoot"
    }
    else {
        Write-Host "What if: would create target folder $TargetRoot"
    }
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$results = @()

foreach ($item in $itemsToCopy) {
    $srcPath = Join-Path $SourceRoot $item.Name
    $dstPath = Join-Path $TargetRoot $item.Name
    $backedUp = $false

    try {
        if (Test-Path -LiteralPath $dstPath) {
            $backupPath = "$dstPath.backup.$timestamp"
            if ($PSCmdlet.ShouldProcess($dstPath, "Back up existing item to $backupPath")) {
                Copy-Item -LiteralPath $dstPath -Destination $backupPath -Recurse -Force
                $backedUp = $true
                Write-Host "Backed up : $dstPath -> $backupPath"
            }
            else {
                Write-Host "What if: would back up $dstPath -> $backupPath"
            }
        }

        if ($PSCmdlet.ShouldProcess($dstPath, "Install $($item.Name) from source")) {
            if ($item.IsDirectory) {
                if (-not (Test-Path -LiteralPath $dstPath)) {
                    New-Item -ItemType Directory -Path $dstPath -Force | Out-Null
                }
                Copy-Item -Path (Join-Path $srcPath '*') -Destination $dstPath -Recurse -Force
            }
            else {
                Copy-Item -LiteralPath $srcPath -Destination $dstPath -Force
            }
            Write-Host "Installed : $($item.Name)" -ForegroundColor Green
            $results += [pscustomobject]@{ Item = $item.Name; Status = 'Installed'; BackedUp = $backedUp }
        }
        else {
            Write-Host "What if: would install $($item.Name) -> $dstPath"
            $results += [pscustomobject]@{ Item = $item.Name; Status = 'WhatIf'; BackedUp = $backedUp }
        }
    }
    catch {
        Write-Host "ERROR installing $($item.Name): $($_.Exception.Message)" -ForegroundColor Red
        $results += [pscustomobject]@{ Item = $item.Name; Status = 'FAILED'; BackedUp = $backedUp }
    }
}

Write-Host ''
Write-Host 'Summary:' -ForegroundColor Cyan
$results | Format-Table -AutoSize | Out-Host

$failed = $results | Where-Object { $_.Status -eq 'FAILED' }
if ($failed.Count -gt 0) {
    Write-Host 'One or more items failed to install. See errors above.' -ForegroundColor Red
    exit 1
}

if ($DryRun) {
    Write-Host 'Dry run complete. No files were changed.' -ForegroundColor Yellow
}
else {
    Write-Host "Install complete. settings.json and everything else in $TargetRoot was left untouched." -ForegroundColor Green
}
