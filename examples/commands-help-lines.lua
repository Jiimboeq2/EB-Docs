-- Read the built-in help
--
-- reg:help() lists the domains, reg:help(domain) its commands, reg:help(verb) one command's card.
--
-- kind:      snippet
-- expect:    The help lists the domains, the nav domain lists follow, and follow's card shows its usage and crew scopes.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-help-lines

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
