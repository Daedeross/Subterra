--configuration stuff to go here

-- Max number of layers, including "nauvis" (surface)
subterra.config.MAX_LAYER_COUNT = 3

subterra.config.underground_entities = {}
-- subterra entities
-- subterra.config.underground_entities["subterra-telepad-up"] = true
-- subterra.config.underground_entities["subterra-telepad-down"] = true
-- subterra.config.underground_entities["subterra-belt-up"] = true
-- subterra.config.underground_entities["subterra-belt-down"] = true
-- subterra.config.underground_entities["subterra-belt-out"] = true
-- subterra.config.underground_entities["subterra-power-up"] = true
-- subterra.config.underground_entities["subterra-power-down"] = true
-- subterra.config.underground_entities["subterra-power-in"] = true
-- subterra.config.underground_entities["subterra-power-out"] = true

-- whitelisted vanilla entities

--- belts
subterra.config.underground_entities["transport-belt"] = true
subterra.config.underground_entities["fast-transport-belt"] = true
subterra.config.underground_entities["express-transport-belt"] = true
subterra.config.underground_entities["underground-belt"] = true
subterra.config.underground_entities["fast-underground-belt"] = true
subterra.config.underground_entities["express-underground-belt"] = true

-- inserters & loaders
subterra.config.underground_entities["inserter"] = true
subterra.config.underground_entities["fast-inserter"] = true
subterra.config.underground_entities["filter-inserter"] = true
subterra.config.underground_entities["stack-inserter"] = true
subterra.config.underground_entities["stack-filter-inserter"] = true
subterra.config.underground_entities["loader"] = true
subterra.config.underground_entities["fast-loader"] = true
subterra.config.underground_entities["express-loader"] = true

-- rail
subterra.config.underground_entities["straight-rail"] = true
subterra.config.underground_entities["curved-rail"] = true
subterra.config.underground_entities["small-electric-pole"] = true
subterra.config.underground_entities["medium-electric-pole"] = true
subterra.config.underground_entities["big-electric-pole"] = true
subterra.config.underground_entities["locomotive"] = true
subterra.config.underground_entities["cargo-wagon"] = true
subterra.config.underground_entities["rail-signal"] = true
subterra.config.underground_entities["rail-chain-signal"] = true
subterra.config.underground_entities["train-stop"] = true

-- misc
subterra.config.underground_entities["small-lamp"] = true
subterra.config.underground_entities["wooden-chest"] = true
subterra.config.underground_entities["iron-chest"] = true
subterra.config.underground_entities["steel-chest"] = true
subterra.config.underground_entities["pipe"] = true
subterra.config.underground_entities["pipe-to-ground"] = true
subterra.config.underground_entities["pump"] = true
subterra.config.underground_entities["accumulator"] = true
subterra.config.underground_entities["electric-energy-interface"] = true
