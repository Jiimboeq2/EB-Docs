-- A moment after this, if that follows
--
-- A rule with a delay and a follow-up gate: act only when a second line comes within the window ("require"), or only when it does NOT ("block").
--
-- kind:      snippet
-- expect:    The require rules act when their follow-up line arrives; the block rule acts only when its window passes quietly.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.coord.rules
-- id:        coord-delay-and-gate

-- your script
local Coord = require("eb.coord.rules")
local now = 0
local coord = Coord.new({ me = { box = "is1", name = "Fixturae", role = "healer" }, clock = function() return now end })
local did = {}
coord:onIntent(function(it) did[#did + 1] = it.ability end)

-- 1. "Beware", then 500 ms later, if "flames" is said within 3 s: ward the group
coord:add({ id = "ward", trigger = { kind = "chat", match = "Beware" }, delayMs = 500,
            gate = { kind = "chat", match = "flames", withinMs = 3000, mode = "require" },
            action = { kind = "cast", ability = "Fixture Ward" }, scope = "self" })
-- 2. "rumbles": stand still if "calms" follows within 2 s, dodge if it does not
coord:add({ id = "stand", trigger = { kind = "chat", match = "rumbles" },
            gate = { kind = "chat", match = "calms", withinMs = 2000, mode = "require" },
            action = { kind = "cast", ability = "Fixture Stand" }, scope = "self" })
coord:add({ id = "dodge", trigger = { kind = "chat", match = "rumbles" },
            gate = { kind = "chat", match = "calms", withinMs = 2000, mode = "block" },
            action = { kind = "cast", ability = "Fixture Dodge" }, scope = "self" })

coord:feed({ kind = "chat", text = "Beware the fixture!" })
now = 600; coord:tick()                                   -- the delay is up: the gate opens
coord:feed({ kind = "chat", text = "Fixture flames rise" })
local afterWard = #did

coord:feed({ kind = "chat", text = "The floor rumbles" })    -- this time the calm line follows
now = 1200; coord:feed({ kind = "chat", text = "The floor calms" })
now = 4000; coord:tick()
local afterCalm = #did

coord:feed({ kind = "chat", text = "The floor rumbles" })    -- and this time it does not
now = 7000; coord:tick()                                  -- the 2 s window passed quietly
print("casts in order: " .. table.concat(did, ", "))

-- check
DOCS.eq(afterWard, 1, "the ward went up when its follow-up line came")
DOCS.eq(afterCalm, 2, "the calm line let stand act and held dodge back")
DOCS.eq(did[3], "Fixture Dodge", "with no calm line, dodge acted when its window closed")
DOCS.eq(#did, 3, "nothing else acted")
