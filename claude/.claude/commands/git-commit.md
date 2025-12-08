---
description: Stage, commit and push changes
allowed-tools: Bash(git:*)
argument-hint: [commit message]
---

## Context
- Status: !`git status --short`
- Diff: !`git diff --staged --stat`
- Recent commits: !`git log --oneline -5`

## Task
Stage all changes, create a commit with the message: $ARGUMENTS

Then push to the remote. If no message provided, generate one from the diff.

Use conventional commit format (feat:, fix:, docs:, chore:, refactor:, test:, style:).

Keep summary under 50 characters, add detailed description if needed.

IMPORTANT: Never mention Claude, AI, or include any "Generated with" or "Co-Authored-By" lines.
