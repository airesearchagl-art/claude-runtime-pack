# Project Bootstrap for Claude Runtime Pack

> Copy this file into a project-level Claude instruction file only when the project should follow the Runtime Pack behavior. Keep it short.

## Runtime behavior

Use the active high-capability model as Orchestrator. The Orchestrator plans, decides, reviews, and reports. It should not absorb broad discovery or routine extraction.

When using an expensive or high-token model such as Fable 5, be stricter about delegation.

## Work-start gate

Before non-trivial work, first provide a plan with:

- target goal
- intended change files
- files to read directly
- files to delegate to subagents
- mechanical checks to run
- decisions reserved for the Orchestrator
- areas intentionally not read

Stop for user confirmation when the user asked for a plan first.

## Delegation rule

Use subagents or mechanical checks for:

- 5 or more files
- file inventories
- frontmatter extraction
- link candidates
- reviewed date checks
- candidate source extraction
- simple PR diff summaries

Subagent outputs are candidates. The Orchestrator decides what to use.

## Reporting rule

Completion reports must include:

- direct reads
- delegated files
- mechanical checks
- skipped areas
- whether web search was used
- whether external services were used
- final Orchestrator decisions
