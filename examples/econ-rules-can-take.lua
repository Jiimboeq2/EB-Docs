-- EB tested example: Ask the safety gate before destroying or selling
-- econ-rules-can-take | snippet | topics: items, helpers
--
-- What it does:  rules.canTake(action, item, ctx) is the one gate every destroy, transmute, salvage and sell goes through. It
--                fails safe: an item whose details were not read, a protected item, or a no-trade item you did not opt in is
--                refused, with the reason.
-- Tested:        The plain junk item may go; the unread, the protected and the no-trade items are refused with their reasons.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local R = require("eb.economy.rules")
local cfg = R.load({})
local function try(item) local ok, why = R.canTake("destroy", item, { cfg = cfg }); return ok and "ok" or why end
local junk = { name = "a fixture rag", type = "Item", tier = "COMMON" }
local unread = { name = "a fixture mystery", type = "Unknown", tier = "UNKNOWN" }
local treasure = { name = "a fixture personal treasure", type = "Item", tier = "TREASURED" }
local bound = { name = "a fixture keepsake", type = "Item", tier = "COMMON", noTrade = true }
print(("%s: %s; unread: %s; protected: %s; no-trade: %s"):format(junk.name, try(junk), try(unread), try(treasure),
    try(bound)))

-- check
DOCS.eq(try(junk), "ok", "plain junk may go")
DOCS.eq(R.canTake("destroy", bound, { cfg = cfg, asked = { noTrade = true } }), true, "opted in by name: allowed")
DOCS.eq((R.canTake("sell", bound, { cfg = cfg })), false, "selling a bound item needs its own opt-in")
