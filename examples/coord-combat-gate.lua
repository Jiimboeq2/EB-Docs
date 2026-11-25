-- EB tested example: Claim before a group cure
-- coord-combat-gate | snippet | topics: combat, crew
--
-- What it does:  needsClaim says which combat casts need a claim; attach wraps an engine's cast so a group cure is claimed first
--                and stands down when another box has it.
-- Tested:        A group cure needs the "groupcure" claim, a damage art none; the wrapped cast waits, then casts once it wins.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local gate = require("eb.coord.combat_gate")
local Arb = require("eb.coord.arbiter")
local now = 0
local arb = Arb.new({ box = "is1", role = 10, clock = function() return now end })   -- no link: a solo box

local cureAll = { kind = "cure", target = "group", entry = { target = "AllParty", gates = { type = "GROUP" } } }   -- a group cure says so
local nuke = { kind = "dps", target = 200, entry = { target = "Target" } }
local key = gate.needsClaim(cureAll)
local none = gate.needsClaim(nuke)

-- an engine of your own with a cast(dec) method: attach claims before every cast that needs it
local engine = { sent = 0 }
function engine:cast(dec) self.sent = self.sent + 1; return true end
local detach = gate.attach(engine, arb, { now = function() return now end })
local first = engine:cast(cureAll)                         -- the claim window is still open
now = 200
local second = engine:cast(cureAll)                        -- this box won: the cast goes out
detach()
print(("%s|%s|%s: %s, then %s"):format(key.action, key.target, key.scope, first and "go" or "wait",
    second and "go" or "wait"))

-- check
DOCS.eq(none, nil, "a damage art needs no claim")
DOCS.eq(first, false, "the first cast waited for the claim window")
DOCS.eq(second, true, "the second cast went out")
DOCS.eq(engine.sent, 1, "the engine's own cast ran exactly once")
DOCS.eq(cureAll.sendWhy, "wait for the arbitration (collecting bids)", "the decision says why it held")
