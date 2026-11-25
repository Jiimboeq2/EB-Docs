-- Answer the purchase question in your own buy helper
--
-- When your own helper buys something, answer the game's purchase question the way EB does: confirm.new(env) over a drive that can read the question (choice.purchasePrompt) and answer it (choice.answer), expect(item) before the buy, then resolve(item) - Yes only for the exact item, No for anything else, "none" while no question is up.
--
-- kind:      snippet
-- expect:    "none" with no question up, "confirmed" for our item, "declined" for another one.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.confirm
-- id:        econ-confirm-own-buy

-- your script: the two drive actions the answerer needs (in game EB's drive has them)
local question = nil
local answers = {}
local env = {
    drive = {
        ["choice.purchasePrompt"] = function() return question and { text = question } or nil end,
        ["choice.answer"] = function(n) answers[#answers + 1] = n; question = nil; return "done" end,
    },
    log = function() end,
    now = function() return 0 end,
}
local Confirm = require("eb.economy.confirm")
local c = Confirm.new(env)

c:expect("Fixture Tonic", 30)                                 -- about to buy: keep expecting it for 30 s
DOCS.eq(c:resolve("Fixture Tonic"), "none", "no question up yet")

question = "Are you sure you want to purchase Fixture Tonic?  This cannot be undone."
DOCS.eq(c:resolve("Fixture Tonic"), "confirmed", "our item: Yes")

question = "Are you sure you want to purchase Fixture Crown?  This cannot be undone."
DOCS.eq(c:resolve("Fixture Tonic"), "declined", "another item: No")
print("answered: " .. table.concat(answers, ", "))

-- check
DOCS.eq(answers[1], 1, "1 = Yes")
DOCS.eq(answers[2], 2, "2 = No")
DOCS.eq(Confirm.seconds(2), 20, "a wait under 5 s falls back to 20")
DOCS.eq(c.expected.item, "Fixture Tonic", "what it expects")
