-- See which window actions a drive provides
--
-- The economy works through a DRIVE: one table of window actions (bags.items, merchant.sell, depot.withdraw, ...). eb.economy.drive lists every action, checks a drive against the list, and fills the gaps with honest stubs: a missing read answers empty, a missing action answers "blocked" with what it still needs. eco:driveGaps() and eco:driveReport() say the same for a built economy.
--
-- kind:      snippet
-- expect:    A two-action drive is reported with the rest missing; a stubbed buy answers blocked with its reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.drive, eb.economy
-- id:        econ-drive-report

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
