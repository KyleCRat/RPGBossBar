local ADDON_NAME, addon = ...

-- addon.db.Get("health", "texture", "atlas") -> returns value or default
function addon.db.Get(...)
    local keys = { ... }

    -- Ensure db is loaded
    addon.db.data = addon.db.data or {}

    -- Traverse the db
    local db_value = addon.db.data
    for _, key in ipairs(keys) do
        if type(db_value) ~= "table" then
            db_value = nil
            break
        end

        db_value = db_value[key]
    end

    -- If found in db, return it
    if db_value ~= nil then return db_value end

    -- Fall back to defaults
    local default_value = addon.db.defaults
    for _, key in ipairs(keys) do
        if type(default_value) ~= "table" then
            return nil
        end
        default_value = default_value[key]
    end

    return default_value
end

-- addon.db.GetDB("health", "texture", "atlas") -> returns value from DB
function addon.db.GetDB(...)
    local keys = { ... }

    -- Ensure db is loaded
    addon.db.data = addon.db.data or {}

    -- Traverse the db
    local db_value = addon.db.data
    for _, key in ipairs(keys) do
        if type(db_value) ~= "table" then
            db_value = nil
            break
        end

        db_value = db_value[key]
    end

    return db_value
end

-- addon.db.Set("health", "texture", "atlas", "NewAtlasName") -> sets addon.db.data.health.texture.atlas = "NewAtlasName"
function addon.db.Set(...)
    local args = { ... }
    local value = args[#args]  -- Last argument is the value

    -- Ensure db is loaded
    addon.db.data = addon.db.data or {}

    -- Traverse/create the path, stop one before the end
    local current = addon.db.data
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

function addon.db.GetColor(...)
    color = addon.db.Get(...)

    if type(color) == "table" and color.r and color.g and color.b and color.a then
        return color.r, color.g, color.b, color.a
    else
        print("ERROR! addon: GetColor: did not return a color object")
        return 1, 1, 1, 1
    end
end

-- addon.db.GetColorDefault("health", "texture", "color") -> returns default r, g, b, a
function addon.db.GetColorDefault(...)
    local keys = { ... }

    -- Traverse defaults
    local color = addon.db.defaults
    for _, key in ipairs(keys) do
        if type(color) ~= "table" then
            return 1, 1, 1, 1
        end
        color = color[key]
    end

    if type(color) == "table" and color.r and color.g and color.b and color.a then
        return color.r, color.g, color.b, color.a
    else
        print("ERROR! addon: GetColorDefault: did not return a color object")
        return 1, 1, 1, 1
    end
end

-- addon.db.SetColor("health", "texture", "color", { r = 1, g = 0, b = 0, a = 1 })
function addon.db.SetColor(...)
    local args = { ... }
    local new_color = args[#args]  -- Last argument is the color table

    -- Validate the new color
    if type(new_color) ~= "table" or not (new_color.r and new_color.g and new_color.b and new_color.a) then
        print("ERROR! addon: SetColor: invalid color object")
        return
    end

    -- Get the keys (all args except the last one)
    local keys = {}
    for i = 1, #args - 1 do
        keys[i] = args[i]
    end

    -- Get the existing color object
    local color = addon.db.GetDB(unpack(keys))


    -- If it exists, update its values
    if type(color) == "table" then
        color.r = new_color.r
        color.g = new_color.g
        color.b = new_color.b
        color.a = new_color.a
    else
        -- Create the color object if it doesn't exist
        addon.db.Set(unpack(args))
    end
end

-- addon.db.SetDefault("health", "texture", "atlas") -> sets addon.db.health.texture.atlas to default value
function addon.db.SetDefault(...)
    local keys = { ... }

    -- Get the default value
    local default_value = addon.db.defaults
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
    addon.db.Set(unpack(keys))

    return default_value
end

-- function addon.db.Toggle(...)
--     keys = { ... }
-- end

function addon.db.Reset()
    addon.db.data = {}
end
