# EB tested examples

Every example here runs and passes against EB's offline stand-in for the game before it is published. Each file starts with a comment header: what it does, where a complete script goes, how to run it, what it needs and what it prints.

A complete script is the whole file: save it where its header says (`file:`) and start it with its `run:` line. A snippet carries its own test: the lines above `-- your script` build the test world, the code under `-- your script` is the part to use in game, and the lines under `-- check` check the result. `DOCS` exists only in the docs test runner, so it never goes into a script of yours.

408 examples: 22 complete scripts and 386 snippets.

| Example | Kind | Topics |
|---|---|---|
| [Apply an adornment profile](adorn-apply-profile.lua) | snippet | Items, bags and loot |
| [What an adornment profile still needs](adorn-audit.lua) | snippet | Items, bags and loot |
| [A class set of adornments, picked for each character](adorn-class-set.lua) | snippet | Group and crew, Items, bags and loot |
| [Strip old gear's adornments, keep temporary adornments up](adorn-unadorn-and-temp.lua) | snippet | Items, bags and loot |
| [Buy the missing collection pieces - the three models](collection-buy.lua) | snippet | Items, bags and loot |
| [Add the collection pieces you already have](collection-fill.lua) | snippet | Helpers, Items, bags and loot |
| [Which collection pieces you still miss](collection-scope.lua) | snippet | Quests, Items, bags and loot |
| [The combat plane EB runs](combat-app-plane.lua) | snippet | Combat and casting |
| [Keep a buff up, keep the tank's ward up](combat-buff-upkeep.lua) | snippet | Group and crew, Combat and casting |
| [Cure only who carries the detriment](combat-cure-detriment.lua) | snippet | Group and crew, Combat and casting, Named fights |
| [Strip a named's buff](combat-dispel-named.lua) | snippet | Combat and casting, Named fights |
| [One engine step, one decision](combat-engine-step.lua) | snippet | Combat and casting |
| [The combat plane, its facade and the follower view](combat-facade-views.lua) | snippet | Group and crew, Combat and casting, Instances |
| [Give up a fight that cannot be won](combat-giveup-unwinnable.lua) | snippet | Combat and casting, Named fights |
| [A group heal waits for enough hurt members](combat-group-heal.lua) | snippet | Group and crew, Combat and casting |
| [Heal whoever fell furthest](combat-heal-lowest.lua) | snippet | Group and crew, Combat and casting |
| [Open and advance a heroic opportunity](combat-ho-wheel.lua) | snippet | Combat and casting, Named fights |
| [Interrupt a listed cast](combat-interrupt-cast.lua) | snippet | Combat and casting, Named fights |
| [The kill-first list, rules and stragglers](combat-kill-list-rules.lua) | snippet | Combat and casting, Named fights, Instances |
| [Mez the adds, renew before it breaks](combat-mez-adds.lua) | snippet | Combat and casting, Named fights |
| [Guards are never pulled or splashed](combat-never-a-guard.lua) | snippet | Helpers, Combat and casting |
| [Overrides per zone, per mob, and a timed pause](combat-override-per-mob.lua) | snippet | Combat and casting, Named fights, Instances |
| [Where to stand, and line of sight](combat-positioning.lua) | snippet | Movement and navigation, Combat and casting, Named fights |
| [Presets per context](combat-presets.lua) | snippet | Combat and casting |
| [Is it ready? Then cast it](combat-ready-and-cast.lua) | snippet | The game layer, Combat and casting |
| [Readiness costs one read a frame](combat-ready-one-read.lua) | snippet | Performance (the 100-FPS rule), Combat and casting |
| [Rez the fallen, then a power heal](combat-rez-and-power.lua) | snippet | Group and crew, Combat and casting |
| [Aim at a role: Bard, DPS1, Healer1](combat-roles.lua) | snippet | Group and crew, Combat and casting |
| [Lock the engine onto one mob](combat-target-lock.lua) | snippet | Combat and casting, Named fights |
| [Timed tags and a pre-cast](combat-timed-tags.lua) | snippet | Combat and casting, Named fights |
| [The engine's small helpers](combat-util-helpers.lua) | snippet | Helpers, Combat and casting |
| [Why does the engine not cast that?](combat-why-no-cast.lua) | snippet | Helpers, Combat and casting |
| [The combat commands, and answering one from a script](combat-wire-commands.lua) | snippet | Helpers, Commands and the console, Combat and casting |
| [Change combat for one zone](combat-zone-override.lua) | snippet | Combat and casting, Instances |
| [Run a command from a script in a running EB](commands-app-dispatch.lua) | snippet | Helpers, Commands and the console |
| [Answer an eb command with your own handler](commands-attach-handler.lua) | snippet | Helpers, Commands and the console |
| [Type an eb command](commands-console-status.lua) | snippet | Helpers, Commands and the console |
| [A console word of your own](commands-console-words.lua) | snippet | Commands and the console, UI windows |
| [Pause, resume, status and the kill switch](commands-core-family.lua) | snippet | Helpers, Commands and the console |
| [A crew line leaves this box](commands-crew-line-out.lua) | snippet | Commands and the console, Group and crew |
| [Send a command to the crew](commands-crew-scopes.lua) | snippet | Commands and the console, Group and crew |
| [Export the command list](commands-customer-schema.lua) | snippet | Commands and the console, Data files |
| [Read the built-in help](commands-help-lines.lua) | snippet | Commands and the console |
| [Which commands this box answers](commands-not-answered-yet.lua) | snippet | Commands and the console |
| [Read a command line without running it](commands-parse-line.lua) | snippet | Commands and the console |
| [What a refused line tells you](commands-refusals.lua) | snippet | Helpers, Commands and the console |
| [A registry of your own, and wrapping a handler](commands-registry-own-copy.lua) | snippet | Helpers, Commands and the console |
| [Tab-complete a command line](commands-tab-complete.lua) | snippet | Commands and the console, UI windows |
| [The utility commands in this release](commands-utility-commands.lua) | snippet | Commands and the console, Data files |
| [Build a button row from the registry](commands-view-grid.lua) | snippet | Commands and the console, UI windows |
| [The window and monitor commands in this release](commands-window-commands.lua) | snippet | Commands and the console, UI windows |
| [When the winner never finishes](coord-arbiter-failover.lua) | snippet | Group and crew, Combat and casting |
| [Hand a claim over at once](coord-arbiter-hand-over.lua) | snippet | Group and crew, Combat and casting |
| [Exactly one box cures](coord-arbiter-one-cure.lua) | snippet | Helpers, Group and crew, Combat and casting |
| [Claim before a group cure](coord-combat-gate.lua) | snippet | Group and crew, Combat and casting |
| [A moment after this, if that follows](coord-delay-and-gate.lua) | snippet | Helpers, Named fights |
| [Hold an ability for a while](coord-embargo-hold.lua) | snippet | Group and crew, Combat and casting, Named fights |
| [Keep a set of rules](coord-manage-rules.lua) | snippet | Group and crew, Data files |
| [When the tank shouts, the healer reacts](coord-rule-tag-across-boxes.lua) | snippet | Helpers, Group and crew, Named fights |
| [A rule that listens to the game](coord-rules-from-events.lua) | snippet | Helpers, Events, Group and crew |
| [Read a cast stack's tags as rules](coord-tag-import.lua) | snippet | Group and crew, Combat and casting, Data files |
| [The coordination messages and the tie-break](coord-wire-and-tiebreak.lua) | snippet | Group and crew, Data files |
| [Fetch missing fuel from the fuel depot before a combine](craft-fuel-from-depot.lua) | snippet | Items, bags and loot |
| [Craft one order at the station in reach](craft-one-recipe.lua) | snippet | Items, bags and loot |
| [Pick the reaction art for this moment of a combine](craft-pick-art.lua) | snippet | Items, bags and loot |
| [Craft a list of orders](craft-queue.lua) | snippet | Items, bags and loot |
| [Does this station serve the recipe?](craft-station-serves.lua) | snippet | Helpers, Items, bags and loot |
| [Refuse a station that does not serve the recipe](craft-wrong-station.lua) | snippet | Items, bags and loot |
| [Which crafting, harvest and gear commands are live on this box](crafting-commands-live.lua) | snippet | Commands and the console, Items, bags and loot |
| [Send a command to one box, announce to all](crew-announce-and-send.lua) | snippet | Commands and the console, Group and crew |
| [The crew and coordination commands in this release](crew-commands-status.lua) | snippet | Commands and the console, Group and crew |
| [Drive the console from a script](crew-console-model.lua) | snippet | Group and crew, UI windows |
| [A line heard twice runs once](crew-dedupe.lua) | snippet | Group and crew |
| [Turn one box's event into a crew command](crew-event-to-crew.lua) | snippet | Helpers, Events, Group and crew |
| [Wait for the group at a mark](crew-group-barrier.lua) | snippet | Group and crew, Instances |
| [Call the group back, evacuate, read the group](crew-group-calls.lua) | snippet | Group and crew, Instances |
| [Give the followers an order](crew-orders.lua) | snippet | Group and crew, Instances |
| [Split a typed line into scope and command](crew-parse-scope.lua) | snippet | Commands and the console, Group and crew |
| [Who drives the group](crew-roles-driver.lua) | snippet | Group and crew, Instances |
| [Hear what the other boxes are doing](crew-state-roster.lua) | snippet | Helpers, Group and crew |
| [Two boxes, one crew](crew-two-boxes.lua) | snippet | Helpers, Group and crew |
| [Address boxes by box, name, class or archetype](crew-who-matching.lua) | snippet | Group and crew |
| [Print numbers the same way everywhere](data-compat-numbers.lua) | snippet | Data files |
| [Read, write, copy and list your helper's files](data-files-list-and-copy.lua) | snippet | Data files |
| [Save from game code without touching the disk in the frame](data-files-write-behind.lua) | snippet | Performance (the 100-FPS rule), Data files |
| [Keep a helper's own config in a JSON file](data-helper-config-file.lua) | snippet | Helpers, Data files |
| [Change one field in a JSON file another program owns](data-json-lossless-edit.lua) | snippet | Data files |
| [One JSON string, and the key order files use](data-json-quote-and-order.lua) | snippet | Data files |
| [Write an empty list as []](data-jsontable-empty-list.lua) | snippet | UI windows, Data files |
| [Keep a null in a JSON document](data-jsontable-null.lua) | snippet | Data files |
| [Turn a table into JSON and back](data-jsontable-roundtrip.lua) | snippet | Data files |
| [Write a Lua data file](data-lua-fmt-document.lua) | snippet | Instances, Quests, Data files |
| [A JSON null, and Lua values as text](data-null-and-lua-values.lua) | snippet | Data files |
| [Read and change an EB setting](data-settings-get-set.lua) | snippet | Data files, Settings |
| [The after-looting guard: destroy only by exact name](econ-after-loot-guard.lua) | snippet | Helpers, Items, bags and loot, Loot |
| [Give a gear drop to the member who gains the most](econ-auction-resolve.lua) | snippet | Group and crew, Items, bags and loot, Loot |
| [The economy's bags-full check](econ-bags-full-contract.lua) | snippet | Helpers, Items, bags and loot |
| [Keep a set amount of coin on you](econ-bank-coin-purse.lua) | snippet | Items, bags and loot |
| [Plan a bank deposit before you make it](econ-bank-deposit-plan.lua) | snippet | Items, bags and loot |
| [Buy what you are short of, under a price cap](econ-broker-buy-capped.lua) | snippet | Helpers, Items, bags and loot |
| [Put bag items up on the broker](econ-broker-list-from-bags.lua) | snippet | Items, bags and loot |
| [Reprice your broker listings](econ-broker-reprice.lua) | snippet | Items, bags and loot |
| [Answer the economy's commands from your own economy](econ-commands-layer.lua) | snippet | Commands and the console, Items, bags and loot |
| [The item and loot commands in this build](econ-commands-status.lua) | snippet | Commands and the console, Items, bags and loot |
| [Accept crafting commissions only from your own people](econ-commissions-allow.lua) | snippet | Group and crew, Items, bags and loot |
| [Answer the purchase question in your own buy helper](econ-confirm-own-buy.lua) | snippet | Helpers, Items, bags and loot, Dialogs, hails and clicks |
| [Deposit by a rule, keep the keep list](econ-depot-deposit-rule.lua) | snippet | Items, bags and loot |
| [Restock from the depot with one list for the whole group](econ-depot-topup.lua) | snippet | Group and crew, Items, bags and loot |
| [See which window actions a drive provides](econ-drive-report.lua) | snippet | Items, bags and loot |
| [Pick items from a list with a filter](econ-filter-pick.lua) | snippet | Items, bags and loot, Data files |
| [Understand a group loot method however it is typed](econ-group-loot-words.lua) | snippet | Group and crew, Items, bags and loot, Loot |
| [One job per request: call it every tick, it resumes](econ-job-gate.lua) | snippet | Tasks and loops, Items, bags and loot |
| [Write long work as a pollable job](econ-job-steps.lua) | snippet | Helpers, Tasks and loops, Items, bags and loot |
| [Clear junk without a vendor trip](econ-junk-by-rule.lua) | snippet | Items, bags and loot |
| [Coin in words and a day's sums](econ-ledger-coin.lua) | snippet | Items, bags and loot, UI windows, Data files |
| [Record and read the money and item ledger](econ-ledger-feed.lua) | snippet | Items, bags and loot, Data files |
| [Give a drop to a role: @priest, @fighter ...](econ-loot-assign-role.lua) | snippet | Group and crew, Items, bags and loot, Loot |
| [Which loot rule names an item](econ-loot-best-rule.lua) | snippet | Items, bags and loot, Data files, Loot |
| [What this box does with each drop](econ-loot-classify.lua) | snippet | Group and crew, Items, bags and loot, Loot |
| [Decide what to do with a whole loot window](econ-loot-decide-window.lua) | snippet | Helpers, Items, bags and loot, Loot |
| [A loot helper: read the window, apply the rules, take the lot](econ-loot-from-window.lua) | snippet | Worked recipes, Helpers, Events, Items, bags and loot, Loot |
| [Loot a corpse by rule](econ-loot-grab-corpse.lua) | snippet | Helpers, Items, bags and loot, Loot |
| [Hand drops out from the leader's loot window](econ-loot-leader-assign.lua) | snippet | Group and crew, Items, bags and loot, Loot |
| [Open one letter by its subject and take what it carries](econ-mail-open-letter.lua) | snippet | Quests, Items, bags and loot |
| [Mail items and coin to another character](econ-mail-send.lua) | snippet | Group and crew, Items, bags and loot |
| [Buy from a merchant and answer the purchase question](econ-merchant-buy-confirm.lua) | snippet | Helpers, Items, bags and loot, Dialogs, hails and clicks |
| [Read a merchant's price and the game's buy lines](econ-merchant-lines.lua) | snippet | Events, Items, bags and loot |
| [Protect an item from every bulk action](econ-protect-and-gate.lua) | snippet | Items, bags and loot |
| [Answer a purchase question only for your own item](econ-purchase-confirm.lua) | snippet | Helpers, Items, bags and loot, Dialogs, hails and clicks |
| [Top up your ammo from the ammo depot](econ-quiver-fill.lua) | snippet | Items, bags and loot |
| [Repair only when the gear needs it](econ-repair-threshold.lua) | snippet | Items, bags and loot |
| [Ask the safety gate before destroying or selling](econ-rules-can-take.lua) | snippet | Helpers, Items, bags and loot |
| [Economy settings and their safe defaults](econ-rules-config.lua) | snippet | Items, bags and loot, Data files |
| [Find an item and hand some to a player](econ-search-and-trade.lua) | snippet | Group and crew, Items, bags and loot |
| [Write the economy settings](econ-settings-document.lua) | snippet | Items, bags and loot, Data files, Settings |
| [Read a stone merchant's rows](econ-stone-table.lua) | snippet | Items, bags and loot |
| [Sell a list of items at a merchant](econ-vendor-sell-sweep.lua) | snippet | Helpers, Items, bags and loot |
| [React to a chat line](events-chat-line.lua) | snippet | Helpers, Events |
| [Turn an event into one command for the crew](events-crew-line.lua) | snippet | Helpers, Events, Group and crew |
| [The same line twice is delivered once](events-dedupe.lua) | snippet | Events |
| [A handler that fails never stops the others](events-handler-error.lua) | snippet | Helpers, Events |
| [A one-time handler, and unsubscribing](events-once-and-off.lua) | snippet | Events |
| [Follow a quest's progress](events-quest-update.lua) | snippet | Events, Quests |
| [React to a zone change](events-zoning.lua) | snippet | Helpers, Events, Movement and navigation |
| [What an ability asks for and what it does](export-ability-labels.lua) | snippet | Combat and casting, Data files |
| [Fold per-rank ability records into an ability export](export-convert-records.lua) | snippet | Combat and casting, Data files |
| [Share gear exports across the crew](export-gear-feed.lua) | snippet | Group and crew, Items, bags and loot |
| [Snapshot a character's gear for a group decision](export-gear-snapshot.lua) | snippet | Group and crew, Items, bags and loot |
| [Snapshot a character's ability book](export-live-snapshot.lua) | snippet | Combat and casting, Data files |
| [Ask an ability export what a character can do](export-reader-queries.lua) | snippet | Helpers, Combat and casting, Data files |
| [Ability names, line keys and stable files](export-util-helpers.lua) | snippet | Data files |
| [Time a mechanic from an announcement](fight-announcement-timer.lua) | snippet | Events, Named fights |
| [Pause the crew when the named appears](fight-crew-pause-on-spawn.lua) | snippet | Helpers, Events, Group and crew, Named fights |
| [Cure a member on cue](fight-cure-on-cue.lua) | snippet | Group and crew, Combat and casting, Named fights |
| [React to a boss emote](fight-emote-cue.lua) | snippet | Helpers, Events, Named fights |
| [Shape combat for one encounter](fight-encounter-override.lua) | snippet | Combat and casting, Named fights, Instances |
| [Who is in the fight](fight-engaged-named.lua) | snippet | The game layer, Performance (the 100-FPS rule), Combat and casting, Named fights |
| [Interrupt the boss's big cast yourself](fight-interrupt-on-cue.lua) | snippet | Combat and casting, Named fights |
| [Change phase at a health mark](fight-phase-by-health.lua) | snippet | Combat and casting, Named fights |
| [Step out to a safe spot and back](fight-safe-spot.lua) | snippet | Movement and navigation, Named fights |
| [Where an actor stands, and whether it is gone](game-actor-pos.lua) | snippet | The game layer, Movement and navigation, Combat and casting |
| [Read what you and your target are casting, and cancel](game-cast-bars.lua) | snippet | The game layer, Combat and casting, Named fights |
| [Cast a heal on a group member by name](game-cast-on-player.lua) | snippet | Helpers, Group and crew, The game layer, Combat and casting |
| [Read a yes / no popup](game-choice-window.lua) | snippet | Helpers, Events, The game layer, Dialogs, hails and clicks |
| [List doors and clickable things near you](game-clickables-doors.lua) | snippet | Helpers, The game layer, Instances |
| [Find a member who is stunned, feared or rooted](game-control-effects.lua) | snippet | Helpers, Group and crew, The game layer, Combat and casting |
| [Count the mobs fighting you](game-engaged-hostiles.lua) | snippet | The game layer, Combat and casting, Named fights |
| [Spot the named in the fight](game-engaged-named.lua) | snippet | The game layer, Combat and casting, Named fights |
| [Equip an item from your bags](game-equip-from-bags.lua) | snippet | The game layer, Items, bags and loot |
| [Turn to face an actor or a point](game-face-actor.lua) | snippet | The game layer, Movement and navigation |
| [Keep food and drink on auto-consume](game-food-auto-consume.lua) | snippet | Helpers, The game layer, Items, bags and loot |
| [Know when to repair](game-gear-condition.lua) | snippet | Helpers, The game layer, Items, bags and loot |
| [Read your group and find who is hurt](game-group-rows.lua) | snippet | Helpers, Group and crew, The game layer |
| [Hail an NPC](game-hail-target.lua) | snippet | Helpers, The game layer, Quests, Dialogs, hails and clicks |
| [Check a buff without flooding the server](game-has-effect-cache.lua) | snippet | The game layer, Performance (the 100-FPS rule), Combat and casting |
| [Read the heroic opportunity wheel](game-heroic-wheel.lua) | snippet | The game layer, Combat and casting, Named fights |
| [Load your ability book once](game-load-book.lua) | snippet | The game layer, Performance (the 100-FPS rule), Combat and casting |
| [Read the loot window without polling it](game-loot-window.lua) | snippet | The game layer, Performance (the 100-FPS rule), Items, bags and loot, Loot |
| [Find corpses and chests to loot](game-lootables-open.lua) | snippet | The game layer, Items, bags and loot, Loot |
| [List the spells you keep up](game-maintained.lua) | snippet | Helpers, The game layer, Combat and casting |
| [Read your own character](game-me-basics.lua) | snippet | Helpers, The game layer |
| [See which mobs are casting](game-mob-casts.lua) | snippet | The game layer, Combat and casting, Named fights |
| [Find the nearest NPC by name](game-nearest-npc.lua) | snippet | Helpers, The game layer |
| [Record chat lines from the game's own chat event](game-onchat-record.lua) | snippet | Events, The game layer |
| [Stay inside the per-frame read budget](game-read-budget.lua) | snippet | The game layer, Performance (the 100-FPS rule) |
| [Ask about many abilities for the price of one read](game-readiness-one-read.lua) | snippet | The game layer, Performance (the 100-FPS rule), Combat and casting |
| [Cast an ability when it is ready](game-ready-and-cast.lua) | snippet | Helpers, The game layer, Combat and casting |
| [Repair at a mender and close the window](game-repair-and-close.lua) | snippet | Helpers, The game layer, Items, bags and loot |
| [Answer an NPC's conversation](game-reply-dialog.lua) | snippet | Helpers, The game layer, Quests, Dialogs, hails and clicks |
| [Read a quest reward window](game-reward-window.lua) | snippet | The game layer, Quests, Dialogs, hails and clicks |
| [Call out in group chat and send a tell](game-say-and-tell.lua) | snippet | Helpers, Group and crew, The game layer |
| [Target an actor and wait for it to take](game-target-and-wait.lua) | snippet | Helpers, The game layer, Combat and casting |
| [Read your target](game-target-read.lua) | snippet | The game layer, Combat and casting |
| [Read your tradeskill level and a skill](game-tradeskill-levels.lua) | snippet | The game layer, Items, bags and loot |
| [List the items you can click](game-usable-items.lua) | snippet | The game layer, Items, bags and loot, UI windows |
| [Use an item when it is ready](game-use-item.lua) | snippet | Helpers, The game layer, Items, bags and loot |
| [Wait for something without freezing the game](game-wait-in-task.lua) | snippet | Helpers, The game layer, Performance (the 100-FPS rule) |
| [Hold a helper while a zone loads](game-zoning.lua) | snippet | Helpers, The game layer, Movement and navigation |
| [Wear the best gear in the bags (auto-upgrade)](gear-auto-upgrade.lua) | snippet | Items, bags and loot |
| [Fill an empty slot from the broker](gear-fill-from-broker.lua) | snippet | Items, bags and loot |
| [Plan who in the group should get which spare piece](gear-group-trades.lua) | snippet | Group and crew, Items, bags and loot |
| [How EB scores a piece of gear](gear-score.lua) | snippet | Items, bags and loot |
| [Turn Master scrolls into Grandmaster crafts](gm-plan-and-run.lua) | snippet | Items, bags and loot |
| [Run a gather route](harvest-route.lua) | snippet | Movement and navigation, Items, bags and loot, Harvesting |
| [Track shinies and send the pack pony out](harvest-shiny-and-pony.lua) | snippet | Helpers, Group and crew, Items, bags and loot, Harvesting |
| [Decide which harvest nodes to take](harvest-want-node.lua) | snippet | Helpers, Items, bags and loot, Harvesting |
| [The runner's small helpers in a custom action](ic-base-helpers.lua) | snippet | Helpers, Instances |
| [Spot a reset that did not take](ic-cleared-copy.lua) | snippet | Instances, Tasks and loops |
| [When does a combat wait end?](ic-combat-hold.lua) | snippet | Combat and casting, Named fights, Instances |
| [Encounter conditions, and how they fail closed](ic-conditions.lua) | snippet | Named fights, Instances |
| [The instance commands from the console](ic-console-commands.lua) | snippet | Commands and the console, Instances |
| [Add your own route step kind](ic-custom-route-act.lua) | snippet | Helpers, Instances |
| [Death in an instance: revive, walk back, pull again](ic-death-recovery.lua) | snippet | Named fights, Instances |
| [Dry-run an instance file](ic-dry-run.lua) | snippet | Helpers, Instances |
| [eb ic from the console and from a script](ic-eb-ic-command.lua) | snippet | Commands and the console, Instances |
| [Who is still elsewhere, and one copy for the door](ic-group-stragglers.lua) | snippet | Group and crew, Instances |
| [Tell a stuck combat flag from a real fight](ic-hold-flag-watch.lua) | snippet | Named fights, Instances |
| [A hub route the tank walks alone](ic-hub-route.lua) | snippet | Movement and navigation, Instances |
| [What runner:load refuses](ic-load-checks.lua) | snippet | Instances |
| [A member's run: hold, never walk the route](ic-member-holds.lua) | snippet | Group and crew, Instances |
| [Instance options and step gates](ic-options-and-gates.lua) | snippet | Instances |
| [A mechanic mid-fight: a reactive phase](ic-reactive-phase.lua) | snippet | Named fights, Instances |
| [One route step of each kind](ic-route-step-kinds.lua) | snippet | Instances |
| [Save a run and resume it at a step](ic-saved-run.lua) | snippet | Instances, Data files |
| [The tank zones the group in](ic-tank-zones-group-in.lua) | snippet | Group and crew, Instances |
| [Read a fight's sensors through the world facade](ic-world-facade-sensors.lua) | snippet | Named fights, Instances |
| [Writs and collections as chore loops](loop-errands-collections.lua) | snippet | Tasks and loops, Items, bags and loot |
| [Loop windows and the reset decision](loop-ic-args.lua) | snippet | Commands and the console, Instances, Tasks and loops |
| [Chores at the end of each run](loop-ic-chores.lua) | snippet | Instances, Tasks and loops, Items, bags and loot |
| [Loop one instance: wait inside until it can be reset](loop-ic-one-zone.lua) | snippet | Instances, Tasks and loops |
| [The overseer's daily pass, and how it picks agents](loop-overseer-plan.lua) | snippet | Helpers, Tasks and loops |
| [The loops' own decisions: an upgrade and a hire](loop-pickers.lua) | snippet | Helpers, Tasks and loops |
| [Build a loop's provider and see what is missing](loop-provider.lua) | snippet | Helpers, Tasks and loops |
| [A chore loop's stop flag and coin gate](loop-stop-and-gates.lua) | snippet | Helpers, Tasks and loops |
| [Hand the brain a chore loop](loop-trainer-goal.lua) | snippet | Helpers, Tasks and loops |
| [Share a fight with the crew](monitor-crew-summary.lua) | snippet | Group and crew, Combat and casting, UI windows |
| [Meter the game's own combat lines](monitor-feed-from-events.lua) | snippet | Helpers, Events, Combat and casting |
| [One fight ends, the next begins](monitor-fights-split.lua) | snippet | Combat and casting |
| [Meter a fight](monitor-meter-a-fight.lua) | snippet | Helpers, Combat and casting |
| [Read combat lines into records](monitor-read-combat-lines.lua) | snippet | Combat and casting, Data files |
| [Remember what a bell's map offers](nav-bell-maps.lua) | snippet | Helpers, Movement and navigation |
| [Which side of the city bells you travel on](nav-bell-sides.lua) | snippet | Helpers, Movement and navigation |
| [Keep walks out of a bad spot](nav-blacklist-spot.lua) | snippet | Helpers, Movement and navigation |
| [Fix a door's verb on this PC](nav-door-lines.lua) | snippet | Movement and navigation, Data files |
| [Open the door a route goes through](nav-door-on-route.lua) | snippet | Helpers, Movement and navigation |
| [Read a zone's mesh corrections](nav-fixes-layer.lua) | snippet | Movement and navigation, Data files |
| [Follow an actor](nav-follow-actor.lua) | snippet | Group and crew, Movement and navigation |
| [Follow a crew member with eb follow](nav-follow-command.lua) | snippet | Commands and the console, Group and crew, Movement and navigation |
| [Catch health lost out of combat and back out](nav-hazard-abort.lua) | snippet | Helpers, Movement and navigation |
| [Never swim where the liquid kills](nav-hazard-lethal.lua) | snippet | Movement and navigation, Quests |
| [A goal in lava becomes its shore](nav-lava-goal-shore.lua) | snippet | Helpers, Movement and navigation |
| [Where the mesh joins two floors: one jump tap](nav-link-jump.lua) | snippet | Movement and navigation |
| [Pin marks the crew and the map share](nav-mark-shared.lua) | snippet | Movement and navigation, Data files |
| [Marks and blacklists from the console](nav-marks-command.lua) | snippet | Commands and the console, Movement and navigation |
| [Ask the mesh directly](nav-mesh-queries.lua) | snippet | Movement and navigation |
| [Diagnose a zone's mesh](nav-mesh-reports.lua) | snippet | Movement and navigation, UI windows |
| [Ask the mesh service directly](nav-mesh-service.lua) | snippet | Performance (the 100-FPS rule), Movement and navigation |
| [Face a point and hold a key](nav-move-basics.lua) | snippet | The game layer, Movement and navigation |
| [Hold, tap and release the movement keys](nav-move-keys.lua) | snippet | Performance (the 100-FPS rule), Movement and navigation |
| [A walk the mesh has no route for fails and says why](nav-no-route.lua) | snippet | Helpers, Movement and navigation |
| [What a walk costs](nav-perf-one-route.lua) | snippet | Performance (the 100-FPS rule), Movement and navigation |
| [Keep every walk out of a bad spot](nav-place-avoid.lua) | snippet | Helpers, Movement and navigation |
| [Plan a route without walking it](nav-plan-route.lua) | snippet | Movement and navigation |
| [Save a spot and walk back to it](nav-saved-spot.lua) | snippet | Helpers, Movement and navigation |
| [A short hop needs no route](nav-short-hop.lua) | snippet | Performance (the 100-FPS rule), Movement and navigation |
| [Stop a walk cleanly](nav-stop-a-walk.lua) | snippet | Helpers, Movement and navigation |
| [Where EB's nav data lives](nav-store-layout.lua) | snippet | Movement and navigation, Data files |
| [Swim corners, the water's surface and no dive in a fight](nav-swim-surface.lua) | snippet | Movement and navigation, Named fights |
| [Read a zone's pads and plan a pad trip](nav-transit-graph.lua) | snippet | Movement and navigation, Data files |
| [Ride the zone's own transit](nav-transit-pads.lua) | snippet | Movement and navigation |
| [Preview and ride a trip from the console](nav-travel-commands.lua) | snippet | Commands and the console, Movement and navigation |
| [Plan a multi-zone trip by bell and spire, by your side](nav-travel-multizone.lua) | snippet | Worked recipes, Movement and navigation |
| [Plan a trip to another zone](nav-travel-plan.lua) | snippet | Movement and navigation, Quests |
| [Walk with an eb command](nav-walk-command.lua) | snippet | Commands and the console, Movement and navigation |
| [Walk to a point over the mesh](nav-walk-to-point.lua) | snippet | Helpers, Movement and navigation |
| [Where am I, and where is that actor](nav-zone-and-actor.lua) | snippet | Helpers, The game layer, Movement and navigation |
| [Turn a typed word into a zone](nav-zone-words.lua) | snippet | Commands and the console, Movement and navigation |
| [EB Overseer from the console](overseer-command.lua) | snippet | Commands and the console, Quests |
| [Time something with the platform clock](platform-clock-now.lua) | snippet | Helpers, Performance (the 100-FPS rule) |
| [Drive the clock in a test](platform-clock-stand-in.lua) | snippet | Performance (the 100-FPS rule), Data files |
| [Test a helper's saves without a disk](platform-files-memory-host.lua) | snippet | Helpers, Data files |
| [Stay inside the read budget](platform-frame-read-budget.lua) | snippet | The game layer, Performance (the 100-FPS rule) |
| [Write a log line](platform-log-lines.lua) | snippet | Helpers |
| [Clean up when EB stops](platform-onstop-cleanup.lua) | snippet | Helpers, Data files |
| [Drive EB's frames yourself](platform-pulse-frames-by-hand.lua) | snippet | Helpers, Performance (the 100-FPS rule) |
| [Run a job on a timer](platform-pulse-job.lua) | snippet | Helpers, Performance (the 100-FPS rule) |
| [Wait inside a task](platform-pulse-task-wait.lua) | snippet | Helpers, Performance (the 100-FPS rule) |
| [A tour of the platform services](platform-services-tour.lua) | snippet | Performance (the 100-FPS rule), UI windows, Data files |
| [Read the settings catalog](platform-settings-catalog.lua) | snippet | UI windows, Data files, Settings |
| [Ask the platform for a service](platform-target-and-services.lua) | snippet | Helpers, Data files |
| [Test a script with a fake service](platform-test-with-a-fake.lua) | snippet | Helpers, Data files |
| [Never wait in a job or a handler](platform-wait-outside-task.lua) | snippet | Helpers, Performance (the 100-FPS rule) |
| [Wait for a condition, with a timeout](platform-wait-until.lua) | snippet | Helpers, The game layer |
| [A route's actions, one bite at a time](plroute-actions.lua) | snippet | Tasks and loops |
| [The power-level routes EB ships, and their short codes](plroute-catalog.lua) | snippet | Tasks and loops, Data files |
| [Look a route up in the catalog](plroute-catalog-lookup.lua) | snippet | Tasks and loops, Data files |
| [A route's plan helpers: skipped steps, repeats, stalls, rates](plroute-plan-helpers.lua) | snippet | Tasks and loops |
| [The pull and break rules behind a route](plroute-plan-rules.lua) | snippet | Helpers, Combat and casting, Tasks and loops |
| [Run a power-level route, step by step](plroute-run.lua) | snippet | Movement and navigation, Combat and casting, Tasks and loops |
| [Share a route: the scrub and the short code](plroute-share.lua) | snippet | Group and crew, Tasks and loops, Data files |
| [Skip a step on a condition or on the journal](quest-conditions.lua) | snippet | Quests |
| [Read a pack's condition text yourself](quest-conditions-read.lua) | snippet | Quests |
| [The quest commands from the console](quest-console-commands.lua) | snippet | Commands and the console, Quests |
| [Run a pack on the runner's core, with only your own verbs](quest-core-api.lua) | snippet | Quests |
| [Add your own pack verb](quest-custom-verb.lua) | snippet | Helpers, Quests |
| [A pack's gates: level, a held sibling, a zone's wing](quest-gates.lua) | snippet | Quests |
| [A quest that goes into an instance, in a group](quest-instance-member.lua) | snippet | Group and crew, Instances, Quests |
| [Is a quest on the tracker?](quest-journal-held.lua) | snippet | Quests |
| [Read a quest's journal lines](quest-journal-reader.lua) | snippet | Helpers, Quests |
| [Load a quest pack from its file](quest-load-file.lua) | snippet | Quests, Data files |
| [Pick a letter for OpenMail](quest-mail-pick.lua) | snippet | Quests, Items, bags and loot |
| [Packs never fast travel](quest-no-fast-travel.lua) | snippet | Movement and navigation, Quests |
| [Save where a quest is, and resume there](quest-resume-pointer.lua) | snippet | Quests, Data files |
| [What quests.step answers, and what to do with it](quest-statuses.lua) | snippet | Quests |
| [Where does the current step want the character?](quest-step-target.lua) | snippet | Movement and navigation, Quests |
| [Stop a quest run at once](quest-stop-flag.lua) | snippet | Helpers, Quests |
| [A pack verb that reads the journal and the world](quest-turn-helpers.lua) | snippet | Helpers, Quests |
| [The verb registry's parsers and its refusals](quest-verb-helpers.lua) | snippet | Quests |
| [What a pack can say: the verb list](quest-verbs.lua) | snippet | Helpers, Quests |
| [Wait for the journal to move on](quest-wait-for-journal.lua) | snippet | Events, Quests |
| [A pack's own way into a zone](quest-zone-routes.lua) | snippet | Movement and navigation, Quests |
| [Recipe: an instance route with steps, pulls and a camp spot](recipe-ic-route.lua) | snippet | Worked recipes, Instances |
| [Recipe: script a named fight](recipe-named-fight.lua) | snippet | Worked recipes, Events, Combat and casting, Named fights |
| [Recipe: a quest pack with stages, hails and clicks](recipe-quest-pack.lua) | snippet | Worked recipes, Quests |
| [Follow and assist the tank (complete script)](script-assist.lua) | complete script | Helpers, Group and crew, Combat and casting |
| [Auto-cure watcher (complete script)](script-autocure.lua) | complete script | Worked recipes, Helpers, Combat and casting |
| [Pause EB when the bags are full (complete script)](script-bagwatch.lua) | complete script | Helpers, Group and crew, Items, bags and loot |
| [Buff keeper (complete script)](script-buffkeeper.lua) | complete script | Helpers, Combat and casting |
| [Tell me when a yes/no question waits (complete script)](script-choicealert.lua) | complete script | Helpers, Events, Dialogs, hails and clicks |
| [Crew status board (complete script)](script-crewboard.lua) | complete script | Worked recipes, Helpers, Group and crew |
| [Event watcher (complete script)](script-eventwatch.lua) | complete script | Worked recipes, Helpers, Events |
| [Crew, follow me (complete script)](script-followme.lua) | complete script | Helpers, Group and crew, Movement and navigation |
| [Food and drink keeper (complete script)](script-foodkeeper.lua) | complete script | Helpers, Items, bags and loot |
| [Group-ready checker (complete script)](script-groupready.lua) | complete script | Helpers, Group and crew |
| [Hail and answer an NPC (complete script)](script-hailreply.lua) | complete script | Worked recipes, Helpers, Quests, Dialogs, hails and clicks |
| [Harvest the nodes in reach (complete script)](script-harvest.lua) | complete script | Helpers, Harvesting |
| [A whole instance file: hub, door, route, camp spots, pulls, loop (complete script)](script-ic-instance.lua) | complete script | Worked recipes, Instances, Tasks and loops |
| [Loop an instance once the group is ready (complete script)](script-ic-loop-task.lua) | complete script | Worked recipes, Helpers, Instances, Tasks and loops |
| [A trash pull encounter (complete script)](script-ic-trash-pull.lua) | complete script | Worked recipes, Instances |
| [Take loot windows by your rules (complete script)](script-lootall.lua) | complete script | Helpers, Events, Loot |
| [A named fight with a gate, phases, a reaction and a win test (complete script)](script-named-fight.lua) | complete script | Worked recipes, Named fights, Instances |
| [Say when a named spawns (complete script)](script-namedwatch.lua) | complete script | Helpers, Events, Group and crew |
| [Patrol between saved marks (complete script)](script-patrol.lua) | complete script | Helpers, Movement and navigation |
| [Sell junk at a merchant (complete script)](script-selljunk.lua) | complete script | Helpers, Items, bags and loot |
| [Change an EB setting (complete script)](script-setting.lua) | complete script | Helpers, Data files, Settings |
| [Answer tells while you are away (complete script)](script-tellreply.lua) | complete script | Helpers, Events |
| [Level a new crafter's tradeskill](skill-level-crafter.lua) | snippet | Items, bags and loot |
| [The levelling decisions, step by step](skill-level-decisions.lua) | snippet | Items, bags and loot |
| [Level Tinkering to its cap](skill-level-run.lua) | snippet | Items, bags and loot |
| [Where a secondary skill stands, and the books a trip would buy](skill-level-status.lua) | snippet | Items, bags and loot |
| [Read a skill value the way EB does](skill-parse-rules.lua) | snippet | Items, bags and loot |
| [Read a crafting skill through the game layer](skill-read-live.lua) | snippet | The game layer, Items, bags and loot |
| [Hand a built stack to category managers](stack-apply-managers.lua) | snippet | Combat and casting, Data files |
| [Build a cast stack from its rows](stack-build.lua) | snippet | Combat and casting, Data files |
| [Class facts fill in what a heal row leaves out](stack-class-facts.lua) | snippet | Combat and casting, Data files |
| [A class module of your own](stack-class-module.lua) | snippet | Combat and casting, Data files |
| [Switch a tag from the engine](stack-engine-toggle.lua) | snippet | Combat and casting, Named fights |
| [Find a character's cast stack by name](stack-loader-find.lua) | snippet | Combat and casting, Data files |
| [Reload a cast stack when its file changes](stack-loader-reload.lua) | snippet | Combat and casting, Data files |
| [A reload keeps your switches](stack-rebind-keeps-switches.lua) | snippet | Combat and casting, Named fights |
| [Write cast-stack rows by hand](stack-row-format.lua) | snippet | Combat and casting, Data files |
| [Switch one cast-stack row off and on](stack-switch-row.lua) | snippet | Combat and casting, Named fights |
| [Switch every row with a tag](stack-switch-tag.lua) | snippet | Combat and casting, Named fights |
| [Read an actor by its id](tlo-actor-by-id.lua) | snippet | The game layer, TLOs and game reads |
| [Search actors with a query](tlo-actor-query.lua) | snippet | Helpers, The game layer, TLOs and game reads |
| [Check EB's nav extension before you route](tlo-ebnav-probe.lua) | snippet | TLOs and game reads, Movement and navigation |
| [Effect names are server requests - never poll them](tlo-effect-info-server.lua) | snippet | TLOs and game reads, Performance (the 100-FPS rule) |
| [TRUE or NULL, and numbers as text](tlo-exists-and-text.lua) | snippet | TLOs and game reads |
| [Read the cast bars through GetGameData](tlo-gamedata-casting.lua) | snippet | TLOs and game reads, Combat and casting, Named fights |
| [What GetVar does with a member that is not verified yet](tlo-getvar-not-verified.lua) | snippet | TLOs and game reads |
| [Read one member the game layer does not return](tlo-getvar-verified.lua) | snippet | TLOs and game reads, Items, bags and loot |
| [Read a group slot: Me.Group[n]](tlo-group-member.lua) | snippet | Group and crew, TLOs and game reads |
| [InnerSpace's own reads: session, extensions, the window, the folder](tlo-innerspace-basics.lua) | snippet | Helpers, TLOs and game reads |
| [Check that the game extension is ready](tlo-isxeq2-ready.lua) | snippet | Helpers, TLOs and game reads |
| [Read the items in an open loot window](tlo-loot-items.lua) | snippet | TLOs and game reads, Items, bags and loot, Loot |
| [Read several Me members in ONE read](tlo-me-batched-read.lua) | snippet | TLOs and game reads, Performance (the 100-FPS rule) |
| [What a merchant pays for a bag item](tlo-merchant-price.lua) | snippet | TLOs and game reads, Items, bags and loot |
| [Read the raid outside your group](tlo-raid-rows.lua) | snippet | Group and crew, TLOs and game reads |
| [The classic conversation window](tlo-reply-dialog-classic.lua) | snippet | TLOs and game reads, Quests, Dialogs, hails and clicks |
| [Target members, and what NULL looks like](tlo-target-members.lua) | snippet | TLOs and game reads, Combat and casting |
| [Read an interface element by its full name](tlo-ui-page-by-name.lua) | snippet | TLOs and game reads, UI windows |
| [Zone.Name changes at the START of a zone load](tlo-zone-name-flips-early.lua) | snippet | Helpers, TLOs and game reads, Movement and navigation |
| [Run a bulk salvage - and the guards that refuse a careless one](transmute-bulk-run.lua) | snippet | Items, bags and loot |
| [Level the Transmuting skill on a stone merchant](transmute-level-skill.lua) | snippet | Items, bags and loot |
| [Preview what a bulk transmute would take](transmute-preview.lua) | snippet | Items, bags and loot |
| [The T.S.E at the zone's end, inside](tse-at-zone-end.lua) | snippet | Instances, Tasks and loops |
| [The T.S.E hand-over: a member gives its pick to the leader](tse-handover.lua) | snippet | Group and crew, Tasks and loops, Items, bags and loot |
| [Sell the T.S.E pick at the merchant instead](tse-sell-pick.lua) | snippet | Tasks and loops, Items, bags and loot |
| [Press EB Main's buttons from a script](ui-control-presses.lua) | snippet | Commands and the console, UI windows |
| [Check a UI read before you send it](ui-guard-ui-reads.lua) | snippet | The game layer, UI windows |
| [Put icons on a window's rows](ui-icons-for-rows.lua) | snippet | UI windows |
| [Cap how often a window's state goes out](ui-push-budget.lua) | snippet | Performance (the 100-FPS rule), UI windows |
| [Spread a big scan over several frames](ui-read-budget.lua) | snippet | Helpers, Performance (the 100-FPS rule), UI windows |
| [Register a window with EB's window bridge](ui-register-window.lua) | snippet | UI windows |
| [A window's verbs, its open and close, and the push budget](ui-window-and-budget-tour.lua) | snippet | Performance (the 100-FPS rule), UI windows |
| [Refresh a window from data that moves on its own](ui-window-live.lua) | snippet | Performance (the 100-FPS rule), UI windows |
| [Build a window's state](ui-window-state.lua) | snippet | Performance (the 100-FPS rule), UI windows |
| [Answer a click with a verb](ui-window-verbs.lua) | snippet | Commands and the console, UI windows |
| [Give the brain your own goal](world-brain-custom-goal.lua) | snippet | Helpers, Instances |
| [Pause the brain and read its status](world-brain-pause.lua) | snippet | Helpers, UI windows |
| [Step a brain by hand](world-brain-step-by-step.lua) | snippet | Helpers, Combat and casting |
| [Check a subsystem against its contract](world-contracts.lua) | snippet | Helpers |
| [Goals, interrupts and one tick](world-goals-and-interrupts.lua) | snippet | Helpers, Combat and casting |
| [Do nothing while a zone loads](world-out-of-world.lua) | snippet | Helpers, The game layer |
| [One snapshot per frame, shared by everyone](world-shared-per-frame.lua) | snippet | Performance (the 100-FPS rule), UI windows |
| [Read the world snapshot](world-snapshot.lua) | snippet | Helpers, The game layer, Performance (the 100-FPS rule) |
| [Work out which recipe a work-order step asks for](writ-resolve-recipe.lua) | snippet | Items, bags and loot |
| [Take a work order, craft every step, hand it in](writ-run.lua) | snippet | Items, bags and loot |
