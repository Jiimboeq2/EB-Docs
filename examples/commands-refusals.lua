-- What a refused line tells you
--
-- reg:dispatch never raises: every refusal is ok == false plus a plain reason a script can show or log.
--
-- kind:      snippet
-- expect:    An unknown word, a bad argument, a missing argument and a command nothing answers yet are each refused.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-refusals

-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local function try(line)
    local ok, text = reg:dispatch(line)
    if not ok then print("refused: " .. text) end
    return ok, text
end
local _, unknown = try("eb juggle home")
local _, badArg = try("eb pause maybe")             -- pause takes pause | resume | toggle | status
local _, missing = try("eb end")                    -- end needs <system>
local _, notWired = try("eb follow")                -- a real command with no handler attached in this registry
local raised = reg:attach("core.reload", function() error("boom") end, { owner = "my_helper" }) and
    select(2, reg:dispatch("eb reload"))

-- check
DOCS.has(unknown, "is not an eb command", "an unknown word")
DOCS.has(badArg, "is one of pause|resume|toggle|status", "a bad value names the choices")
DOCS.has(missing, "needs system", "a missing required argument is named")
DOCS.has(notWired, "does not answer on this box yet", "a command nothing answers yet")
DOCS.has(raised, "raised: ", "a handler that raises is caught and reported")
