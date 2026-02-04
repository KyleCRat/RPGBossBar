local ADDON_NAME, RPGBB = ...

RPGBB.db = {}

function RPGBB.db.Initialize()
    -- Initialize saved variable if it doesn't exist
    RPGBossBarDB = RPGBossBarDB or {}
    RPGBB.db.data = RPGBossBarDB

    -- Old version of RPGBossBarDB.lua, reset db
    if RPGBossBarDB.position then
        RPGBB:Print("Outdated / Invalid settings detected, resetting RPGBossBarDB!")
        RPGBB.db.Reset()
    end
end
