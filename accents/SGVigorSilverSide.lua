local ADDON_NAME, RPGBB = ...

local function Frame(state, context)
    local boss_bar_height = context.frame_height
    local color = context.color
    local is_right_side = context.side == "right"
    local offset_x = context.offset_x or 0
    local offset_y = context.offset_y or 0

    -- SG Vigor side accents are made from three atlas pieces:
    -- frame: the metal foreground frame, source ratio 44.5w x 62.5h
    -- fill: the tintable inner fill, 50/62.5 as tall as the frame, source ratio 36w x 50h
    -- decor: the outer diamond/spike accent, 75.5/62.5 as tall as the frame, source ratio 58.5w x 75.5h
    --
    -- The entire group scales from the configured boss bar height so the accent keeps
    -- its visual proportions as the bar height changes.
    local vigor_frame_height = boss_bar_height * 1.8
    local vigor_frame_width = vigor_frame_height * (44.5 / 62.5)

    local tint_fill_height = vigor_frame_height * (50 / 62.5)
    local tint_fill_width = tint_fill_height * (36 / 50)

    local decor_height = vigor_frame_height * (75.5 / 62.5)
    local decor_width = decor_height * (58.5 / 75.5)

    -- The decor piece tucks back over the metal frame instead of sitting
    -- completely outside it. It also needs a small downward nudge so the
    -- lower bevels line up with the frame artwork.
    local decor_frame_overlap_x = vigor_frame_width / 2.25
    local decor_bottom_alignment_y = -(vigor_frame_height * 0.015)

    -- The same side accent is rendered on either edge by flipping the anchor
    -- points and x offsets. The decor atlas faces the right side by default.
    -- The registry sets context.mirrored when this right-native group renders
    -- on the left side.
    local frame_anchor_point = is_right_side and "RIGHT" or "LEFT"
    local frame_anchor_offset_x = (is_right_side and 2 or -2) + offset_x
    local decor_anchor_point = is_right_side and "BOTTOMLEFT" or "BOTTOMRIGHT"
    local decor_frame_anchor_point = is_right_side and "BOTTOMRIGHT" or "BOTTOMLEFT"
    local decor_anchor_offset_x = is_right_side and -decor_frame_overlap_x or decor_frame_overlap_x

    state.foreground:ClearAllPoints()
    state.foreground:SetPoint("CENTER", context.anchor, frame_anchor_point, frame_anchor_offset_x, offset_y)
    state.foreground:SetSize(vigor_frame_width, vigor_frame_height)

    state.background:ClearAllPoints()
    state.background:SetPoint("CENTER", state.foreground, "CENTER", 0, 0)
    state.background:SetSize(tint_fill_width, tint_fill_height)
    state.background:SetVertexColor(color.r, color.g, color.b, color.a)

    state.accent:ClearAllPoints()
    state.accent:SetTexCoord(context.mirrored and 1 or 0, context.mirrored and 0 or 1, 0, 1)
    state.accent:SetPoint(
        decor_anchor_point,
        state.foreground,
        decor_frame_anchor_point,
        decor_anchor_offset_x,
        decor_bottom_alignment_y
    )
    state.accent:SetSize(decor_width, decor_height)
end

RPGBB:RegisterAccentGroup({
    id = "sgvigor-silver-side",
    name = "SG Vigor Silver",
    slots = {
        left = true,
        right = true,
    },
    mirrorable = true,
    native_side = "right",
    textures = {
        {
            key = "background",
            layer = "ARTWORK",
            sublevel = 1,
            atlas = "dragonriding_sgvigor_fillfull",
            desaturated = true,
        },
        {
            key = "foreground",
            layer = "ARTWORK",
            sublevel = 2,
            atlas = "dragonriding_sgvigor_frame_silver",
        },
        {
            key = "accent",
            layer = "ARTWORK",
            sublevel = 3,
            atlas = "dragonriding_sgvigor_decor_silver",
        },
    },
    Render = Frame,
})
