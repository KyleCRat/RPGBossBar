local ADDON_NAME, RPGBB = ...

local LibSharedMedia = LibStub('LibSharedMedia-3.0')

-- Available bar textures (atlas names)
RPGBB.atlas_textures = {
       ["Blizzard Insanity"] = "Unit_Priest_Insanity_Fill",
           ["Blizzard Pain"] = "_DemonHunter-DemonicPainBar",
     ["Blizzard Ebon Might"] = "Unit_Evoker_EbonMight_Fill",
      ["Blizzard Maelstrom"] = "Unit_Shaman_Maelstrom_Fill",
    ["Blizzard Lunar Power"] = "Unit_Druid_AstralPower_Fill",
           ["Blizzard Fury"] = "Unit_DemonHunter_Fury_Fill",
    ["Blizzard Runic Power"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-RunicPower",
           ["Blizzard Rage"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Rage",
           ["Blizzard Mana"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Mana",
          ["Blizzard Focus"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Focus",
         ["Blizzard Energy"] = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Energy",
}

-- Available spark textures (atlas names)
RPGBB.spark_textures = {
           ["Blizzard Spark"] = "Spark",
        ["Blizzard Garrison"] = "GarrMission_EncounterBar-Spark",
        ["Blizzard Insanity"] = "Insanity-Spark",
      ["Blizzard Legionfall"] = "Legionfall_BarSpark",
           ["Blizzard XPBar"] = "XPBarAnim-OrangeSpark",
         ["Bonus Objectives"] = "bonusobjectives-bar-spark",
    ["Blizzard Honor System"] = "honorsystem-bar-spark",
}

local fonts = {
    {
        name = 'Metamorphous',
        path = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf"
    },
    {
        name = 'Comfortaa Light',
        path = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Comfortaa-Light.ttf"
    },
    {
        name = 'Comfortaa Regular',
        path = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Comfortaa-Regular.ttf"
    },
    {
        name = 'Comfortaa Bold',
        path = "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Comfortaa-Bold.ttf"
    },
}

for _, media in ipairs(fonts) do
    LibSharedMedia:Register('font', media.name, media.path)
end

local borders = {
    {
        name = "RPGBB: Vigor Bronze",
        path = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_bronze.tga",
    },
    {
        name = "RPGBB: Vigor Dark",
        path = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_dark.tga",
    },
    {
        name = "RPGBB: Vigor Gold",
        path = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_gold.tga",
    },
    {
        name = "RPGBB: Vigor Silver",
        path = "Interface\\AddOns\\RPGBossBar\\media\\art\\dragonriding_sgvigor_border_silver.tga",
    },
    {
        name = "RPGBB: Action Bar Border",
        path = "Interface\\AddOns\\RPGBossBar\\media\\art\\ActionBar-Border.tga",
    },
    {
        name = "Blizzard Arena",
        path = "Interface\\ArenaEnemyFrame\\UI-Arena-Border",
    },
    {
        name = "Blizzard Azerite",
        path = "Interface\\Tooltips\\UI-Tooltip-Border-Azerite",
    },
    {
        name = "Blizzard Corrupted",
        path = "Interface\\Tooltips\\UI-Tooltip-Border-Corrupted",
    },
    {
        name = "Blizzard LFG",
        path = "Interface\\LFGFrame\\LFGBorder",
    },
    {
        name = "Blizzard Maw",
        path = "Interface\\Tooltips\\UI-Tooltip-Border-Maw",
    },
    {
        name = "Blizzard Text Panel",
        path = "Interface\\Glues\\Common\\TextPanel-Border",
    },
    {
        name = "Blizzard Toast",
        path = "Interface\\FriendsFrame\\UI-Toast-Border",
    },
}

for _, media in ipairs(borders) do
    LibSharedMedia:Register('border', media.name, media.path)
end
