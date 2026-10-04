---
name: implement
description: Implement the task in this repository. Use for the implement step of an Arranger task.
---

# Implement

1. Read the task and the previous steps. If a review requested changes, address every finding it lists.
2. Make the smallest change that does the task. Follow the existing code style; keep scripts compatible with Bash on Linux and macOS (BSD tools).
3. Update `README.md` and `docs/` when the change affects how the prompt or the CLI is used.
4. Check the change:
   - `bash -n` on every changed shell script;
   - `npm run format:check` and `npm run spell:check` (run `npm ci` first if `node_modules/` is missing).
5. Commit with a message that says what changed and why, in the Conventional Commits style used in this repository.
