local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_silver",
    name = "Vigor Silver",
    overrides = {
        accents = {
            center = {
                group = "sgvigor-silver-center",
            },
            color = {
                a = 1,
                b = 210 / 255,
                g = 190 / 255,
                r = 165 / 255,
            },
            left = {
                group = "sgvigor-silver-side",
            },
            right = {
                group = "sgvigor-silver-side",
            },
        },
        frame = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
        },
        health = {
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
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
            },
        },
    },
})
