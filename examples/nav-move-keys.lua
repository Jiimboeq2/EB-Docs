-- Hold, tap and release the movement keys
--
-- eb.move holds a key by its role and sends a key command only when its state changes; tap presses once; the group's swim-up hold survives every stop until it is released; headings convert between EB's and the game's.
--
-- kind:      snippet
-- expect:    A second hold of a held key sends nothing; stop() lets go of forward but keeps the latched swim-up.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.move
-- id:        nav-move-keys

-- offline stand-in for the game (only the docs runner has DOCS; in game the keys reach the game client)
local w = DOCS.world()

-- your script
local move = require("eb.move")
local first = move.hold("forward", true)        -- sent
local second = move.hold("forward", true)       -- already held: nothing is sent
print(move.status())
move.tap("jump")                                -- one press and release
move.swimHold(true)                             -- the group's swim-up hold before a water fight
move.stop()                                     -- lets go of forward; the latched swim-up stays down
local afterStop = move.held("forward")
local latched = move.swimHeld()
move.swimHold(false)
local game90 = move.toGameHeading(90)           -- EB faces +X at 90; the game counts half a turn further

-- check
DOCS.eq(first, true, "holding forward sent a key command")
DOCS.eq(second, false, "holding it again sent nothing")
DOCS.eq(afterStop, false, "stop() let forward go")
DOCS.eq(latched, true, "the group's swim-up hold survived the stop")
DOCS.eq(move.swimHeld(), false, "until it was released")
DOCS.eq(game90, 270, "EB's 90 is the game's 270")
DOCS.eq(move.fromGameHeading(game90), 90, "and back")
