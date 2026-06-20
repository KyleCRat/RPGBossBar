local ADDON_NAME, RPGBB = ...

RPGBB:RegisterDefaultSkin({
    id = "vigor_bronze",
    name = "Vigor Bronze",
    overrides = {
        accents = {
            center = {
                group = "sgvigor-bronze-center",
            },
            color = {
                a = 1,
                b = 43 / 255,
                g = 92 / 255,
                r = 164 / 255,
            },
            left = {
                group = "sgvigor-bronze-side",
            },
            right = {
                group = "sgvigor-bronze-side",
            },
        },
        frame = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_bronze.tga",
            },
        },
        health = {
            spark = {
                color = {
                    a = 1,
                    b = 55 / 255,
                    g = 140 / 255,
                    r = 1,
                },
            },
            texture = {
                atlas = true,
                atlas_texture = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage",
                color = {
                    a = 1,
                    b = 40 / 255,
                    g = 105 / 255,
                    r = 220 / 255,
                },
                desaturated = true,
                texture = false,
            },
        },
        power = {
            border = {
                texture = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_bronze.tga",
            },
        },
    },
})
