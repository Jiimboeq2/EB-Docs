-- A trash pull encounter (complete script)
--
-- encounters/hollow_skitters.lua of the complete instance: a gate that skips the step when no pack is up, a pull that brings the pack to the group's camp spot, then a clear of whatever is left within reach.
--
-- kind:      complete script
-- file:      EB/data/eb/ic/<collection>/fixture_hollow/encounters/hollow_skitters.lua
-- run:       eb ic run fixture_hollow
-- needs:     the instance file fixture_hollow/instance.lua beside its encounters folder
-- expect:    With four skitters up, the pack is pulled once and cleared; with none up, the step is skipped by its gate.
-- verified:  on the offline stand-in for the game
-- modules:   eb.ic
-- id:        script-ic-trash-pull

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
