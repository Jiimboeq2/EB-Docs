-- Press EB Main's buttons from a script
--
-- eb.control is what EB Main and the mini press through: summary and toggles for what they show, act for a press - each press becomes a command line through the one registry.
--
-- kind:      snippet
-- expect:    The pause press pauses the brain and the toggle shows it; the start press resumes; a verb with no action says not wired yet.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.windows
-- id:        ui-control-presses

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
