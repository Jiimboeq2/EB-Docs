-- EB tested example: Top up your ammo from the ammo depot
-- econ-quiver-fill | snippet | topics: items
--
-- What it does:  Count the ammo you hold, work out the shortfall, and pull it with eco.depot:withdraw(name, qty, "ammo"), which
--                opens the ammo depot in reach, withdraws and closes it. eco.inventory:quiver{ ammo, target } answers "blocked"
--                with the reason when no ammo depot is open; in this build its pull step loses the count, so a script withdraws
--                the shortfall itself as shown.
-- Tested:        quiver refuses with no depot open; the withdraw pulls the 150 arrows that make 200.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = { { name = "Fixture Arrow", qty = 50 } }, depots = { ammo = { ["Fixture Arrow"] = 900 } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

-- your script
local s1, why1
for _ = 1, 5 do
    s1, why1 = eco.inventory:quiver({ ammo = "Fixture Arrow", target = 200 })
    if s1 ~= "working" then break end
end
DOCS.eq(s1, "blocked", "no ammo depot open")
DOCS.has(why1, "ammo depot not open", "the reason")

local target, held = 200, 0
for _, it in ipairs(eco.inventory:scan()) do if it.name == "Fixture Arrow" then held = held + it.qty end end
local status
for _ = 1, 20 do
    status = eco.depot:withdraw("Fixture Arrow", target - held, "ammo")
    if status ~= "working" then break end
end
print("arrows: " .. W.bags[1].qty)

-- check
DOCS.eq(status, "done", "withdrawn")
DOCS.eq(W.bags[1].qty, 200, "the target")
DOCS.eq(W.depots.ammo.contents["Fixture Arrow"], 750, "150 came from the depot")
DOCS.check(W.depotOpen == nil, "the depot was closed again")
