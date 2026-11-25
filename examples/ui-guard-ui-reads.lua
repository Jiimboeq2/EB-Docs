-- EB tested example: Check a UI read before you send it
-- ui-guard-ui-reads | snippet | topics: ui, game
--
-- What it does:  Read the game's window elements by name. eb.uiguard checks a UI path first and refuses the unsafe kinds.
-- Tested:        A by-name read is allowed; a read by position under a tabbed window is refused with the reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local G = require("eb.uiguard")
local byName = 'EQ2UIPage[Inventory,Merchant].Child[TabbedPane,Tabs].Child[Page,Buy]'
local byPosition = 'EQ2UIPage[Inventory,Merchant].Child[TabbedPane,Tabs].Child[2]'
local okName = G.checkExpr(byName)
local okPos, why = G.checkExpr(byPosition)
print(("by name: %s | by position under tabs: %s"):format(okName and "allowed" or "refused",
    okPos and "allowed" or "refused"))

-- check
DOCS.eq(okName, true, "a read by name is always allowed")
DOCS.eq(okPos, false, "by position under a tabbed window is refused")
DOCS.has(why, "read its child by name", "and the reason says what to do instead")
DOCS.check(G.isTabbed("TabbedPane") and not G.isTabbed("Page"), "isTabbed names the window type that needs care")
DOCS.eq(G.allowChildRead("Page", "index"), true, "by position is fine under an ordinary page")
