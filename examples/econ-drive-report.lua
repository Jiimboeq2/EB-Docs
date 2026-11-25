-- EB tested example: See which window actions a drive provides
-- econ-drive-report | snippet | topics: items
--
-- What it does:  The economy works through a DRIVE: one table of window actions (bags.items, merchant.sell, depot.withdraw, ...).
--                eb.economy.drive lists every action, checks a drive against the list, and fills the gaps with honest stubs: a
--                missing read answers empty, a missing action answers "blocked" with what it still needs. eco:driveGaps() and
--                eco:driveReport() say the same for a built economy.
-- Tested:        A two-action drive is reported with the rest missing; a stubbed buy answers blocked with its reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script: a drive of your own that only knows the bags
local Drive = require("eb.economy.drive")
local mine = {
    ["bags.slots"] = function() return 12, 40 end,
    ["bags.items"] = function() return {} end,
    __drive = { name = "my bag reader", proven = { ["bags.slots"] = true },
                need = { ["merchant.buy"] = "the merchant window's Buy button" } },
}
print(Drive.signature("broker.setPrice"))
DOCS.eq(Drive.kind("bags.items"), "read", "a read")
DOCS.eq(Drive.kind("merchant.sell"), "action", "an action")

local ok, missing = Drive.validate(mine)
DOCS.check(not ok and #missing == #Drive.SPEC - 2, "everything but the two is missing")

local full = Drive.withFallback(mine)
local s, why = full["merchant.buy"]("Fixture Tonic", 1)
DOCS.eq(s, "blocked", "a missing action refuses")
DOCS.has(why, "the merchant window's Buy button", "with what it still needs")
DOCS.eq(#full["merchant.offers"](), 0, "a missing read answers empty")

local report = Drive.report(mine)
DOCS.eq(report.present, 2, "two present")
DOCS.eq(report.proven, 1, "one of them proven")

-- check: the same from a built economy
local eco = require("eb.economy").new({ drive = mine })
DOCS.eq(#eco:driveGaps(), #Drive.SPEC - 2, "driveGaps")
DOCS.eq(eco:driveReport().missing, #Drive.SPEC - 2, "driveReport")
