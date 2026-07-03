# Windows Local Setup

## Purpose

Install this Runtime Pack into the user-level Claude Code configuration folder on a Windows PC.

## Recommended target

```text
%USERPROFILE%\.claude\
```

## Manual setup

1. Clone this repository.
2. Open the repository folder.
3. Copy the following items into `%USERPROFILE%\.claude\`:

```text
CLAUDE.md
agents\
rules\
bootstrap\
```

After copying, the target should look like this:

```text
%USERPROFILE%\.claude\
  CLAUDE.md
  agents\
    vault-scout.md
    vault-auditor.md
    vault-pr-summarizer.md
  rules\
    orchestrator-executor.md
    token-economy.md
  bootstrap\
    cloud-session-bootstrap.md
    project-bootstrap-CLAUDE.md
```

## Automated setup (optional): scripts/install.ps1

`scripts\install.ps1` copies the same four items (`CLAUDE.md`, `agents\`, `rules\`, `bootstrap\`) into `%USERPROFILE%\.claude\`. It never touches `settings.json`, `settings.local.json`, credentials, environment variables, or GitHub authentication, and it never deletes anything.

Safety behavior:

- If an item already exists at the target, it is copied to a timestamped backup (for example `CLAUDE.md.backup.20260703-115208`) before being overwritten.
- Nothing is deleted; only backup copies are added alongside the new content.
- The target folder must end in `.claude` or the script refuses to run.

Always preview first:

```powershell
cd claude-runtime-pack
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -DryRun
```

This prints the source root, target root, and every item that would be created, backed up, or overwritten, without changing anything on disk. `-WhatIf` works the same way, since the script also supports PowerShell's built-in `ShouldProcess` mechanism.

Once you are satisfied with the preview, run it for real:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

Optional parameters:

```powershell
# Install into a non-default target (for example, to test in a scratch folder
# before touching a real profile)
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -TargetRoot "D:\test\.claude" -DryRun

# Install from a repository checked out somewhere other than the current folder
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -SourceRoot "C:\path\to\claude-runtime-pack"
```

If `powershell -File` is blocked by your execution policy, `-ExecutionPolicy Bypass` applies only to that one process and does not change your system-wide policy.

The manual steps above remain the recommended first pass, especially the first time you set this up on a given PC, since they make it easiest to see exactly what is being placed where.

## CLI and Desktop

On the same Windows PC, Claude Code CLI and Claude Desktop Code tab are expected to use the same user-level configuration folder.

## Sync across PCs

For another PC, clone this repository there as well and copy the same files into that PC's `%USERPROFILE%\.claude\` folder (manually, or with `scripts\install.ps1`).

Do not store API keys or private tokens in this repository.
