require ("util")


subterra.configured_belts = {
    ["transport-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-1-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-1-icon-32.png"
    },
    ["fast-transport-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-2-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-2-icon-32.png",
        technology_name = "logistics-2"
    },
    ["express-transport-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-3-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-3-icon-32.png",
        technology_name = "logistics-3"
    }
}

local function make_recipe(prototype, source_name)
    --debug("SOURCE: ".. source_name)
    return {
        type = "recipe",
        name = prototype.name,
        enabled = false,
        energy_required = 10,
        ingredients =
        {
            { source_name, 10},
            { "iron-gear-wheel", 10}
        },
        results = {{ prototype.name, 1}},
        requester_paste_multiplier = 4
    }
end

local function make_exchange_recipe(source, target)
    return {
        type = "recipe",
        name = target.name .. "-ex",
        enabled = false,
        energy_required = 0.5,
		allow_as_intermediate = false,
		allow_intermediates = false,
        ingredients =
        {
            { source.name, 1}
        },
        results = {{ target.name, 1}},
        requester_paste_multiplier = 1
    }
end

local function make_item(prototype, icon)
    return {
        type = "item",
        name = prototype.name,
        icon = icon,
        icon_size = 32,
        flags = { },
        subgroup = "subterra-transport",
        order = "s[" .. prototype.name .. "]",
        place_result = prototype.name,
        stack_size = 10
    }
end

function make_belt_elevator(belt_prototype, source_name, config)
    local icon_up = config.up_icon
    local icon_down = config.down_icon
    if not icon_up then
        icon_up = belt_prototype.icon
    end
    if not icon_down then
        icon_down = belt_prototype.icon
    end

    local up = table.deepcopy(belt_prototype)
    local down = table.deepcopy(belt_prototype)
    local out = table.deepcopy(belt_prototype)

    up_name = "subterra-" .. up.name .. "-up"
    up.name = up_name
    up.minable.result = up_name
    down_name = "subterra-" .. down.name .. "-down"
    down.name = down_name
    down.minable.result = down_name
    out_name = "subterra-" .. out.name .. "-out"
    out.name = out_name
    out.minable.result = out_name

    local up_recipe = make_recipe(up, source_name)
    local up_ex = make_exchange_recipe(down, up)
    local up_item = make_item(up, icon_up)

    local down_recipe = make_recipe(down, source_name)
    local down_ex = make_exchange_recipe(up, down)
    local down_item = make_item(down, icon_down)

    local out_item = make_item(out, belt_prototype.icon)

    data:extend({
        up,
        up_item,
        up_recipe,
        up_ex,
        down,
        down_item,
        down_recipe,
        down_ex,
        out,
        out_item
    })

    if config.technology_name then
        table.insert(data.raw.technology[config.technology_name].effects,
        {
            type = "unlock-recipe",
            recipe = up_recipe.name,
        })
        table.insert(data.raw.technology[config.technology_name].effects,
        {
            type = "unlock-recipe",
            recipe = up_ex.name,
        })
        table.insert(data.raw.technology[config.technology_name].effects,
        {
            type = "unlock-recipe",
            recipe = down_recipe.name,
        })
        table.insert(data.raw.technology[config.technology_name].effects,
        {
            type = "unlock-recipe",
            recipe = down_ex.name,
        })
    end
end


local belts = data.raw["transport-belt"]
if belts then
    for name, config in pairs(subterra.configured_belts) do
        local source_prototype = belts[name]
        if source_prototype then
            make_belt_elevator(source_prototype, name, config)
        end
    end
end
