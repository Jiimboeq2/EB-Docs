-- EB tested example: Spread a big scan over several frames
-- ui-read-budget | snippet | topics: perf, ui, helpers
--
-- What it does:  A scan that reads the game counts its reads and stops at the budget, then carries on next frame.
-- Tested:        20 rows are read 8 per frame: the scan takes 3 frames and no frame goes over 8 reads.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
