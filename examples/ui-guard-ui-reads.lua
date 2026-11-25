-- Check a UI read before you send it
--
-- Read the game's window elements by name. eb.uiguard checks a UI path first and refuses the unsafe kinds.
--
-- kind:      snippet
-- expect:    A by-name read is allowed; a read by position under a tabbed window is refused with the reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.uiguard
-- id:        ui-guard-ui-reads

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
