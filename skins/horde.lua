local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "horde",
    name = "Horde",
    overrides = {
        frame = {
            background_color = { r = 0, g = 0, b = 0, a = 0.8, },
            border = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                offset = 9,
                size = 13,
                texture = "nineslice:horde",
            },
        },
        accents = {
            center = {
                color = { r = 1, g = 1, b = 1, a = 1, },
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
                scale = 0.65,
                selected = "none",
                width_scale = 1,
            },
            left = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                custom_atlas = "charcreatetest-logo-horde",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 28,
                    y = -9,
                },
                rotation = 0,
                scale = 1.5,
                selected = "none",
                width_scale = 1,
            },
            right = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                custom_atlas = "charcreatetest-logo-horde",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = -28,
                    y = -9,
                },
                rotation = 0,
                scale = 1.5,
                selected = "none",
                width_scale = 1,
            },
        },
        name = {
            enabled = true,
            font = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                outline = "THICKOUTLINE",
                size = 30,
            },
            offset = {
                y = 4,
            },
        },
        health = {
            font = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                enabled = true,
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                outline = "OUTLINESLUG",
                offset = {
                    y = -1,
                },
                size = 21,
            },
            percent_font = {
                enabled = true,
                outline = "OUTLINESLUG",
                offset = {
                    x = -22,
                },
            },
            spark = {
                atlas = "GarrMission_EncounterBar-Spark",
                blend_mode = "ADD",
                color = { r = 140 / 255, g = 22 / 255, b = 22 / 255, a = 1 },
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
            percent_width = 80,
            offset_y = -7,
            texture = "Interface\\Buttons\\WHITE8X8",
            border = {
                color = { r = 1, g = 1, b = 1, a = 1, },
                offset = 3,
                size = 10,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
            },
            color = { r = 1, g = 1, b = 0, a = 1, },
            font = {
                enabled = false,
            },
        },
    },
})
