-- Which commands this box answers
--
-- reg:unattached lists the declared commands nothing on this box answers yet (each part of EB attaches its commands as it starts; a part that did not start leaves its commands there, and eb status says which). Such a command - here a script's own, declared before it has a handler, in a registry built from EB's command list - is refused in plain words when typed, never run (EB Help marks such a row "this box does not answer it yet").
--
-- kind:      snippet
-- expect:    the core commands are answered on the booted box; the script's own command, declared without a handler, is listed by unattached and refused plainly (it does not answer on this box yet) until a handler is attached.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry, commands.util
-- id:        commands-not-answered-yet

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script
local reg = a.app.reg
local waiting = reg:unattached()                    -- EB's own declared commands nothing answers on this box
local answered = #reg:view({ domain = "core" }) - #reg:unattached({ domain = "core" })

-- a command of your own, declared before its handler: a registry built from EB's command list, plus one row
local R = require("eb.registry")
local mine = R.new()
assert(mine:load(assert(R.readFile("data/eb/commands.json"))))  -- the shipped list (in game: under the EB folder)
assert(mine:load({ schema = R.SCHEMA, domains = { { id = "myscript", label = "My script", desc = "my own commands" } },
    commands = { { id = "myscript.myreport", domain = "myscript", verb = "myreport", name = "eb myreport",
                   desc = "my own report", module = "my.script", ship = "shipped", scopes = { "local" }, args = {} } } }))
local listed = mine:unattached({ domain = "myscript" })
local okBefore, before = mine:dispatch("eb myreport")
mine:attach("myscript.myreport", function() return true, "my report: all quiet" end, { owner = "my.script" })
local okAfter, after = mine:dispatch("eb myreport")
print(("myreport: %s | EB's own commands waiting on this box: %d"):format(
    tostring(before):match("does not answer on this box yet") or tostring(before), #waiting))

-- check
DOCS.check(answered >= 5, "the core commands are answered (help, status, stop, pause, resume)")
DOCS.eq(#reg:unattached({ domain = "core" }), 0, "no core command waits on a booted box")
DOCS.eq(listed[1], "myscript.myreport", "unattached lists the declared command nothing answers yet")
DOCS.check(okBefore == false and tostring(before):find("does not answer on this box yet", 1, true) ~= nil,
    "typed, it is refused in plain words - never run")
DOCS.check(okAfter == true and after == "my report: all quiet", "once a handler is attached, it answers")
a.stop()
