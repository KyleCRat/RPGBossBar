local ADDON_NAME, RPGBB = ...

local LibSimpleDB = LibStub('LibSimpleDB-1.0')

function RPGBB.InitializeDB()
    RPGBB.MigrateOldDB()

    RPGBossBarDB = RPGBossBarDB or {}
    RPGBossBarDB.profileKeys = RPGBossBarDB.profileKeys or {}
    RPGBossBarDB.profiles = RPGBossBarDB.profiles or {}

    local profileKey = RPGBB.GetActiveProfileKey()
    RPGBossBarDB.profiles[profileKey] = RPGBossBarDB.profiles[profileKey] or {}

    RPGBB.db = LibSimpleDB:New(RPGBossBarDB.profiles[profileKey], RPGBB.db_defaults)
end

function RPGBB.GetCharKey()
    return UnitName("player") .. " - " .. GetRealmName()
end

function RPGBB.GetActiveProfileKey()
    local charKey = RPGBB.GetCharKey()

    return RPGBossBarDB.profileKeys[charKey] or "Default"
end

function RPGBB.SetActiveProfile(profileKey)
    local charKey = RPGBB.GetCharKey()
    RPGBossBarDB.profileKeys[charKey] = profileKey
    RPGBossBarDB.profiles[profileKey] = RPGBossBarDB.profiles[profileKey] or {}

    RPGBB.db:SetData(RPGBossBarDB.profiles[profileKey])
end

function RPGBB.MigrateOldDB()
    local sv = RPGBossBarDB

    -- Nothing to migrate
    if not sv or sv.profileKeys then
        return
    end

    -- Old format: RPGBossBarDB held per-character data directly
    -- Old format: RPGBossBarGlobalDB held global profile data directly
    local oldCharData = {}
    local oldGlobalData = {}

    -- Collect old character data (skip the "global" flag)
    for k, v in pairs(sv) do
        if k ~= "global" then
            oldCharData[k] = v
        end
    end

    -- Collect old global data
    if RPGBossBarGlobalDB then
        for k, v in pairs(RPGBossBarGlobalDB) do
            oldGlobalData[k] = v
        end
    end

    local wasGlobal = sv.global

    -- Wipe and rebuild in new format
    wipe(sv)
    sv.profileKeys = {}
    sv.profiles = {}

    -- Migrate old character data into "Default" profile
    if next(oldCharData) then
        sv.profiles["Default"] = oldCharData
    end

    -- Migrate old global data into "Global" profile
    if next(oldGlobalData) then
        sv.profiles["Global"] = oldGlobalData
    end

    -- If the user was using global mode, point to the "Global" profile
    if wasGlobal then
        local charKey = UnitName("player") .. " - " .. GetRealmName()
        sv.profileKeys[charKey] = "Global"
    end

    -- Clean up the old global saved variable
    if RPGBossBarGlobalDB then
        wipe(RPGBossBarGlobalDB)
    end
end
