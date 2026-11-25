-- EB tested example: Answer a click with a verb
-- ui-window-verbs | snippet | topics: ui, commands
--
-- What it does:  A window's verbs are its allow-list: a click runs one by name, answers at once, and nothing else can run.
-- Tested:        reset answers "cleared", an unknown verb is refused with the list, and one that raises answers false.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local W = require("ebkit.window")
local kills = 7
local win = W.new({
    id = "killcounter", title = "Kill Counter",
    build = function() return { kills = kills } end,
    verbs = {
        reset = function(args, self) kills = 0; return true, "cleared" end,
        add = function(args, self)
            local n = W.int(args.n, 1, 100)          -- what a page sent, made safe: a whole number in 1..100, or nil
            if not n then return false, "add takes n = 1..100" end
            kills = kills + n
            return true, "added " .. n
        end,
        broken = function() error("oops") end,
    },
})
local ok, text = win:verb("reset", {})
print(("reset -> %s %s"):format(tostring(ok), text))
local okAdd = win:verb("add", { n = "4" })
local okBad, badText = win:verb("add", { n = 500 })
local okUnknown, unknownText = win:verb("unknown_verb", {})
local okRaised, raisedText = win:verb("broken", {})

-- check
DOCS.eq(win:state().kills, 4, "the verbs changed the data and the window rebuilt")
DOCS.check(okAdd and not okBad, "a bad argument is refused by the verb itself")
DOCS.has(badText, "1..100", "with its reason")
DOCS.eq(okUnknown, false, "an unknown verb never runs")
DOCS.has(unknownText, "add, broken, reset", "and the answer lists the verbs there are")
DOCS.eq(okRaised, false, "a verb that raises answers false")
DOCS.has(raisedText, "raised", "and says so")
