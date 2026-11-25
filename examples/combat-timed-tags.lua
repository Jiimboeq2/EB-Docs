-- EB tested example: Timed tags and a pre-cast
-- combat-timed-tags | snippet | topics: combat, fights
--
-- What it does:  An allow row casts only while its tag is raised, an embargo row is held while its tag is raised, and a pre-cast
--                goes out right before the ability it belongs to - all on the engine's own clock.
-- Tested:        The burn row waits for its tag, casts while it is raised for 2 seconds, and waits again after; the slow row
--                stays held while SLOW is raised; Fixture Focus goes out right before Fixture Strike.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Burn", "Fixture Slow", "Fixture Strike", "Fixture Focus" })
FW.recastOnUse(w, 10)                                      -- the game shows each cast as taken: the ability goes on its reuse
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Burn", ability = "Fixture Burn", group = "dps", tags = "CA", priority = 99, gates = {},
      allowTag = "BURN" },                                   -- casts only while BURN is raised
    { name = "Fixture Slow", ability = "Fixture Slow", group = "dps", tags = "CA", priority = 98, gates = {},
      embargoTag = "SLOW" },                                 -- held while SLOW is raised
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {},
      precast = "Fixture Focus" },                           -- cast Fixture Focus right before it
} })
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = stack })
local burn, slow = stack.get("Fixture Burn"), stack.get("Fixture Slow")

local before = engine:timedTagFail(burn)                   -- "ATagOff": BURN is not raised
engine:raiseTag("SLOW", 5)                                 -- another box asked everyone to hold the slow
local slowHeld = engine:timedTagFail(slow)
engine:tagFor("BURN", 2, "Allow")                          -- open the burn rows for 2 seconds
local d1 = engine:step()                                   -- the burn goes out
w.runFor(2100)
local d2 = engine:step()                                   -- BURN has ended (the engine's timer); Strike's pre-cast first
w.runFor(500)                                              -- a quick art goes out at most every half second
local d3 = engine:step()                                   -- then Strike itself
local after = engine:timedTagFail(burn)
local pre = engine:precastFor("Fixture Strike", stack.get("Fixture Strike"))
print("casts: " .. table.concat(FW.casts(w), ", "))

-- check
DOCS.eq(before, "ATagOff", "an allow row waits for its tag")
DOCS.eq(slowHeld, "Embargoed", "an embargo row is held while its tag is raised")
DOCS.eq(d1.ability, "Fixture Burn", "the allow row casts while its tag is raised")
DOCS.eq(d2.kind, "precast", "the pre-cast goes first")
DOCS.eq(d2.ability, "Fixture Focus", "it is the ability the entry names")
DOCS.eq(d3.ability, "Fixture Strike", "then the main ability")
DOCS.eq(after, "ATagOff", "the burn waits again once its window ended")
DOCS.eq(engine:tagLive("SLOW"), true, "SLOW is still raised (5 seconds)")
DOCS.eq(pre, "Fixture Focus", "the pre-cast the engine looks up")
