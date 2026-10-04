---
name: review
description: Review the work done for an Arranger task and decide whether it is ready. Use for the review step.
---

# Review

1. Look at all changes of the task: `git diff <start commit>..HEAD` and `git log <start commit>..HEAD`.
2. Check that the change does what the task asks, handles edge cases, and works on both Linux and macOS (BSD tools).
3. Run `bash -n` on the changed shell scripts, `npm run format:check` and `npm run spell:check`.
4. Do not change files yourself.
5. Outcome:
   - `approved` when the task is done correctly and the checks pass;
   - `changes_requested` otherwise. List each finding in the summary concretely (file, problem, expected fix), so the next implementation step can address it.
