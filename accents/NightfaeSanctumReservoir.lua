local ADDON_NAME, RPGBB = ...

local function Frame(state, context)
    local boss_bar_height = context.frame_height
    local color = context.color or { r = 1, g = 1, b = 1, a = 1 }
    local side = context.side
    local offset_x = context.offset_x or 0
    local offset_y = context.offset_y or 0

    -- The Nightfae sanctum reservoir is a layered circular accent. All pieces use
    -- the same base size so the empty reservoir, fill, glass, glow, and motes
    -- continue to line up as the boss bar height changes.
    local center_size_multiplier = context.width_multiplier or 1
    local reservoir_size = boss_bar_height * 2.4 * center_size_multiplier
    local glow_size = reservoir_size * 1.12

    local point = "CENTER"
    local relative_point = "CENTER"

    if side == "left" then
        relative_point = "LEFT"
    elseif side == "right" then
        relative_point = "RIGHT"
    elseif side == "center" then
        relative_point = "RIGHT"
    end

    state.empty:ClearAllPoints()
    state.empty:SetPoint(point, context.anchor, relative_point, offset_x, offset_y)
    state.empty:SetSize(reservoir_size, reservoir_size)
    state.empty:SetVertexColor(1, 1, 1, 1)

    state.full:ClearAllPoints()
    state.full:SetPoint("CENTER", state.empty, "CENTER", 0, 0)
    state.full:SetSize(reservoir_size, reservoir_size)
    state.full:SetVertexColor(color.r, color.g, color.b, color.a)

    state.glass:ClearAllPoints()
    state.glass:SetPoint("CENTER", state.empty, "CENTER", 0, 0)
    state.glass:SetSize(reservoir_size, reservoir_size)
    state.glass:SetVertexColor(1, 1, 1, 1)

    state.glow:ClearAllPoints()
    state.glow:SetPoint("CENTER", state.empty, "CENTER", 0, 0)
    state.glow:SetSize(glow_size, glow_size)
    state.glow:SetBlendMode("ADD")
    state.glow:SetVertexColor(1, 1, 1, 1)

    state.speck:ClearAllPoints()
    state.speck:SetPoint("CENTER", state.empty, "CENTER", 0, 0)
    state.speck:SetSize(reservoir_size, reservoir_size)
    state.speck:SetBlendMode("ADD")
    state.speck:SetVertexColor(1, 1, 1, 1)

    state.speck2:ClearAllPoints()
    state.speck2:SetPoint("CENTER", state.empty, "CENTER", 0, 0)
    state.speck2:SetSize(reservoir_size, reservoir_size)
    state.speck2:SetBlendMode("ADD")
    state.speck2:SetVertexColor(1, 1, 1, 1)
end

RPGBB:RegisterAccentGroup({
    id = "nightfae-sanctum-reservoir",
    name = "Nightfae Sanctum Reservoir",
    slots = {
        center = true,
        left = true,
        right = true,
    },
    supportsScale = true,
    supportsRotation = true,
    supportsMirror = true,
    textures = {
        {
            key = "empty",
            layer = "ARTWORK",
            sublevel = 1,
            atlas = "CovenantSanctum-Resevoir-Empty-Nightfae",
        },
        {
            key = "full",
            layer = "ARTWORK",
            sublevel = 2,
            atlas = "CovenantSanctum-Resevoir-Full-Nightfae",
        },
        {
            key = "glass",
            layer = "ARTWORK",
            sublevel = 3,
            atlas = "CovenantSanctum-Reservoir-Idle-Nightfae-Glass",
        },
        {
            key = "glow",
            layer = "ARTWORK",
            sublevel = 4,
            atlas = "CovenantSanctum-Resevoir-Glow-Nightfae",
        },
        {
            key = "speck",
            layer = "ARTWORK",
            sublevel = 5,
            atlas = "CovenantSanctum-Reservoir-Idle-Nightfae-Speck",
        },
        {
            key = "speck2",
            layer = "ARTWORK",
            sublevel = 6,
            atlas = "CovenantSanctum-Reservoir-Idle-Nightfae-Speck2",
        },
    },
    Render = Frame,
})
