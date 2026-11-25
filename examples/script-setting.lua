-- Change an EB setting (complete script)
--
-- A drop-in script that changes one key in EB's settings file while EB is stopped (EB has no in-game set command yet): it checks EB's heartbeat, finds the file through EB's install, and checks the key, its kind and its range against EB's own settings catalog before it writes.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_setting.lua
-- run:       eb stop
--            lua eb_setting followDistance 12
--            lua EBIS/eb_isx_boot
-- needs:     EB for InnerSpace installed by EB Setup (it finds EB through InnerSpace/Scripts/EBIS/boot.json)
--            EB stopped in this session while the file changes (eb stop); start it again afterwards
-- expect:    Refuses while EB runs; with EB stopped it writes followDistance = 12, keeps every other key, refuses an unknown key, pulls a number outside the range to the nearest allowed value, and reads a key back.
-- verified:  on the offline stand-in for the game
-- modules:   eb.ui.settings.settings
-- id:        script-setting

-- eb_setting.lua - change one of EB's settings, or read one. EB reads its settings file (eb-settings.json in the EB
-- folder) when it starts, so the file changes only while EB is stopped:
--   1. EB's heartbeat - the LavishScript variable EBISX_Beat EB rewrites several times a second - must stand still;
--   2. the EB folder comes from InnerSpace/Scripts/EBIS/boot.json (written by EB Setup), read with ISXLUA's cjson;
--   3. EB's own settings catalog (eb.ui.settings.settings, plain Lua in the EB folder) says whether the key exists, its
--      kind (on/off, a number with a range, one of a list) and its range;
--   4. the file is read, the one key changed, and the whole file written back.
--
--   lua eb_setting <key> <value>     change it (on/off for a switch; a number; one of the listed choices)
--   lua eb_setting <key>             read it

local key, value = ...
if not key then
    echo("usage: lua eb_setting <key> [<value>]")
    return
end

-- 1. EB must be stopped
IS.Execute("squelch declarevariable EBISX_Beat int64 global")      -- nothing changes when EB declared it already
local beat = IS.Parse("${EBISX_Beat}")
wait(1)
if IS.Parse("${EBISX_Beat}") ~= beat then
    echo("eb_setting: EB is running in this session - type eb stop, run this again, then start EB")
    return
end

-- 2. EB's folder
local cjson = require("cjson.safe")
local home = tostring(IS.Parse("${LavishScript.HomeDirectory}") or ""):gsub("\\", "/"):gsub("/+$", "")
local bf = io.open(home .. "/Scripts/EBIS/boot.json", "rb")
if not bf then
    echo("eb_setting: EB for InnerSpace is not installed in this InnerSpace (no Scripts/EBIS/boot.json)")
    return
end
local boot = cjson.decode(bf:read("*a") or "")
bf:close()
if type(boot) ~= "table" or type(boot.root) ~= "string" or boot.root == "" then
    echo("eb_setting: boot.json names no EB folder - run EB Setup again")
    return
end
local root = boot.root:gsub("\\", "/"):gsub("/+$", "")
local path = root .. "/eb-settings.json"

-- 3. the key, from EB's own catalog
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local okC, catalog = pcall(require, "eb.ui.settings.settings")
local item = okC and type(catalog) == "table" and catalog.item(key) or nil
if okC and not item then
    echo("eb_setting: " .. key .. " is not an EB setting")
    return
end

-- 4. the file as it is (no file yet = every setting at its default)
local settings = {}
local rf = io.open(path, "rb")
if rf then
    local t = cjson.decode(rf:read("*a") or "")
    rf:close()
    if type(t) == "table" then settings = t end
end

if value == nil then
    local v = settings[key]
    if v == nil and item then
        echo(("eb_setting: %s = %s (the default)"):format(key, tostring(catalog.defaultOf(item))))
    else
        echo(("eb_setting: %s = %s"):format(key, tostring(v)))
    end
    return
end

-- the new value, in the key's own kind
local function asBool(s)
    s = tostring(s):lower()
    if s == "on" or s == "true" or s == "yes" or s == "1" then return true end
    if s == "off" or s == "false" or s == "no" or s == "0" then return false end
    return nil
end
local v
local kind = item and item.kind or nil
if kind == "bool" then
    v = asBool(value)
    if v == nil then echo("eb_setting: " .. key .. " is on or off"); return end
elseif kind == "num" then
    local n = tonumber(value)
    if not n then echo("eb_setting: " .. key .. " is a number"); return end
    v = catalog.snap(item, n)
    if v ~= n then
        echo(("eb_setting: %s takes %s to %s in steps of %s - set to %s"):format(key, item.min, item.max, item.step or 1, v))
    end
elseif kind == "cycle" or kind == "choice" then
    for _, c in ipairs(item.cycle or item.choice or {}) do
        if tostring(c):lower() == tostring(value):lower() then v = c end
    end
    if v == nil then
        echo("eb_setting: " .. key .. " is one of: " .. table.concat(item.cycle or item.choice or {}, ", "))
        return
    end
else
    v = tonumber(value) or asBool(value)
    if v == nil then v = value end
end

settings[key] = v
local wf = io.open(path, "wb")
if not wf then
    echo("eb_setting: cannot write " .. path)
    return
end
wf:write(cjson.encode(settings))
wf:close()
echo(("eb_setting: %s = %s - EB reads it when it starts"):format(key, tostring(v)))
