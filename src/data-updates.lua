require("prototypes.belts.belts")

local base_locomotive = data.raw["locomotive"]["locomotive"]
local group_name = "locomotive"
if base_locomotive and base_locomotive.fast_replaceable_group then
    group_name = base_locomotive.fast_replaceable_group
else
    base_locomotive.fast_replaceable_group = group_name
end

for i=1, 5, 1 do
    local subterra_locomotive = data.raw["locomotive"]["locomotive-" .. i]
    if subterra_locomotive then
        subterra_locomotive.fast_replaceable_group = group_name
    end
end

