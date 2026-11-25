-- Ask the platform for a service
--
-- One script runs on both EB targets: ask eb.platform which target it is on and take each service from it.
--
-- kind:      snippet
-- expect:    Names the target, gets the clock, pulse, files and log services, and checks every service meets its contract.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-target-and-services

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local P = require("eb.platform")
print("target " .. P.name())                       -- "isx" on EB for InnerSpace, "boxer" on EB Boxer

local clock = P.clock()                            -- the same as P.get("clock")
local pulse, files, log = P.pulse(), P.files(), P.log()
log.info("docs", "services ready: clock %s, pulse %s, files %s", tostring(clock ~= nil), tostring(pulse ~= nil),
    files.kind)

-- every service of this target against its contract: nothing missing, nothing unavailable
local missing = {}
for service, r in pairs(P.check()) do
    if r.unavailable or #(r.missing or {}) > 0 then missing[#missing + 1] = service end
end

-- check
DOCS.eq(P.name(), "isx", "the target")
DOCS.check(P.get("clock") == clock, "P.clock() is P.get('clock')")
DOCS.eq(#missing, 0, "every service meets its contract")
DOCS.check(w.said("services ready"), "the log line reached the console")
