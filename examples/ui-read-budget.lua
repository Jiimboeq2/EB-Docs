-- Spread a big scan over several frames
--
-- A scan that reads the game counts its reads and stops at the budget, then carries on next frame.
--
-- kind:      snippet
-- expect:    20 rows are read 8 per frame: the scan takes 3 frames and no frame goes over 8 reads.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.push_budget
-- id:        ui-read-budget

-- your script
local budget = require("ebkit.push_budget")
local rows, nextRow, frames, peak = {}, 1, 0, 0
local function readRow(i) return { id = i } end           -- stands for one game read

while nextRow <= 20 do                                   -- each pass of this loop is one frame
    frames = frames + 1
    local rb = budget.readBudget(8)
    while rb:ok() and nextRow <= 20 do
        rb:take(1)
        rows[#rows + 1] = readRow(nextRow)
        nextRow = nextRow + 1
    end
    if rb:used() > peak then peak = rb:used() end
end
print(("%d rows in %d frames, at most %d a frame"):format(#rows, frames, peak))

-- check
DOCS.eq(#rows, 20, "every row read")
DOCS.eq(frames, 3, "8 + 8 + 4")
DOCS.eq(peak, 8, "never over the budget")
