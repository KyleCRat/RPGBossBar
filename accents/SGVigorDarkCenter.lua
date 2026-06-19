local ADDON_NAME, RPGBB = ...

local function Frame(state, context)
    local boss_bar_height = context.frame_height
    local color = context.color
    local width_multiplier = context.width_multiplier or 1

    -- The center divider reuses the SG Vigor frame and fill atlases, but omits
    -- the outer decor piece used by the side accents. The width multiplier keeps
    -- the divider narrower while preserving the source atlas height ratios.
    --
    -- frame: the dark metal foreground frame, source ratio 44.5w x 62.5h
    -- fill: the tintable inner fill, 50/62.5 as tall as the frame, source ratio 36w x 50h
    local vigor_frame_height = boss_bar_height * 1.8
    local vigor_frame_width = vigor_frame_height * (44.5 / 62.5) * width_multiplier

    local tint_fill_height = vigor_frame_height * (50 / 62.5)
    local tint_fill_width = tint_fill_height * (36 / 50) * width_multiplier

    if not state.frame then
        state.frame = CreateFrame("Frame", nil, context.parent)

        state.background = state.frame:CreateTexture(nil, "ARTWORK", nil, 1)
        state.background:SetAtlas("dragonriding_sgvigor_fillfull")
        state.background:SetDesaturated(true)

        state.foreground = state.frame:CreateTexture(nil, "ARTWORK", nil, 2)
        state.foreground:SetAtlas("dragonriding_sgvigor_frame_dark")
    end

    state.frame:ClearAllPoints()
    state.frame:SetAllPoints(context.parent)
    state.frame:SetFrameLevel(context.frame_level)
    state.frame:Show()

    state.foreground:ClearAllPoints()
    state.foreground:SetPoint("CENTER", context.anchor, "RIGHT", 0, 0)
    state.foreground:SetSize(vigor_frame_width, vigor_frame_height)

    state.background:ClearAllPoints()
    state.background:SetPoint("CENTER", state.foreground, "CENTER", 0, 0)
    state.background:SetSize(tint_fill_width, tint_fill_height)
    state.background:SetVertexColor(color.r, color.g, color.b, color.a)
end

RPGBB:RegisterAccentGroup({
    id = "sgvigor-dark-center",
    name = "SG Vigor Dark Center",
    slots = {
        center = true,
    },
    Render = Frame,
})
