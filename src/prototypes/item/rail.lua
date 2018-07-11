local train_levels = 3

function make_loco_item(level)
data:extend({
{
    type = "item-with-entity-data",
    name = "subterra-locomotive-" .. level,
    icon = "__base__/graphics/icons/diesel-locomotive.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "transport",
    order = "a[train-system]-f[diesel-locomotive]",
    place_result = "subterra-locomotive-" .. level,
    stack_size = 5
}
})
end

for i=1,train_levels,1 do
    make_loco_item(i)
end