---
description: Review and address all CLAUDE comments in the codebase
---

## Context

CLAUDE comments found in codebase:

!`grep -rn "CLAUDE:" --include="*" . 2>/dev/null | grep -v ".git/" | head -50`

## Task

Review each `CLAUDE:` comment found above. For each comment:

1. **Read the file** containing the comment to understand the context
2. **Address the request** - implement the fix, refactor, or change requested
3. **Update the comment** after addressing it, add a comment for context
4. **Summarize** what you did for each comment

If no comments are found, report that the codebase is clean.

Work through all comments systematically. After addressing all comments, provide a summary of changes made.
