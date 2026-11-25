-- Answer the economy's commands from your own economy
--
-- eb.economy.commands attaches the economy's command handlers to a registry for an economy you built: rows() are the command rows it needs, handlers(eco) the handler table, attach(reg, eco) declares any row the registry lacks and attaches every handler.
--
-- kind:      snippet
-- expect:    After attach, "eb tse" runs the economy's bulk transmute and is refused with its reason (no T.S.E is set up, so the pick names nothing), and "eb tse give" is understood and asks for the leader's name.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.commands, eb.economy, eb.registry
-- id:        econ-commands-layer

-- offline: an economy over the offline stand-in, and a fresh command registry
local CW = require("crafting.lib.craftworld")
local eco = CW.economy(CW.world())
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))

-- your script
local Commands = require("eb.economy.commands")
local ids = {}
for _, row in ipairs(Commands.rows()) do ids[#ids + 1] = row.id end
local ok, why = Commands.attach(reg, eco)
local okT, text = reg:dispatch("eb tse")
print(("eb tse -> %s: %s"):format(tostring(okT), text))
local okG, textG = reg:dispatch("eb tse give")

-- check
DOCS.eq(ok, true, "attached (" .. tostring(why) .. ")")
local have = {}
for _, id in ipairs(ids) do have[id] = true end
DOCS.check(have["depot.ledger"] and have["depot.tse"] and have["gear.gearset"] and have["gear.unadorn"],
    "the rows it carries: the ledger, the T.S.E and the gear sets among them")
DOCS.check(type(Commands.handlers(eco)["depot.tse"]) == "function", "the handler table")
DOCS.eq(okT, false, "the bulk transmute refused an empty pick")
DOCS.has(text, "no saved T.S.E", "and says why: nothing is set up to take")
DOCS.eq(okG, false, "give needs the leader's name")
DOCS.has(textG, "needs the leader's name", "and says so")
