-- The utility commands in this release
--
-- Types the utility commands on a booted EB: settings by command (eb set reads a value; eb preset and eb alias list theirs), seeing what EB does (eb debug, eb fps, eb uiscan, eb tlocheck), the timers, the keep-alive and the voice (eb tts) answer at once - eb tts says why when the overlay that speaks is not there - and a script can always use the settings store.
--
-- kind:      snippet
-- expect:    eb set reads what the store holds; every utility command typed answers - none says "does not answer on this box yet". (eb set <key> <value>, eb export, eb dumplog and eb debugreport answer too, but they write the user's own files, and eb grabloc puts down the house item on your cursor in the game, so a doc example does not press them.)
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.util, commands.core
-- id:        commands-utility-commands

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script
local store = require("eb.platform").settings()             -- the settings store a script uses directly
store.set("myhelper.enabled", true)
local okSet, readBack = eb.dispatch("eb set myhelper.enabled")
local answered = { "eb preset", "eb alias", "eb debug", "eb fps", "eb afk status", "eb timer list", "eb tts", "eb uiscan",
                   "eb tlocheck" }
local okCount = 0
for _, line in ipairs(answered) do
    local ok, text = eb.dispatch(line)
    if not tostring(text):find("does not answer on this box yet", 1, true) then okCount = okCount + 1 end
end
print("eb set myhelper.enabled -> " .. tostring(readBack))

-- check
DOCS.check(okSet, "eb set answers")
DOCS.has(readBack, "myhelper.enabled = on", "and reads what the store holds")
DOCS.eq(okCount, #answered, "every utility command typed answers")
DOCS.eq(store.get("myhelper.enabled"), true, "the store holds the value for this session")
a.stop()
