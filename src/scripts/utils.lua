if not subterra.events then subterra.events = {} end
if not subterra.tick_events then subterra.tick_events = {} end
if not subterra.config_events then subterra.config_events = {} end

S_ROOT = "__subterra__"

_blank = S_ROOT .. "/graphics/blank.png"
function blank_picture()
    return {
        filename = _blank,
        priority = "high",
		width = 1,
		height = 1,
		frame_count = 1,
    }
end

function get_member_safe( t, key )
    local call_result, value = pcall( function () return t[key] end )
    if call_result then
        return value
    else
        return nil
    end
end

function remove_value(t, value)
    local index
    for i, v in pairs(t) do
        if value == v then 
            index = i
            break
        end
    end
    if index then
        table.remove(t, index)
        return true
    end
    return false
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function print_bounding_box(bbox)
    return "{ {" .. bbox.left_top.x .. ", " .. bbox.left_top.y .. "}, {"..bbox.right_bottom.x .. ", " .. bbox.right_bottom.y .. "} }"
end

function add_player_proxy(i)
    local p = game.players[i]
    if global.player_proxies[i] == nil and p.connected and p.character then
        local proxy = {
            name = p.name,
            index = i,
            player = p,
            on_pad = -1,
        }
        global.player_proxies[i] = proxy
    end
    print("Added player: " .. p. name )
end

function get_underground_settings(surface)
    -- copy map settings
    local gen_settings = table.deepcopy(surface.map_gen_settings)
    -- remove resources from settings
    for _, r in pairs(gen_settings.autoplace_controls) do
        if not r.category == "terrain" then
            r.frequency = 'very-low'
            r.size = 'none'
            r.richness = 'very-poor'
        end
    end
    gen_settings.peaceful_mode = true

    return gen_settings
end

function get_generated_extents(surface)
    -- get currently generated surface chunks
    local minx = 2147483648 -- sentinels, min/max 32-bit 2's compliment
    local miny = 2147483648 
    local maxx = -2147483647
    local maxy = -2147483647 

    for chunk in surface.get_chunks() do
        minx = math.min(minx, chunk.x)
        miny = math.min(miny, chunk.y)
        maxx = math.max(maxx, chunk.x)
        maxy = math.max(maxy, chunk.y)
    end

    local middle = {
        (maxx + minx) / 2,
        (maxy + miny) / 2
    }
    local radius = math.max(10, math.max(maxx - minx, maxy - miny) / 2)
    middle[1] = middle[1] * 16
    middle[2] = middle[2] * 16

    -- print("World Rect: {" .. middle[1] .. ", " .. middle[2] .. "} radius = " .. radius .. "\n")
    -- print("X: " .. minx .. ", " .. maxx)
    -- print("Y: " .. miny .. ", " .. maxy)
    -- print("")

    return middle, radius
end

function create_layer(depth, gen_settings)
    local layer_name = "underground_" .. tostring(depth)

    print("Making Layer: " .. layer_name)

    local surface = game.surfaces[layer_name]
    if not surface then
        surface = game.create_surface(layer_name, gen_settings)
        surface.daytime = 0.5
        surface.freeze_daytime = true
    end

    if remote.interfaces["RSO"] then
        remote.call("RSO", "ignoreSurface", layer_name)
    end

    local layer = {
        index = depth + 1,
        surface = surface,
        telepads = Quadtree:new(),
        pad_ghosts = Quadtree:new(),
        belt_ghosts = Quadtree:new(),
        power_ghosts = Quadtree:new()
    }

    layer.telepads:rebuild_index()
    layer.pad_ghosts:rebuild_index()
    layer.belt_ghosts:rebuild_index()
    layer.power_ghosts:rebuild_index()

    return layer_name, layer
end

function check_layer(surface, ent_name, is_down, force)
    local sname = surface.name
    
    local layer = global.layers[sname]

    -- to prevent entity from being buld on other mods' surfaces
    if not layer then
        return nil, nil, {"message.building-surface-blacklist", {"entity-name."..ent_name}}
    end

    local target_layer
    if is_down then 
        target_layer = layer.layer_below
    else
        target_layer = layer.layer_above
    end
    
    -- check if target layer exists
    if target_layer == nil then
        return nil, nil, {"message.building-surface-nil", {"entity-name."..ent_name}}
    end
    
    local target_depth = target_layer.index - 1    
    if force then
        if target_depth > global.current_depth[force.name] then
            return nil, nil, {"message.building-level-not-unlocked", {"entity-name."..ent_name}, {"technology-name.underground-building"}, target_depth}
        end
    end

    return layer, target_layer
