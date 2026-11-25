-- Give the followers an order
--
-- The lead sends an order with crew.order, a follower answers it with crew.onOrder; boxes hear each other.
--
-- kind:      snippet
-- expect:    The follower gets the lead's camp order with its arguments and the sender's box id; each box hears the other. A crew line from a box that has not said who it is waits for that box's state, so each box ticks first.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.crew, eb.relay, eb.relay.events
-- id:        crew-orders

-- offline stand-in: an offline relay bus between two boxes and a clock you step
local bus = require("eb.relay.events").bus()
local t = { now = 0 }

-- your script
local Relay, Crew = require("eb.relay"), require("eb.app.crew")
local function box(id, name)
    local R = Relay.new({ box = id, name = name, transport = bus.box(id), clock = function() return t.now end })
    local crew = Crew.new({ relay = R, now = function() return t.now end,
        me = function() return { name = name, zone = "a_test_hall", mode = "idle", hp = 100, pw = 100 } end })
    R.join()
    return crew
end
local lead, follower = box("is1", "Tankard"), box("is2", "Mendwell")
local got
follower.onOrder("camp", function(args, env) got = { args = args, from = env.from } end)

lead.tick(t.now); follower.tick(t.now)                     -- EB runs tick() as a pulse job: each box says who it is
lead.order("to is2", "camp", { "12.5", "0", "-40" })      -- travels as a crew line, never as an eb command
print(("is2 got camp %s from %s"):format(got and got.args or "?", got and got.from or "?"))

-- check
DOCS.eq(got.args, "12.5 0 -40", "the order's arguments")
DOCS.eq(got.from, "is1", "and who sent it")
DOCS.eq(#lead.peers(), 1, "the lead hears one other box")
DOCS.eq(follower.nameOf("is1"), "Tankard", "a box learns the others' characters from their state")
DOCS.check(follower.isMe("is2") and not follower.isMe("is3"), "isMe answers for this box only")
