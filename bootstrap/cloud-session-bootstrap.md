# Cloud Session Bootstrap Notes

## Purpose

This note explains how to reuse this Runtime Pack in Claude Code cloud or web-based sessions.

## Important limitation

Putting this Runtime Pack in a separate GitHub repository does not automatically make every cloud session read it.

A cloud session usually reads the working repository context. Local user-level files such as `~/.claude/CLAUDE.md` are not automatically available in a fresh cloud environment.

## Recommended options

### Option A: Minimal project bootstrap

Add a small project-level Claude file to the working repository, not the full Runtime Pack.

Recommended content is in:

```text
bootstrap/project-bootstrap-CLAUDE.md
```

Use this when the project should follow the Runtime Pack principles but should not vendor the whole pack.

### Option B: Setup script pulls Runtime Pack

For cloud environments that support setup scripts, add a project setup step that clones this repository and copies or imports the needed files.

Caution:

- Do not place private keys or access tokens in the repository.
- Keep the bootstrap minimal.
- Verify that the cloud session actually reads the copied files.

### Option C: Work-start prompt includes Runtime Pack summary

When setup scripts are not available, paste a short work-start rule into the first instruction:

```text
Use the active high-capability model as Orchestrator only. Do not read broadly. Delegate discovery, listing, extraction, frontmatter checks, and diff summarization to subagents or mechanical checks. Report direct reads, delegated files, mechanical checks, skipped areas, and final decisions.
```

### Option D: Remote Control

If using a phone or tablet, Remote Control can operate a Claude Code session running on the main PC. In that case, the main PC's local `~/.claude/` settings apply because the work is executed on that PC.

## Future work

- Add a safe setup script pattern for cloud sessions.
- Decide whether each project should include only a bootstrap file or a project-specific `.claude/` folder.
- Keep Runtime Pack updates centralized in this repository.
