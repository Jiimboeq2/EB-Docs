-- Sell junk at a merchant (complete script)
--
-- A drop-in script that waits for a merchant window and sells every listed item your bags hold through the window's own rows, once per window. It answers no question it did not cause.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_selljunk.lua
-- run:       lua eb_selljunk "Rusty Fixture Blade" "Torn Fixture Pelt"
--            endlua eb_selljunk
-- needs:     EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--            the exact names of the items to sell (only those are ever sold)
--            you open the merchant window yourself (hail the merchant); the script never opens one
-- expect:    Sells the whole stack of each listed item in the bags when a window opens, leaves every other item, and sells again only at the next window.
-- verified:  on the offline stand-in for the game
-- id:        script-selljunk

-- eb_selljunk.lua - sell the items you name, whenever a merchant window is open. Twice a second it checks whether a
-- merchant window is up; when one opens it reads every listed item's stack and price in ONE read and sells each whole
-- stack through MerchantWindow.MyInventory["<name>"]:Sell. It sells again only after that window closed and the next
-- one opened. It never clicks a question (selling asks none it would answer) and reads only verified members.
--
--   lua eb_selljunk "<item name>" ["<item name>" ...]     start it with the exact item names
--   endlua eb_selljunk                                    stop it

local junk = {}
for _, name in ipairs({ ... }) do
    if tostring(name):find('["\\]') then
        echo("eb_selljunk: skipping a name with a quote or a backslash in it: " .. tostring(name))
    elseif name ~= "" then
        junk[#junk + 1] = name
    end
end
if #junk == 0 then
    echo('usage: lua eb_selljunk "<item name>" ["<item name>" ...]')
    return
end

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

local function row(name) return 'MerchantWindow.MyInventory["' .. name .. '"]' end

local function merchantOpen() return IS.Parse("${MerchantWindow.IsVisible}") == "TRUE" end

-- one read for every listed item (its stack in the bags - NULL when there is none - and the price), then one Sell each
local function sellListed()
    local seq = {}
    for _, name in ipairs(junk) do seq[#seq + 1] = "${" .. row(name) .. ".Quantity}|${" .. row(name) .. ".PriceString}" end
    local r = split(IS.Parse(table.concat(seq, "|")))
    local sold = 0
    for i, name in ipairs(junk) do
        local qty = tonumber(r[i * 2 - 1]) or 0
        if qty > 0 then
            IS.Execute(row(name) .. ":Sell[" .. qty .. "]")
            echo(("eb_selljunk: sold %d %s (%s each)"):format(qty, name, tostring(r[i * 2])))
            sold = sold + 1
        end
    end
    return sold
end

echo(("eb_selljunk: selling %d listed item(s) at the next merchant window - endlua eb_selljunk stops it"):format(#junk))
local soldHere = false
while true do
    if merchantOpen() then
        if not soldHere then
            local n = sellListed()
            echo(("eb_selljunk: done at this merchant (%d stack(s) sold)"):format(n))
            soldHere = true
        end
    else
        soldHere = false
    end
    wait(0.5)
end
