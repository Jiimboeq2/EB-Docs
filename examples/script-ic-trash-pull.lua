-- EB tested example: A trash pull encounter (complete script)
-- script-ic-trash-pull | complete script | topics: instances, recipes
--
-- What it does:  encounters/hollow_skitters.lua of the complete instance: a gate that skips the step when no pack is up, a pull
--                that brings the pack to the group's camp spot, then a clear of whatever is left within reach.
-- Where it goes: EB/data/eb/ic/<collection>/fixture_hollow/encounters/hollow_skitters.lua (save it as hollow_skitters.lua)
-- Run it:        eb ic run fixture_hollow
-- Needs:         - the instance file fixture_hollow/instance.lua beside its encounters folder
-- Tested:        With four skitters up, the pack is pulled once and cleared; with none up, the step is skipped by its gate.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- fixture_hollow/encounters/hollow_skitters.lua - conditions -> actions, as data. The route's "trash" step runs it.
return {
    schema = "eb.ic/1",
    name = "a hollow skitter",
    kind = "trash",
    spot = { 0, 0, 5 },                                   -- where the tank fights it from
    -- the gate: no skitter up = nothing to do (the verdict says "skipped:gate" and the run goes on)
    when = { { actor_count = { query = "a hollow skitter", cmp = ">=", value = 1 } } },
    phases = {
        { id = "pull", do_ = { { pull = "a hollow skitter" } } },                  -- bring the pack to the camp spot
        { id = "clear", do_ = { { clear_area = "a hollow skitter", radius = 30 } } },
    },
    done = { { actor_count = { query = "a hollow skitter", cmp = "==", value = 0 } } },
}
