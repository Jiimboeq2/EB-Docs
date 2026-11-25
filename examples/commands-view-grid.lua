-- Build a button row from the registry
--
-- reg:view(filter) lists the shipped commands of a domain in schema order: an allow-list for a window.
--
-- kind:      snippet
-- expect:    The nav view lists follow; an alias finds its command; a fresh registry reports what is not wired yet.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-view-grid

-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local buttons = {}
for _, row in ipairs(reg:view({ domain = "nav" })) do
    buttons[#buttons + 1] = { label = row.verb, line = "eb " .. row.verb, help = row.desc }
end
local row = reg:command("ah")                     -- a verb, an alias or a "<domain>.<verb>" id, any case
print(("ah -> %s"):format(row.id))
local byId = reg:command("NAV.FOLLOW")
local notWired = reg:unattached({ domain = "nav" })   -- a fresh registry: no handler attached yet

-- check
local labels = {}
for _, b in ipairs(buttons) do labels[b.label] = true end
DOCS.check(labels.follow and labels.walk, "the nav row has follow and walk")
DOCS.eq(row.verb, "autohunt", "the alias found the command")
DOCS.eq(byId.verb, "follow", "an id finds it too, any case")
DOCS.eq(#notWired, #buttons, "nothing is wired in a fresh registry")
