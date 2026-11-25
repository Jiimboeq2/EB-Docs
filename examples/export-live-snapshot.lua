-- EB tested example: Snapshot a character's ability book
-- export-live-snapshot | snippet | topics: data, combat
--
-- What it does:  exporter.snapshot asks a host for the book and each ability's details, then folds and labels them into an
--                ability export. Asking for every ability's details is a server request: snapshot asks once (host.warm), waits a
--                bounded while for them (host.ready), and reports how many had not arrived. Here the host is a small fake.
-- Tested:        Both abilities are read, one detail is missing and counted, and the snapshot carries no character name.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
