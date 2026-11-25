-- EB tested example: Press EB Main's buttons from a script
-- ui-control-presses | snippet | topics: ui, commands
--
-- What it does:  eb.control is what EB Main and the mini press through: summary and toggles for what they show, act for a press -
--                each press becomes a command line through the one registry.
-- Tested:        The pause press pauses the brain and the toggle shows it; the start press resumes; a verb with no action says
--                not wired yet.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script
local before = eb.control.summary()
local ok = eb.control.act("pause", { on = true })
local tg = eb.control.toggles()
local okNo, why = eb.control.act("loot")
eb.control.act("start")                                  -- start = eb resume (a pause-off press does not resume yet)
print(("running %s, paused %s -> pause on: %s"):format(tostring(before.running), tostring(before.paused),
    tostring(tg.pause)))

-- check
DOCS.check(ok, "the pause press went through the registry")
DOCS.eq(tg.pause, true, "the toggle shows the pause")
DOCS.eq(okNo, false, "a verb with no action is refused")
DOCS.has(why, "not wired yet", "and says why")
DOCS.eq(a.app.brain.paused, false, "the start press resumed")
a.stop()
