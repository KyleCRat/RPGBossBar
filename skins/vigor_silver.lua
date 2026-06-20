local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_silver",
    name = "Vigor Silver",
    overrides = {
        frame = {
            background_color = {
                a = 0.8,
                b = 0,
                g = 0,
                r = 0,
            },
            border = {
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = 4,
                size = 32,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
        },
        accents = {
            center = {
                custom_atlas = "",
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
            color = {
                a = 1,
                b = 210 / 255,
                g = 190 / 255,
                r = 165 / 255,
            },
            left = {
                custom_atlas = "",
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
                custom_atlas = "",
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
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
                size = 32,
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
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
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
                color = {
                    a = 1,
                    b = 1,
                    g = 225 / 255,
                    r = 180 / 255,
                },
            },
            texture = {
                atlas = true,
                atlas_texture = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
                color = {
                    a = 1,
                    b = 1,
                    g = 225 / 255,
                    r = 180 / 255,
                },
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
                color = {
                    a = 1,
                    b = 1,
                    g = 1,
                    r = 1,
                },
                offset = 2,
                size = 10,
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
            color = {
                a = 1,
                b = 0,
                g = 1,
                r = 1,
            },
            font = {
                enabled = false,
            },
        },
    },
})
