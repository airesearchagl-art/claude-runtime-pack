# Token Economy Rule

## Purpose

Reduce unnecessary token use while keeping final judgment quality high.

## Principles

- Do not read the whole repository unless the task explicitly requires broad architecture judgment.
- Start from the smallest useful context.
- Prefer file lists, grep results, diffs, and subagent summaries over full-file reads.
- Prefer mechanical checks for repeatable validation.
- Keep permanent instructions short; move long procedures into skills, prompts, or dedicated rule files.

## Reading budget guidance

For ordinary work:

1. Read the user request.
2. Read the governing roadmap or task instruction.
3. Read the target index/schema file.
4. Read only files that will be edited.
5. Delegate broad discovery to subagents.
6. Read final diff before reporting.

Do not directly read broad project logs, histories, issue archives, or long source files unless the plan explains why they are required.

## When to use subagents

Use subagents or mechanical checks when:

- more than 4 source files must be inspected
- candidate extraction is needed
- existing notes must be inventoried
- frontmatter must be listed
- link checking is needed
- reviewed dates must be checked
- project briefs must be scanned
- PR diffs need simple summarization

## Required subagent handoff fields

```text
Target goal:
Files to read:
Allowed work:
Forbidden work:
Output format:
No final judgment:
No file edits:
No web search:
No external service access:
```

## Completion reporting

Always report the actual context strategy:

- direct files read
- delegated files
- mechanical checks
- intentionally skipped areas
- whether web search was used
- whether external services were used
- final Orchestrator decisions

## Good enough rule

If a candidate fact is not needed for the current PR, do not pull it into context. Record it as a future check instead.
