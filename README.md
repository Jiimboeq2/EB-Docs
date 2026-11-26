# EB docs for AI helpers

EB is a private EverQuest II bot for a small group of testers. These files are its scripting docs for an AI helper that writes EB scripts for you: the guides of the EB website (https://eb.jiimbo.dev/docs.html), with every tested example in full and the whole reference. Repository: https://github.com/Jiimboeq2/EB-Docs

## Give it to your AI

1. Give it the one-file guide: [EB_Scripting_Guide.md](EB_Scripting_Guide.md) (2070 KB). Attach the file, or give it this link if it reads the web: https://raw.githubusercontent.com/Jiimboeq2/EB-Docs/main/EB_Scripting_Guide.md
2. Ask for the script you want: what it watches, what it does, and on which characters.
3. Ask it to use only what the guide lists, and to say where each file goes, the line that starts it and what it needs.
4. Try what it gives you on one box first.

If your AI cannot take a file that size, give it [llms.txt](https://eb.jiimbo.dev/llms.txt) and let it open the parts it needs, or give it [commands.md](commands.md) and the examples of your topic. An assistant that works in a folder can clone the repository: `git clone https://github.com/Jiimboeq2/EB-Docs`

## The files

| File | What it is |
| --- | --- |
| [EB_Scripting_Guide.md](EB_Scripting_Guide.md) | THE one file to give an AI: every guide, every tested example in full, the Lua library, the TLOs and the commands (2070 KB). |
| [commands.md](commands.md) | every console command EB ships, by group (192 KB). |
| [examples/](examples/README.md) | the 406 tested examples (22 complete scripts), one .lua file each, with an index. |
| [reference/lua_api.json](reference/lua_api.json) | the reference as data: modules, functions with their parameters and returns, the examples, the topics and the TLOs (2710 KB). |
| [llms.txt](https://eb.jiimbo.dev/llms.txt) | the website's index of these files, in the llms.txt format, for an AI that reads the web; [llms-full.txt](https://eb.jiimbo.dev/llms-full.txt) is the one-file guide again. |

## About the examples

Every example ran end to end on EB's offline stand-in for the game before it was published (verified: fake-host), not in the live game: try one on one box first. A complete script runs as it is. The guide shows a snippet's script, then how it was tested; a real script leaves the offline stand-in and the checks out, and any line of the script that uses `DOCS`, `w.` or `a.` too.

## Where these files come from

They are built from the EB website's docs and EB's reference of 2026-11-25, so they match each other. A fix goes into the docs, and the files are built again.
