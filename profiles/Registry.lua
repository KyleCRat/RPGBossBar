local ADDON_NAME, RPGBB = ...

RPGBB.default_skins = RPGBB.default_skins or {}
RPGBB.default_skin_order = RPGBB.default_skin_order or {}

local function DeepMerge(dest, src)
    for key, value in pairs(src) do
        if type(value) == "table" and type(dest[key]) == "table" then
            DeepMerge(dest[key], value)
        else
            dest[key] = type(value) == "table" and CopyTable(value) or value
        end
    end
end

local function ReplaceTable(dest, src)
    wipe(dest)

    for key, value in pairs(src) do
        dest[key] = type(value) == "table" and CopyTable(value) or value
    end
end

function RPGBB:RegisterDefaultSkin(skin)
    if type(skin) ~= "table"
        or type(skin.id) ~= "string"
        or type(skin.name) ~= "string"
        or type(skin.overrides) ~= "table" then
        error("RPGBB:RegisterDefaultSkin requires id, name, and overrides", 2)
    end

    if not RPGBB.default_skins[skin.id] then
        RPGBB.default_skin_order[#RPGBB.default_skin_order + 1] = skin.id
    end

    RPGBB.default_skins[skin.id] = skin
end

function RPGBB:GetDefaultSkin(id)
    return RPGBB.default_skins[id]
end

function RPGBB:GetDefaultSkinList()
    local skins = {}

    for _, id in ipairs(RPGBB.default_skin_order) do
        local skin = RPGBB.default_skins[id]
        if skin then
            skins[#skins + 1] = skin
        end
    end

    return skins
end

function RPGBB:GetFirstDefaultSkinID()
    return RPGBB.default_skin_order[1]
end

function RPGBB:BuildProfileFromDefaultSkin(skinID)
    local profile = CopyTable(RPGBB.db_defaults)
    local skin = RPGBB:GetDefaultSkin(skinID)

    if skin then
        DeepMerge(profile, skin.overrides)
    end

    return profile
end

function RPGBB:ApplyDefaultSkinToProfile(profileName, skinID)
    local profile = RPGBossBarProfiles.profiles[profileName]
    local skin = RPGBB:GetDefaultSkin(skinID)

    if not profile or not skin then
        return false
    end

    DeepMerge(profile, skin.overrides)

    RPGBossBarProfiles.profileMeta = RPGBossBarProfiles.profileMeta or {}
    RPGBossBarProfiles.profileMeta[profileName] = RPGBossBarProfiles.profileMeta[profileName] or {}
    RPGBossBarProfiles.profileMeta[profileName].defaultSkin = skinID

    return true
end

function RPGBB:CreateProfileFromDefaultSkin(skinID, profileName)
    if not profileName or profileName == "" then
        return false
    end

    if RPGBossBarProfiles.profiles[profileName] then
        return false
    end

    local skin = RPGBB:GetDefaultSkin(skinID)
    if not skin then
        return false
    end

    RPGBossBarProfiles.profiles[profileName] = RPGBB:BuildProfileFromDefaultSkin(skinID)

    RPGBossBarProfiles.profileMeta = RPGBossBarProfiles.profileMeta or {}
    RPGBossBarProfiles.profileMeta[profileName] = {
        defaultSkin = skinID,
    }

    return true
end

function RPGBB:ResetProfileToDefaults(profileName)
    local profile = RPGBossBarProfiles.profiles[profileName]
    if not profile then
        return false
    end

    local profileMeta = RPGBossBarProfiles.profileMeta and RPGBossBarProfiles.profileMeta[profileName]
    local skinID = profileMeta and profileMeta.defaultSkin
    local resetProfile

    if skinID and RPGBB:GetDefaultSkin(skinID) then
        resetProfile = RPGBB:BuildProfileFromDefaultSkin(skinID)
    else
        resetProfile = CopyTable(RPGBB.db_defaults)
        if profileMeta then
            profileMeta.defaultSkin = nil
        end
    end

    ReplaceTable(profile, resetProfile)

    if profileName == RPGBB.GetActiveProfileKey() then
        RPGBB.db:SetData(profile)
    end

    return true
end

function RPGBB:ResetActiveProfile()
    return RPGBB:ResetProfileToDefaults(RPGBB.GetActiveProfileKey())
end
