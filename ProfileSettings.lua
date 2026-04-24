local ADDON_NAME, RPGBB = ...

local LEM = LibStub('LibEditMode')

-------------------------------------------------------------------------------
--- Static Popups
-------------------------------------------------------------------------------

StaticPopupDialogs["RPGBB_CREATE_PROFILE"] = {
    text = "Enter a name for the new profile:",
    button1 = "Create",
    button2 = "Cancel",
    hasEditBox = true,
    editBoxWidth = 200,
    OnAccept = function(self)
        local name = self.EditBox:GetText():trim()
        if RPGBB.CreateProfile(name) then
            RPGBB:Print("Created profile: " .. name)
            RPGBB.RefreshProfileSettings()
        else
            RPGBB:Print("Could not create profile. Name may already exist or be empty.")
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local parent = self:GetParent()
        local name = parent.EditBox:GetText():trim()
        if RPGBB.CreateProfile(name) then
            RPGBB:Print("Created profile: " .. name)
            RPGBB.RefreshProfileSettings()
        end
        parent:Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

StaticPopupDialogs["RPGBB_DELETE_PROFILE"] = {
    text = "Delete profile \"%s\"?\n\nThis cannot be undone.",
    button1 = "Delete",
    button2 = "Cancel",
    OnAccept = function(self, profileName)
        if RPGBB.DeleteProfile(profileName) then
            RPGBB:Print("Deleted profile: " .. profileName)
            RPGBB.RefreshProfileSettings()
        else
            RPGBB:Print("Cannot delete the active profile.")
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    showAlert = true,
    preferredIndex = 3,
}

StaticPopupDialogs["RPGBB_RENAME_PROFILE"] = {
    text = "Enter a new name for profile \"%s\":",
    button1 = "Rename",
    button2 = "Cancel",
    hasEditBox = true,
    editBoxWidth = 200,
    OnAccept = function(self, oldName)
        local newName = self.EditBox:GetText():trim()
        if RPGBB.RenameProfile(oldName, newName) then
            RPGBB:Print("Renamed profile \"" .. oldName .. "\" to \"" .. newName .. "\"")
            RPGBB.RefreshProfileSettings()
            if RPGBB.activeProfileSetting then
                RPGBB.activeProfileSetting:SetValue(RPGBB.GetActiveProfileKey())
            end
        else
            RPGBB:Print("Could not rename profile. New name may already exist or be empty.")
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local parent = self:GetParent()
        local oldName = parent.data
        local newName = parent.EditBox:GetText():trim()
        if RPGBB.RenameProfile(oldName, newName) then
            RPGBB:Print("Renamed profile \"" .. oldName .. "\" to \"" .. newName .. "\"")
            RPGBB.RefreshProfileSettings()
            if RPGBB.activeProfileSetting then
                RPGBB.activeProfileSetting:SetValue(RPGBB.GetActiveProfileKey())
            end
        end
        parent:Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

StaticPopupDialogs["RPGBB_COPY_PROFILE"] = {
    text = "Copy all settings from \"%s\" into the active profile?\n\nThis will overwrite your current settings.",
    button1 = "Copy",
    button2 = "Cancel",
    OnAccept = function(self, sourceName)
        if RPGBB.CopyProfile(sourceName) then
            RPGBB:Print("Copied settings from: " .. sourceName)
            RPGBB:InitOrUpdateFrame()
            LEM:RefreshFrameSettings(RPGBB.frame)
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    showAlert = true,
    preferredIndex = 3,
}

-------------------------------------------------------------------------------
--- Blizzard Settings Panel
-------------------------------------------------------------------------------

function RPGBB.RegisterProfileSettings()
    local category, layout = Settings.RegisterVerticalLayoutCategory("RPG Boss Bar")

    ---- Active Profile
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Active Profile"))

    local function GetProfileOptions()
        local container = Settings.CreateControlTextContainer()
        for _, name in ipairs(RPGBB.GetProfileList()) do
            container:Add(name, name)
        end

        return container:GetData()
    end

    local function GetActiveProfile()
        return RPGBB.GetActiveProfileKey()
    end

    local function SetActiveProfile(value)
        RPGBB.SetActiveProfile(value)
        RPGBB:InitOrUpdateFrame()
        LEM:RefreshFrameSettings(RPGBB.frame)
        RPGBB:Print("Switched to profile: " .. value)
    end

    RPGBB.activeProfileSetting = Settings.RegisterProxySetting(
        category, "RPGBB_ACTIVE_PROFILE",
        Settings.VarType.String, "Active Profile",
        "Default", GetActiveProfile, SetActiveProfile
    )
    local activeProfileSetting = RPGBB.activeProfileSetting
    Settings.CreateDropdown(category, activeProfileSetting, GetProfileOptions,
        "Select which profile to use for this character.")

    ---- Profile Management
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Profile Management"))

    local createInitializer = CreateSettingsButtonInitializer(
        "New Profile", "Create",
        function()
            StaticPopup_Show("RPGBB_CREATE_PROFILE")
        end,
        "Create a new empty profile.",
        false
    )
    layout:AddInitializer(createInitializer)

    local copyInitializer = CreateSettingsButtonInitializer(
        "Copy From Profile", "Copy",
        function()
            local profiles = RPGBB.GetProfileList()
            local active = RPGBB.GetActiveProfileKey()

            -- Build a menu of profiles to copy from (exclude active)
            local menuFrame = MenuUtil.CreateContextMenu(UIParent, function(owner, rootDescription)
                rootDescription:CreateTitle("Copy settings from:")
                for _, name in ipairs(profiles) do
                    if name ~= active then
                        rootDescription:CreateButton(name, function()
                            StaticPopup_Show("RPGBB_COPY_PROFILE", name, nil, name)
                        end)
                    end
                end
            end)
        end,
        "Copy all settings from another profile into the active profile.",
        false
    )
    layout:AddInitializer(copyInitializer)

    local renameInitializer = CreateSettingsButtonInitializer(
        "Rename Profile", "Rename",
        function()
            local profiles = RPGBB.GetProfileList()

            local menuFrame = MenuUtil.CreateContextMenu(UIParent, function(owner, rootDescription)
                rootDescription:CreateTitle("Rename profile:")
                for _, name in ipairs(profiles) do
                    rootDescription:CreateButton(name, function()
                        StaticPopup_Show("RPGBB_RENAME_PROFILE", name, nil, name)
                    end)
                end
            end)
        end,
        "Rename a profile.",
        false
    )
    layout:AddInitializer(renameInitializer)

    local deleteInitializer = CreateSettingsButtonInitializer(
        "Delete Profile", "Delete",
        function()
            local profiles = RPGBB.GetProfileList()
            local active = RPGBB.GetActiveProfileKey()

            local menuFrame = MenuUtil.CreateContextMenu(UIParent, function(owner, rootDescription)
                rootDescription:CreateTitle("Delete profile:")
                for _, name in ipairs(profiles) do
                    if name ~= active then
                        rootDescription:CreateButton(name, function()
                            StaticPopup_Show("RPGBB_DELETE_PROFILE", name, nil, name)
                        end)
                    end
                end
            end)
        end,
        "Delete a profile. Cannot delete the active profile.",
        false
    )
    layout:AddInitializer(deleteInitializer)

    Settings.RegisterAddOnCategory(category)
    RPGBB.settingsCategory = category
end

function RPGBB.RefreshProfileSettings()
    -- Re-opening the category forces the dropdown options to refresh
    if RPGBB.settingsCategory then
        Settings.OpenToCategory(RPGBB.settingsCategory:GetID())
    end
end
