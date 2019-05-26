require("__subterra__.scripts.utils")

local max_level = settings.startup["subterra-max-depth"].value + 1  -- level is depth + 1 (i.e. nauvis = depth 0 & level 1)
local layers = global.layers

local radar_proxies = {}
local radar_proxy_array = {}
local radar_proxy_forces = {}

-- get all radars on nauvis
-- this could take a while...
local nauvis = game.surfaces['nauvis']
local all_radars = nauvis.find_entities_filtered{
    type = "radar"
}

local try_add_radar_proxy = function(radar)
    local hidden_name = "subterra-hidden-" .. radar.name
    local hidden_prototype = game.entity_prototypes[hidden_name]
    if not hidden_prototype then
        return  -- radar prototype must have been added after subterra's data-updates thus cannot use it
    end

    local force = radar.force
    local f_name = force.name
    local force_array = radar_proxy_forces[f_name] 
    if not force_array then
        force_array = {}
        radar_proxy_forces[f_name] = force_array
    end

    local index = # radar_proxy_array + 1
    local f_index = # force_array + 1
    local unit_number = radar.unit_number
    local center = chunk_to_position(position_to_chunk(radar.position))
    local range = hidden_prototype.max_health   -- haaaaak

    local proxy = {
        index = index,
        force_index = f_index,
        force = radar.force,
        radar = radar,
        chart_area = { { center.x - range, center.y - range }, { center.x + range, center.y + range } },
        max_level = 1       -- underground radar tech also added this version so it cannot already be researched.
    }                       -- Thus only the top radar is in the proxy and max_level is 1

    radar_proxies[unit_number] = proxy
    table.insert(radar_proxy_array, proxy)
    table.insert(force_array, proxy)
end

for _, radar in pairs(all_radars) do
    try_add_radar_proxy(radar)
end

global.radar_proxies = radar_proxies
global.radar_proxy_array = radar_proxy_array 
global.radar_proxy_forces = radar_proxy_forces

-- quick lookup of subterra surfaces indexed by level
local surfaces = {}
for i = 1, max_level do
    surfaces[i] = layers[i].surface
end

-- migrate power_proxies
local power_proxies = {}
local power_inputs = global.power_inputs
local power_outputs = global.power_outputs

local target_name = "subterra-power-column"
local mark_color = { r = 1, g = 0, b = 0, a = 1 }
local mark_radius = 1
local mark_width = 2
local mark_scale = 5
local mark_text = "!"
local mark_offset = {-0.3, -1.5}

for _, old_proxy in pairs(power_inputs) do
    local unit_numbers = {}
    local inputs = {}
    local outputs = {}
    local columns = {}
    local poles = {}

    local old_input = old_proxy.input
    local old_output = old_proxy.output
    local old_top = old_proxy.top
    local old_bottom = old_proxy.bottom
    local old_pole_top = old_proxy.pole_top
    local old_pole_bottom = old_proxy.pole_bottom
    local old_out_index = old_proxy.target_layer.index
    local old_in_index = layers[old_top.surface.name].index
    local old_top_index = layers[old_input.surface.name].index
    local old_bottom_index = old_top_index + 1
    local target_position = old_top.position
    local target_direction = old_top.direction
    local force = old_top.force

    local draw_marks = false

    for i=1, max_level do
        local surface = surfaces[i]
        local can_place = surface.can_place_entity{name = target_name, position = target_position}

        local input
        local output
        local column
        local pole
    
        if i == old_in_index then
            input = old_input
            output = surface.create_entity{
                name = "subterra-power-out",
                position = target_position,
                force = force,
                direction = target_direction
            }
        elseif i == old_out_index then
            output = old_output
            input = surface.create_entity{
                name = "subterra-power-in",
                position = target_position,
                force = force,
                direction = target_direction
            }
        elseif can_place then
            input = surface.create_entity{
                name = "subterra-power-in",
                position = target_position,
                force = force,
                direction = target_direction
            }
            output = surface.create_entity{
                name = "subterra-power-out",
                position = target_position,
                force = force,
                direction = target_direction
            }
        end

        if i == old_top_index then
            column = old_top
            pole = old_pole_top
        elseif i == old_bottom_index then
            column = old_bottom
            pole = old_pole_bottom
        elseif can_place then
            column = surface.create_entity{
                name = "subterra-power-column",
                force = force,
                position = target_position,
                direction = target_direction
            }
            pole = surface.create_entity{
                name = "subterra-power-pole",
                position = target_position,
                force = force,
                direction = target_direction
            }
        else
            draw_marks = true
            debug("CAN'T PLACE : " .. surface.name)
        end

        columns[i] = column
        inputs[i] = input
        outputs[i] = output
        poles[i] = pole

        if column then
            table.insert(unit_numbers, column.unit_number)
        end
    end

    -- these rendering are automatically invalidated when the target is removed/destroyed
    if draw_marks then
        for _, column in pairs(columns) do
            rendering.draw_circle{
                color = mark_color,
                radius = mark_radius,
                width = mark_width,
                surface = column.surface,
                force = force,
                target = column
            }
            rendering.draw_text{
                color = mark_color,
                surface = column.surface,
                force = force,
                target = column,
                text = mark_text,
                scale = mark_scale,
                target_offset = mark_offset
            }
        end
    end

    -- clean up any dangling references
    old_proxy.input = nil
    old_proxy.output = nil
    old_proxy.top = nil
    old_proxy.bottom = nil
    old_proxy.pole_top = nil
    old_proxy.pole_bottom = nil
    old_proxy.target_layer = nil
    
    local power_proxy = {
        columns = columns,
        inputs = inputs,
        outputs = outputs,
        poles = poles
    }
    -- add to new index
    for _, unit_number in pairs(unit_numbers) do
        power_proxies[unit_number] = power_proxy
    end
end

global.power_proxies = power_proxies

-- clear old tables
global.power_inputs = nil
for k, _ in pairs(power_inputs) do
    power_inputs[k] = nil
end

global.power_outputs = nil
for k, _ in pairs(power_outputs) do
    power_outputs[k] = nil
end

global.drawing_players = {}