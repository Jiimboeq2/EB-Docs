-- EB tested example: Reload a cast stack when its file changes
-- stack-loader-reload | snippet | topics: combat, data
--
-- What it does:  Join a loader to the combat plane, pin the server for a name, and let a changed profile file reload the stack -
--                through refresh (a stamp check) or the plane's own reload - with the loader telling you each time.
-- Tested:        The pinned server picks the profile; the plane casts from the loader's stack; after the file changes, refresh
--                reloads it (two rows now) and the change callback hears it; an unchanged stamp does nothing.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the profiles folder, in a files host of your own (in game: EB's files service and your profiles)
local w = DOCS.world()
local function profile(names)
    local rows = {}
    for _, n in ipairs(names) do rows[#rows + 1] = ('{"Type": "CA", "name": "%s"}'):format(n) end
    return '{"_v": 1, "default": "Main", "profiles": {"Main": {"sections": {"CastStack": [' .. table.concat(rows, ", ") .. ']}}}}'
end
local disk = { ["stacks/Main/Fixture Server_Fixturae.json"] = profile({ "Fixture Strike" }),
               ["stacks/Main/Second Server_Fixturae.json"] = profile({ "Fixture Other" }) }
local files = {
    read = function(path) return disk[(path:gsub("[\\/]", "/"))] end,
    list = function(dir, glob)
        local pat, out = "^" .. glob:gsub("[%.%-]", "%%%0"):gsub("%*", ".*") .. "$", {}
        for path in pairs(disk) do
            local d, name = path:match("^(.*)/([^/]+)$")
            if d == dir:gsub("[\\/]", "/") and name:match(pat) then out[#out + 1] = name end
        end
        table.sort(out)
        return out
    end,
}
local where = function() return "stacks" end
local stamp = 1

-- your script
local loader = require("eb.caststack.loader")
local store = { ["caststack.server.fixturae"] = "Fixture Server" }       -- this name has profiles on two servers
local settings = { get = function(key) return store[key] end }
local pinned = loader.pinnedServer(settings, "Fixturae")

local plane = require("eb.app.combat").new({ game = w.game })           -- in game: eb.app.combat
local ld = loader.new({ files = files, getenv = where, settings = settings, stat = function() return stamp end,
                        me = function() return "Fixturae", "warden" end })
loader.attach(ld, plane)                                                 -- the plane now casts from the loader
local heard, joined = 0, ld.onChange
ld.onChange = function(l) heard = heard + 1; joined(l) end
ld.load()
local first = #plane.holder.entries()

disk["stacks/Main/Fixture Server_Fixturae.json"] = profile({ "Fixture Strike", "Fixture Burn" })   -- the file changed
stamp = 2
local ok = ld.refresh()
local unchanged, why = ld.refresh()                                      -- the stamp did not move again
local again = plane.reload()                                             -- the plane's reload goes through the loader
print(plane.describe())
local stat = loader.lfsStat()                                            -- nil here; a stamp reader inside ISXLUA

-- check
DOCS.eq(pinned, "Fixture Server", "the server pinned for this name")
DOCS.eq(first, 1, "the pinned server's profile was loaded")
DOCS.eq(ok, true, "a changed stamp reloads")
DOCS.eq(#plane.holder.entries(), 2, "the plane casts from the new rows")
DOCS.eq(unchanged, false, "an unchanged stamp does nothing")
DOCS.eq(why, "unchanged", "and says so")
DOCS.eq(again, true, "the plane's reload works through the loader")
DOCS.check(heard >= 3, "the change callback heard every load and reload")
DOCS.has(plane.describe(), "2 entries", "the plane's status line follows the loader")
DOCS.eq(stat, nil, "no file-time reader in a plain Lua")
