-- EB tested example: Hear what the other boxes are doing
-- crew-state-roster | snippet | topics: crew, helpers
--
-- What it does:  Each box broadcasts a small state (zone, mode, health, power, a fight on); every box keeps a roster of it.
-- Tested:        is2 hears is1's state: its zone, health and that it is fighting.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: an offline relay bus between two boxes
local bus = require("eb.relay.events").bus()

-- your script
local Relay = require("eb.relay")
local tank = Relay.new({ box = "is1", name = "Tankard", transport = bus.box("is1") })
local heal = Relay.new({ box = "is2", name = "Mendwell", transport = bus.box("is2") })
tank.join(); heal.join()
local heard = {}
heal.onState(function(boxId, st) heard[#heard + 1] = boxId end)

tank.broadcastState({ name = "Tankard", zone = "a_test_hall", mode = "ic-lead", hp = 64, pw = 90, combat = true })
for _, p in ipairs(heal.boxes()) do
    local st = p.state
    print(("%s: %s hp %d%s"):format(p.box, st.zone, st.hp, st.combat and " FIGHTING" or ""))
end

-- check
DOCS.eq(heard[1], "is1", "is2 heard is1's state")
local st = heal.boxes()[1].state
DOCS.eq(st.hp, 64, "health travels as a number")
DOCS.eq(st.combat, true, "the fight flag")
DOCS.eq(st.mode, "ic-lead", "and the mode")
