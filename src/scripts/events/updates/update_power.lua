-- based on transger_power(from, to) from: https://github.com/MagmaMcFry/Factorissimo2
local function equalize_power(proxy, max_level, do_print)
	local inputs = proxy.inputs
	local outputs = proxy.outputs
	local buffer_size = outputs[1].electric_buffer_size * max_level
	local input_energy = 0
	local output_energy = 0

	for i = 1, max_level do
		local input = inputs[i]
		if input then	-- compatibility for saves pre 0.6.0
			local output = outputs[i]
			if not (input.valid and output.valid) then return end	
			input_energy = input_energy + input.energy
			output_energy = output_energy + output.energy
		end
	end
	local total_energy = input_energy + output_energy

	if total_energy > buffer_size then
		output_energy = buffer_size
		input_energy = total_energy - buffer_size
	else
		output_energy = total_energy
		input_energy = 0
	end

	local input_each = input_energy / max_level
	if input_each < 1 then input_each = 1 end
	local output_each = output_energy / max_level

	for i = 1, max_level do
		inputs[i].energy = input_each
		outputs[i].energy = output_each
	end
end

local update_power = function (event)
	local max_level = settings.startup["subterra-max-depth"].value + 1
    for _,p in pairs(global.power_proxies) do
		if not p.destroying then
            equalize_power(p, max_level)
        end
    end
end

return update_power