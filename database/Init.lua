local ADDON_NAME, RPGBB = ...

local LibSimpleDB = LibStub('LibSimpleDB-1.0')

function RPGBB.InitializeDB()
    RPGBB.MigrateOldDB()

    RPGBossBarProfiles = RPGBossBarProfiles or {}
    RPGBossBarProfiles.profileKeys = RPGBossBarProfiles.profileKeys or {}
    RPGBossBarProfiles.profiles = RPGBossBarProfiles.profiles or {}
    RPGBossBarProfiles.profileMeta = RPGBossBarProfiles.profileMeta or {}
    RPGBossBarProfiles.accountMeta = RPGBossBarProfiles.accountMeta or {}

    local profileKey = RPGBB.GetActiveProfileKey()
    RPGBossBarProfiles.profiles[profileKey] = RPGBossBarProfiles.profiles[profileKey] or {}

    RPGBB.db = LibSimpleDB:New(RPGBossBarProfiles.profiles[profileKey], RPGBB.db_defaults)
end

function RPGBB.GetCharKey()
    return UnitName("player") .. " - " .. GetRealmName()
end

function RPGBB.GetActiveProfileKey()
    local charKey = RPGBB.GetCharKey()

    return RPGBossBarProfiles.profileKeys[charKey] or "Default"
end

function RPGBB.SetActiveProfile(profileKey)
    local charKey = RPGBB.GetCharKey()
    RPGBossBarProfiles.profileKeys[charKey] = profileKey
    RPGBossBarProfiles.profiles[profileKey] = RPGBossBarProfiles.profiles[profileKey] or {}

    RPGBB.db:SetData(RPGBossBarProfiles.profiles[profileKey])
end

function RPGBB.GetProfileList()
    local profiles = {}
    for name in pairs(RPGBossBarProfiles.profiles) do
        profiles[#profiles + 1] = name
    end
    table.sort(profiles)

    return profiles
end

function RPGBB.CreateProfile(name)
    if not name or name == "" then
        return false
    end

    if RPGBossBarProfiles.profiles[name] then
        return false
    end

    RPGBossBarProfiles.profiles[name] = {}
    RPGBossBarProfiles.profileMeta[name] = nil

    return true
end

function RPGBB.DeleteProfile(name)
    if not name or not RPGBossBarProfiles.profiles[name] then
        return false
    end

    if name == RPGBB.GetActiveProfileKey() then
        return false
    end

    RPGBossBarProfiles.profiles[name] = nil
    RPGBossBarProfiles.profileMeta[name] = nil

    for charKey, profileKey in pairs(RPGBossBarProfiles.profileKeys) do
        if profileKey == name then
            RPGBossBarProfiles.profileKeys[charKey] = "Default"
        end
    end

    return true
end

function RPGBB.RenameProfile(oldName, newName)
    if not oldName or not newName or newName == "" then
        return false
    end

    if not RPGBossBarProfiles.profiles[oldName] then
        return false
    end

    if RPGBossBarProfiles.profiles[newName] then
        return false
    end

    RPGBossBarProfiles.profiles[newName] = RPGBossBarProfiles.profiles[oldName]
    RPGBossBarProfiles.profiles[oldName] = nil
    RPGBossBarProfiles.profileMeta[newName] = RPGBossBarProfiles.profileMeta[oldName]
    RPGBossBarProfiles.profileMeta[oldName] = nil

    for charKey, profileKey in pairs(RPGBossBarProfiles.profileKeys) do
        if profileKey == oldName then
            RPGBossBarProfiles.profileKeys[charKey] = newName
        end
    end

    return true
end

function RPGBB.CopyProfile(sourceName)
    local source = RPGBossBarProfiles.profiles[sourceName]
    if not source then
        return false
    end

    local activeKey = RPGBB.GetActiveProfileKey()
    local dest = RPGBossBarProfiles.profiles[activeKey]
    wipe(dest)

    for k, v in pairs(source) do
        if type(v) == "table" then
            dest[k] = CopyTable(v)
        else
            dest[k] = v
        end
    end

    if RPGBossBarProfiles.profileMeta[sourceName] then
        RPGBossBarProfiles.profileMeta[activeKey] = CopyTable(RPGBossBarProfiles.profileMeta[sourceName])
    else
        RPGBossBarProfiles.profileMeta[activeKey] = nil
    end

    return true
end

-------------------------------------------------------------------------------
--- Migration from old saved variable format
-------------------------------------------------------------------------------
-- Old TOC had:
--   ## SavedVariablesPerCharacter: RPGBossBarDB    (per-character settings)
--   ## SavedVariables: RPGBossBarGlobalDB          (shared "global" profile)
--
-- New TOC has:
--   ## SavedVariables: RPGBossBarProfiles, RPGBossBarGlobalDB
--   ## SavedVariablesPerCharacter: RPGBossBarDB
--
-- We keep the old names so WoW still loads old data from disk.
-- RPGBossBarDB (per-char) and RPGBossBarGlobalDB (account-wide) are preserved
-- in the TOC purely for migration. After migration they are wiped.
-- RPGBossBarProfiles is the new account-wide profile store.
--
-- Each character that logs in after the upgrade will migrate their own
-- per-character RPGBossBarDB into a profile named after them.

function RPGBB.MigrateOldDB()
    RPGBossBarProfiles = RPGBossBarProfiles or {}

    -- Already migrated if profileKeys exists
    if RPGBossBarProfiles.profileKeys then
        -- Still check if this character has un-migrated per-char data
        RPGBB.MigrateCharacterDB()

        return
    end

    -- First-ever migration: set up the new structure
    RPGBossBarProfiles.profileKeys = {}
    RPGBossBarProfiles.profiles = {}
    RPGBossBarProfiles.profileMeta = {}
    RPGBossBarProfiles.accountMeta = {}

    -- Migrate old global data into "Global" profile
    if RPGBossBarGlobalDB and next(RPGBossBarGlobalDB) then
        local globalData = {}
        for k, v in pairs(RPGBossBarGlobalDB) do
            globalData[k] = v
        end
        RPGBossBarProfiles.profiles["Global"] = globalData
        wipe(RPGBossBarGlobalDB)
    end

    -- Migrate this character's per-char data
    RPGBB.MigrateCharacterDB()
end

function RPGBB.MigrateCharacterDB()
    local sv = RPGBossBarDB
    if not sv or not next(sv) then
        return
    end

    -- If the per-char DB has a "global" key, it's old-format data
    -- (new format never writes to RPGBossBarDB)
    local hasOldData = false
    for k in pairs(sv) do
        if k ~= "global" then
            hasOldData = true
            break
        end
    end

    if not hasOldData then
        wipe(sv)

        return
    end

    local charKey = UnitName("player") .. " - " .. GetRealmName()
    local wasGlobal = sv.global

    -- Collect old settings (everything except the "global" flag)
    local charData = {}
    for k, v in pairs(sv) do
        if k ~= "global" then
            charData[k] = v
        end
    end

    -- Store as a profile named after the character
    RPGBossBarProfiles.profiles[charKey] = charData

    -- Point this character to their migrated profile
    -- Unless they were using global mode
    if wasGlobal and RPGBossBarProfiles.profiles["Global"] then
        RPGBossBarProfiles.profileKeys[charKey] = "Global"
    else
        RPGBossBarProfiles.profileKeys[charKey] = charKey
    end

    -- Clear old per-char data so it won't migrate again
    wipe(sv)
end
