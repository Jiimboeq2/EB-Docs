-- EB tested example: Read the built-in help
-- commands-help-lines | snippet | topics: commands
--
-- What it does:  reg:help() lists the domains, reg:help(domain) its commands, reg:help(verb) one command's card.
-- Tested:        The help lists the domains, the nav domain lists follow, and follow's card shows its usage and crew scopes.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local top = reg:help()                         -- { lines }: the domains and how many commands each has
local nav = reg:help("nav")                    -- one domain's commands
local card = reg:help("follow")                -- one command: usage, what it does, its args, aliases, crew scopes
print(card[1])
local usage = reg:usage("follow")
local unknown = reg:help("juggle")

-- check
DOCS.has(top[1], "eb <command>", "the first line says how to type a command")
DOCS.has(table.concat(nav, "\n"), "follow", "the nav domain lists follow")
DOCS.eq(usage, "eb follow [who] [dist]", "the usage line")
DOCS.has(card[#card], "for the crew: eb all|others|to follow", "the card says it can go to the crew")
DOCS.has(unknown[1], "no eb command or domain", "an unknown topic is answered, never an error")
