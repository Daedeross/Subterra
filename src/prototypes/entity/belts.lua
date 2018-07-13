require ("prototypes.entity.transport-belt-pictures")
require ("prototypes.entity.circuit-connector-sprites")

data:extend({
    {
        type = "transport-belt",
        name = "subterra-belt-out",
        icon = "__base__/graphics/icons/underground-belt.png",
        icon_size = 32,
        flags = { },
        minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-belt-out"},
        max_health = 60,
        corpse = "small-remnants",
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        working_sound =
        {
            sound =
            {
                filename = "__base__/sound/transport-belt.ogg",
                volume = 0.4
            },
            max_sounds_per_type = 3
        },
        animation_speed_coefficient = 32,
        animations =
        {
            filename = "__base__/graphics/entity/transport-belt/transport-belt.png",
            priority = "low",
            width = 40,
            height = 40,
            frame_count = 16,
            direction_count = 12
        },
        belt_horizontal = basic_belt_horizontal,
        belt_vertical = basic_belt_vertical,
        ending_top = basic_belt_ending_top,
        ending_bottom = basic_belt_ending_bottom,
        ending_side = basic_belt_ending_side,
        starting_top = basic_belt_starting_top,
        starting_bottom = basic_belt_starting_bottom,
        starting_side = basic_belt_starting_side,
        ending_patch = ending_patch_prototype,
        --fast_replaceable_group = "transport-belt",
        speed = 0.03125,
        connector_frame_sprites = transport_belt_connector_frame_sprites,
        circuit_connector_sprites = transport_belt_circuit_connector_sprites,
        circuit_wire_connection_point = transport_belt_circuit_wire_connection_point,
        circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
    },
    {
        type = "transport-belt",
        name = "subterra-belt-down",
        icon = "__base__/graphics/icons/underground-belt.png",
        icon_size = 32,
        flags = {"placeable-neutral", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-belt-down"},
        max_health = 60,
        corpse = "small-remnants",
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        working_sound =
        {
            sound =
            {
                filename = "__base__/sound/transport-belt.ogg",
                volume = 0.4
            },
            max_sounds_per_type = 3
        },
        animation_speed_coefficient = 32,
        animations =
        {
            filename = "__base__/graphics/entity/transport-belt/transport-belt.png",
            priority = "extra-high",
            width = 40,
            height = 40,
            frame_count = 16,
            direction_count = 12
        },
        belt_horizontal = basic_belt_horizontal,
        belt_vertical = basic_belt_vertical,
        ending_top = basic_belt_ending_top,
        ending_bottom = basic_belt_ending_bottom,
        ending_side = basic_belt_ending_side,
        starting_top = basic_belt_starting_top,
        starting_bottom = basic_belt_starting_bottom,
        starting_side = basic_belt_starting_side,
        ending_patch = ending_patch_prototype,
        fast_replaceable_group = "transport-belt",
        speed = 0.03125,
        connector_frame_sprites = transport_belt_connector_frame_sprites,
        circuit_connector_sprites = transport_belt_circuit_connector_sprites,
        circuit_wire_connection_point = transport_belt_circuit_wire_connection_point,
        circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
    },
    {
        type = "transport-belt",
        name = "subterra-belt-up",
        icon = "__base__/graphics/icons/underground-belt.png",
        icon_size = 32,
        flags = {"placeable-neutral", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-belt-up"},
        max_health = 60,
        corpse = "small-remnants",
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        working_sound =
        {
            sound =
            {
                filename = "__base__/sound/transport-belt.ogg",
                volume = 0.4
            },
            max_sounds_per_type = 3
        },
        animation_speed_coefficient = 32,
        animations =
        {
            filename = "__base__/graphics/entity/transport-belt/transport-belt.png",
            priority = "extra-high",
            width = 40,
            height = 40,
            frame_count = 16,
            direction_count = 12
        },
        belt_horizontal = basic_belt_horizontal,
        belt_vertical = basic_belt_vertical,
        ending_top = basic_belt_ending_top,
        ending_bottom = basic_belt_ending_bottom,
        ending_side = basic_belt_ending_side,
        starting_top = basic_belt_starting_top,
        starting_bottom = basic_belt_starting_bottom,
        starting_side = basic_belt_starting_side,
        ending_patch = ending_patch_prototype,
        --fast_replaceable_group = "transport-belt",
        speed = 0.03125,
        connector_frame_sprites = transport_belt_connector_frame_sprites,
        circuit_connector_sprites = transport_belt_circuit_connector_sprites,
        circuit_wire_connection_point = transport_belt_circuit_wire_connection_point,
        circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
    }--,
-- {
--         type = "transport-belt",
--         name = "subterra-belt-up-out",
--         icon = "__base__/graphics/icons/underground-belt.png",
--         flags = {"placeable-neutral", "player-creation"},
--         minable = {hardness = 0.2, mining_time = 0.5, result = "subterra-belt-up-out"},
--         max_health = 60,
--         corpse = "small-remnants",
--         collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
--         selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
--         working_sound =
--         {
--             sound =
--             {
--                 filename = "__base__/sound/transport-belt.ogg",
--                 volume = 0.4
--             },
--             max_sounds_per_type = 3
--         },
--         animation_speed_coefficient = 32,
--         animations =
--         {
--             filename = "__base__/graphics/entity/transport-belt/transport-belt.png",
--             priority = "extra-high",
--             width = 40,
--             height = 40,
--             frame_count = 16,
--             direction_count = 12
--         },
--         belt_horizontal = basic_belt_horizontal,
--         belt_vertical = basic_belt_vertical,
--         ending_top = basic_belt_ending_top,
--         ending_bottom = basic_belt_ending_bottom,
--         ending_side = basic_belt_ending_side,
--         starting_top = basic_belt_starting_top,
--         starting_bottom = basic_belt_starting_bottom,
--         starting_side = basic_belt_starting_side,
--         ending_patch = ending_patch_prototype,
--         fast_replaceable_group = "transport-belt",
--         speed = 0.03125,
--         connector_frame_sprites = transport_belt_connector_frame_sprites,
--         circuit_connector_sprites = transport_belt_circuit_connector_sprites,
--         circuit_wire_connection_point = transport_belt_circuit_wire_connection_point,
--         circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
-- }
})