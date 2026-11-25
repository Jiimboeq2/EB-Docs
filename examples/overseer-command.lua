-- EB Overseer from the console
--
-- eb overseer is the Overseer's one command: run a pass, stop it, read where it stands, set this character's options (a season or a colour is ONE choice), keep the PC's preferences (who a click is for, after each run), and buy missions with words a crew line carries to every box (eb all overseer buy season 3 colour blue ...). A word whose part is not on this box yet says so; a game read that waits for its live proof answers held, in words.
--
-- kind:      snippet
-- expect:    set neutral on reads back and options lists it; who mygroup is kept for every box of the PC; the buy's dash flags read as EB's words; status says the pass is idle; stop finds nothing running.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.quest
-- id:        overseer-command

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script: lines exactly as you type them
local set = a.console("eb overseer set neutral on")
local opts = a.console("eb overseer options")
local who = a.console("eb overseer who mygroup")
local status = a.console("eb overseer status")
local stop = a.console("eb overseer stop")
print((tostring(set):gsub(" %(.*$", "")))

-- the buy's words: what EB's Overseer window sends to every box of its Who (the dash flags read as EB's own words)
local OV = require("eb.mcpverbs.overseer")
local buy = require("eb.overseer.trip.args").parse("-season 3 -colour blue -num 12 -amount 10 -noscribe",
    require("eb.overseer.options").defaults())

-- check
DOCS.has(set, "overseer set: neutral on", "an option is set and read back")
DOCS.has(opts, "neutral", "the character's options list it as on")
DOCS.has(who, "who: My group", "who a click is for is kept for the PC")
DOCS.has(status, "Overseer: idle", "no pass has run yet")
DOCS.has(stop, "nothing of the Overseer runs on this box", "stop finds nothing running")
DOCS.eq(OV.buyWords(buy.opts), "season 3 colour blue num 12 copies 10 noscribe destroy off gettogh off", "the flags read as EB's buy words")
a.stop()
