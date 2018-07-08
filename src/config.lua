--configuration stuff to go here

-- Max number of layers, including "nauvis" (surface)
subterra.config.MAX_LAYER_COUNT = 3

-- 
-- subterra.config.underground_entities =
-- {
--     "subterra-telepad-up" = true,
--     "subterra-telepad-down" = true,
--     "subterra-belt-up" = true,
--     "subterra-belt-down" = true
-- }

subterra.config.underground_entities = {}
-- subterra entities
subterra.config.underground_entities["subterra-telepad-up"] = true
subterra.config.underground_entities["subterra-telepad-down"] = true
subterra.config.underground_entities["subterra-belt-up"] = true
subterra.config.underground_entities["subterra-belt-down"] = true
subterra.config.underground_entities["subterra-belt-out"] = true
subterra.config.underground_entities["subterra-power-up"] = true
subterra.config.underground_entities["subterra-power-down"] = true
subterra.config.underground_entities["subterra-power-in"] = true
subterra.config.underground_entities["subterra-power-out"] = true

-- whitelisted vanilla entities
subterra.config.underground_entities["small-lamp"] = true
subterra.config.underground_entities["transport-belt"] = true
subterra.config.underground_entities["inserter"] = true
subterra.config.underground_entities["straight-rail"] = true
subterra.config.underground_entities["curved-rail"] = true
subterra.config.underground_entities["small-electric-pole"] = true
subterra.config.underground_entities["medium-electric-pole"] = true
subterra.config.underground_entities["big-electric-pole"] = true
subterra.config.underground_entities["locomotive"] = true
subterra.config.underground_entities["cargo-wagon"] = true
