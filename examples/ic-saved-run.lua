-- Save a run and resume it at a step
--
-- runner:saveRun snapshots a configured run (file, difficulty, loop window, chores, a resume pointer = a route step id, and the reuse timer) as a plain record. Store it however you like; runner:resumeRun restores it and starts at the pointer.
--
-- kind:      snippet
-- expect:    The record round-trips through decode, and the resumed run starts at step n2: the first named is never fought again.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic, eb.ic.ic_saved
-- id:        ic-saved-run

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    route = {
        { id = "n1", act = "encounter", name = "first" },
        { id = "n2", act = "encounter", name = "second" },
    },
}
local ENC = {
    first = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named", phases = { { do_ = { { engage = "Captain Fixturo" } } } } },
    second = { schema = "eb.ic/1", name = "Mire Queen Fixtura", kind = "boss", phases = { { do_ = { { engage = "Mire Queen Fixtura" } } } } },
}

local env, world = require("instances.lib.icworld").make({ start = "copy", reuseNow = 900,
    alive = { ["Captain Fixturo"] = 100, ["Mire Queen Fixtura"] = 100 } })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function(_, name) return ENC[name] end
local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))

-- save: a single run (loop = false) to resume at route step "n2"
local record = runner:saveRun({ inst = inst, name = "evening run", loop = false, pointer = "n2",
                                between = { tse = true } })
-- the record is plain data: write it off the game thread, read it back later
local SAVED = require("eb.ic.ic_saved").SAVED
local back = assert(SAVED.decode(record))

local ok, _, report = runner:resumeRun(inst, back)
for _, l in ipairs(world.lines) do if l:find("saved run", 1, true) then print(l) end end

DOCS.eq(record.schema, "eb.icsave/1", "the record's schema")
DOCS.eq(record.reuse.fixture_hollow, 900, "the reuse timer at save")
DOCS.eq(SAVED.reuseRemaining(record, "fixture_hollow", 600), 300, "10 minutes after a save at 0 s, 5 are left")
DOCS.check(ok, "the resumed run completes")
DOCS.eq(report.verdicts.n1, nil, "step n1 was before the pointer")
DOCS.eq(report.verdicts.n2, "killed", "the run resumed at n2")
DOCS.eq(world.attempts["Captain Fixturo"], nil, "the first named was never pulled")
