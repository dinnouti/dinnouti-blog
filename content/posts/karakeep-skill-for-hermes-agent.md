---
title: "Managing Karakeep Bookmarks from Hermes Agent"
date: 2026-10-24T20:57:31-04:00
tags: ["Hermes Agent", "Karakeep", "CLI", "self-hosted"]
description: "What the Karakeep skill gives Hermes Agent: bookmarks, tags, lists and search through the CLI or MCP."
comments: false
draft: false
---

Hermes Agent now has a Karakeep skill. It lets the agent manage bookmarks, tags and lists in a Karakeep instance, either through the official CLI or through MCP.

Karakeep is a self-hosted, open-source bookmark manager for links, notes and assets (images, PDFs), with tags, highlights, favorites, archiving and lists.

## CLI setup

The skill prefers the CLI over hand-written HTTP calls.

{{< highlight bash >}}
npm install -g @karakeep/cli
{{< / highlight >}}

The CLI reads two environment variables: `KARAKEEP_API_KEY` (created in your instance's settings page) and `KARAKEEP_SERVER_ADDR` (your server). Set both in your shell profile or the agent's environment, and keep the key out of the repo and out of chat. Then check that it works:

{{< highlight bash >}}
karakeep whoami
{{< / highlight >}}

## What you can ask

The skill already carries the commands and the search syntax, so you ask in plain language:

- "Tag everything I saved this week about Terraform."
- "What's in my reading list that I never favorited?"
- "Add this link and put it in my AWS list."
- "Find archived bookmarks from 2024 tagged #work."

## Smart lists

A manual list holds bookmarks you put there. A smart list is a saved search query, so it updates itself as bookmarks change. A query like `#ai -is:archived` gives you a live "current AI reading" list with no upkeep. Run the query as a search first, and only save it as a smart list once the results look right.

## Careful with delete

`bookmarks delete` is permanent. For bulk cleanups, have the agent show the search results first, and prefer archiving over deleting.

## Download the skill

Download the skill file I use: [SKILL.md](../../downloads/karakeep/SKILL.md). To install it, save it as `~/.hermes/skills/karakeep/SKILL.md` (under the active profile's `skills` directory if you use profiles) and start a new Hermes session. The full command list and search qualifiers are in that file.

I haven't tested the MCP path myself.

Sources: the official Karakeep skill on [skills.sh](https://www.skills.sh/karakeep-app/karakeep/karakeep) and [ClawHub](https://clawhub.ai/karakeep/skills/karakeep-app).

*Updated 2026-10-24: removed the command list and search reference; they duplicated the skill file.*
