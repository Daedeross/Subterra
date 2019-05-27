require("__subterra__.scripts.utils")
-- based on transfer_power(from, to) from: https://github.com/MagmaMcFry/Factorissimo2
local function equalize_power(proxy, max_level, do_print)
    local inputs = proxy.inputs
    local outputs = proxy.outputs
    local input_energy = 0
    local output_energy = 0
    local n = 0

    for i = 1, max_level do
        local input = inputs[i]
        if input then   -- compatibility for saves pre 0.6.0
            n = n + 1
            local output = outputs[i]
            if not (input.valid and output.valid) then
                return
            end
            input_energy = input_energy + input.energy
            output_energy = output_energy + output.energy
        end
    end
    local total_energy = input_energy + output_energy
    local buffer_size = outputs[1].electric_buffer_size * n

    if total_energy > buffer_size then
        output_energy = buffer_size
        input_energy = total_energy - buffer_size
    else
        output_energy = total_energy
        input_energy = 0
    end

    local input_each = input_energy / n
    if input_each < 1 then input_each = 0 end
    local output_each = output_energy / n

    for i = 1, max_level do
        local input = inputs[i]
        if input then   -- compatibility for saves pre 0.6.0
            input.energy = input_each
            outputs[i].energy = output_each
        end
    end
end
--============================================================================--
-- update_power(event)
--
-- Transfers energy from the input buffers to the output buffers and equalizes
--      the outputs of each power transfer column
--
-- param event (OnTickEvent): { tick }
--
--============================================================================--
local update_power = function (event)
    local max_level = settings.startup["subterra-max-depth"].value + 1
    local proxies = global.power_array
    for i = 1, # proxies do
        local proxy = proxies[i]
        if not proxy.destroying then
            equalize_power(proxy, max_level)
        end
    end
end

return update_power