local ADDON_NAME, RPGBB = ...
ADDON_ABVR = "RPGBB"

-- local RPGBBSettings = CreateFrame('frame')
local LibSharedMedia = LibStub('LibSharedMedia-3.0')

-- Register our custom font with LibSharedMedia
LibSharedMedia:Register('font', 'Metamorphous', "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf")

local LEM = LibStub('LibEditMode')

-- Available bar textures (atlas names) for future theme selection
RPGBB.atlas_textures = {
    ["Blizzard Insanity"]    = "Unit_Priest_Insanity_Fill",
    ["Blizzard Pain"]        = "_DemonHunter-DemonicPainBar",
    ["Blizzard Ebon Might"]  = "Unit_Evoker_EbonMight_Fill",
    ["Blizzard Maelstrom"]   = "Unit_Shaman_Maelstrom_Fill",
    ["Blizzard Lunar Power"] = "Unit_Druid_AstralPower_Fill",
    ["Blizzard Fury"]        = "Unit_DemonHunter_Fury_Fill",
    ["Blizzard Runic Power"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower",
    ["Blizzard Rage"]        = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage",
    ["Blizzard Mana"]        = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
    ["Blizzard Focus"]       = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus",
    ["Blizzard Energy"]      = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
}


-------------------------------------------------------------------------------
--- Listeners
-------------------------------------------------------------------------------

local function OnPositionChanged(frame, layoutName, point, x, y)
    local point, _, relative_point, x, y = frame:GetPoint()
    local uiScale = UIParent:GetScale()

    x = PixelUtil.GetNearestPixelSize(x, uiScale)
    y = PixelUtil.GetNearestPixelSize(y, uiScale)

    RPGBB.db.Set("frame", "position", "point", point)
    RPGBB.db.Set("frame", "position", "relative_point", relative_point)
    RPGBB.db.Set("frame", "position", "x", x)
    RPGBB.db.Set("frame", "position", "y", y)
end


-------------------------------------------------------------------------------
--- Settings Frame
-------------------------------------------------------------------------------
--- Health Bar Desaturated
local function health_bar_desaturated_get()
    return RPGBB.db.Get("health", "texture", "desaturated")
end

local function health_bar_desaturated_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "desaturated")
    else
        RPGBB.db.Set("health", "texture", "desaturated", value)
    end

    RPGBB:UpdateFrames()
end

health_bar_desaturated_setting = {
    name = 'Health Bar Desaturated',
    kind = LEM.SettingType.Checkbox,
    default = RPGBB.db.defaults.health.texture.desaturated,
    get = health_bar_desaturated_get,
    set = health_bar_desaturated_set,
}

-------------------------------------------------------------------------------
--- Health Bar Texture
local function health_bar_texture_get(value)
    if RPGBB.atlas_textures[value] then
        return RPGBB.db.Get("health", "texture", "atlas_texture") == RPGBB.atlas_textures[value]
    else
        texture = LibSharedMedia:Fetch('statusbar', value)
        return RPGBB.db.Get("health", "texture", "texture") == texture
    end
end

local function health_bar_texture_set(value)
    if RPGBB.atlas_textures[value] then
        RPGBB.db.Set("health", "texture", "atlas", true)
        RPGBB.db.SetDefault("health", "texture", "texture")
        RPGBB.db.Set("health", "texture", "atlas_texture", RPGBB.atlas_textures[value])
    else
        texture = LibSharedMedia:Fetch('statusbar', value)
        RPGBB.db.Set("health", "texture", "atlas", false)
        RPGBB.db.Set("health", "texture", "texture", texture)
        RPGBB.db.Set("health", "texture", "atlas_texture", false)
    end

    RPGBB.UpdateFrames()
end

local function health_bar_texture_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "atlas")
        RPGBB.db.SetDefault("health", "texture", "atlas_texture")
        RPGBB.db.SetDefault("health", "texture", "texture")

        RPGBB.UpdateFrames()
    end
end

health_bar_texture_setting = {
  name = 'Health Bar Texture',
  kind = LEM.SettingType.Dropdown,
  default = RPGBB.db.defaults.health.texture.texture,
  set = health_bar_texture_default,
  generator = function(owner, rootDescription)
    rootDescription:SetScrollMode(400)

    rootDescription:CreateTitle('Atlas Textures')
    for name, texture in pairs(RPGBB.atlas_textures) do
        rootDescription:CreateCheckbox(name, health_bar_texture_get, health_bar_texture_set, name)
    end

    rootDescription:CreateSpacer();

    rootDescription:CreateTitle('Shared Media')
    for _, name in ipairs(LibSharedMedia:List('statusbar')) do
        rootDescription:CreateCheckbox(name, health_bar_texture_get, health_bar_texture_set, name)
    end
  end,
}

-------------------------------------------------------------------------------
--- Health Bar Texture Color
local function health_bar_texture_color_get(layoutName)
    return CreateColor(RPGBB.db.GetColor("health", "texture", "color"))
end

