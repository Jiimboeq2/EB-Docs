-- A loot helper: read the window, apply the rules, take the lot
--
-- When the game reports a loot window, read its type and item names, let the loot rules decide, and take everything only when every item is wanted.
--
-- kind:      snippet
-- expect:    The LootOpened event arrives, both items are wanted, and the helper sends Loot All.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.lootrules, game, eb.events
-- id:        econ-loot-from-window

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()               -- in game EB's boot has already attached the game's events and ticks them

-- your script
local LR = require("eb.economy.lootrules")
local game = require("eb.platform").game()
local rules = LR.parse({ fallback = "leave", rules = { { match = "contains", item = "fixture", act = "greed" } } })
local said
events.on("LootOpened", function()
    game.NoteLoot()                                       -- tell the game layer's loot watch a window is up
    local lw = game.LootWindow()
    if not (lw and (lw.items or 0) > 0) then return end
    local items = {}
    for i = 1, lw.items do items[i] = { name = game.GetVar("LootWindow.Item[" .. i .. "].Name", "") } end
    local d = LR.decideWindow(rules.rules, rules.opts, items, LR.parseWin(lw.type), { me = game.Me().name })
    if d.act == "lootall" then
        game.Execute("LootWindow:LootAll")
        said = ("looted %d items (%s)"):format(#items, LR.actText(d.act))
        print(said)
    end
end)

-- a corpse is opened: the window appears and the game raises its loot event
w.setWindow("loot", { type = "Free For All", items = { { name = "a fixture pelt" }, { name = "a fixture fang" } } })
w.host:fire("EQ2_onLootWindowAppeared", "1001")
w.frame(2)

-- check
DOCS.check(said ~= nil, "the helper ran")
local last = w.world.actions[#w.world.actions]
DOCS.eq(last and last.kind, "lootall", "Loot All went out")
