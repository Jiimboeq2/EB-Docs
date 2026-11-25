-- The combat commands, and answering one from a script
--
-- EB answers the combat commands itself: eb mez off, eb combat off, eb cures off, eb interrupts on, eb embargo tag BURN 15 and eb ho off each change EB's own engine, in the console and for the crew. A script can still take one command over with its own handler (replace = true); a second owner without replace is refused.
--
-- kind:      snippet
-- expect:    Each typed line changes the engine: mez off, casting paused, cures off, interrupt-all on, the BURN tag held for 15 seconds, the heroic part off. After the script takes eb mez over, eb mez off runs the script's handler.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.combat, eb.registry, eb.app.combat, eb.combat
-- id:        combat-wire-commands

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- EB's own answers: nothing to wire
local reg = eb.app.reg                                    -- the one command registry
local engine = eb.app.combat.engine                       -- EB's own engine: never build a second one
local unwired = reg:unattached({ domain = "combat" })
for _, line in ipairs({ "eb mez off", "eb combat off", "eb cures off", "eb interrupts on", "eb embargo tag BURN 15",
                        "eb ho off" }) do
    a.console(line)
end
local mezByEB = engine:moduleOn("mez")

-- your script: take eb mez over (replace = true), counting what it was asked
local asked = 0
local ok = reg:attach("combat.mez", function(args)
    asked = asked + 1
    engine:toggle("mez", args.state ~= "off")
    return true, "mez " .. tostring(args.state) .. " (my script)"
end, { owner = "my-combat-helper", replace = true })
if ok then print("the script answers eb mez") end
local said = a.console("eb mez on")
local again = reg:attach("combat.mez", function() return true end, { owner = "someone-else" })   -- one owner per command

-- check
local function has(list, id) for _, v in ipairs(list) do if v == id then return true end end return false end
DOCS.check(not has(unwired, "combat.mez") and not has(unwired, "combat.embargo"), "EB answers the combat commands itself")
DOCS.eq(mezByEB, false, "eb mez off (EB's own handler)")
DOCS.eq(engine:isPaused(), true, "eb combat off")
DOCS.eq(engine:switchOn("cures"), false, "eb cures off")
DOCS.eq(engine:switchOn("interrupts"), true, "eb interrupts on")
DOCS.eq(engine:tagLive("BURN"), true, "eb embargo tag BURN 15")
DOCS.eq(engine:moduleOn("ho"), false, "eb ho off")
DOCS.eq(asked, 1, "after the take-over, eb mez runs the script's handler")
DOCS.eq(engine:moduleOn("mez"), true, "eb mez on (through the script)")
DOCS.check(said:find("my script", 1, true) ~= nil, "the console shows the script's answer")
DOCS.eq(again, false, "a second owner is refused without replace = true")
a.stop()
