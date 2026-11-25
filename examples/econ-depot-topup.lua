-- Restock from the depot with one list for the whole group
--
-- A restock row says how many to KEEP in the bags and who it is for; each box takes only its own rows and pulls just the shortfall from the right depot (food, ammo, fuel, harvest). eco.depot:planLines shows the plan, and the brain's restock(list) (or eco.depot:topUp) runs it. It never buys anything.
--
-- kind:      snippet
-- expect:    The warden skips the ranger's arrows and pulls 15 bread to reach 20.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.depot, eb.economy.vendor
-- id:        econ-depot-topup

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = { { name = "Fixture Bread", qty = 5 } },
                       depots = { food = { ["Fixture Bread"] = 50 }, ammo = { ["Fixture Arrow"] = 900 } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })   -- me: a warden

-- your script: one list, shared by every box of the group
local rows = {
    { name = "Fixture Arrow", qty = 200, who = "ranger" },    -- only a ranger takes this row
    { name = "Fixture Bread", qty = 20 },                      -- everyone keeps 20
}
local lines, notMine = eco.depot:planLines(rows)
DOCS.eq(#lines, 1, "one line for this box")
DOCS.eq(notMine, 1, "the ranger's row is not mine")
DOCS.eq(lines[1].kind, "food", "bread comes from the food depot")

local status
for _ = 1, 20 do
    status = eco:contract().restock(rows)
    if status ~= "working" then break end
end
local bread = 0
for _, it in ipairs(W.bags) do if it.name == "Fixture Bread" then bread = it.qty end end
print("bread: " .. bread)

-- check
DOCS.eq(status, "done", "the restock finished")
DOCS.eq(bread, 20, "topped up to the target")
DOCS.eq(W.depots.food.contents["Fixture Bread"], 35, "15 came out of the depot")
DOCS.eq(W.depots.ammo.contents["Fixture Arrow"], 900, "the arrows were left for the ranger")
