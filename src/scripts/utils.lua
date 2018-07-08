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

function debug(x)
    game.players[1].print(tostring(x))
end