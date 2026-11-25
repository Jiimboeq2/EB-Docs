-- EB tested example: The levelling decisions, step by step
-- skill-level-decisions | snippet | topics: items
--
-- What it does:  eb.economy.skilllevel's pure rules: decide() says where a run starts (learn, unreadable, done, book or level);
--                afterRound() says what a finished round comes to (done, again, buy, book or giveup); for Adorning,
--                mostStockedTier() and roundFromStock() plan a round from what is on hand.
-- Tested:        Each case answers as the rules say; the best-stocked Adorning tier is 2 and a round dilutes 5 and distils 4.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script (pure)
local L = require("eb.economy.skilllevel")
local r = function(cur, max) return { ok = true, cur = cur, max = max } end
local starts = {
    L.decide({ learned = false, read = { ok = false } }),                     -- never learned
    L.decide({ learned = true, read = { ok = false } }),                      -- learned, does not read
    L.decide({ learned = true, read = r(100, 100) }),                         -- capped
    L.decide({ learned = true, read = r(10, 100), bandBooksInBags = true }),  -- scribe the band's books first
    L.decide({ learned = true, read = r(50, 100), bookDone = true }),         -- craft the band's rows
}
print("starts: " .. table.concat(starts, ", "))
local again = L.afterRound({ before = r(10, 100), after = r(14, 100) })
local done = L.afterRound({ before = r(97, 100), after = r(100, 100) })
local short = L.afterRound({ before = r(10, 100), after = r(10, 100), missing = true, tripsNoGain = 3 })
local stuck = L.afterRound({ before = r(10, 100), after = r(10, 100), noGain = 1, secs = 300, tierTried = true })
print(("after a gain -> %s; capped -> %s; short -> %s; stuck -> %s"):format(again, done, short, stuck))

local tier = L.mostStockedTier({ { tier = 1, powders = 2, fragments = 30 }, { tier = 2, powders = 5, fragments = 10 } })
local plan = L.roundFromStock(5, 10, 6)

-- check
DOCS.eq(table.concat(starts, ","), "learn,unreadable,done,book,level", "where a run starts")
DOCS.eq(again, "again", "a gain goes again")
DOCS.eq(done, "done", "capped is done")
DOCS.eq(short, "giveup", "short of materials after 3 trips with no gain gives up")
DOCS.eq(stuck, "giveup", "two rounds with no gain give up")
DOCS.eq(tier, 2, "the tier with the most worth on hand")
DOCS.eq(plan.dilute .. "/" .. plan.distil, "5/4", "dilute 5 powders, distil 4")
