-- Drive the console from a script
--
-- eb.console is the console window's model: scoped lines through the relay, history, search and completion.
--
-- kind:      snippet
-- expect:    A scoped line goes to the crew and the other box's dispatcher runs it; history and search see it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.console, eb.relay, eb.relay.events
-- id:        crew-console-model

-- offline stand-in: an offline relay bus between two boxes
local bus = require("eb.relay.events").bus()

-- your script
local Relay, Console = require("eb.relay"), require("eb.console")
local function box(id, name)
    local ran = {}
    local R = Relay.new({ box = id, name = name, transport = bus.box(id) })
    local C = Console.new({ relay = R, box = id, name = name,
        dispatch = function(line) ran[#ran + 1] = line; return true, "ran " .. line end })
    R.join()
    return C, ran
end
local c1, ran1 = box("is1", "Tankard")
local _, ran2 = box("is2", "Mendwell")
local _, answer = c1.run("others pause")
print(answer)
c1.run("boxes")                                   -- a console verb, answered right here
local hits = c1.search("pause")
local comp = c1.complete("to ")

-- check
DOCS.eq(#ran2, 1, "the other box ran it")
DOCS.eq(#ran1, 0, "others never runs on the sender")
DOCS.eq(c1.historyList()[1], "others pause", "the typed line is in the history")
DOCS.check(#hits >= 1, "search finds it in the output")
DOCS.check(#comp.candidates >= 2, "after 'to' the console offers box ids and archetypes")
