-- EB tested example: Call out in group chat and send a tell
-- game-say-and-tell | snippet | topics: game, crew, helpers
--
-- What it does:  Say("group" | "raid", text) speaks in group or raid chat once EB has proven that call in the game - until then
--                it sends nothing and answers false with the reason; Tell(name, text) whispers one player. Text is sent as plain
--                words, never evaluated.
-- Tested:        The tell goes out with the text as written (a "${" defused); the group line is held back: Say answers false and
--                says why.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addMember({ name = "Mendfixture", id = 12, class = "templar", healthPct = 30, powerPct = 70, inZone = true })
w.addActor({ id = 12, name = "Mendfixture", type = "PC", isNPC = false, distance = 8 })

-- your script
local game = require("eb.platform").game()
local groupHeld
for _, m in ipairs(game.Group()) do
    if m.healthPct < 40 then
        -- group and raid chat are held back until EB has proven them in the game: Say answers false, and why
        local sent, why = game.Say("group", m.name .. " is low!")
        if not sent then groupHeld = why end
        game.Tell(m.name, "drink a potion, ${not code}")       -- a "${" in text is defused, never run
    end
end
print(("sent %d chat line; group chat: %s"):format(#w.world.chatOut, groupHeld and "held back" or "sent"))

-- check
DOCS.check(groupHeld ~= nil, "Say answered false: group chat is held back for now")
DOCS.has(groupHeld, "proven", "and said why")
DOCS.eq(#w.world.chatOut, 1, "so only the tell went out")
DOCS.eq(w.world.chatOut[1].to, "Mendfixture", "a tell to the member")
DOCS.eq(w.world.chatOut[1].text, "drink a potion, $ {not code}", "the words as written, the ${ defused")
