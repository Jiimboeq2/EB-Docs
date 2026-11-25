-- EB tested example: Build a button row from the registry
-- commands-view-grid | snippet | topics: commands, ui
--
-- What it does:  reg:view(filter) lists the shipped commands of a domain in schema order: an allow-list for a window.
-- Tested:        The nav view lists follow; an alias finds its command; a fresh registry reports what is not wired yet.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
