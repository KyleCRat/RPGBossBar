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
--- Export
-------------------------------------------------------------------------------

local function serializeValue(value, indent)
    local t = type(value)

    if t == "string" then
        return string.format("%q", value)
    end

    if t == "number" then
        return tostring(value)
    end

    if t == "boolean" then
        return value and "true" or "false"
    end

    if t ~= "table" then
        return "nil"
    end

    local parts = {}
    local innerIndent = indent .. "    "

    -- Collect and sort keys for consistent output
    local keys = {}
    for k in pairs(value) do
        keys[#keys + 1] = k
    end
    table.sort(keys, function(a, b)
        return tostring(a) < tostring(b)
    end)

    for _, k in ipairs(keys) do
        local keyStr
        if type(k) == "string" and k:match("^[%a_][%w_]*$") then
            keyStr = k
        else
            keyStr = "[" .. string.format("%q", tostring(k)) .. "]"
        end

        parts[#parts + 1] = innerIndent .. keyStr .. " = " .. serializeValue(value[k], innerIndent) .. ","
    end

    return "{\n" .. table.concat(parts, "\n") .. "\n" .. indent .. "}"
end

local function createTextFrame(name, buttonText, onButtonClick)
    local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    frame:SetSize(500, 400)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            self:Hide()
        end
    end)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", 0, -12)
    frame.Title = title

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)

    local bottomOffset = 12
    if buttonText then
        local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        button:SetSize(120, 22)
        button:SetPoint("BOTTOM", 0, 12)
        button:SetText(buttonText)
        button:SetScript("OnClick", function() onButtonClick(frame) end)
        frame.ActionButton = button
        bottomOffset = 40
    end

    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 12, -36)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, bottomOffset)

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(GameFontHighlightSmall)
    editBox:SetWidth(scrollFrame:GetWidth() or 440)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    scrollFrame:SetScrollChild(editBox)

    frame.EditBox = editBox

    return frame
end

local exportFrame

local function showExport(profileName, data)
    if not exportFrame then
        exportFrame = createTextFrame("RPGBBExportFrame")
    end

    exportFrame.Title:SetText("Export: " .. profileName)
    exportFrame.EditBox:SetText(serializeValue(data, ""))
    exportFrame:Show()
    exportFrame.EditBox:HighlightText()
    exportFrame.EditBox:SetFocus()
end

-------------------------------------------------------------------------------
--- Import
-------------------------------------------------------------------------------

local function deserialize(str)
    if type(str) ~= "string" or str:trim() == "" then
        return nil
    end

    local func = loadstring("return " .. str)
    if not func then
        return nil
    end

    setfenv(func, {})
    local ok, result = pcall(func)
    if not ok or type(result) ~= "table" then
        return nil
    end

    return result
end

local importFrame

local function showImport()
    if not importFrame then
        importFrame = createTextFrame("RPGBBImportFrame", "Import", function(frame)
            local text = frame.EditBox:GetText()
            local data = deserialize(text)
            if not data then
                RPGBB:Print("Import failed: invalid format. Paste an exported profile table.")

                return
            end

            local activeKey = RPGBB.GetActiveProfileKey()
            local dest = RPGBossBarProfiles.profiles[activeKey]
            wipe(dest)
            for k, v in pairs(data) do
                dest[k] = v
            end

            RPGBB:Print("Imported settings into profile: " .. activeKey)
            RPGBB:InitOrUpdateFrame()
            LEM:RefreshFrameSettings(RPGBB.frame)
            frame:Hide()
        end)
    end

    local activeKey = RPGBB.GetActiveProfileKey()
    importFrame.Title:SetText("Import into: " .. activeKey)
    importFrame.EditBox:SetText("")
    importFrame:Show()
    importFrame.EditBox:SetFocus()
end

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

    ---- Import / Export
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Import / Export"))

    local exportInitializer = CreateSettingsButtonInitializer(
        "Export Active Profile", "Export",
        function()
            local active = RPGBB.GetActiveProfileKey()
            showExport(active, RPGBossBarProfiles.profiles[active])
        end,
        "Export the active profile's settings as a Lua table for sharing.",
        false
    )
    layout:AddInitializer(exportInitializer)

    local importInitializer = CreateSettingsButtonInitializer(
        "Import Into Active Profile", "Import",
        function()
            showImport()
        end,
        "Import settings into the active profile. This will overwrite current settings.",
        false
    )
    layout:AddInitializer(importInitializer)

    Settings.RegisterAddOnCategory(category)
    RPGBB.settingsCategory = category
end

function RPGBB.RefreshProfileSettings()
    -- Re-opening the category forces the dropdown options to refresh
    if RPGBB.settingsCategory then
        Settings.OpenToCategory(RPGBB.settingsCategory:GetID())
    end
end
