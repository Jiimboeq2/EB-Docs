-- Export the command list
--
-- reg:customerSchema() is every shipped command as a plain table; reg:customerJson() is the same as JSON.
--
-- kind:      snippet
-- expect:    The schema's counts match its lists, every row is shipped, and the JSON decodes back to the same count.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry, ebkit.jsontable
-- id:        commands-customer-schema

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
