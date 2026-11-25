-- EB tested example: Load your ability book once
-- game-load-book | snippet | topics: game, combat, perf
--
-- What it does:  LoadAbilities() reads the knowledge book once, in small rounds, while the game fetches each ability's details
--                from the server; FindAbility() then answers by name with no further read.
-- Tested:        Loads the three fixture abilities inside a task, then finds one by name with its cast time from the book.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addAbility({ id = 5001, name = "Fixture Strike", ready = true, castTime = 0.5 })
w.addAbility({ id = 5002, name = "Fixture Ward", ready = true, castTime = 1 })
w.addAbility({ id = 5003, name = "Fixture Mend", ready = false, secondsUntilReady = 4, castTime = 2 })

-- your script: the load waits between rounds, so it runs inside a task (call it once, at start-up)
local game = require("eb.platform").game()
w.task(function() game.LoadAbilities(30, 5, 25) end)       -- timeout s, stall s, abilities per round
local have, total = game.BookCounts()
local strike = game.FindAbility("Fixture Strike")
print(("book: %d of %d loaded; %s casts in %.1f s"):format(have, total, strike.name, strike.castTime))

-- check
DOCS.eq(have, 3, "every ability whose details arrived")
DOCS.eq(game.BookIncomplete(), false, "nothing is missing")
DOCS.eq(strike.id, 5001, "the book knows its id")
DOCS.eq(#game.AbilityLines(), 3, "three ability lines")
