require ("util")

subterra.configured_belts = {
    ["underground-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-1-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-1-icon-32.png",
        top_in =
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/regular-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                y = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-regular-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height =192,
                    y = 192,
                    scale = 0.5
                }
            }
        },
        top_out = 
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/regular-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-regular-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height = 192,
                    scale = 0.5
                }
            }
        }
    },
    ["fast-underground-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-2-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-2-icon-32.png",
        technology_name = "logistics-2",
        top_in =
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/fast-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                y = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-fast-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height =192,
                    y = 192,
                    scale = 0.5
                }
            }
        },
        top_out = 
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/fast-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-fast-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height = 192,
                    scale = 0.5
                }
            }
        }
    },
    ["express-underground-belt"] = {
        up_icon = "__subterra__/graphics/icons/belt-up-3-icon-32.png",
        down_icon = "__subterra__/graphics/icons/belt-down-3-icon-32.png",
        technology_name = "logistics-3",
        top_in =
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/express-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                y = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-express-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height =192,
                    y = 192,
                    scale = 0.5
                }
            }
        },
        top_out = 
        {
            sheet =
            {
                filename = "__subterra__/graphics/entity/belt-elevator/express-belt-top.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                hr_version =
                {
                    filename = "__subterra__/graphics/entity/belt-elevator/hr-express-belt-top.png",
                    priority = "extra-high",
                    width = 192,
                    height = 192,
                    scale = 0.5
                }
            }
        }
    }
}

-- local new_ug = table.deepcopy(data.raw["underground-belt"]["underground-belt"])
-- new_ug.name = "the-new-ug"
-- new_ug.max_distance = 0

-- local new_i = table.deepcopy(data.raw["item"]["underground-belt"])
-- new_i.name = new_ug.name
-- new_i.place_result = new_ug.name

-- local new_r = table.deepcopy(data.raw["recipe"]["underground-belt"])
-- new_r.enabled = true
-- new_r.results = {{ new_ug.name, 1}}
-- data:extend({ new_ug, new_i, new_r })

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

    local target_name, subs = string.gsub(belt_prototype.name, "underground", "transport")
    log(target_name)
    local up = table.deepcopy(belt_prototype)
    local down = table.deepcopy(belt_prototype)
    local bottom_out = table.deepcopy(belt_prototype)
    local top_out = table.deepcopy(belt_prototype)

    up_name = "subterra-" .. target_name .. "-up"
    up.name = up_name
    up.minable.result = up_name
    up.max_distance = 0
    up.type = "linked-belt"
    --up.structure.direction_in = config.bottom_in
    --up.structure.direction_out = config.bottom_out

    down_name = "subterra-" .. target_name .. "-down"
    down.name = down_name
    down.minable.result = down_name
    down.max_distance = 0
    down.type = "linked-belt"
    log(serpent.block(down.structure))
    down.structure.direction_in = config.top_in
    down.structure.direction_out = config.top_in
    log(serpent.block(down.structure))

    bottom_out_name = "subterra-" .. target_name .. "-bottom-out"
    bottom_out.name = bottom_out_name
    bottom_out.minable.result = bottom_out_name
    bottom_out.max_distance = 0
    bottom_out.type = "linked-belt"
    --bottom_out.structure.direction_in = config.bottom_in
    --bottom_out.structure.direction_out = config.bottom_out

    top_out_name = "subterra-" .. target_name .. "-top-out"
    top_out.name = top_out_name
    top_out.minable.result = top_out_name
    top_out.max_distance = 0
    top_out.type = "linked-belt"
    top_out.structure.direction_in = config.top_in
    top_out.structure.direction_out = config.top_out

    local up_recipe = make_recipe(up, source_name)
    local up_ex = make_exchange_recipe(down, up)
    local up_item = make_item(up, icon_up)

    local down_recipe = make_recipe(down, source_name)
    local down_ex = make_exchange_recipe(up, down)
    local down_item = make_item(down, icon_down)

    local bottom_out_item = make_item(bottom_out, belt_prototype.icon)
    local top_out_item = make_item(top_out, belt_prototype.icon)

    data:extend({
        up,
        up_item,
        up_recipe,
        up_ex,
        down,
        down_item,
        down_recipe,
        down_ex,
        bottom_out,
        bottom_out_item,
        top_out,
        top_out_item,
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
log("Making Belt Elevator Recipies")
local belts = data.raw["underground-belt"]
if belts then
    for name, config in pairs(subterra.configured_belts) do
        local source_prototype = belts[name]
        if source_prototype then
            make_belt_elevator(source_prototype, name, config)
        end
    end
end
--log(serpent.block(data.raw["transport-belt"]))