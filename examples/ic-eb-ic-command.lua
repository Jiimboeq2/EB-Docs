-- eb ic from the console and from a script
--
-- On a running box, eb ic run / loop / stop / status drive the instance runner as an EB task. Type the line, or call the same launcher from a script through eb.app.ic: status says what runs, a file name that is not installed is refused with the reason.
--
-- kind:      snippet
-- expect:    eb ic status answers idle; an unknown IC name is refused and nothing starts.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.app.ic
-- id:        ic-eb-ic-command

-- offline stand-in: EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- the console line
local status = a.console("eb ic status")
print(status)
-- the same launcher from a script: the app's `eb ic` object
local IC = a.app.ic
local ok, why = IC.launch({ cmd = "run", zone = "fixture_nowhere" })
local where, notFound = IC.find("fixture_nowhere")

DOCS.has(status, "ic: idle", "nothing is running")
DOCS.eq(ok, false, "an IC that is not installed is refused")
DOCS.has(why, "no IC called 'fixture_nowhere'", "with the reason")
DOCS.eq(where, nil, "find answers nil for it")
DOCS.has(notFound, "eb ic list", "and points at the list")
DOCS.eq(IC.run, nil, "no run was started")
a.stop()
