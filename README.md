# EB docs for players and their AI helpers

EB is an EverQuest II bot you can script in Lua. This repository holds EB's scripting docs as plain files, so you
can hand them to an AI helper (Claude, ChatGPT or any other) and ask it for the EB script you want. The docs to
read in a browser are on [eb.jiimbo.dev](https://eb.jiimbo.dev/docs.html). Everything here is written for EB for InnerSpace, the
build EB Setup picks for you.

## What is here

| File | What it is |
|---|---|
| [commands.md](commands.md) | Every console command EB ships (296), grouped, with what each takes. |
| [examples/](examples/) | Every tested example (408: 22 complete scripts and 386 snippets), one `.lua` file each. Each one runs and passes against EB's offline stand-in for the game before it is published. |
| [reference/lua_api.json](reference/lua_api.json) | The whole scripting reference: 196 modules, 2242 functions, the TLOs and the examples (schema `eb.luadoc/1`). |

The whole guide in one file, `EB_Scripting_Guide.md`, is on its way: it lands here with the docs rewrite.

## Give it to your AI helper

1. Give it the files above: attach them, or paste their raw links, e.g.
   `https://raw.githubusercontent.com/Jiimboeq2/EB-Docs/main/commands.md` and `https://raw.githubusercontent.com/Jiimboeq2/EB-Docs/main/reference/lua_api.json`.
2. Tell it what you want in plain words: what the script should do, and your class.
3. Ask it to use only the functions and commands in these files, and to start from the closest tested example.
4. Run what it gives you the way that example's header says (where the file goes, the exact `run` line), and send
   it back what EB printed if something is off.

A snippet carries its own test: in game, use only the code under `-- your script`. `DOCS` exists only in the docs
test runner, so it never goes into a script of yours ([examples/README.md](examples/README.md) says more).

Made from EB's own docs on 2026-11-25; when EB changes, these files are made again.
