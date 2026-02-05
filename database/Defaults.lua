local ADDON_NAME, addon = ...

addon.db.defaults = {
    frame = {
        width = 1200,
        height = 44,
        background_color = { r = 0, g = 0, b = 0, a = 0.8 },
        position = {
            x = 0,
            y = -70,
            point = "TOP",
            relative_point = "TOP",
        },
    },
    health = {
        font = {
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 24,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
        percent_font = {
            disable_above = 3,
            offset = {
                x = -20,
            },
        },
        texture = {
            atlas = true,
            texture = false,
            atlas_texture = "Unit_Priest_Insanity_Fill",
            desaturated = false,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
        spark = {
            atlas = "GarrMission_EncounterBar-Spark",
            color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
            blend_mode = "ADD",
            width = 8,
            height_multi = 2.2,
        },
    },
    name = {
        offset = {
            y = 2,
        },
        font = {
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 32,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
    },
    power = {
        enabled = false,
        font = {
            font = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf",
            size = 16,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
    },
    accents = {
        copy_healthbar_texture_color = false,
        color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
    }
}
