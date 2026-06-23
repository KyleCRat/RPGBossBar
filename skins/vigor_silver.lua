local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_silver",
    name = "Vigor Silver",
    overrides = {
        frame = {
            background_color = { r = 0, g = 0, b = 0, a = 0.8 },
            border = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = 4,
                size = 32,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
        },
        accents = {
            center = {
                color = { r = 135 / 255, g = 206 / 255, b = 235 / 255, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-silver-center",
                width_scale = 1,
            },
            left = {
                color = { r = 135 / 255, g = 206 / 255, b = 235 / 255, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-silver-side",
                width_scale = 1,
            },
            right = {
                color = { r = 135 / 255, g = 206 / 255, b = 235 / 255, a = 1 },
                custom_atlas = "",
                desaturated = false,
                height_scale = 1,
                mirror_x = false,
                mirror_y = false,
                offset = {
                    x = 0,
                    y = 0,
                },
                rotation = 0,
                scale = 1,
                selected = "sgvigor-silver-side",
                width_scale = 1,
            },
        },
        name = {
            enabled = true,
            font = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                size = 30,
            },
            offset = {
                y = 2,
            },
        },
        health = {
            font = {
                enabled = true,
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                size = 20,
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = {
                    y = 0,
                },
            },
            percent_font = {
                enabled = true,
                offset = {
                    x = -24,
                },
            },
            spark = {
                color = { r = 180 / 255, g = 225 / 255, b = 1, a = 1 },
            },
            texture = {
                atlas = true,
                atlas_texture = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
                color = { r = 180 / 255, g = 225 / 255, b = 1, a = 1 },
                desaturated = true,
                texture = false,
            },
        },
        power = {
            enabled = true,
            height = 12,
            offset_y = 0,
            percent_width = 80,
            texture = "Interface\\Buttons\\WHITE8X8",
            border = {
                color = { r = 1, g = 1, b = 1, a = 1 },
                offset = 2,
                size = 10,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
            color = { r = 1, g = 1, b = 0, a = 1 },
            font = {
                enabled = false,
            },
        },
    },
})
