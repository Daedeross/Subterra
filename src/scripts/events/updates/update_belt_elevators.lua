--============================================================================--
-- update_belt_elevators(event)
--
-- event hadler for defines.events.on_tick
--
-- checks every tick and transfers items from inputs to outputs on
--      belt-elevators
--
-- param event (table): { tick }
--
--============================================================================--
local update_belt_elevators = function (event)
    for _,b in pairs(global.belt_inputs) do
        if b.input.valid and b.output.valid then
            --local type = b.input.type
            local in1 = b.in_line1
            local in2 = b.in_line2
            local out1 = b.out_line1
            local out2 = b.out_line2
            local c1 = # in1
            local c2 = # in2
            if c1 > 0 then
                local n = in1[1].name
                if out1.insert_at_back({name=n}) then
                    in1.remove_item({name=n})
                end
            end
            if c2 > 0 then
                local n = in2[1].name
                if out2.insert_at_back({name=n}) then
                    in2.remove_item({name=n})
                end
            end
        end
    end
end

return update_belt_elevators