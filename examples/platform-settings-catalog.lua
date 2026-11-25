-- EB tested example: Read the settings catalog
-- platform-settings-catalog | snippet | topics: ui, data, settings
--
-- What it does:  The settings window's catalog as data: a setting's label and range, its default, what one + press gives, how it
--                prints, and what "Apply to All" shows when the characters differ.
-- Tested:        followDistance defaults to the middle of 2..40 (21m), steps to 7 from 6, reads mixed for two characters who
--                differ; the instance preset sets it to 6.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local S = require("eb.ui.settings.settings")
local it = S.item("followDistance")
local def = S.defaultOf(it)
local nextOne = S.step(it, 6, 1)
local values = { Tankard = { followDistance = 6 }, Mendwell = { followDistance = 8 } }
local chars = { "Tankard", "Mendwell" }
local all = S.valueFor(values, "All", "followDistance", chars)
local preset = S.preset("instance")
print(("%s = %s; 6 -> %d; All reads %s; instance preset %d"):format(it.label, S.format(it, def), nextOne,
    S.format(it, all), preset.settings.followDistance))

-- check
DOCS.eq(it.unit, "m", "a distance in metres")
DOCS.eq(S.snap(it, 6.4), 6, "snap keeps a number on its step (and whole)")
DOCS.eq(S.snap(it, 99), 40, "and inside its range")
DOCS.eq(all, S.MIXED, "the two characters differ")
DOCS.eq(S.baseValue(values, "All", "followDistance", chars), 6, "a press starts from the first character's value")
DOCS.eq(#S.targets(it, "Tankard", chars), 1, "Apply to one character reaches only that one")
DOCS.eq(S.step(S.item("autoLoot"), true, 1), false, "a switch flips")
DOCS.eq(S.defaults().autoLoot, false, "a switch defaults to off")
