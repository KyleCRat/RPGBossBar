local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "simple_horde",
    name = "Simple Horde",
    overrides = {
        frame = {
            background_color = { r = 0, g = 0, b = 0, a = 0.8 },
            border = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = 5,
                size = 24,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
            },
        },
        accents = {
            center = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "Quest-Horde-WaxSeal",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = .7,
                selected = "none",
                width_scale = 1,
            },
            left = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 22,
                    y = 8,
                },
                rotation = 0,
                scale = 1,
                selected = "simple-horde-wyvern-left",
                width_scale = 1,
            },
            right = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = -22,
                    y = 8,
                },
                rotation = 0,
                scale = 1,
                selected = "simple-horde-wyvern-right",
                width_scale = 1,
            },
        },
        name = {
            enabled = true,
            font = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                font = "Fonts\\FRIZQT__.TTF",
                size = 28,
            },
            offset = {
                y = 2,
            },
        },
        health = {
            font = {
                enabled = true,
                font = "Fonts\\FRIZQT__.TTF",
                size = 23,
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = {
                    y = -1,
                },
            },
            percent_font = {
                enabled = true,
                offset = {
                    x = -28,
                },
            },
            spark = {
                atlas = "GarrMission_EncounterBar-Spark",
                blend_mode = "ADD",
                color = { r = 220 / 255, g = 96 / 255, b = 54 / 255, a = 1 },
                height_multi = 2.3,
                width = 10,
            },
            texture = {
                atlas = false,
                atlas_texture = false,
                color = { r = 140 / 255, g = 22 / 255, b = 22 / 255, a = 1 },
                desaturated = false,
                texture = "Interface\\Buttons\\WHITE8X8",
            },
        },
        power = {
            enabled = true,
            height = 12,
            offset_y = -2,
            percent_width = 80,
            texture = "Interface\\Buttons\\WHITE8X8",
            border = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = 2,
                size = 10,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
            },
            color = { r = 1, g = 1, b = 0, a = 1 },
            font = {
                enabled = false,
            },
        },
    },
})
