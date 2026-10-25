---
title: "Managing Karakeep Bookmarks from Hermes Agent"
date: 2026-10-24T20:57:31-04:00
tags: ["Hermes Agent", "Karakeep", "CLI", "self-hosted"]
description: "What the Karakeep skill gives Hermes Agent: bookmarks, tags, lists and search through the CLI or MCP."
comments: false
draft: false
---

Hermes Agent now has a Karakeep skill. It lets the agent manage bookmarks, tags and lists in a Karakeep instance, either through the official CLI or through MCP.

## What Karakeep is

Karakeep is a self-hosted, open-source bookmark manager. It stores three kinds of bookmarks:

- Links. Karakeep fetches the title, description, image, screenshot and a full-page archive.
- Text. Notes and snippets.
- Assets. Images and PDFs.

Bookmarks can have tags, notes, highlights, a favorite flag and an archived state, and can sit in one or more lists.

## CLI setup

The skill prefers the CLI over hand-written HTTP calls.

{{< highlight bash >}}
npm install -g @karakeep/cli
{{< / highlight >}}

The CLI reads two environment variables: `KARAKEEP_API_KEY` (created in your instance's settings page) and `KARAKEEP_SERVER_ADDR` (your server). Set both in your shell profile or the agent's environment, and keep the key out of the repo and out of chat. Then check that it works:

{{< highlight bash >}}
karakeep whoami
{{< / highlight >}}

## Common commands

{{< highlight bash >}}
# add a link, a note
karakeep bookmarks add --link "https://example.com"
karakeep bookmarks add --note "Remember to review the PR"

# read and update
karakeep bookmarks get <bookmark-id>
karakeep bookmarks update <bookmark-id> --favourite
karakeep bookmarks update-tags <bookmark-id> --add-tag "reading"

# lists
karakeep lists list
karakeep lists add-bookmark --list <list-id> --bookmark <bookmark-id>

# search and delete
karakeep bookmarks search "is:fav #work"
karakeep bookmarks delete <bookmark-id>
{{< / highlight >}}

Add `--json` to any command for raw JSON, which is what you want when an agent parses the output.

## Search query language

Search is where this gets useful. Spaces mean AND, `and` / `or` are explicit, a `-` or `!` prefix negates, and parentheses group (a group can't be negated). Anything that isn't a qualifier is full-text search.

| Qualifier | Matches |
| --- | --- |
| `is:fav` | favorites |
| `is:archived` | archived bookmarks |
| `#tag` | bookmarks with that tag |
| `list:name` | bookmarks in that list |
| `after:` / `before:` | created on or after / before a date (YYYY-MM-DD) |
| `age:<1w` | younger than one week (units d, w, m, y) |

Examples:

{{< highlight text >}}
is:fav after:2024-01-01 #important
is:archived and (list:reading or #work)
machine learning is:fav -is:archived
age:<1w
{{< / highlight >}}

The full list also includes `is:tagged`, `is:inlist`, `is:link`, `is:broken`, `url:`, `title:`, `feed:` and `source:`.

## Smart lists

A manual list holds bookmarks you put there. A smart list is a saved search query, so it updates itself as bookmarks change. A query like `#ai -is:archived` gives you a live "current AI reading" list with no upkeep. Run the query as a search first, and only save it as a smart list once the results look right.

## Why bother with the skill

Without it, the agent has to guess flags and query syntax. With it, requests like "tag everything I saved this week about Terraform" or "what's in my reading list that I never favorited" map onto real commands and qualifiers.

A caution: `bookmarks delete` is permanent. For bulk cleanups, have the agent show the search results first, and prefer archiving over deleting.

I haven't tested the MCP path myself; the CLI commands above come from the official skill pages.

## Download the skill

Download the skill file I use: [SKILL.md](../../downloads/karakeep/SKILL.md). To install it, save it as `~/.hermes/skills/karakeep/SKILL.md` (under the active profile's `skills` directory if you use profiles) and start a new Hermes session.

Sources: the official Karakeep skill on [skills.sh](https://www.skills.sh/karakeep-app/karakeep/karakeep) and [ClawHub](https://clawhub.ai/karakeep/skills/karakeep-app).
