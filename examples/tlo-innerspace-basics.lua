-- InnerSpace's own reads: session, extensions, the window, the folder
--
-- ${Session} names this InnerSpace session, Extension[name](exists) says whether an extension is loaded, Display.Foreground whether this window has the focus, and LavishScript.HomeDirectory where InnerSpace runs from - build paths from it, never hard-code one.
--
-- kind:      snippet
-- expect:    The session is is1, ISXEQ2 is loaded and an absent extension reads NULL; the folder is known.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-innerspace-basics

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local game = require("eb.platform").game()
local raw = IS.Parse("${Extension[ISXEQ2](exists)}|${Extension[ISXNoSuchThing](exists)}|${Display.Foreground}")
local loaded, missing, front = raw:match("^([^|]*)|([^|]*)|([^|]*)$")
print(("session %s, ISXEQ2 %s, missing %s, front %s"):format(game.SessionName(), loaded, missing, front))
local home = IS.Parse("${LavishScript.HomeDirectory}")
local myFile = home and (home .. "/Scripts/my_helper_notes.txt")     -- a path built from it, not typed in

-- check
DOCS.eq(game.SessionName(), "is1", "this session's name")
DOCS.eq(missing, "NULL", "an extension that is not loaded reads NULL, never FALSE")
DOCS.check(type(home) == "string" and #home > 0, "the folder is known")
DOCS.check(myFile:sub(1, #home) == home, "and paths are built from it")
