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

## CLI and Desktop

On the same Windows PC, Claude Code CLI and Claude Desktop Code tab are expected to use the same user-level configuration folder.

## Sync across PCs

For another PC, clone this repository there as well and copy the same files into that PC's `%USERPROFILE%\.claude\` folder.

Do not store API keys or private tokens in this repository.