end

--============================================================================--
-- register_event(id, callback)
--
-- registers an event to be wired up automatically by wire_all_events() below
--
-- param id (uint): the id of the event, (usually from defines.events)
-- param callback (function): function to register for the event
--
-- remarks: if multiple callback are registered for the same event id, then
-- they will each be called from the event, in the order they were registered
--============================================================================--
function register_event (id, callback)
    table.insert(subterra.events, {
        id = id,
        callback = callback
    })
    print("Registered callback for event #" .. id)
end

--============================================================================--
-- register_nth_tick_event(id, callback)
--
-- Registers an event to be wired up to script.on_nth_tick
-- automatically by wire_all_events() below
--
-- param tick (uint): the tick multiple to register for
-- param callback (function): function to call on the nth tick
-- remarks: if multiple callback are registered for the same tick #, then
-- they will each be called from the event, in the order they were registered
--============================================================================--
function register_nth_tick_event (tick, callback)
    table.insert(subterra.tick_events, {
        tick = tick,
        callback = callback
    })
    print("Registered nth-tick callback for tick count " .. tick)
end

--============================================================================--
-- register_configuration_event(predicate, callback)
--
-- registers an event to be wired up automatically by wire_all_events() below
--
-- param predicate (uint): A function that returns true if [param]:callback
--      is to run. Given (ConfigurationChangedData) as a prameter
-- param callback (function): function to fire if [param]:predicate returns
--      true.  Given (ConfigurationChangedData) as a prameter
--
-- remarks: All registered predicates will be called
--============================================================================--
function register_configuration_event(predicate, callback)
    table.insert(subterra.config_events, {
        predicate = predicate,
        callback = callback
    })
    print("Registered configuration callback")
end

--============================================================================--
-- wire_all_events()
--
-- wires all events registerd using the register_event above and the on_tick events
-- to be called in control.lua
--============================================================================--
function wire_all_events()
    print("Wiring events")
    -- configuration_changed events
    if subterra.config_events and #(subterra.config_events) > 0 then
        script.on_configuration_changed(function(config_data)
            for _, event in pairs(subterra.config_events) do
                if event.predicate(config_data) then event.callback(config_data) end
            end
        end)
    end

    -- on_nth_tick events
    if subterra.tick_events then
        local events = {}
        local counts = {}

        for _, event in pairs(subterra.tick_events) do
            local n = event.tick
            if counts[n] then
                counts[n] = counts[n] + 1
                events[n][counts[n]] = event.callback
            else
                counts[n] = 1
                events[n] = {}
                events[n][1] = event.callback
            end
        end

        for n, callbacks in pairs(events) do
            if counts[n] == 1 then
                script.on_nth_tick(n, callbacks[1])
                print("Wired nth tick event for n = " .. n)
            elseif counts[n] > 1 then
                script.on_nth_tick(n,
                function(event)
                    for _, callback in pairs(callbacks) do
                        callback(event)
                    end
                end)
            end
        end
    end

    -- all other events
    local events = {}
    local counts = {}

    for _, event in pairs(subterra.events) do
        local id = event.id
        if not counts[id] then
            counts[id] = 0
            events[id] ={}
        end
        table.insert(events[id], event.callback)
        table.insert(events[id], event.callback)
        counts[id] = counts[id] + 1
    end

    for id, callbacks in pairs(events) do
        if counts[id] == 1 then
            script.on_event(id, callbacks[1])
        elseif counts[id] > 1 then
            script.on_event(id,
            function(event)
                for _, callback in pairs(callbacks) do
                    callback(event)
                end
            end)
        end
        print("Wired " .. counts[id] .. " callback(s) for event id:" .. id)
    end
end

function shrink(bounding_box)
    return {
        left_top = { x = bounding_box.left_top.x + 0.00125, y = bounding_box.left_top.y + 0.00125 },
        right_bottom = { x = bounding_box.right_bottom.x - 0.00125, y = bounding_box.right_bottom.y - 0.00125 }
    }
end

function debug(x)
    game.players[1].print(tostring(x))
end