require("__subterra__.scripts.utils")

local function create_hidden_entities(surface, position, direction, force)
    local input = surface.create_entity{
        name = "subterra-power-in",
        position = position,
        force = force,
        direction = direction
    }
    local output = surface.create_entity{
        name = "subterra-power-out",
        position = position,
        force = force,
        direction = direction
    }
    local pole = surface.create_entity{
        name = "subterra-power-pole",
        position = position,
        force = force,
        direction = direction
    }

    return input, output, pole
end

--============================================================================--
-- add_power_proxy(placed, surface, creator)
--
-- callback for when a telepad (i.e. Stairs) is placed
--
-- param placed (LuaEntity): The placed power-converter entity or ghost
-- param surface (LuaSurface): The surface the entity is placed on
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
-- returns (boolean, LocalisedString):
--  1: true if the entity and its paired entity are successfully placed
--  2: The message to display if unable to place (nil if above is true)
--
--============================================================================--
local add_power_proxy = function (placed, surface, creator)
    local force = creator and get_member_safe(creator, "force")

    local sname = surface.name
    local layers = global.layers 
    local layer = layers[sname]
    debug("Place Surface: " .. sname)

    local ent_name = placed.name
    local is_ghost = ent_name == "entity-ghost"

    -- to prevent entity from being built on other mods' surfaces
    if not layer then
        return false, {"message.building-surface-blacklist", {"entity-name."..ent_name}}
    end

    if is_ghost then
        ent_name = placed.ghost_name
    end

    local target_name = "subterra-power-column"
    local target_position = placed.position
    local target_direction = placed.direction

    -- check if target locations are free
    local max_level = settings.startup["subterra-max-depth"].value + 1  -- level is depth + 1 (i.e. nauvis = depth 0 & level 1)
    local surfaces = {}
    local invalid = false
    for i = 1, max_level do
        local target_surface = layers[i].surface
        if (surface ~= target_surface and not target_surface.can_place_entity{name = target_name, position = target_position}) then
            debug("Can't place on Surface: " .. target_surface.name .. " | level: " .. i)
            invalid = true     
        end
        surfaces[i] = target_surface
    end

    if invalid then
        return false, {"message.building-conflict", {"entity-name."..ent_name}}
    end

    if is_ghost then 
        -- create target ghosts
        local ghosts = {}
        for i = 1, max_level do
            local target_surface = surfaces[i]
            local target_entity
            if target_surface == surface then
                target_entity = placed
            else
                target_entity = target_surface.create_entity{
                    name = "entity-ghost",
                    inner_name = target_name,
                    force = force,
                    position = target_position,
                    direction = target_direction
                }
            end
            ghosts[i] = target_entity 
        end
        -- create ghost proxy
        local ghost_proxy = {
            bbox = top.bounding_box,
            ghosts = ghosts
        }

        layer.power_ghosts:add_proxy(ghost_proxy)
        target_layer.power_ghosts:add_proxy(ghost_proxy)

        return true
    end
    -- when actually placing the entity
    local unit_numbers = {}
    local inputs = {}
    local outputs = {}
    local columns = {}
    local poles = {}

    for i = 1, max_level do
        local target_surface = surfaces[i]
        local column
        if target_surface == surface then
            column = placed
        else
            column = target_surface.create_entity{
                name = "subterra-power-column",
                force = force,
                position = target_position,
                direction = target_direction
            }
        end
        columns[i] = column
        unit_numbers[i] = column.unit_number

        local input, output, pole = create_hidden_entities(target_surface, target_position, target_direction, force)
        inputs[i] = input
        outputs[i] = output
        poles[i] = pole
    end

    local power_proxy = {
        columns = columns,
        inputs = inputs,
        outputs = outputs,
        poles = poles
    }

    -- add to proxy table with index for each 'column' entity
    for _, unit_number in pairs(unit_numbers) do
        global.power_proxies[unit_number] = power_proxy
    end
    -- add to compact table
    table.insert(global.power_array, power_proxy)

    return true
end

return add_power_proxy