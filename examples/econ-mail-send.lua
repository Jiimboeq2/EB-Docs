-- EB tested example: Mail items and coin to another character
-- econ-mail-send | snippet | topics: items, crew
--
-- What it does:  eco.mail:send(to, { names | filter, count, copper }) needs a recipient (one character name) and an explicit pick
--                - it never mails "everything". Bound items cannot be mailed and protected items stay unless named exactly and
--                allowed. One item per letter; the coin rides on the first letter.
-- Tested:        A two-word recipient and an empty pick are refused; the ore and 500 copper go out in one letter.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = { { name = "Fixture Ore", qty = 30 }, { name = "Fixture Bound Ring", noTrade = true } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

-- your script: what a send refuses
local p1, why1 = eco.mail:sendPlan("Friendo Fixwell", { names = { "Fixture Ore" } })
DOCS.check(p1 == nil and why1:find("one character name"), "a recipient is one name")
local p2, why2 = eco.mail:sendPlan("Friendo", {})
DOCS.check(p2 == nil and why2:find("name the items"), "a send names what it mails")
local picked, kept = eco.mail:sendPlan("Friendo", { names = { "Fixture Ore", "Fixture Bound Ring" } })
DOCS.eq(#picked, 1, "the ore can go")
DOCS.eq(kept[1].why, "bound (cannot be mailed)", "the bound ring cannot")

-- the send itself: called once a tick until it is done
local status
for _ = 1, 30 do
    status = eco.mail:send("Friendo", { names = { "Fixture Ore" }, copper = 500 })
    if status ~= "working" then break end
end
for _, line in ipairs(W.log) do print(line) end

-- check
DOCS.eq(status, "done", "mailed")
local letter = W.mail.sent[1]
DOCS.eq(letter.to, "Friendo", "to the recipient")
DOCS.eq(letter.items[1].name, "Fixture Ore", "the ore attached")
DOCS.eq(letter.coin, 500, "with the coin")