local function health_bar_texture_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "texture", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("health", "texture", "color", { r = r, g = g, b = b, a = a } )
    end

    RPGBB.UpdateFrames()
end

health_bar_texture_color_setting = {
  name = 'Health Bar Color',
  kind = LEM.SettingType.ColorPicker,
  default = CreateColor(RPGBB.db.GetColorDefault("health", "texture", "color")),
  hasOpacity = true,
  get = health_bar_texture_color_get,
  set = health_bar_texture_color_set,
}

-------------------------------------------------------------------------------
--- Health Bar Font
local function health_bar_font_get(value)
    local font = LibSharedMedia:Fetch('font', value)
    return RPGBB.db.Get("health", "font", "font") == font
end

local function health_bar_font_set(value)
    local font = LibSharedMedia:Fetch('font', value)
    RPGBB.db.Set("health", "font", "font", font)
    RPGBB:InitOrUpdateFrame()
end

local function health_bar_font_default(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "font")

        RPGBB:InitOrUpdateFrame()
    end
end

health_bar_font_setting = {
    name = 'Health Bar Font',
    kind = LEM.SettingType.Dropdown,
    default = RPGBB.db.defaults.health.font.font,
    set = health_bar_font_default,
    generator = function(owner, rootDescription)
        rootDescription:SetScrollMode(400)

        for _, name in ipairs(LibSharedMedia:List('font')) do
            rootDescription:CreateCheckbox(name, health_bar_font_get, health_bar_font_set, name)
        end
    end,
}

-------------------------------------------------------------------------------
--- Health Bar Font Size
local function health_bar_font_size_get(layoutName)
    RPGBB.db.Get("health", "font", "size")
end

local function health_bar_font_size_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "size")
    else
        RPGBB.db.Set("health", "font", "size", value)
    end

    RPGBB:InitOrUpdateFrame()
end

health_bar_font_size_setting = {
  name = 'Health Font Size',
  kind = LEM.SettingType.Slider,
  default = RPGBB.db.defaults.health.font.size,
  get = health_bar_font_size_get,
  set = health_bar_font_size_set,
  minValue = 6,
  maxValue = 32,
  valueStep = 1,
  formatter = function(value)
    return value
  end,
}

-------------------------------------------------------------------------------
--- Health Bar Font Color
local function health_bar_font_color_get(layoutName)
    return CreateColor(RPGBB.db.GetColor("health", "font", "color"))
end

local function health_bar_font_color_set(layoutName, value, fromReset)
    if fromReset then
        RPGBB.db.SetDefault("health", "font", "color")
    else
        local r, g, b, a = value:GetRGBA()
        RPGBB.db.SetColor("health", "font", "color", { r = r, g = g, b = b, a = a } )
    end

    RPGBB:InitOrUpdateFrame()
end

health_bar_font_color_setting = {
  name = 'Health Font Color',
  kind = LEM.SettingType.ColorPicker,
  default = CreateColor(RPGBB.db.GetColorDefault("health", "font", "color")),
  hasOpacity = true,
  get = health_bar_font_color_get,
  set = health_bar_font_color_set,
}

-------------------------------------------------------------------------------
--- Health Bar Desaturated

-------------------------------------------------------------------------------
--- Health Bar Desaturated

-------------------------------------------------------------------------------
--- Health Bar Desaturated

-------------------------------------------------------------------------------
--- Health Bar Desaturated

-------------------------------------------------------------------------------
--- Health Bar Desaturated


--- Construct the settings frame

local default_position = CopyTable(RPGBB.db.defaults.frame.position)

RPGBB.frame.editModeName = 'RPG Boss Bar'
LEM:AddFrame(RPGBB.frame, OnPositionChanged, default_position)
LEM:AddFrameSettings(RPGBB.frame, {
    health_bar_texture_setting,
    health_bar_desaturated_setting,
    health_bar_texture_color_setting,
    health_bar_font_setting,
    health_bar_font_size_setting,
    health_bar_font_color_setting,
})


-------------------------------------------------------------------------------
--- Hook into and hide the Edit Mode selection label
-------------------------------------------------------------------------------

-- Hide the overlay in edit mode when selected on RPGBB
local function SetEditModeSelectionState(alpha, isLabelVisible)
  RPGBB.frame.Selection.Center:SetAlpha(alpha)
  if isLabelVisible then
    RPGBB.frame.Selection.Label:Show()
    -- Add a "Editing RPG Boss Bar" text frame?
  else
    RPGBB.frame.Selection.Label:Hide()
  end
end

RPGBB.frame.Selection:HookScript('OnLeave', function(self)
  if self.isSelected then
    SetEditModeSelectionState(0, false)
  else
    SetEditModeSelectionState(1, false)
  end
end)

LEM.internal.dialog:HookScript('OnHide', function(self)
  if not RPGBB.frame.Selection.isSelected then
    SetEditModeSelectionState(1, false)
  end
end)

LEM:RegisterCallback('enter', function()
    RPGBB:Lock(false)
end)

LEM:RegisterCallback('exit', function()
    RPGBB:Lock(true)
end)
