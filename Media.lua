local ADDON_NAME, RPGBB = ...

local LibSharedMedia = LibStub('LibSharedMedia-3.0')

LibSharedMedia:Register(
    'font',
    'Metamorphous',
    "Interface\\AddOns\\RPGBossBar\\media\\fonts\\Metamorphous-Regular.ttf"
)

local border_media = {
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

for _, media in ipairs(border_media) do
    LibSharedMedia:Register('border', media.name, media.path)
end
