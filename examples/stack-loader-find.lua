-- EB tested example: Find a character's cast stack by name
-- stack-loader-find | snippet | topics: combat, data
--
-- What it does:  eb.caststack.loader finds the character's imported profile by its name, builds it with the class facts and
--                serves it from a live holder; a character with no profile gets a plain reason.
-- Tested:        The loader finds Fixturae's profile and builds its two rows with the warden's facts; a name with no profile is
--                refused with why.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the profiles folder, in a files host of your own (in game: EB's files service and your profiles)
local disk = {
    ["stacks/Main/Fixture Server_Fixturae.json"] = [[{"_v": 1, "default": "Main", "profiles": {"Main": {"sections":
        {"CastStack": [{"Type": "CA", "name": "Fixture Strike"}, {"Type": "CA", "name": "Fixture Burn", "Tag": "BURN"}]}}}}]],
}
local files = {                                            -- a files host: the loader needs read and list
    read = function(path) return disk[(path:gsub("[\\/]", "/"))] end,
    list = function(dir, glob)
        local pat, out = "^" .. glob:gsub("[%.%-]", "%%%0"):gsub("%*", ".*") .. "$", {}
        for path in pairs(disk) do
            local d, name = path:match("^(.*)/([^/]+)$")
            if d == dir:gsub("[\\/]", "/") and name:match(pat) then out[#out + 1] = name end
        end
        return out
    end,
}
local where = function() return "stacks" end              -- offline: which folder holds the profiles

-- your script
local loader = require("eb.caststack.loader")
local ld = loader.new({ files = files, getenv = where, me = function() return "Fixturae", "warden" end })
local ok = ld.load()                                       -- in game EB has done this already for eb.app.combat
print(ld.describe())
local none, why = loader.find({ files = files, getenv = where, char = "Nobodyhere" })
print("another character: " .. tostring(why))

-- check
DOCS.eq(ok, true, "the profile was found and built")
DOCS.eq(#ld.holder.entries(), 2, "both rows")
DOCS.eq(ld.result.server, "Fixture Server", "the server comes from the file's name")
DOCS.has(ld.describe(), "class facts: warden", "the class facts were added")
DOCS.eq(none, nil, "no profile for another name")
DOCS.check(type(why) == "string" and #why > 0, "and a plain reason")
DOCS.eq(loader.pinKey("Fixturae"), "caststack.server.fixturae", "the setting that pins a server for a name")
