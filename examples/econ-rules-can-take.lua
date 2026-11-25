-- Ask the safety gate before destroying or selling
--
-- rules.canTake(action, item, ctx) is the one gate every destroy, transmute, salvage and sell goes through. It fails safe: an item whose details were not read, a protected item, or a no-trade item you did not opt in is refused, with the reason.
--
-- kind:      snippet
-- expect:    The plain junk item may go; the unread, the protected and the no-trade items are refused with their reasons.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.rules
-- id:        econ-rules-can-take

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
