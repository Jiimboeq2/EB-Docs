-- EB tested example: Read the items in an open loot window
-- tlo-loot-items | snippet | topics: tlos, items, loot
--
-- What it does:  LootWindow.NumItems and LootWindow.Item[n].Name read an OPEN loot window. Read them only after the game's loot
--                event (or game.LootWindow()) says one is up: asking with none open is slow.
-- Tested:        Waits for game.LootWindow() to report the window, then reads both item names in one read.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local game = require("eb.platform").game()
game.LootWindow()                                  -- (EB's own watch is listening for the loot event)
w.setWindow("loot", { type = "Lotto", items = { { name = "a fixture pelt" }, { name = "a fixture fang" } } })
w.host:fire("EQ2_onLootWindowAppeared", "1001")

-- your script
game.BeginTick()
local lw = game.LootWindow()                       -- nil while no loot window is up: no read is made
local names = {}
if lw and lw.items and lw.items > 0 then
    local seqParts = {}
    for i = 1, lw.items do seqParts[i] = "${LootWindow.Item[" .. i .. "].Name}" end
    for v in (IS.Parse(table.concat(seqParts, "|")) .. "|"):gmatch("([^|]*)|") do names[#names + 1] = v end
end
print(("%s: %s"):format(lw.type, table.concat(names, ", ")))

-- check
DOCS.eq(lw.type, "Lotto", "the window type")
DOCS.eq(#names, 2, "both names in one read")
