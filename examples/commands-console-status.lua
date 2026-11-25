-- Type an eb command
--
-- Boot EB for InnerSpace offline and run console lines through the one command registry.
--
-- kind:      snippet
-- expect:    eb status crew answers with this box's crew line; a word that is not a command is refused plainly.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry, eb.app
-- id:        commands-console-status

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- your script: lines exactly as you type them in the InnerSpace console
local said = a.console("eb status crew")
print(said)
local refused = a.console("eb dance")

-- check
DOCS.has(said, "crew: box is1", "eb status crew names this box")
DOCS.has(refused, "refused", "a word that is not a command is refused")
a.stop()
DOCS.check(a.said("EB stopped"), "eb stop ends EB")
