-- Tab-complete a command line
--
-- reg:complete(line, opts) returns the words that could come next and the line advanced to them.
--
-- kind:      snippet
-- expect:    pau completes to pause; after "to" it offers box ids; an onoff argument offers on and off.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-tab-complete

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
