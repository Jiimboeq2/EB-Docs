-- Where a secondary skill stands, and the books a trip would buy
--
-- eco.skilllevel:status(id) reads the skill live and answers its state, the levelling band it is in (the books and the recipe rows of that band) and the books a book trip would buy ahead.
--
-- kind:      snippet
-- expect:    Tinkering at 25 of 100 is in the tier-2 band; a trip buys that band's book and the next ones that start below the cap (8 books).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.skilllevel, eb.economy
-- id:        skill-level-status

-- offline: the skill seam answers 25 of 100 (in game the game layer answers it)
local eco = require("eb.economy").new({ drive = {}, me = { level = 20 },
    shim = { Skill = function(id) if id == "tinkering" then return 25, 100 end end, TSLevel = function() return 20 end } })

-- your script
local st = eco.skilllevel:status("tinkering")
print(("tinkering %d/%d: %s, band tier %d, %d books ahead"):format(st.read.cur, st.read.max, st.state, st.band.tier,
    #st.books))
print("first book: " .. st.books[1] .. "; the round crafts " .. st.band.queue[1].count .. " of a recipe")
local unknown = eco.skilllevel:status("juggling")

-- check
DOCS.eq(st.state, "level", "still levelling")
DOCS.eq(st.band.tier, 2, "the band from 20")
DOCS.eq(#st.books, 8, "this band's book and the next seven below the cap")
DOCS.eq(unknown.state, "unknown", "a skill with no levelling data")
