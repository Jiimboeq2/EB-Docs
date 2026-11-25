-- EB tested example: Read several Me members in ONE read
-- tlo-me-batched-read | snippet | topics: tlos, perf
--
-- What it does:  A data sequence with several ${} in it is ONE game read, however many members it names. Batch the members you
--                need into one IS.Parse instead of one read each.
-- Tested:        One read answers four members; the values arrive as text and are converted with tonumber.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { healthPct = 64, powerPct = 80 } })

-- your script (EB for InnerSpace: IS is ISXLUA's bridge; the game layer's Me() already batches these for you)
local before = w.host.stats.parse
local raw = IS.Parse("${Me.Health}|${Me.Power}|${Me.Level}|${Me.SubClass}")
local hp, power, level, sub = raw:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)$")
hp, power, level = tonumber(hp), tonumber(power), tonumber(level)      -- every answer is text
print(("hp %d power %d level %d %s in %d read"):format(hp, power, level, sub, w.host.stats.parse - before))

-- check
DOCS.eq(w.host.stats.parse - before, 1, "four members, one read")
DOCS.eq(hp, 64, "Health is a percent")
DOCS.eq(sub, "warden", "SubClass")
DOCS.eq(level, require("eb.platform").game().Me().level, "the same answer the game layer gives")
