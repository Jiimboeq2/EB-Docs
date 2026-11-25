-- EB tested example: Export the command list
-- commands-customer-schema | snippet | topics: commands, data
--
-- What it does:  reg:customerSchema() is every shipped command as a plain table; reg:customerJson() is the same as JSON.
-- Tested:        The schema's counts match its lists, every row is shipped, and the JSON decodes back to the same count.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local J = require("ebkit.jsontable")
local doc = reg:customerSchema()
print(("%d commands in %d domains"):format(doc.counts.commands, doc.counts.domains))
local back = assert(J.decode(reg:customerJson()))
local allShipped = true
for _, c in ipairs(doc.commands) do if c.ship ~= "shipped" then allShipped = false end end

-- check
DOCS.eq(doc.schema, "eb.command-schema/1", "the schema name")
DOCS.eq(doc.counts.commands, #doc.commands, "the count matches the list")
DOCS.check(doc.counts.commands > 100, "a full command list")
DOCS.check(allShipped, "only shipped rows")
DOCS.eq(#back.commands, #doc.commands, "the JSON decodes back to the same rows")
