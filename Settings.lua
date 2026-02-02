local ADDON_NAME, RPGBB = ...
ADDON_ABVR = "RPGBB"

local FONT = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf"

local default_settings = {
    handle = {
        size = 32,
        bg_color = { r = 0, g = 0, b = 0, a = 0.8 },
        texture = "Interface\\CURSOR\\UI-Cursor-Move",
        vertex_color = { r = 1, g = 1, b = 1, a = 0.8 },
    },
    frame = {
        width = 1000,
        height = 38,
        background_color = { r = 0, g = 0, b = 0, a = 0.8 },
        position = {
            x = 0,
            y = -400,
            point = "TOP",
            relative_point = "TOP",
        },
    },
    health = {
        font = FONT,
        font_size = 24,
        texture = {
            atlas = true,
            texture = "Interface\\TargetingFrame\\UI-StatusBar",
            atlas_texture = "Unit_Priest_Insanity_Fill",
            desaturated = false,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
        spark = {
            atlas = "Insanity-Spark",
            color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
            blend_mode = "BLEND",
            width = 4,
        },
    },
    name = {
        font = FONT,
        font_size = 32,
        color = { r = 1, g = 1, b = 1, a = 1 },
    },
    power = {
        enabled = false,
        font = FONT,
        font_size = 16,
        color = { r = 1, g = 1, b = 1, a = 1 },
    },
    accents = {
        enabled = true,
        copy_healthbar_texture_color = true,
        color = { r = 70/255, g = 34/255, b = 106/255, a = 1 },
    }
}

RPGBB.db = {}

-- RPGBB.db.Get("health", "texture", "atlas") -> returns value or default
RPGBB.db.Get = function(...)
    local keys = { ... }

    -- Ensure db is loaded
    RPGBossBarDB = RPGBossBarDB or {}

    -- Traverse the db
    local db_value = RPGBossBarDB
    for _, key in ipairs(keys) do
        if type(db_value) ~= "table" then
            db_value = nil
            break
        end

        db_value = db_value[key]
    end

    -- If found in db, return it
    if db_value ~= nil then
        return db_value
    end

    -- Fall back to default_settings
    local default_value = default_settings
    for _, key in ipairs(keys) do
        if type(default_value) ~= "table" then
            return nil
        end
        default_value = default_value[key]
    end

    return default_value
end

-- RPGBB.db.get("health", "texture", "atlas") -> returns value or default
RPGBB.db.GetColor = function(...)
    color = RPGBB.db.Get(...)

    if type(color) == "table" and color.r and color.g and color.b and color.a then
        return color.r, color.g, color.b, color.a
    else
        print("ERROR! RPGBB: GetColor: did not return a color object")
        return 1, 1, 1, 1
    end
end
