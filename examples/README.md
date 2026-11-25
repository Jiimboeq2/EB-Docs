# EB tested examples

Every example in the EB docs, one file each (406: 22 complete scripts, 384 snippets). Each file starts with a comment header: what it does, where it goes, how to run it, what it needs and what its test saw; the code under it is exactly the code that ran.

- A complete script runs as it is: save it under the name its header gives, in the place it gives.
- A snippet shows how to call EB's Lua library. Its file is the whole test: EB's offline stand-in for the game, the script, and the checks. A real script keeps only the script, without its lines that use DOCS, w. or a. (the guide shows the parts apart).

Each one is printed in full, with the guide around it, in [EB_Scripting_Guide.md](../EB_Scripting_Guide.md).

| Example | Kind | Topics | Title |
| --- | --- | --- | --- |
| [script-autocure](script-autocure.lua) | complete script | helpers, recipes, combat | Auto-cure watcher (complete script) |
| [script-buffkeeper](script-buffkeeper.lua) | complete script | helpers, combat | Buff keeper (complete script) |
| [script-assist](script-assist.lua) | complete script | helpers, crew, combat | Follow and assist the tank (complete script) |
| [script-namedwatch](script-namedwatch.lua) | complete script | helpers, crew, events | Say when a named spawns (complete script) |
| [script-groupready](script-groupready.lua) | complete script | helpers, crew | Group-ready checker (complete script) |
| [script-tellreply](script-tellreply.lua) | complete script | helpers, events | Answer tells while you are away (complete script) |
| [script-eventwatch](script-eventwatch.lua) | complete script | events, helpers, recipes | Event watcher (complete script) |
| [script-crewboard](script-crewboard.lua) | complete script | crew, helpers, recipes | Crew status board (complete script) |
| [script-followme](script-followme.lua) | complete script | crew, nav, helpers | Crew, follow me (complete script) |
| [script-hailreply](script-hailreply.lua) | complete script | dialogs, quests, helpers, recipes | Hail and answer an NPC (complete script) |
| [script-choicealert](script-choicealert.lua) | complete script | dialogs, helpers, events | Tell me when a yes/no question waits (complete script) |
| [script-ic-instance](script-ic-instance.lua) | complete script | instances, recipes, tasks | A whole instance file: hub, door, route, camp spots, pulls, loop (complete script) |
| [script-ic-trash-pull](script-ic-trash-pull.lua) | complete script | instances, recipes | A trash pull encounter (complete script) |
| [script-named-fight](script-named-fight.lua) | complete script | fights, recipes, instances | A named fight with a gate, phases, a reaction and a win test (complete script) |
| [script-ic-loop-task](script-ic-loop-task.lua) | complete script | tasks, instances, helpers, recipes | Loop an instance once the group is ready (complete script) |
| [script-foodkeeper](script-foodkeeper.lua) | complete script | items, helpers | Food and drink keeper (complete script) |
| [script-selljunk](script-selljunk.lua) | complete script | items, helpers | Sell junk at a merchant (complete script) |
| [script-bagwatch](script-bagwatch.lua) | complete script | items, helpers, crew | Pause EB when the bags are full (complete script) |
| [script-lootall](script-lootall.lua) | complete script | loot, events, helpers | Take loot windows by your rules (complete script) |
| [script-harvest](script-harvest.lua) | complete script | harvest, helpers | Harvest the nodes in reach (complete script) |
| [script-patrol](script-patrol.lua) | complete script | nav, helpers | Patrol between saved marks (complete script) |
| [script-setting](script-setting.lua) | complete script | settings, helpers, data | Change an EB setting (complete script) |
| [platform-target-and-services](platform-target-and-services.lua) | snippet | helpers, data | Ask the platform for a service |
| [platform-clock-now](platform-clock-now.lua) | snippet | helpers, perf | Time something with the platform clock |
| [platform-pulse-job](platform-pulse-job.lua) | snippet | helpers, perf | Run a job on a timer |
| [platform-pulse-task-wait](platform-pulse-task-wait.lua) | snippet | helpers, perf | Wait inside a task |
| [platform-wait-outside-task](platform-wait-outside-task.lua) | snippet | helpers, perf | Never wait in a job or a handler |
| [platform-wait-until](platform-wait-until.lua) | snippet | helpers, game | Wait for a condition, with a timeout |
| [platform-onstop-cleanup](platform-onstop-cleanup.lua) | snippet | helpers, data | Clean up when EB stops |
| [platform-log-lines](platform-log-lines.lua) | snippet | helpers | Write a log line |
| [platform-frame-read-budget](platform-frame-read-budget.lua) | snippet | perf, game | Stay inside the read budget |
| [platform-test-with-a-fake](platform-test-with-a-fake.lua) | snippet | helpers, data | Test a script with a fake service |
| [platform-clock-stand-in](platform-clock-stand-in.lua) | snippet | data, perf | Drive the clock in a test |
| [platform-pulse-frames-by-hand](platform-pulse-frames-by-hand.lua) | snippet | perf, helpers | Drive EB's frames yourself |
| [platform-settings-catalog](platform-settings-catalog.lua) | snippet | ui, data, settings | Read the settings catalog |
| [platform-files-memory-host](platform-files-memory-host.lua) | snippet | data, helpers | Test a helper's saves without a disk |
| [platform-services-tour](platform-services-tour.lua) | snippet | data, perf, ui | A tour of the platform services |
| [game-me-basics](game-me-basics.lua) | snippet | helpers, game | Read your own character |
| [game-target-read](game-target-read.lua) | snippet | game, combat | Read your target |
| [game-target-and-wait](game-target-and-wait.lua) | snippet | game, combat, helpers | Target an actor and wait for it to take |
| [game-face-actor](game-face-actor.lua) | snippet | game, nav | Turn to face an actor or a point |
| [game-nearest-npc](game-nearest-npc.lua) | snippet | game, helpers | Find the nearest NPC by name |
| [game-clickables-doors](game-clickables-doors.lua) | snippet | game, instances, helpers | List doors and clickable things near you |
| [game-lootables-open](game-lootables-open.lua) | snippet | game, items, loot | Find corpses and chests to loot |
| [game-engaged-hostiles](game-engaged-hostiles.lua) | snippet | game, combat, fights | Count the mobs fighting you |
| [game-engaged-named](game-engaged-named.lua) | snippet | game, fights, combat | Spot the named in the fight |
| [game-mob-casts](game-mob-casts.lua) | snippet | game, combat, fights | See which mobs are casting |
| [game-group-rows](game-group-rows.lua) | snippet | game, crew, helpers | Read your group and find who is hurt |
| [game-load-book](game-load-book.lua) | snippet | game, combat, perf | Load your ability book once |
| [game-ready-and-cast](game-ready-and-cast.lua) | snippet | game, combat, helpers | Cast an ability when it is ready |
| [game-cast-on-player](game-cast-on-player.lua) | snippet | game, combat, crew, helpers | Cast a heal on a group member by name |
| [game-readiness-one-read](game-readiness-one-read.lua) | snippet | game, perf, combat | Ask about many abilities for the price of one read |
| [game-cast-bars](game-cast-bars.lua) | snippet | game, combat, fights | Read what you and your target are casting, and cancel |
| [game-maintained](game-maintained.lua) | snippet | game, combat, helpers | List the spells you keep up |
| [game-has-effect-cache](game-has-effect-cache.lua) | snippet | game, perf, combat | Check a buff without flooding the server |
| [game-use-item](game-use-item.lua) | snippet | game, items, helpers | Use an item when it is ready |
| [game-equip-from-bags](game-equip-from-bags.lua) | snippet | game, items | Equip an item from your bags |
| [game-food-auto-consume](game-food-auto-consume.lua) | snippet | game, items, helpers | Keep food and drink on auto-consume |
| [game-gear-condition](game-gear-condition.lua) | snippet | game, items, helpers | Know when to repair |
| [game-usable-items](game-usable-items.lua) | snippet | game, items, ui | List the items you can click |
| [game-choice-window](game-choice-window.lua) | snippet | game, events, helpers, dialogs | Read a yes / no popup |
| [game-reply-dialog](game-reply-dialog.lua) | snippet | game, quests, helpers, dialogs | Answer an NPC's conversation |
| [game-reward-window](game-reward-window.lua) | snippet | game, quests, dialogs | Read a quest reward window |
| [game-loot-window](game-loot-window.lua) | snippet | game, items, perf, loot | Read the loot window without polling it |
| [game-zoning](game-zoning.lua) | snippet | game, nav, helpers | Hold a helper while a zone loads |
| [game-say-and-tell](game-say-and-tell.lua) | snippet | game, crew, helpers | Call out in group chat and send a tell |
| [game-onchat-record](game-onchat-record.lua) | snippet | game, events | Record chat lines from the game's own chat event |
| [game-tradeskill-levels](game-tradeskill-levels.lua) | snippet | game, items | Read your tradeskill level and a skill |
| [game-read-budget](game-read-budget.lua) | snippet | game, perf | Stay inside the per-frame read budget |
| [game-heroic-wheel](game-heroic-wheel.lua) | snippet | game, combat, fights | Read the heroic opportunity wheel |
| [game-control-effects](game-control-effects.lua) | snippet | game, combat, crew, helpers | Find a member who is stunned, feared or rooted |
| [game-actor-pos](game-actor-pos.lua) | snippet | game, nav, combat | Where an actor stands, and whether it is gone |
| [game-repair-and-close](game-repair-and-close.lua) | snippet | game, items, helpers | Repair at a mender and close the window |
| [game-hail-target](game-hail-target.lua) | snippet | game, quests, helpers, dialogs | Hail an NPC |
| [game-wait-in-task](game-wait-in-task.lua) | snippet | game, perf, helpers | Wait for something without freezing the game |
| [tlo-me-batched-read](tlo-me-batched-read.lua) | snippet | tlos, perf | Read several Me members in ONE read |
| [tlo-getvar-verified](tlo-getvar-verified.lua) | snippet | tlos, items | Read one member the game layer does not return |
| [tlo-getvar-not-verified](tlo-getvar-not-verified.lua) | snippet | tlos | What GetVar does with a member that is not verified yet |
| [tlo-target-members](tlo-target-members.lua) | snippet | tlos, combat | Target members, and what NULL looks like |
| [tlo-actor-by-id](tlo-actor-by-id.lua) | snippet | tlos, game | Read an actor by its id |
| [tlo-actor-query](tlo-actor-query.lua) | snippet | tlos, game, helpers | Search actors with a query |
| [tlo-group-member](tlo-group-member.lua) | snippet | tlos, crew | Read a group slot: Me.Group\[n\] |
| [tlo-raid-rows](tlo-raid-rows.lua) | snippet | tlos, crew | Read the raid outside your group |
| [tlo-zone-name-flips-early](tlo-zone-name-flips-early.lua) | snippet | tlos, nav, helpers | Zone.Name changes at the START of a zone load |
| [tlo-gamedata-casting](tlo-gamedata-casting.lua) | snippet | tlos, combat, fights | Read the cast bars through GetGameData |
| [tlo-isxeq2-ready](tlo-isxeq2-ready.lua) | snippet | tlos, helpers | Check that the game extension is ready |
| [tlo-exists-and-text](tlo-exists-and-text.lua) | snippet | tlos | TRUE or NULL, and numbers as text |
| [tlo-effect-info-server](tlo-effect-info-server.lua) | snippet | tlos, perf | Effect names are server requests - never poll them |
| [tlo-loot-items](tlo-loot-items.lua) | snippet | tlos, items, loot | Read the items in an open loot window |
| [tlo-merchant-price](tlo-merchant-price.lua) | snippet | tlos, items | What a merchant pays for a bag item |
| [tlo-ui-page-by-name](tlo-ui-page-by-name.lua) | snippet | tlos, ui | Read an interface element by its full name |
| [tlo-ebnav-probe](tlo-ebnav-probe.lua) | snippet | tlos, nav | Check EB's nav extension before you route |
| [tlo-reply-dialog-classic](tlo-reply-dialog-classic.lua) | snippet | tlos, quests, dialogs | The classic conversation window |
| [tlo-innerspace-basics](tlo-innerspace-basics.lua) | snippet | tlos, helpers | InnerSpace's own reads: session, extensions, the window, the folder |
| [events-chat-line](events-chat-line.lua) | snippet | events, helpers | React to a chat line |
| [events-zoning](events-zoning.lua) | snippet | events, helpers, nav | React to a zone change |
| [events-once-and-off](events-once-and-off.lua) | snippet | events | A one-time handler, and unsubscribing |
| [events-crew-line](events-crew-line.lua) | snippet | events, crew, helpers | Turn an event into one command for the crew |
| [events-handler-error](events-handler-error.lua) | snippet | events, helpers | A handler that fails never stops the others |
| [events-dedupe](events-dedupe.lua) | snippet | events | The same line twice is delivered once |
| [events-quest-update](events-quest-update.lua) | snippet | events, quests | Follow a quest's progress |
| [commands-console-status](commands-console-status.lua) | snippet | commands, helpers | Type an eb command |
| [commands-app-dispatch](commands-app-dispatch.lua) | snippet | commands, helpers | Run a command from a script in a running EB |
| [commands-attach-handler](commands-attach-handler.lua) | snippet | commands, helpers | Answer an eb command with your own handler |
| [commands-crew-scopes](commands-crew-scopes.lua) | snippet | commands, crew | Send a command to the crew |
| [commands-crew-line-out](commands-crew-line-out.lua) | snippet | commands, crew | A crew line leaves this box |
| [commands-help-lines](commands-help-lines.lua) | snippet | commands | Read the built-in help |
| [commands-tab-complete](commands-tab-complete.lua) | snippet | commands, ui | Tab-complete a command line |
| [commands-view-grid](commands-view-grid.lua) | snippet | commands, ui | Build a button row from the registry |
| [commands-parse-line](commands-parse-line.lua) | snippet | commands | Read a command line without running it |
| [commands-refusals](commands-refusals.lua) | snippet | commands, helpers | What a refused line tells you |
| [commands-customer-schema](commands-customer-schema.lua) | snippet | commands, data | Export the command list |
| [commands-core-family](commands-core-family.lua) | snippet | commands, helpers | Pause, resume, status and the kill switch |
| [commands-not-answered-yet](commands-not-answered-yet.lua) | snippet | commands | Which commands this box answers |
| [commands-console-words](commands-console-words.lua) | snippet | commands, ui | A console word of your own |
| [commands-registry-own-copy](commands-registry-own-copy.lua) | snippet | commands, helpers | A registry of your own, and wrapping a handler |
| [commands-window-commands](commands-window-commands.lua) | snippet | commands, ui | The window and monitor commands in this release |
| [commands-utility-commands](commands-utility-commands.lua) | snippet | commands, data | The utility commands in this release |
| [crew-two-boxes](crew-two-boxes.lua) | snippet | crew, helpers | Two boxes, one crew |
| [crew-who-matching](crew-who-matching.lua) | snippet | crew | Address boxes by box, name, class or archetype |
| [crew-parse-scope](crew-parse-scope.lua) | snippet | crew, commands | Split a typed line into scope and command |
| [crew-state-roster](crew-state-roster.lua) | snippet | crew, helpers | Hear what the other boxes are doing |
| [crew-dedupe](crew-dedupe.lua) | snippet | crew | A line heard twice runs once |
| [crew-group-barrier](crew-group-barrier.lua) | snippet | crew, instances | Wait for the group at a mark |
| [crew-roles-driver](crew-roles-driver.lua) | snippet | crew, instances | Who drives the group |
| [crew-orders](crew-orders.lua) | snippet | crew, instances | Give the followers an order |
| [crew-console-model](crew-console-model.lua) | snippet | crew, ui | Drive the console from a script |
| [crew-event-to-crew](crew-event-to-crew.lua) | snippet | crew, events, helpers | Turn one box's event into a crew command |
| [crew-announce-and-send](crew-announce-and-send.lua) | snippet | crew, commands | Send a command to one box, announce to all |
| [crew-group-calls](crew-group-calls.lua) | snippet | crew, instances | Call the group back, evacuate, read the group |
| [crew-commands-status](crew-commands-status.lua) | snippet | commands, crew | The crew and coordination commands in this release |
| [world-snapshot](world-snapshot.lua) | snippet | game, perf, helpers | Read the world snapshot |
| [world-shared-per-frame](world-shared-per-frame.lua) | snippet | perf, ui | One snapshot per frame, shared by everyone |
| [world-out-of-world](world-out-of-world.lua) | snippet | helpers, game | Do nothing while a zone loads |
| [world-contracts](world-contracts.lua) | snippet | helpers | Check a subsystem against its contract |
| [world-brain-custom-goal](world-brain-custom-goal.lua) | snippet | helpers, instances | Give the brain your own goal |
| [world-brain-pause](world-brain-pause.lua) | snippet | helpers, ui | Pause the brain and read its status |
| [world-goals-and-interrupts](world-goals-and-interrupts.lua) | snippet | combat, helpers | Goals, interrupts and one tick |
| [world-brain-step-by-step](world-brain-step-by-step.lua) | snippet | combat, helpers | Step a brain by hand |
| [nav-walk-to-point](nav-walk-to-point.lua) | snippet | nav, helpers | Walk to a point over the mesh |
| [nav-plan-route](nav-plan-route.lua) | snippet | nav | Plan a route without walking it |
| [nav-stop-a-walk](nav-stop-a-walk.lua) | snippet | nav, helpers | Stop a walk cleanly |
| [nav-follow-actor](nav-follow-actor.lua) | snippet | nav, crew | Follow an actor |
| [nav-short-hop](nav-short-hop.lua) | snippet | nav, perf | A short hop needs no route |
| [nav-no-route](nav-no-route.lua) | snippet | nav, helpers | A walk the mesh has no route for fails and says why |
| [nav-link-jump](nav-link-jump.lua) | snippet | nav | Where the mesh joins two floors: one jump tap |
| [nav-mesh-queries](nav-mesh-queries.lua) | snippet | nav | Ask the mesh directly |
| [nav-zone-and-actor](nav-zone-and-actor.lua) | snippet | nav, game, helpers | Where am I, and where is that actor |
| [nav-lava-goal-shore](nav-lava-goal-shore.lua) | snippet | nav, helpers | A goal in lava becomes its shore |
| [nav-travel-plan](nav-travel-plan.lua) | snippet | nav, quests | Plan a trip to another zone |
| [nav-transit-pads](nav-transit-pads.lua) | snippet | nav | Ride the zone's own transit |
| [nav-walk-command](nav-walk-command.lua) | snippet | nav, commands | Walk with an eb command |
| [nav-perf-one-route](nav-perf-one-route.lua) | snippet | nav, perf | What a walk costs |
| [nav-saved-spot](nav-saved-spot.lua) | snippet | nav, helpers | Save a spot and walk back to it |
| [nav-blacklist-spot](nav-blacklist-spot.lua) | snippet | nav, helpers | Keep walks out of a bad spot |
| [nav-mesh-service](nav-mesh-service.lua) | snippet | nav, perf | Ask the mesh service directly |
| [nav-door-on-route](nav-door-on-route.lua) | snippet | nav, helpers | Open the door a route goes through |
| [nav-door-lines](nav-door-lines.lua) | snippet | nav, data | Fix a door's verb on this PC |
| [nav-mesh-reports](nav-mesh-reports.lua) | snippet | nav, ui | Diagnose a zone's mesh |
| [nav-place-avoid](nav-place-avoid.lua) | snippet | nav, helpers | Keep every walk out of a bad spot |
| [nav-travel-multizone](nav-travel-multizone.lua) | snippet | nav, recipes | Plan a multi-zone trip by bell and spire, by your side |
| [nav-transit-graph](nav-transit-graph.lua) | snippet | nav, data | Read a zone's pads and plan a pad trip |
| [nav-hazard-abort](nav-hazard-abort.lua) | snippet | nav, helpers | Catch health lost out of combat and back out |
| [nav-hazard-lethal](nav-hazard-lethal.lua) | snippet | nav, quests | Never swim where the liquid kills |
| [nav-mark-shared](nav-mark-shared.lua) | snippet | nav, data | Pin marks the crew and the map share |
| [nav-bell-sides](nav-bell-sides.lua) | snippet | nav, helpers | Which side of the city bells you travel on |
| [nav-fixes-layer](nav-fixes-layer.lua) | snippet | nav, data | Read a zone's mesh corrections |
| [nav-store-layout](nav-store-layout.lua) | snippet | nav, data | Where EB's nav data lives |
| [nav-bell-maps](nav-bell-maps.lua) | snippet | nav, helpers | Remember what a bell's map offers |
| [nav-swim-surface](nav-swim-surface.lua) | snippet | nav, fights | Swim corners, the water's surface and no dive in a fight |
| [nav-zone-words](nav-zone-words.lua) | snippet | nav, commands | Turn a typed word into a zone |
| [nav-follow-command](nav-follow-command.lua) | snippet | nav, commands, crew | Follow a crew member with eb follow |
| [nav-marks-command](nav-marks-command.lua) | snippet | nav, commands | Marks and blacklists from the console |
| [nav-travel-commands](nav-travel-commands.lua) | snippet | nav, commands | Preview and ride a trip from the console |
| [combat-ready-and-cast](combat-ready-and-cast.lua) | snippet | combat, game | Is it ready? Then cast it |
| [combat-engine-step](combat-engine-step.lua) | snippet | combat | One engine step, one decision |
| [combat-never-a-guard](combat-never-a-guard.lua) | snippet | combat, helpers | Guards are never pulled or splashed |
| [combat-presets](combat-presets.lua) | snippet | combat | Presets per context |
| [combat-zone-override](combat-zone-override.lua) | snippet | combat, instances | Change combat for one zone |
| [combat-target-lock](combat-target-lock.lua) | snippet | combat, fights | Lock the engine onto one mob |
| [combat-interrupt-cast](combat-interrupt-cast.lua) | snippet | combat, fights | Interrupt a listed cast |
| [combat-ready-one-read](combat-ready-one-read.lua) | snippet | combat, perf | Readiness costs one read a frame |
| [combat-app-plane](combat-app-plane.lua) | snippet | combat | The combat plane EB runs |
| [combat-why-no-cast](combat-why-no-cast.lua) | snippet | combat, helpers | Why does the engine not cast that? |
| [combat-giveup-unwinnable](combat-giveup-unwinnable.lua) | snippet | combat, fights | Give up a fight that cannot be won |
| [combat-timed-tags](combat-timed-tags.lua) | snippet | combat, fights | Timed tags and a pre-cast |
| [combat-dispel-named](combat-dispel-named.lua) | snippet | combat, fights | Strip a named's buff |
| [combat-kill-list-rules](combat-kill-list-rules.lua) | snippet | combat, fights, instances | The kill-first list, rules and stragglers |
| [combat-util-helpers](combat-util-helpers.lua) | snippet | combat, helpers | The engine's small helpers |
| [combat-facade-views](combat-facade-views.lua) | snippet | combat, instances, crew | The combat plane, its facade and the follower view |
| [combat-heal-lowest](combat-heal-lowest.lua) | snippet | combat, crew | Heal whoever fell furthest |
| [combat-group-heal](combat-group-heal.lua) | snippet | combat, crew | A group heal waits for enough hurt members |
| [combat-cure-detriment](combat-cure-detriment.lua) | snippet | combat, crew, fights | Cure only who carries the detriment |
| [combat-rez-and-power](combat-rez-and-power.lua) | snippet | combat, crew | Rez the fallen, then a power heal |
| [combat-buff-upkeep](combat-buff-upkeep.lua) | snippet | combat, crew | Keep a buff up, keep the tank's ward up |
| [combat-mez-adds](combat-mez-adds.lua) | snippet | combat, fights | Mez the adds, renew before it breaks |
| [combat-ho-wheel](combat-ho-wheel.lua) | snippet | combat, fights | Open and advance a heroic opportunity |
| [combat-override-per-mob](combat-override-per-mob.lua) | snippet | combat, fights, instances | Overrides per zone, per mob, and a timed pause |
| [combat-positioning](combat-positioning.lua) | snippet | combat, nav, fights | Where to stand, and line of sight |
| [combat-roles](combat-roles.lua) | snippet | combat, crew | Aim at a role: Bard, DPS1, Healer1 |
| [combat-wire-commands](combat-wire-commands.lua) | snippet | combat, commands, helpers | The combat commands, and answering one from a script |
| [stack-build](stack-build.lua) | snippet | combat, data | Build a cast stack from its rows |
| [stack-switch-row](stack-switch-row.lua) | snippet | combat, fights | Switch one cast-stack row off and on |
| [stack-switch-tag](stack-switch-tag.lua) | snippet | combat, fights | Switch every row with a tag |
| [stack-rebind-keeps-switches](stack-rebind-keeps-switches.lua) | snippet | combat, fights | A reload keeps your switches |
| [stack-class-facts](stack-class-facts.lua) | snippet | combat, data | Class facts fill in what a heal row leaves out |
| [stack-engine-toggle](stack-engine-toggle.lua) | snippet | combat, fights | Switch a tag from the engine |
| [stack-loader-find](stack-loader-find.lua) | snippet | combat, data | Find a character's cast stack by name |
| [stack-row-format](stack-row-format.lua) | snippet | combat, data | Write cast-stack rows by hand |
| [stack-class-module](stack-class-module.lua) | snippet | combat, data | A class module of your own |
| [stack-apply-managers](stack-apply-managers.lua) | snippet | combat, data | Hand a built stack to category managers |
| [stack-loader-reload](stack-loader-reload.lua) | snippet | combat, data | Reload a cast stack when its file changes |
| [recipe-named-fight](recipe-named-fight.lua) | snippet | recipes, fights, combat, events | Recipe: script a named fight |
| [fight-emote-cue](fight-emote-cue.lua) | snippet | fights, events, helpers | React to a boss emote |
| [fight-announcement-timer](fight-announcement-timer.lua) | snippet | fights, events | Time a mechanic from an announcement |
| [fight-safe-spot](fight-safe-spot.lua) | snippet | fights, nav | Step out to a safe spot and back |
| [fight-phase-by-health](fight-phase-by-health.lua) | snippet | fights, combat | Change phase at a health mark |
| [fight-cure-on-cue](fight-cure-on-cue.lua) | snippet | fights, combat, crew | Cure a member on cue |
| [fight-interrupt-on-cue](fight-interrupt-on-cue.lua) | snippet | fights, combat | Interrupt the boss's big cast yourself |
| [fight-crew-pause-on-spawn](fight-crew-pause-on-spawn.lua) | snippet | fights, events, crew, helpers | Pause the crew when the named appears |
| [fight-engaged-named](fight-engaged-named.lua) | snippet | fights, combat, game, perf | Who is in the fight |
| [fight-encounter-override](fight-encounter-override.lua) | snippet | fights, combat, instances | Shape combat for one encounter |
| [recipe-ic-route](recipe-ic-route.lua) | snippet | recipes, instances | Recipe: an instance route with steps, pulls and a camp spot |
| [ic-load-checks](ic-load-checks.lua) | snippet | instances | What runner:load refuses |
| [ic-tank-zones-group-in](ic-tank-zones-group-in.lua) | snippet | instances, crew | The tank zones the group in |
| [ic-member-holds](ic-member-holds.lua) | snippet | instances, crew | A member's run: hold, never walk the route |
| [ic-reactive-phase](ic-reactive-phase.lua) | snippet | instances, fights | A mechanic mid-fight: a reactive phase |
| [ic-conditions](ic-conditions.lua) | snippet | instances, fights | Encounter conditions, and how they fail closed |
| [ic-death-recovery](ic-death-recovery.lua) | snippet | instances, fights | Death in an instance: revive, walk back, pull again |
| [ic-options-and-gates](ic-options-and-gates.lua) | snippet | instances | Instance options and step gates |
| [ic-dry-run](ic-dry-run.lua) | snippet | instances, helpers | Dry-run an instance file |
| [ic-saved-run](ic-saved-run.lua) | snippet | instances, data | Save a run and resume it at a step |
| [ic-combat-hold](ic-combat-hold.lua) | snippet | instances, combat, fights | When does a combat wait end? |
| [ic-eb-ic-command](ic-eb-ic-command.lua) | snippet | instances, commands | eb ic from the console and from a script |
| [ic-hub-route](ic-hub-route.lua) | snippet | instances, nav | A hub route the tank walks alone |
| [ic-route-step-kinds](ic-route-step-kinds.lua) | snippet | instances | One route step of each kind |
| [ic-custom-route-act](ic-custom-route-act.lua) | snippet | instances, helpers | Add your own route step kind |
| [ic-world-facade-sensors](ic-world-facade-sensors.lua) | snippet | instances, fights | Read a fight's sensors through the world facade |
| [ic-group-stragglers](ic-group-stragglers.lua) | snippet | instances, crew | Who is still elsewhere, and one copy for the door |
| [tse-at-zone-end](tse-at-zone-end.lua) | snippet | instances, tasks | The T.S.E at the zone's end, inside |
| [ic-cleared-copy](ic-cleared-copy.lua) | snippet | instances, tasks | Spot a reset that did not take |
| [ic-base-helpers](ic-base-helpers.lua) | snippet | instances, helpers | The runner's small helpers in a custom action |
| [ic-hold-flag-watch](ic-hold-flag-watch.lua) | snippet | instances, fights | Tell a stuck combat flag from a real fight |
| [ic-console-commands](ic-console-commands.lua) | snippet | instances, commands | The instance commands from the console |
| [recipe-quest-pack](recipe-quest-pack.lua) | snippet | recipes, quests | Recipe: a quest pack with stages, hails and clicks |
| [quest-statuses](quest-statuses.lua) | snippet | quests | What quests.step answers, and what to do with it |
| [quest-load-file](quest-load-file.lua) | snippet | quests, data | Load a quest pack from its file |
| [quest-resume-pointer](quest-resume-pointer.lua) | snippet | quests, data | Save where a quest is, and resume there |
| [quest-step-target](quest-step-target.lua) | snippet | quests, nav | Where does the current step want the character? |
| [quest-conditions](quest-conditions.lua) | snippet | quests | Skip a step on a condition or on the journal |
| [quest-wait-for-journal](quest-wait-for-journal.lua) | snippet | quests, events | Wait for the journal to move on |
| [quest-no-fast-travel](quest-no-fast-travel.lua) | snippet | quests, nav | Packs never fast travel |
| [quest-verbs](quest-verbs.lua) | snippet | quests, helpers | What a pack can say: the verb list |
| [quest-zone-routes](quest-zone-routes.lua) | snippet | quests, nav | A pack's own way into a zone |
| [quest-instance-member](quest-instance-member.lua) | snippet | quests, instances, crew | A quest that goes into an instance, in a group |
| [quest-journal-reader](quest-journal-reader.lua) | snippet | quests, helpers | Read a quest's journal lines |
| [quest-gates](quest-gates.lua) | snippet | quests | A pack's gates: level, a held sibling, a zone's wing |
| [quest-custom-verb](quest-custom-verb.lua) | snippet | quests, helpers | Add your own pack verb |
| [quest-stop-flag](quest-stop-flag.lua) | snippet | quests, helpers | Stop a quest run at once |
| [quest-console-commands](quest-console-commands.lua) | snippet | quests, commands | The quest commands from the console |
| [overseer-command](overseer-command.lua) | snippet | quests, commands | EB Overseer from the console |
| [quest-turn-helpers](quest-turn-helpers.lua) | snippet | quests, helpers | A pack verb that reads the journal and the world |
| [quest-verb-helpers](quest-verb-helpers.lua) | snippet | quests | The verb registry's parsers and its refusals |
| [quest-journal-held](quest-journal-held.lua) | snippet | quests | Is a quest on the tracker? |
| [quest-core-api](quest-core-api.lua) | snippet | quests | Run a pack on the runner's core, with only your own verbs |
| [quest-conditions-read](quest-conditions-read.lua) | snippet | quests | Read a pack's condition text yourself |
| [quest-mail-pick](quest-mail-pick.lua) | snippet | quests, items | Pick a letter for OpenMail |
| [loop-ic-one-zone](loop-ic-one-zone.lua) | snippet | tasks, instances | Loop one instance: wait inside until it can be reset |
| [loop-ic-args](loop-ic-args.lua) | snippet | tasks, instances, commands | Loop windows and the reset decision |
| [loop-ic-chores](loop-ic-chores.lua) | snippet | tasks, instances, items | Chores at the end of each run |
| [loop-trainer-goal](loop-trainer-goal.lua) | snippet | tasks, helpers | Hand the brain a chore loop |
| [loop-pickers](loop-pickers.lua) | snippet | tasks, helpers | The loops' own decisions: an upgrade and a hire |
| [loop-provider](loop-provider.lua) | snippet | tasks, helpers | Build a loop's provider and see what is missing |
| [loop-stop-and-gates](loop-stop-and-gates.lua) | snippet | tasks, helpers | A chore loop's stop flag and coin gate |
| [plroute-run](plroute-run.lua) | snippet | tasks, nav, combat | Run a power-level route, step by step |
| [plroute-catalog](plroute-catalog.lua) | snippet | tasks, data | The power-level routes EB ships, and their short codes |
| [plroute-share](plroute-share.lua) | snippet | tasks, data, crew | Share a route: the scrub and the short code |
| [plroute-plan-rules](plroute-plan-rules.lua) | snippet | tasks, combat, helpers | The pull and break rules behind a route |
| [loop-overseer-plan](loop-overseer-plan.lua) | snippet | tasks, helpers | The overseer's daily pass, and how it picks agents |
| [loop-errands-collections](loop-errands-collections.lua) | snippet | tasks, items | Writs and collections as chore loops |
| [plroute-catalog-lookup](plroute-catalog-lookup.lua) | snippet | tasks, data | Look a route up in the catalog |
| [plroute-plan-helpers](plroute-plan-helpers.lua) | snippet | tasks | A route's plan helpers: skipped steps, repeats, stalls, rates |
| [plroute-actions](plroute-actions.lua) | snippet | tasks | A route's actions, one bite at a time |
| [econ-job-steps](econ-job-steps.lua) | snippet | tasks, items, helpers | Write long work as a pollable job |
| [econ-job-gate](econ-job-gate.lua) | snippet | tasks, items | One job per request: call it every tick, it resumes |
| [tse-handover](tse-handover.lua) | snippet | tasks, items, crew | The T.S.E hand-over: a member gives its pick to the leader |
| [tse-sell-pick](tse-sell-pick.lua) | snippet | tasks, items | Sell the T.S.E pick at the merchant instead |
| [econ-loot-best-rule](econ-loot-best-rule.lua) | snippet | items, data, loot | Which loot rule names an item |
| [econ-loot-decide-window](econ-loot-decide-window.lua) | snippet | items, helpers, loot | Decide what to do with a whole loot window |
| [econ-loot-assign-role](econ-loot-assign-role.lua) | snippet | items, crew, loot | Give a drop to a role: @priest, @fighter ... |
| [econ-loot-from-window](econ-loot-from-window.lua) | snippet | items, helpers, recipes, events, loot | A loot helper: read the window, apply the rules, take the lot |
| [econ-after-loot-guard](econ-after-loot-guard.lua) | snippet | items, helpers, loot | The after-looting guard: destroy only by exact name |
| [econ-filter-pick](econ-filter-pick.lua) | snippet | items, data | Pick items from a list with a filter |
| [econ-rules-can-take](econ-rules-can-take.lua) | snippet | items, helpers | Ask the safety gate before destroying or selling |
| [econ-rules-config](econ-rules-config.lua) | snippet | items, data | Economy settings and their safe defaults |
| [econ-ledger-coin](econ-ledger-coin.lua) | snippet | items, data, ui | Coin in words and a day's sums |
| [econ-group-loot-words](econ-group-loot-words.lua) | snippet | items, crew, loot | Understand a group loot method however it is typed |
| [econ-purchase-confirm](econ-purchase-confirm.lua) | snippet | items, helpers, dialogs | Answer a purchase question only for your own item |
| [econ-merchant-lines](econ-merchant-lines.lua) | snippet | items, events | Read a merchant's price and the game's buy lines |
| [econ-bags-full-contract](econ-bags-full-contract.lua) | snippet | items, helpers | The economy's bags-full check |
| [econ-settings-document](econ-settings-document.lua) | snippet | items, data, settings | Write the economy settings |
| [econ-vendor-sell-sweep](econ-vendor-sell-sweep.lua) | snippet | items, helpers | Sell a list of items at a merchant |
| [econ-protect-and-gate](econ-protect-and-gate.lua) | snippet | items | Protect an item from every bulk action |
| [econ-junk-by-rule](econ-junk-by-rule.lua) | snippet | items | Clear junk without a vendor trip |
| [econ-repair-threshold](econ-repair-threshold.lua) | snippet | items | Repair only when the gear needs it |
| [econ-merchant-buy-confirm](econ-merchant-buy-confirm.lua) | snippet | items, helpers, dialogs | Buy from a merchant and answer the purchase question |
| [econ-confirm-own-buy](econ-confirm-own-buy.lua) | snippet | items, helpers, dialogs | Answer the purchase question in your own buy helper |
| [econ-stone-table](econ-stone-table.lua) | snippet | items | Read a stone merchant's rows |
| [econ-depot-topup](econ-depot-topup.lua) | snippet | items, crew | Restock from the depot with one list for the whole group |
| [econ-depot-deposit-rule](econ-depot-deposit-rule.lua) | snippet | items | Deposit by a rule, keep the keep list |
| [econ-quiver-fill](econ-quiver-fill.lua) | snippet | items | Top up your ammo from the ammo depot |
| [econ-search-and-trade](econ-search-and-trade.lua) | snippet | items, crew | Find an item and hand some to a player |
| [econ-bank-deposit-plan](econ-bank-deposit-plan.lua) | snippet | items | Plan a bank deposit before you make it |
| [econ-bank-coin-purse](econ-bank-coin-purse.lua) | snippet | items | Keep a set amount of coin on you |
| [econ-mail-send](econ-mail-send.lua) | snippet | items, crew | Mail items and coin to another character |
| [econ-mail-open-letter](econ-mail-open-letter.lua) | snippet | items, quests | Open one letter by its subject and take what it carries |
| [econ-broker-reprice](econ-broker-reprice.lua) | snippet | items | Reprice your broker listings |
| [econ-broker-buy-capped](econ-broker-buy-capped.lua) | snippet | items, helpers | Buy what you are short of, under a price cap |
| [econ-broker-list-from-bags](econ-broker-list-from-bags.lua) | snippet | items | Put bag items up on the broker |
| [econ-loot-classify](econ-loot-classify.lua) | snippet | items, crew, loot | What this box does with each drop |
| [econ-loot-grab-corpse](econ-loot-grab-corpse.lua) | snippet | items, helpers, loot | Loot a corpse by rule |
| [econ-loot-leader-assign](econ-loot-leader-assign.lua) | snippet | items, crew, loot | Hand drops out from the leader's loot window |
| [econ-auction-resolve](econ-auction-resolve.lua) | snippet | items, crew, loot | Give a gear drop to the member who gains the most |
| [econ-ledger-feed](econ-ledger-feed.lua) | snippet | items, data | Record and read the money and item ledger |
| [econ-commissions-allow](econ-commissions-allow.lua) | snippet | items, crew | Accept crafting commissions only from your own people |
| [econ-drive-report](econ-drive-report.lua) | snippet | items | See which window actions a drive provides |
| [econ-commands-status](econ-commands-status.lua) | snippet | items, commands | The item and loot commands in this build |
| [ui-window-state](ui-window-state.lua) | snippet | ui, perf | Build a window's state |
| [ui-window-verbs](ui-window-verbs.lua) | snippet | ui, commands | Answer a click with a verb |
| [ui-window-live](ui-window-live.lua) | snippet | ui, perf | Refresh a window from data that moves on its own |
| [ui-push-budget](ui-push-budget.lua) | snippet | ui, perf | Cap how often a window's state goes out |
| [ui-read-budget](ui-read-budget.lua) | snippet | perf, ui, helpers | Spread a big scan over several frames |
| [ui-register-window](ui-register-window.lua) | snippet | ui | Register a window with EB's window bridge |
| [ui-guard-ui-reads](ui-guard-ui-reads.lua) | snippet | ui, game | Check a UI read before you send it |
| [ui-control-presses](ui-control-presses.lua) | snippet | ui, commands | Press EB Main's buttons from a script |
| [ui-icons-for-rows](ui-icons-for-rows.lua) | snippet | ui | Put icons on a window's rows |
| [ui-window-and-budget-tour](ui-window-and-budget-tour.lua) | snippet | ui, perf | A window's verbs, its open and close, and the push budget |
| [data-jsontable-roundtrip](data-jsontable-roundtrip.lua) | snippet | data | Turn a table into JSON and back |
| [data-jsontable-empty-list](data-jsontable-empty-list.lua) | snippet | data, ui | Write an empty list as \[\] |
| [data-jsontable-null](data-jsontable-null.lua) | snippet | data | Keep a null in a JSON document |
| [data-json-lossless-edit](data-json-lossless-edit.lua) | snippet | data | Change one field in a JSON file another program owns |
| [data-lua-fmt-document](data-lua-fmt-document.lua) | snippet | data, quests, instances | Write a Lua data file |
| [data-files-list-and-copy](data-files-list-and-copy.lua) | snippet | data | Read, write, copy and list your helper's files |
| [data-files-write-behind](data-files-write-behind.lua) | snippet | data, perf | Save from game code without touching the disk in the frame |
| [data-helper-config-file](data-helper-config-file.lua) | snippet | data, helpers | Keep a helper's own config in a JSON file |
| [data-settings-get-set](data-settings-get-set.lua) | snippet | data, settings | Read and change an EB setting |
| [data-compat-numbers](data-compat-numbers.lua) | snippet | data | Print numbers the same way everywhere |
| [data-json-quote-and-order](data-json-quote-and-order.lua) | snippet | data | One JSON string, and the key order files use |
| [data-null-and-lua-values](data-null-and-lua-values.lua) | snippet | data | A JSON null, and Lua values as text |
| [craft-station-serves](craft-station-serves.lua) | snippet | items, helpers | Does this station serve the recipe? |
| [craft-pick-art](craft-pick-art.lua) | snippet | items | Pick the reaction art for this moment of a combine |
| [craft-one-recipe](craft-one-recipe.lua) | snippet | items | Craft one order at the station in reach |
| [craft-queue](craft-queue.lua) | snippet | items | Craft a list of orders |
| [craft-wrong-station](craft-wrong-station.lua) | snippet | items | Refuse a station that does not serve the recipe |
| [craft-fuel-from-depot](craft-fuel-from-depot.lua) | snippet | items | Fetch missing fuel from the fuel depot before a combine |
| [writ-resolve-recipe](writ-resolve-recipe.lua) | snippet | items | Work out which recipe a work-order step asks for |
| [writ-run](writ-run.lua) | snippet | items | Take a work order, craft every step, hand it in |
| [harvest-want-node](harvest-want-node.lua) | snippet | items, helpers, harvest | Decide which harvest nodes to take |
| [harvest-route](harvest-route.lua) | snippet | items, nav, harvest | Run a gather route |
| [harvest-shiny-and-pony](harvest-shiny-and-pony.lua) | snippet | items, helpers, crew, harvest | Track shinies and send the pack pony out |
| [skill-parse-rules](skill-parse-rules.lua) | snippet | items | Read a skill value the way EB does |
| [skill-read-live](skill-read-live.lua) | snippet | items, game | Read a crafting skill through the game layer |
| [skill-level-status](skill-level-status.lua) | snippet | items | Where a secondary skill stands, and the books a trip would buy |
| [skill-level-decisions](skill-level-decisions.lua) | snippet | items | The levelling decisions, step by step |
| [skill-level-run](skill-level-run.lua) | snippet | items | Level Tinkering to its cap |
| [skill-level-crafter](skill-level-crafter.lua) | snippet | items | Level a new crafter's tradeskill |
| [transmute-preview](transmute-preview.lua) | snippet | items | Preview what a bulk transmute would take |
| [transmute-bulk-run](transmute-bulk-run.lua) | snippet | items | Run a bulk salvage - and the guards that refuse a careless one |
| [transmute-level-skill](transmute-level-skill.lua) | snippet | items | Level the Transmuting skill on a stone merchant |
| [adorn-audit](adorn-audit.lua) | snippet | items | What an adornment profile still needs |
| [adorn-apply-profile](adorn-apply-profile.lua) | snippet | items | Apply an adornment profile |
| [adorn-class-set](adorn-class-set.lua) | snippet | items, crew | A class set of adornments, picked for each character |
| [adorn-unadorn-and-temp](adorn-unadorn-and-temp.lua) | snippet | items | Strip old gear's adornments, keep temporary adornments up |
| [gear-score](gear-score.lua) | snippet | items | How EB scores a piece of gear |
| [gear-auto-upgrade](gear-auto-upgrade.lua) | snippet | items | Wear the best gear in the bags (auto-upgrade) |
| [gear-fill-from-broker](gear-fill-from-broker.lua) | snippet | items | Fill an empty slot from the broker |
| [gear-group-trades](gear-group-trades.lua) | snippet | items, crew | Plan who in the group should get which spare piece |
| [gm-plan-and-run](gm-plan-and-run.lua) | snippet | items | Turn Master scrolls into Grandmaster crafts |
| [collection-scope](collection-scope.lua) | snippet | items, quests | Which collection pieces you still miss |
| [collection-fill](collection-fill.lua) | snippet | items, helpers | Add the collection pieces you already have |
| [collection-buy](collection-buy.lua) | snippet | items | Buy the missing collection pieces - the three models |
| [econ-commands-layer](econ-commands-layer.lua) | snippet | items, commands | Answer the economy's commands from your own economy |
| [crafting-commands-live](crafting-commands-live.lua) | snippet | items, commands | Which crafting, harvest and gear commands are live on this box |
| [coord-rule-tag-across-boxes](coord-rule-tag-across-boxes.lua) | snippet | crew, fights, helpers | When the tank shouts, the healer reacts |
| [coord-embargo-hold](coord-embargo-hold.lua) | snippet | crew, fights, combat | Hold an ability for a while |
| [coord-delay-and-gate](coord-delay-and-gate.lua) | snippet | fights, helpers | A moment after this, if that follows |
| [coord-rules-from-events](coord-rules-from-events.lua) | snippet | helpers, events, crew | A rule that listens to the game |
| [coord-arbiter-one-cure](coord-arbiter-one-cure.lua) | snippet | crew, combat, helpers | Exactly one box cures |
| [coord-arbiter-failover](coord-arbiter-failover.lua) | snippet | crew, combat | When the winner never finishes |
| [coord-combat-gate](coord-combat-gate.lua) | snippet | combat, crew | Claim before a group cure |
| [coord-tag-import](coord-tag-import.lua) | snippet | combat, crew, data | Read a cast stack's tags as rules |
| [coord-wire-and-tiebreak](coord-wire-and-tiebreak.lua) | snippet | crew, data | The coordination messages and the tie-break |
| [coord-manage-rules](coord-manage-rules.lua) | snippet | crew, data | Keep a set of rules |
| [coord-arbiter-hand-over](coord-arbiter-hand-over.lua) | snippet | crew, combat | Hand a claim over at once |
| [monitor-read-combat-lines](monitor-read-combat-lines.lua) | snippet | combat, data | Read combat lines into records |
| [monitor-meter-a-fight](monitor-meter-a-fight.lua) | snippet | combat, helpers | Meter a fight |
| [monitor-fights-split](monitor-fights-split.lua) | snippet | combat | One fight ends, the next begins |
| [monitor-feed-from-events](monitor-feed-from-events.lua) | snippet | combat, events, helpers | Meter the game's own combat lines |
| [monitor-crew-summary](monitor-crew-summary.lua) | snippet | crew, combat, ui | Share a fight with the crew |
| [export-reader-queries](export-reader-queries.lua) | snippet | data, combat, helpers | Ask an ability export what a character can do |
| [export-convert-records](export-convert-records.lua) | snippet | data, combat | Fold per-rank ability records into an ability export |
| [export-live-snapshot](export-live-snapshot.lua) | snippet | data, combat | Snapshot a character's ability book |
| [export-gear-snapshot](export-gear-snapshot.lua) | snippet | items, crew | Snapshot a character's gear for a group decision |
| [export-gear-feed](export-gear-feed.lua) | snippet | crew, items | Share gear exports across the crew |
| [export-ability-labels](export-ability-labels.lua) | snippet | combat, data | What an ability asks for and what it does |
| [export-util-helpers](export-util-helpers.lua) | snippet | data | Ability names, line keys and stable files |
