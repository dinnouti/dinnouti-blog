---
name: karakeep
description: "Manage Karakeep bookmarks, tags, lists, and search queries."
version: 0.1.0
author: Alex (Dinnouti), Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [karakeep, bookmarks, tags, lists, search, mcp]
    related_skills: []
---

# Karakeep Skill

Operates a self-hosted Karakeep bookmark instance. Covers adding, searching, organizing, and exporting bookmarks, lists, and tags. It does not cover running or hosting Karakeep itself.

## When to Use

- The user asks to add, find, search, tag, archive, favorite, or organize bookmarks.
- The user asks about Karakeep lists, smart lists, or tags.
- Don't use for: general web search (use `web_search`) or for editing the Karakeep server.

## Prerequisites

Two access paths. Prefer the CLI; use the MCP tools when the CLI is not installed.

- **CLI:** `@karakeep/cli` (`npm install -g @karakeep/cli`). Needs `KARAKEEP_API_KEY` and `KARAKEEP_SERVER_ADDR` (the self-hosted URL; it defaults to the cloud instance if unset). Check with `karakeep whoami`.
- **MCP:** a `karakeep` MCP server exposes `search_bookmarks`, `get_bookmark`, `create_bookmark`, `get_tags`, `delete_tag`, and others. Load them with `tool_search` and `tool_describe`.

Never print the API key into chat or logs.

## How to Run

Run CLI commands through the `terminal` tool, for example `terminal(command="karakeep bookmarks search 'is:fav #work' --json", timeout=60)`.

## Quick Reference

- Add link: `karakeep bookmarks add --link "<url>" --tag-name "<tag>" --list-id <id>`
- Add note: `karakeep bookmarks add --note "<text>"`
- Get: `karakeep bookmarks get <id> [--include-content]`
- Update: `karakeep bookmarks update <id> --title "..." [--archive|--favourite]`
- Tags: `karakeep bookmarks update-tags <id> --add-tag X --remove-tag Y`
- Lists: `karakeep lists list`, `lists add-bookmark --list <id> --bookmark <id>`
- Search: `karakeep bookmarks search "<query>" [--limit N] [--sort-order relevance] [--all]`
- Delete: `karakeep bookmarks delete <id>` (confirm with the user first)
- Add `--json` to any command for raw output.

## Search Query Language

- Spaces mean AND. Use `and`, `or`, and `()` for boolean logic.
- Negate with `-` or `!`, e.g. `-is:archived`, `!is:fav`.
- Qualifiers: `is:fav`, `is:archived`, `is:tagged`, `is:inlist`, `is:link|text|media`, `is:broken`, `url:x`, `title:"x"`, `#tag` or `tag:"x"`, `list:name`, `after:YYYY-MM-DD`, `before:YYYY-MM-DD`, `age:<1w`, `feed:name`, `source:rss|web|cli|api|...`.
- Any remaining text is full-text search.
- Examples: `is:fav after:2024-01-01 #important`; `is:archived and (list:reading or #work)`; `-is:tagged or -is:inlist` (unorganized items).

## Procedure

1. Confirm access: `karakeep whoami` (CLI) or one `get_tags` call with a small `limit` (MCP). Done when the call returns data.
2. Resolve targets. Search first and read the IDs back, then act on those IDs. Done when each target ID is confirmed.
3. Make the change. For batches, do one item at a time and record each result.
4. Verify by re-reading the item (`get`, or the same search). Done when the new state matches the request.
5. Report the IDs and changes in a short list.

## Pitfalls

- **Bulk changes:** deletes, tag merges, and list removals cannot be undone from here. Show the exact list and get approval first.
- **Tag merge:** Karakeep has no merge endpoint. Merging two tags means attaching the source tag's bookmarks to the target tag, then deleting the source tag. Plan for many calls on large tags.
- **API key scopes:** the MCP key on this server lacks the `tags:readwrite` scope. Tag deletes fail with `API key is missing required scope: tags:readwrite` until the key is regenerated with that scope.
- **Smart lists** update automatically from their query. Changing their query changes what they show.
- **Deleting a tag** removes it from its bookmarks but does not delete the bookmarks.
- **Full-page or large fetches:** a tag list can be hundreds of KB. Use `--limit` or the `nameContains` filter and page with the cursor.

## Verification

- After a write, re-read the item and confirm the field changed.
- After a delete, confirm the item no longer appears in the search or the tag list.
- Done when the verification output matches the user's request.
