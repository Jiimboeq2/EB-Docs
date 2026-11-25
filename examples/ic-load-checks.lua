-- What runner:load refuses
--
-- The loader checks an instance file before anything runs: its schema, a hub route that would move the group, an option that skips a step the route does not have, and an encounter file that will not load. Each refusal says why.
--
-- kind:      snippet
-- expect:    Four broken files are refused with their reasons; the fixed file loads with its encounter attached.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-load-checks

local IC = require("eb.ic")
local env = require("instances.lib.icworld").make()           -- offline interfaces (the loader needs none of them)

local function try(inst, encounters)
    env.loadInstance = function() return inst end
    env.loadEncounter = function(_, name)
        local e = encounters and encounters[name]
        if not e then error("encounters/" .. name .. ".lua is missing") end
        return e
    end
    return IC.new(env):load("fixture_hollow")
end

local base = function()
    return { schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
             hub = { zone = "fixture_docks", door = { actor = "a fixture rift", verb = "enter" } },
             route = { { id = "n1", act = "encounter", name = "captain_fixturo" } } }
end
local ENC = { captain_fixturo = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named", phases = {} } }

-- 1. not an eb.ic/1 file
local bad1 = base(); bad1.schema = "something/else"
local _, why1 = try(bad1, ENC)
-- 2. a hub route step that walks the group along (the tank walks the hub route ALONE)
local bad2 = base()
bad2.hub.route = { { id = "h1", act = "path", spots = { { 1, 0, 1 } } },
                   { id = "h2", act = "path", spots = { { 9, 0, 9 } }, group = "follow" } }
local _, why2 = try(bad2, ENC)
print("refused: " .. why2)
-- 3. an option that skips a step id the route does not have
local bad3 = base(); bad3.options = { { id = "skip_bonus", default = true, skip_steps = { "bonus" } } }
local _, why3 = try(bad3, ENC)
-- 4. a route step that calls an encounter with no file
local _, why4 = try(base(), {})

local inst = try(base(), ENC)

DOCS.has(why1, "unknown schema", "the schema is checked")
DOCS.has(why2, "the tank walks the hub route alone", "a hub step may not move the group")
DOCS.has(why3, "which is not a route step", "an option must name real route steps")
DOCS.has(why4, "will not load", "a missing encounter refuses the load")
DOCS.eq(inst and inst._enc.captain_fixturo.name, "Captain Fixturo", "the good file loads with its encounter")
