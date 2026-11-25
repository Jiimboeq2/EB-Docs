-- Effect names are server requests - never poll them
--
-- Me.Effect[n].ToEffectInfo.Name asks the SERVER whenever it is read. Reading it for every effect every frame floods the server; read the plain fields (ID, Type) per frame and look a name up once per new effect id.
--
-- kind:      snippet
-- expect:    Polling names directly costs a server request per effect per frame; the cached way costs one per effect, once.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-effect-info-server

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.effects = {
    { id = 9001, name = "Fixture Ward", type = "Beneficial", icon = 11 },
    { id = 9002, name = "Fixture Haste", type = "Beneficial", icon = 12 },
}

-- the WRONG way, shown once: 10 frames x 2 effects of name reads
w.world.stats.examine = 0
for _ = 1, 10 do IS.Parse("${Me.Effect[1].ToEffectInfo.Name}|${Me.Effect[2].ToEffectInfo.Name}") end
local polled = w.world.stats.examine

-- the right way: per frame only the plain id; a name is asked once per id never seen before
w.world.stats.examine = 0
local names = {}
for _ = 1, 10 do
    local n = tonumber(IS.Parse("${Me.CountEffects}")) or 0
    for i = 1, n do
        local id = IS.Parse("${Me.Effect[" .. i .. "].ID}")
        if names[id] == nil then names[id] = IS.Parse("${Me.Effect[" .. i .. "].ToEffectInfo.Name}") end
    end
end
print(("polling names: %d server requests; cached by id: %d"):format(polled, w.world.stats.examine))

-- check (in a real script use game.HasEffect / game.MyEffectNames: they already work this way, in one read a frame)
DOCS.eq(polled, 20, "a request per effect per frame")
DOCS.eq(w.world.stats.examine, 2, "one per effect, once")
DOCS.eq(names["9001"], "Fixture Ward", "the cache maps id to name")
