--configuration stuff to go here

if not subterra then subterra = {} end
if not subterra.config then subterra.config = {} end

-- Max number of layers, including "nauvis" (surface)
subterra.config.MAX_LAYER_COUNT = 6

-- interval, in ticks, to check telepads
subterra.config.TELEPAD_UPDATE_INTERVAL = 5

-- interval, in ticks, to check for and cleanup invalid ghosts
subterra.config.GHOST_CLEANUP_INTERVAL = 6

-- train and battery names
subterra.config.locomotive_levels = {
    locomotive = 1
}

for i=1, subterra.config.MAX_LAYER_COUNT - 1, 1 do
    local name = "subterra-locomotive-" .. i
    -- index 1 is 'nauvis' / ground
    -- each level must be 1 lower that the last
    subterra.config.locomotive_levels[name] = 2
end

-- interval in ticks to redraw the hud when a player has an 'up' or
-- 'down' item in their hand
subterra.config.BOX_DURATION = 10

-- Radius (sorta) to draw the helper hud.
-- Actual area is a bounding box with extents equal to
-- player position +- this radius
subterra.config.HUD_DRAW_RADIUS = 20

-- entity types that are allowed underground by default
local underground_types = {}

subterra.config.underground_types = underground_types
underground_types["accumulator"] = true
underground_types["arithmetic-combinator"] = true
underground_types["arrow"] = true
underground_types["beam"] = true
underground_types["cargo-wagon"] = true
underground_types["character"] = true
underground_types["character-corpse"] = true
underground_types["combat-robot"] = true
underground_types["constant-combinator"] = true
underground_types["construction-robot"] = true
underground_types["container"] = true
underground_types["corpse"] = true
underground_types["curved-rail"] = true
underground_types["decider-combinator"] = true
underground_types["decorative"] = true
underground_types["electric-energy-interface"] = true
underground_types["electric-pole"] = true
underground_types["electric-turret"] = true
underground_types["entity-ghost"] = true
underground_types["explosion"] = true
underground_types["fire"] = true
underground_types["flame-thrower-explosion"] = true
underground_types["fluid-wagon"] = true
underground_types["flying-text"] = true
underground_types["gate"] = true
underground_types["highlight-box"] = true
underground_types["infinity-container"] = true
underground_types["infinity-pipe"] = true
underground_types["inserter"] = true
underground_types["item-entity"] = true
underground_types["item-request-proxy"] = true
underground_types["lamp"] = true
underground_types["loader"] = true
-- underground_types["locomotive"] = true
underground_types["logistic-container"] = true
underground_types["particle"] = true
underground_types["particle-source"] = true
underground_types["pipe"] = true
underground_types["pipe-to-ground"] = true
underground_types["player-port"] = true
underground_types["power-switch"] = true
underground_types["programmable-speaker"] = true
underground_types["projectile"] = true
underground_types["pump"] = true
underground_types["rail-chain-signal"] = true
underground_types["rail-remnants"] = true
underground_types["rail-signal"] = true
underground_types["simple-entity"] = true
-- underground_types["simple-entity-with-force"] = true
-- underground_types["simple-entity-with-owner"] = true
underground_types["speech-bubble"] = true
underground_types["splitter"] = true
underground_types["sticker"] = true
underground_types["storage-tank"] = true
underground_types["straight-rail"] = true
underground_types["tile-ghost"] = true
underground_types["train-stop"] = true
underground_types["transport-belt"] = true
-- underground_types["underground-belt"] = true
underground_types["unit"] = true
underground_types["unit-spawner"] = true
underground_types["wall"] = true

local underground_entities = {}
subterra.config.underground_entities = underground_entities
-- subterra entities
underground_entities["subterra-telepad-up"] = true
underground_entities["subterra-telepad-down"] = true
underground_entities["subterra-belt-up"] = true
underground_entities["subterra-belt-down"] = true
underground_entities["subterra-belt-out"] = true
underground_entities["subterra-power-column"] = true
--underground_entities["subterra-power-column"] = true
underground_entities["subterra-power-in"] = true
underground_entities["subterra-power-out"] = true
underground_entities["subterra-recharger"] = true
-- whitelisted vanilla entities

--- belts
underground_entities["transport-belt"] = true
underground_entities["fast-transport-belt"] = true
underground_entities["express-transport-belt"] = true
underground_entities["underground-belt"] = true
underground_entities["fast-underground-belt"] = true
underground_entities["express-underground-belt"] = true

-- inserters & loaders
underground_entities["inserter"] = true
underground_entities["fast-inserter"] = true
underground_entities["filter-inserter"] = true
underground_entities["stack-inserter"] = true
underground_entities["stack-filter-inserter"] = true
underground_entities["loader"] = true
underground_entities["fast-loader"] = true
underground_entities["express-loader"] = true

-- rail
underground_entities["straight-rail"] = true
underground_entities["curved-rail"] = true
underground_entities["small-electric-pole"] = true
underground_entities["medium-electric-pole"] = true
underground_entities["big-electric-pole"] = true
underground_entities["substation"] = true
underground_entities["locomotive"] = false
underground_entities["cargo-wagon"] = true
underground_entities["rail-signal"] = true
underground_entities["rail-chain-signal"] = true
underground_entities["train-stop"] = true

-- misc
underground_entities["small-lamp"] = true
underground_entities["wooden-chest"] = true
underground_entities["iron-chest"] = true
underground_entities["steel-chest"] = true
underground_entities["pipe"] = true
underground_entities["pipe-to-ground"] = true
underground_entities["pump"] = true
underground_entities["accumulator"] = true
underground_entities["electric-energy-interface"] = true
