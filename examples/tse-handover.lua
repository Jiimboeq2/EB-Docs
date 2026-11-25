-- The T.S.E hand-over: a member gives its pick to the leader
--
-- At the zone's end, inside, each member hands its T.S.E pick to the leader before the leader's pass: twelve items to a trade, leaving out what cannot change hands and anything wished for in a loot roll. The give is a pollable job; when it ends the member's answer tells the leader it is finished.
--
-- kind:      snippet
-- expect:    The heirloom and the wished-for mantle stay; the two tradeable lines go in one trade; the member answers done.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.tse
-- id:        tse-handover

local TSE = require("eb.economy.tse")                        -- its plan helpers; the pillar itself comes from the economy

-- offline stand-in for the game's side of the economy: the bags, the trade window, the group (every name invented)
local bags = {
    { id = 1, name = "a fixture bracer", qty = 1 }, { id = 2, name = "a fixture ring", qty = 2 },
    { id = 3, name = "a fixture heirloom", qty = 1, heirloom = true }, { id = 4, name = "a wished-for mantle", qty = 1 },
}
local added = {}
local eco = require("eb.economy").new({                      -- EB builds this once per box; the T.S.E is eco.tse
    cfg = {}, now = function() return 1000 end, log = function() end,
    relay = { groupState = function() return { members = { { name = "Leaderio" }, { name = "Memberino" } } } end },
    drive = {
        ["bags.items"] = function() return bags end,
        ["trade.near"] = function(to) return to == "Leaderio" end,
        ["trade.open"] = function() return "done" end,
        ["trade.add"] = function(id, qty) added[#added + 1] = id .. "x" .. qty end,
        ["trade.accept"] = function() return "done" end,
        ["trade.state"] = function() return { theyAccepted = true } end,   -- the leader accepted (a gone trade is never counted)
    },
})

-- your script: the member's side (call give every tick until it is not "working")
local tse = eco.tse
local wished = { ["a wished-for mantle"] = true }
local status
for _ = 1, 5 do
    status = tse:give({ to = "Leaderio", items = bags, wished = wished })
    if status ~= "working" then break end
end
local answer = tse:answer()
print(("gave %d line(s) to Leaderio: %s"):format(answer.given, answer.state))

-- check
DOCS.eq(status, "done", "the hand-over finished")
DOCS.eq(table.concat(added, ","), "1x1,2x2", "the bracer and both rings went over; the heirloom and the mantle stayed")
DOCS.check(select(1, tse:mayGive("Leaderio")), "a group member may receive the pick")
DOCS.eq(#TSE.plan.packs(TSE.plan.merge({ { name = "a fixture shard", qty = 1 } }), 12), 1, "a small pick is one trade")
DOCS.eq(#tse:givePick(bags, wished), 2, "givePick leaves out what cannot or should not change hands")
DOCS.check(TSE.plan.allAnswered({ "Memberino" }, { Memberino = answer.at }, 500), "the leader sees every member answered")
