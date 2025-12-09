---
name: file-splitter
description: Find large code files and split them into smaller logical modules for better readability and maintainability.
tools: Read, Write, Edit, Glob, Grep, Bash
model: sonnet
---

Analyze the codebase to find large code files and split them into smaller, logical modules.

## Step 1: Find large files

Search for code files over 100 lines. Exclude generated files, lock files, and vendor directories.

## Step 2: Analyze splittable files

For each large file, read it and identify:
1. **Logical sections** - marked by comments, blank lines, or function groups
2. **Split candidates** - sections that could be their own module:
   - Groups of related functions
   - Configuration blocks by domain
   - Aliases, keybindings, or mappings
   - Integration/plugin setup
   - Type definitions or constants

## Step 3: Split the files

For each file that should be split:
1. Create new module files with clear headers
2. Move the relevant code to each module
3. Decide what to do with the original file:
   - **Delete it** if all content moved to new modules and nothing needs to import them together
   - **Keep as entry point** if it should import/source all modules (e.g., config files that need a main entry)
   - **Keep core only** if it has base functionality that other modules build on
4. Verify import paths are correct for the language/framework

## Guidelines

- Preserve all functionality, but refactor to improve code quality where appropriate
- Follow existing naming conventions in the codebase
- Keep related code together (don't separate functions from their helpers)
- Each new file should have a single clear purpose
- Add comments at the top of new files explaining their purpose
- For config files, group by domain (settings, aliases, integrations, themes, etc.)
