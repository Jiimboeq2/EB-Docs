-- EB tested example: InnerSpace's own reads: session, extensions, the window, the folder
-- tlo-innerspace-basics | snippet | topics: tlos, helpers
--
-- What it does:  ${Session} names this InnerSpace session, Extension[name](exists) says whether an extension is loaded,
--                Display.Foreground whether this window has the focus, and LavishScript.HomeDirectory where InnerSpace runs from
--                - build paths from it, never hard-code one.
-- Tested:        The session is is1, ISXEQ2 is loaded and an absent extension reads NULL; the folder is known.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
