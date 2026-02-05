local ADDON_NAME, RPGBB = ...

RPGBB.db = {}

function RPGBB.db.Initialize()
    -- Initialize character and global saved variable if they don't exist
    RPGBossBarGlobalDB = RPGBossBarGlobalDB or {}
    RPGBossBarDB = RPGBossBarDB or {}
    if RPGBossBarDB.global then
        RPGBB.db.data = RPGBossBarGlobalDB
    else
        RPGBB.db.data = RPGBossBarDB
    end
end
