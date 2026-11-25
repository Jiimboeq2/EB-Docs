-- Accept crafting commissions only from your own people
--
-- eco.commissions:watch() handles a crafting commission another character opened with this box: off by default (left for the player); on (cfg.craft.commissions.enabled) it serves only an allowed requester - your group, as the crew relay reports it, plus cfg names - and declines anyone else, which costs nothing.
--
-- kind:      snippet
-- expect:    A stranger's commission is declined; a group member's is accepted.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.commissions
-- id:        econ-commissions-allow

-- offline stand-in for the game's windows and the crew (in game EB passes its own)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ commission = { from = "Stranger Fixmo", recipe = "Fixture Stew", qty = 1 } })
local relay = { groupState = function() return { members = { { name = "Fixturae" }, { name = "Healwell" } } } end }
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, relay = relay,
    cfg = { craft = { commissions = { enabled = true, allow = "fleet", names = { "Friendo" } } } } })

-- your script
local c = eco.commissions
DOCS.check(c:allowed("Healwell"), "a group member is allowed")
DOCS.check(c:allowed("friendo"), "a listed name is allowed (any case)")
DOCS.check(not c:allowed("Stranger Fixmo"), "anyone else is not")

local s1, what = c:watch()
DOCS.eq(what, "declined", "the stranger's commission is declined")

W.commission = { from = "Healwell", recipe = "Fixture Stew", qty = 1 }
c:watch()                                    -- accepts, then hands the recipe to the craft pillar
for _, line in ipairs(W.log) do print(line) end

-- check
DOCS.eq(s1, "done", "declining is done at once")
DOCS.has(table.concat(W.log, "\n"), "accept commission from Healwell", "the member's commission was accepted")
