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
            y = -70,
            point = "TOP",
            relative_point = "TOP",
        },
    },
    health = {
        font = {
            font = FONT,
            size = 24,
            color = { r = 1, g = 1, b = 1, a = 1 },
        },
        texture = {
            atlas = true,
            texture = false,
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
RPGBB.db.defaults = default_settings

-- RPGBB.db.Get("health", "texture", "atlas") -> returns value or default
function RPGBB.db.Get(...)
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

-- RPGBB.db.Set("health", "texture", "atlas", "NewAtlasName") -> sets RPGBossBarDB.health.texture.atlas = "NewAtlasName"
function RPGBB.db.Set(...)
    local args = { ... }
    local value = args[#args]  -- Last argument is the value

    -- Ensure db is loaded
    if not RPGBossBarDB then
        RPGBossBarDB = {}
    end

    -- Traverse/create the path, stop one before the end
    local current = RPGBossBarDB
    for i = 1, #args - 2 do
        local key = args[i]
        if current[key] == nil then
            current[key] = {}
        end
        current = current[key]
    end

    -- Set the value at the final key
    local finalKey = args[#args - 1]
    current[finalKey] = value
end

function RPGBB.db.GetColor(...)
    color = RPGBB.db.Get(...)

    if type(color) == "table" and color.r and color.g and color.b and color.a then
        return color.r, color.g, color.b, color.a
    else
        print("ERROR! RPGBB: GetColor: did not return a color object")
        return 1, 1, 1, 1
    end
end

-- RPGBB.db.GetColorDefault("health", "texture", "color") -> returns default r, g, b, a
function RPGBB.db.GetColorDefault(...)
    local keys = { ... }

    -- Traverse default_settings
    local color = default_settings
    for _, key in ipairs(keys) do
        if type(color) ~= "table" then
            return 1, 1, 1, 1
        end
        color = color[key]
    end

    if type(color) == "table" and color.r and color.g and color.b and color.a then
        return color.r, color.g, color.b, color.a
    else
        print("ERROR! RPGBB: GetColorDefault: did not return a color object")
        return 1, 1, 1, 1
    end
end

-- RPGBB.db.SetColor("health", "texture", "color", { r = 1, g = 0, b = 0, a = 1 })
function RPGBB.db.SetColor(...)
    local args = { ... }
    local new_color = args[#args]  -- Last argument is the color table

    -- Validate the new color
    if type(new_color) ~= "table" or not (new_color.r and new_color.g and new_color.b and new_color.a) then
        print("ERROR! RPGBB: SetColor: invalid color object")
        return
    end

    -- Get the keys (all args except the last one)
    local keys = {}
    for i = 1, #args - 1 do
        keys[i] = args[i]
    end

    -- Get the existing color object
    local color = RPGBB.db.Get(unpack(keys))

    -- If it exists, update its values
    if type(color) == "table" then
        color.r = new_color.r
        color.g = new_color.g
        color.b = new_color.b
        color.a = new_color.a
    else
        -- Create the color object if it doesn't exist
        RPGBB.db.Set(unpack(args))
    end
end

-- RPGBB.db.SetDefault("health", "texture", "atlas") -> sets RPGBossBarDB.health.texture.atlas to default value
function RPGBB.db.SetDefault(...)
    local keys = { ... }

    -- Get the default value
    local default_value = default_settings
    for _, key in ipairs(keys) do
        if type(default_value) ~= "table" then
            return nil
        end
        default_value = default_value[key]
    end

    -- Deep copy if it's a table (like color objects)
    if type(default_value) == "table" then
        default_value = CopyTable(default_value)
    end

    -- Use Set to apply the default value
    keys[#keys + 1] = default_value
    RPGBB.db.Set(unpack(keys))

    return default_value
end

-- function RPGBB.db.Toggle(...)
--     keys = { ... }
-- end

function RPGBB.db.Initialize()
    RPGBossBarDB = RPGBossBarDB or {}

    -- Old version of RPGBossBarDB.lua, reset db
    if RPGBossBarDB.position then
        RPGBB:Print("Outdated / Invalid settings detected, resetting RPGBossBarDB!")
        RPGBB.db.Reset()
    end
end

function RPGBB.db.Reset()
    RPGBossBarDB = {}
end
