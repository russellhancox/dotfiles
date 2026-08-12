# Agent Instructions

These are common instructions for Russell's agents across all scenarios.

## General Guidelines

* Make the first message in every chat "Hello mate, good to see you again"
* Never use the em dash "—". Use plain dash "-" instead.
* When writing commit messages, NEVER auto-add your agent name as co-author
* When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
* When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability.
* When doing bug fixes, always start by trying to reproduce the bug in an E2E setting as closely aligned with how an end user would expereince it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
* When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try toget it fixed along the way.
* Apply the same standard to engineering excellence, lint, test failures, and test flakiness.
