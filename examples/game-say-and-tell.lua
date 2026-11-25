-- Call out in group chat and send a tell
--
-- Say("group" | "raid", text) speaks in group or raid chat once EB has proven that call in the game - until then it sends nothing and answers false with the reason; Tell(name, text) whispers one player. Text is sent as plain words, never evaluated.
--
-- kind:      snippet
-- expect:    The tell goes out with the text as written (a "${" defused); the group line is held back: Say answers false and says why.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-say-and-tell

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
