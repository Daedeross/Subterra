-- based on transger_power(from, to) from: https://github.com/MagmaMcFry/Factorissimo2
local function equalize_power(from, to)
	if not (from.valid and to.valid) then return end
	local energy = from.energy + to.energy
    local ebs = to.electric_buffer_size
	if energy > ebs then
		to.energy = ebs
		from.energy = energy - ebs
	else
		to.energy = energy
		from.energy = 0
	end
end

local update_power = function (event)
    for _,p in pairs(global.power_inputs) do
        if p.input.valid and p.output.valid then
            equalize_power(p.input, p.output)
        end
    end 
end

return update_power