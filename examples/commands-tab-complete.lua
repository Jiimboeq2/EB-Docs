-- EB tested example: Tab-complete a command line
-- commands-tab-complete | snippet | topics: commands, ui
--
-- What it does:  reg:complete(line, opts) returns the words that could come next and the line advanced to them.
-- Tested:        pau completes to pause; after "to" it offers box ids; an onoff argument offers on and off.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local cands, line = reg:complete("eb pau")               -- one candidate: the line gets the word and a space
print(line)
local boxes = reg:complete("eb to ", { who = { "is1", "is2", "is3" } })
local onoff = reg:complete("eb cures ")                  -- cures takes [state:onoff]
local verbs = reg:complete("eb all fo")                  -- after a scope word: verbs only

-- check
DOCS.eq(cands[1], "pause", "pau -> pause")
DOCS.eq(line, "eb pause ", "the line advanced with a trailing space")
DOCS.eq(table.concat(boxes, ","), "is1,is2,is3", "after 'to' the box ids you passed")
DOCS.eq(table.concat(onoff, ","), "off,on", "an onoff argument offers off and on")
DOCS.check(#verbs >= 1 and verbs[1]:sub(1, 2) == "fo", "verbs starting fo")
