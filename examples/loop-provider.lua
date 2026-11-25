-- EB tested example: Build a loop's provider and see what is missing
-- loop-provider | snippet | topics: tasks, helpers
--
-- What it does:  A chore loop acts through an activities provider: overseer, trainer, mercenary and city-writ drivers plus the
--                economy's writs and collections. eb.loops.providers.build fills every verb you do not supply with a stub that
--                says "needs a live window" the first time it is hit, so a loop runs end to end while you bring a driver up; gaps
--                lists what is still missing.
-- Tested:        The partial trainer driver validates as incomplete, the gaps list names its missing verbs, and a stubbed verb
--                reports itself once.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Providers = require("eb.loops.providers")
local Interface = require("eb.loops.interface")

-- a trainer driver that can only read points so far
local partial = { points = function() return { training = 2, aa = 0 } end }
local notes = {}
local provider = Providers.build({ trainer = partial, note = function(m) notes[#notes + 1] = m end })

local ok, missing = Interface.validate("trainer", partial)
local gaps = Providers.gaps({ trainer = partial })
local st, why = provider.trainer.train("t1")                    -- a stub: blocked, and it says so once
provider.trainer.train("t1")
print(notes[1])

DOCS.eq(ok, false, "the partial driver is not complete")
DOCS.check(#missing >= 5, "validate lists every missing verb")
DOCS.check(table.concat(gaps, " "):find("trainer.train", 1, true) ~= nil, "gaps names trainer.train")
DOCS.eq(provider.trainer.points().training, 2, "the real verb is kept")
DOCS.eq(st, "blocked", "a stubbed action reports blocked")
DOCS.has(why, "no trainer window", "with the reason")
DOCS.eq(#notes, 1, "and notes the gap once, not every tick")
