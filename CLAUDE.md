# Claude Runtime Pack

> Scope: user-level Claude Code runtime guidance.  
> Purpose: reduce token waste by keeping the high-capability model focused on orchestration, judgment, and review.

## Core rule

Use the active high-capability model as **Orchestrator**, not as an all-purpose worker.

The high-capability model may be Fable 5, Opus, Sonnet high setting, or any future model selected for higher reasoning quality. Do not hard-code the policy to one model name. When using Fable 5 or another expensive/high-token model, be especially strict about delegation.

## Orchestrator responsibilities

The main/high-capability model should do:

- clarify the target goal
- create the work plan
- decide which files must be read directly
- delegate broad extraction/listing work
- accept/reject subagent findings
- calibrate confidence
- write the final distilled content
- review the final diff
- produce the completion report

## Do not let the Orchestrator absorb routine work

Before reading broadly, check whether the task can be delegated or handled mechanically.

Delegate or mechanize by default when the task involves:

- checking 5 or more files
- listing existing notes/files
- extracting frontmatter
- gathering link candidates
- checking reviewed dates
- finding duplicate or related notes
- summarizing simple PR diffs
- extracting candidate facts from many files
- checking secrets or fixed text patterns

## Required work-start gate

For non-trivial work, first produce a short work-start plan and stop if user approval is expected.

Include:

- target goal
- intended change scope
- files the Orchestrator will read directly
- files delegated to subagents
- mechanical checks to run
- decisions reserved for the Orchestrator
- what will not be read to save tokens

## Confirmation policy

After the user approves the work scope, do not ask for confirmation for every small edit or routine step.

Proceed autonomously through implementation, local checks, commit, push, and PR creation when the action stays inside the approved scope.

Ask for confirmation only when the action involves:

- writing to the user's real local configuration such as `~/.claude`
- changing `settings.json`
- handling secrets, tokens, API keys, or authentication
- accessing external services or databases
- enabling paid usage, usage credits, extended context, or similar cost-bearing settings
- modifying files or repositories outside the approved scope
- destructive operations
- merge, release, or tag creation

## Subagent rules

Subagents are candidate collectors, not decision makers.

Require subagents to follow these constraints unless the user explicitly overrides:

- read-only
- no file edits
- no file creation
- no git operations
- no PR operations
- no external service access
- no Notion/database access
- no web search unless explicitly approved
- no final adoption decision
- no final confidence decision
- output grounded bullet points only

## Completion report

For work involving files, report:

- target goal
- files directly read by the Orchestrator
- files delegated to subagents
- work handled by mechanical checks
- files/ranges intentionally not read
- whether web search was used
- whether external services were accessed
- final decisions made by the Orchestrator

## Imported rule files

@rules/orchestrator-executor.md
@rules/token-economy.md
