-- EB tested example: Send a command to the crew
-- commands-crew-scopes | snippet | topics: commands, crew
--
-- What it does:  A leading all / others / to <who> hands the line to the crew relay; the registry decides where it also runs.
-- Tested:        all runs here and goes out; others only goes out; to is2 runs here only when this box is is2.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local ranHere = 0
reg:attach("core.pause", function() ranHere = ranHere + 1; return true, "paused" end, { owner = "my_helper" })

-- ctx.relay carries a crew line (EB sets it to the crew relay; here it just records what would go out)
local sent = {}
local ctx = {
    relay = function(scope, who, line) sent[#sent + 1] = { scope = scope, who = who, line = line }; return true end,
    isMe = function(who) for _, w in ipairs(who or {}) do if w == "is1" then return true end end return false end,
}

reg:dispatch("eb all pause", ctx)              -- goes out AND runs here
print(("sent %s: %s"):format(sent[1].scope, sent[1].line))
reg:dispatch("eb others pause", ctx)           -- goes out, never runs here
reg:dispatch("eb to is2 pause", ctx)           -- goes out; is2 is not this box
reg:dispatch("eb to is1,is3 pause", ctx)       -- goes out; is1 IS this box, so it runs here too
local ok, why = reg:dispatch("eb all help")    -- help runs on one box only

-- check
DOCS.eq(#sent, 4, "four crew lines went out")
DOCS.eq(sent[1].line, "eb pause", "the relayed line carries no scope word (it runs on arrival, never relays again)")
DOCS.eq(sent[3].who[1], "is2", "to names who")
DOCS.eq(ranHere, 2, "all and to is1,is3 ran here; others and to is2 did not")
DOCS.eq(ok, false, "a command that runs on this box only refuses a crew scope")
DOCS.has(why, "runs on this box only", "and says so")
