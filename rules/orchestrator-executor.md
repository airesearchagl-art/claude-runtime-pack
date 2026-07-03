# Orchestrator / Executor Rule

## Purpose

Keep the high-capability model focused on planning, judgment, and review. Move routine extraction and broad reading to lower-cost executors, subagents, or mechanical checks.

## Model naming policy

Do not assume the upper model is always Fable 5.

Use these terms instead:

- **Orchestrator**: the active high-capability model selected for planning and judgment.
- **Executor**: lower-cost model, subagent, or mechanical process used for reading, listing, extracting, and drafting.

When Fable 5 is used as the Orchestrator, apply this rule strictly because token and usage cost may be high.

## Standard workflow

```text
1. Plan with Orchestrator
2. Delegate broad reading and extraction to Executor
3. Run mechanical checks where possible
4. Orchestrator reviews candidate outputs
5. Orchestrator writes or approves final distilled content
6. Orchestrator reviews diff and reports scope
```

## Orchestrator should directly read only

- the governing roadmap or task instruction
- the target README / Index / schema file
- files being edited
- a small number of highly relevant source files
- subagent outputs
- final diffs

## Executor / subagent should handle

- file discovery
- existing note inventory
- frontmatter extraction
- link candidate extraction
- related-note candidate extraction
- source snippets with file paths
- first-pass issue lists
- repetitive comparison tables
- simple PR diff summaries

## Escalation rule

Executor output is not final. Escalate to the Orchestrator when:

- adoption or rejection must be decided
- confidence must be calibrated
- source_type must be selected
- a note belongs to multiple possible locations
- web or current information is needed
- privacy, legal, or company-sensitive risk appears
- a cross-repo or cross-folder responsibility conflict appears

## Confirmation is not a per-step ritual

Once the user approves a work scope, treat implementation, local checks, commit, push, and PR creation as normal follow-through, not separate approval gates. Stop and ask again only for the exceptions listed in `CLAUDE.md` under "Confirmation policy" (real local config writes, `settings.json`, secrets/auth, external services, cost-bearing settings, out-of-scope changes, destructive operations, merge/release/tag).

## Anti-patterns

Avoid:

- high-capability model reading the whole vault for routine tasks
- using subagents without explicit file limits
- asking subagents to judge final correctness
- letting subagents edit files without explicit approval
- copying subagent output directly into permanent notes
- putting runtime behavior rules into project knowledge notes unless the project itself is about runtime behavior
