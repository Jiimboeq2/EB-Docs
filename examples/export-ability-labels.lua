-- What an ability asks for and what it does
--
-- The label engine reads an ability's effect lines and flags: a position it must be cast from, stealth, a stun or a group target, a threat increase. classify returns the whole picture; tags_of, tokensOf and to_json give it as text or a small table, and is_enhance / is_tradeskill sort out upgrades and tradeskill abilities.
--
-- kind:      snippet
-- expect:    The backstab asks for behind and stealth; the taunt is a group threat increase with a stun; the upgrade and the crafting ability are recognized.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.exports.csreq
-- id:        export-ability-labels

local csreq = require("eb.exports.csreq")

-- two ability records in the record layout (offline: invented abilities)
local backstab = { Name = "Fixture Backstab", ID = 1, IsSingleTargetAbility = true,
    EffectDesc1 = "You must be behind your target to use this", EffectDesc2 = "You must be stealthed to use this" }
local taunt = { Name = "Fixture Roar", ID = 2, IsGroupAbility = true, IsStun = true,
    EffectDesc1 = "Increases threat to target encounter by 3,000" }

-- your script
local r1 = csreq.classify(backstab)
local r2 = csreq.classify(taunt)
print("backstab: " .. csreq.tokensOf(r1))

-- check
DOCS.eq(r1.pos, "behind", "cast from behind")
DOCS.check(r1.stealth, "only from stealth")
DOCS.check(r1:any(), "it asks something of the caster")
DOCS.has(csreq.tags_of(r2), "stun", "the roar stuns")
DOCS.has(csreq.tags_of(r2), "group", "and reaches the group")
DOCS.eq(r2.up, "e", "it raises threat across the encounter")
DOCS.eq(csreq.to_json(r1).pos, "behind", "to_json keeps the position")
DOCS.check(csreq.is_enhance("Enhance: Fixture Roar"), "an Enhance: entry is an upgrade, not a cast")
DOCS.check(csreq.is_tradeskill("Rapid Manufacturing"), "a crafting ability is a tradeskill one")
