-- EB tested example: Answer the purchase question in your own buy helper
-- econ-confirm-own-buy | snippet | topics: items, helpers, dialogs
--
-- What it does:  When your own helper buys something, answer the game's purchase question the way EB does: confirm.new(env) over
--                a drive that can read the question (choice.purchasePrompt) and answer it (choice.answer), expect(item) before
--                the buy, then resolve(item) - Yes only for the exact item, No for anything else, "none" while no question is up.
-- Tested:        "none" with no question up, "confirmed" for our item, "declined" for another one.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
