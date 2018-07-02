if not subterra.events then subterra.events = {} end
if not subterra.tick_events then subterra.tick_events = {} end

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
    if global.player_proxies[i] == nil and p.connected and p.character ~= nil then
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
end

--============================================================================--
-- wire_all_events()
--
-- wires all events registerd using the register_event above and the on_tick events
-- to be called in control.lua
--============================================================================--
function wire_all_events()
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
                print("registered nth tick event for n = " .. n)
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
            script.on_nth_tick(id,
            function(event)
                for _, callback in pairs(callbacks) do
                    callback(event)
                end
            end)
        end
        print("registered callback(s) for event:" .. id)
    end
end

function debug(x)
    game.players[1].print(tostring(x))
end