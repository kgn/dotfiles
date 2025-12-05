# Feature Request: Hide SCM Input Box

## Status: PR Submitted

- **VS Code Issue**: https://github.com/microsoft/vscode/issues/281562
- **VS Code PR**: https://github.com/microsoft/vscode/pull/281627
- **Submitted**: 2025-12-05
- **Status**: Awaiting Review

---

## How to Submit

1. Go to https://github.com/microsoft/vscode/issues/new/choose
2. Select "Feature Request"
3. Copy the title and body below
4. Submit and update this file with the issue link

---

## Title

```
Add setting to hide Source Control commit input box (scm.showInputBox)
```

## Body

```markdown
**Feature Request**

Add a user-facing setting to hide the commit message input box in the Source Control panel.

**Use Case**

When using VS Code with multiple repositories in a workspace, the Source Control panel displays a commit input box for each repository. For users who:

- Prefer committing via terminal/CLI (e.g., using Claude Code, git CLI, or other tools)
- Want a cleaner, more compact Source Control view
- Only use the panel to view changed files, not to commit

The input boxes take up significant vertical space (34px per repository) and cannot currently be hidden.

**Current Workarounds**

- `scm.inputMinLineCount: 1` and `scm.inputMaxLineCount: 1` reduce height but don't hide the box
- CSS injection via extensions can hide the content but cannot collapse the gap due to VS Code's virtualized list using JavaScript-calculated inline styles for row positioning
- The `SourceControlInputBox.visible` property exists in the API but is only accessible to SCM provider extensions, not end users

**Proposed Solution**

Add a setting like:
```json
"scm.showInputBox": false
```

Or per-provider:
```json
"git.showInputBox": false
```

This would:
1. Hide the input box rows in the Source Control panel
2. Collapse the space they occupy (update the virtualized list to skip these rows)
3. Still allow commits via command palette, terminal, or other means

**Additional Context**

- Related: The `git.showActionButton` setting successfully hides commit/sync/publish buttons
- Related: `SourceControlInputBox.visible` API exists for extension authors (issue #62068, PR #60051)
- This would bring user-facing parity with what extension authors can already do programmatically

**System Info**

- VS Code Version: 1.95+
- OS: Linux (Arch)
```

---

## Notes

- The `SourceControlInputBox.visible` property was added in 2018 for extension authors
- The Git extension does not expose this property through its public API
- CSS-only solutions cannot work because the SCM panel uses a virtualized list with JavaScript-calculated row positions
