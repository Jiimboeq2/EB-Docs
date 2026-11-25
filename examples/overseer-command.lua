-- EB tested example: EB Overseer from the console
-- overseer-command | snippet | topics: quests, commands
--
-- What it does:  eb overseer is the Overseer's one command: run a pass, stop it, read where it stands, set this character's
--                options (a season or a colour is ONE choice), keep the PC's preferences (who a click is for, after each run),
--                and buy missions with words a crew line carries to every box (eb all overseer buy season 3 colour blue ...). A
--                word whose part is not on this box yet says so; a game read that waits for its live proof answers held, in
--                words.
-- Tested:        set neutral on reads back and options lists it; who mygroup is kept for every box of the PC; the buy's dash
--                flags read as EB's words; status says the pass is idle; stop finds nothing running.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
