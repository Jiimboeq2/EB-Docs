-- Snapshot a character's ability book
--
-- exporter.snapshot asks a host for the book and each ability's details, then folds and labels them into an ability export. Asking for every ability's details is a server request: snapshot asks once (host.warm), waits a bounded while for them (host.ready), and reports how many had not arrived. Here the host is a small fake.
--
-- kind:      snippet
-- expect:    Both abilities are read, one detail is missing and counted, and the snapshot carries no character name.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.exports.exporter
-- id:        export-live-snapshot

local exporter = require("eb.exports.exporter")

-- a host over the game's ability reads (offline: invented abilities; in game build it over the game layer)
local warmed = 0
local host = {
    warm = function() warmed = warmed + 1 end,
    ready = function() return true end,
    list = function() return { { id = 11, name = "Fixture Ward II", tier = 3 }, { id = 12, name = "Fixture Taunt" } } end,
    detail = function(id)
        if id == 11 then return { spellbookType = 0, targetTypeId = 1, beneficial = true, castSeconds = 1,
            classes = { { level = 30 } }, effects = { { text = "Wards target against 500 points of damage" } } } end
        return nil                                       -- this one's details have not arrived yet
    end,
    identity = function() return { character = "Fixturae", subClass = "guardian" } end,
}

-- your script: one snapshot, kept and reused (never every frame)
local ex, info = exporter.snapshot({ host = host, anonymize = true, maxWaitMs = 0 })
print(("read %d abilities, %d detail still on its way"):format(info.read, info.detailMisses))

-- check
DOCS.eq(info.read, 2, "both abilities were read")
DOCS.eq(info.detailMisses, 1, "the missing detail is counted")
DOCS.eq(warmed, 1, "the details were asked for once")
DOCS.eq(ex.meta.character, nil, "anonymize keeps the character out")
DOCS.eq(ex.meta.archetype, "fighter", "the subclass gives the archetype")
DOCS.check(#ex.meta.gaps > 0, "the export says what a live snapshot cannot read")
