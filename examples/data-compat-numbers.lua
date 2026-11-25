-- EB tested example: Print numbers the same way everywhere
-- data-compat-numbers | snippet | topics: data
--
-- What it does:  eb.compat.numstr prints 3 and 3.0 both as "3"; format and sortedkeys keep output stable on every target.
-- Tested:        Whole numbers print without .0, %d takes a fractional number, and keys come out in one stable order.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local compat = require("eb.compat")
print(("%s | %s | %s"):format(compat.numstr(3.0), compat.numstr(2.5), compat.format("hp %d", 64.0)))
local keys = compat.sortedkeys({ zone = 1, [2] = "b", name = 2, [1] = "a" })

-- check
DOCS.eq(compat.numstr(3.0), "3", "an integral float prints as an integer")
DOCS.eq(compat.format("%d", 3.7), "3", "%d truncates instead of raising")
DOCS.eq(compat.toint(-3.7), -3, "toint truncates toward zero")
DOCS.check(compat.isint(3.0) and not compat.isint(3.5), "isint")
DOCS.eq(table.concat(compat.sortedkeys({ b = 1, a = 2 }), ","), "a,b", "strings in order")
DOCS.eq(keys[1], 1, "numbers first, then strings")
DOCS.eq(keys[4], "zone", "the last key")
