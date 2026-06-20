local ADDON_NAME, RPGBB = ...

local function GetAtlasInfo(atlas)
    if C_Texture and C_Texture.GetAtlasInfo then
        local ok_info, atlas_info = pcall(C_Texture.GetAtlasInfo, atlas)

        if ok_info and atlas_info then
            return atlas_info
        end
    end

    return nil
end

local function GetAtlasAspectRatio(atlas, fallback_width, fallback_height)
    local atlas_info = GetAtlasInfo(atlas)

    if atlas_info and atlas_info.width and atlas_info.height and atlas_info.height > 0 then
        return atlas_info.width / atlas_info.height
    end

    fallback_width = fallback_width or 1
    fallback_height = fallback_height or 1

    return fallback_width / fallback_height
end

local function ApplyAtlas(texture, atlas, mirror_x, mirror_y)
    if type(atlas) ~= "string" or atlas == "" then
        return false
    end

    local atlas_info = GetAtlasInfo(atlas)

    if not atlas_info then
        return false
    end

    local ok = pcall(texture.SetAtlas, texture, atlas, false, nil, true)
    if not ok then
        ok = pcall(texture.SetAtlas, texture, atlas)

        if not ok then
            return false
        end
    end

    if mirror_x or mirror_y then
        local ul_x, ul_y, bl_x, bl_y, ur_x, ur_y, br_x, br_y = texture:GetTexCoord()

        if not br_y then
            return true
        end

        if mirror_x then
            local original_ul_x, original_ul_y = ul_x, ul_y
            local original_bl_x, original_bl_y = bl_x, bl_y

            ul_x, ul_y = ur_x, ur_y
            bl_x, bl_y = br_x, br_y
            ur_x, ur_y = original_ul_x, original_ul_y
            br_x, br_y = original_bl_x, original_bl_y
        end

        if mirror_y then
            local original_ul_x, original_ul_y = ul_x, ul_y
            local original_ur_x, original_ur_y = ur_x, ur_y

            ul_x, ul_y = bl_x, bl_y
            bl_x, bl_y = original_ul_x, original_ul_y
            ur_x, ur_y = br_x, br_y
            br_x, br_y = original_ur_x, original_ur_y
        end

        texture:SetTexCoord(ul_x, ul_y, bl_x, bl_y, ur_x, ur_y, br_x, br_y)
    end

    return true
end

function RPGBB:RenderAtlasAccent(option, state, context, atlas, render_key)
    option = option or {}

    local color = context.color or { r = 1, g = 1, b = 1, a = 1 }
    local config = context.config or {}
    local is_center = context.side == "center"
    local is_right_side = context.side == "right"
    local offset_x = context.offset_x or 0
    local offset_y = context.offset_y or 0
    local scale = tonumber(config.scale) or 1
    local width_scale = tonumber(config.width_scale) or 1
    local height_scale = tonumber(config.height_scale) or 1
    local height_multiplier = option.height_multiplier or 2
    local width_multiplier = option.width_multiplier or 1
    local mirror_x = config.mirror_x or false
    local mirror_y = config.mirror_y or false
    local rotation = tonumber(config.rotation) or 0

    if state and state.render_key ~= render_key then
        RPGBB:HideAccentGroup(state)
    end

    state = state or {}
    state.render_key = render_key
    state.group_id = nil

    local base_texture_height = context.frame_height * height_multiplier * scale
    local texture_height = base_texture_height * height_scale
    local texture_width = base_texture_height
        * GetAtlasAspectRatio(atlas, option.fallback_width, option.fallback_height)
        * width_multiplier
        * width_scale

    local texture_anchor_point = "RIGHT"
    local frame_anchor_point = "LEFT"
    local anchor_offset_x = option.anchor_offset_x or 0

    if is_center then
        texture_anchor_point = "CENTER"
        frame_anchor_point = "RIGHT"
        anchor_offset_x = 0
    elseif is_right_side then
        texture_anchor_point = "LEFT"
        frame_anchor_point = "RIGHT"
    else
        anchor_offset_x = -anchor_offset_x
    end

    RPGBB:EnsureAccentFrame(state, context.parent)
    RPGBB:EnsureAccentTexture(state, "texture", "ARTWORK", 1)

    if not ApplyAtlas(state.texture, atlas, mirror_x, mirror_y) then
        RPGBB:HideAccentGroup(state)

        return state
    end

    state.frame:ClearAllPoints()
    state.frame:SetAllPoints(context.parent)
    state.frame:SetFrameLevel(context.frame_level)
    state.frame:Show()

    state.texture:ClearAllPoints()
    state.texture:SetPoint(
        texture_anchor_point,
        context.anchor,
        frame_anchor_point,
        anchor_offset_x + offset_x,
        offset_y
    )
    state.texture:SetSize(texture_width, texture_height)
    state.texture:SetDesaturated(option.desaturated and true or false)
    state.texture:Show()

    if state.texture.SetRotation then
        state.texture:SetRotation(math.rad(rotation))
    end

    if option.tint ~= false then
        state.texture:SetVertexColor(color.r, color.g, color.b, color.a)
    else
        state.texture:SetVertexColor(1, 1, 1, 1)
    end

    return state
end

RPGBB:RegisterAccentGroup({
    id = "none",
    name = "None",
    manageFrame = false,
    slots = {
        center = true,
        left = true,
        right = true,
    },
    Render = function(state)
        RPGBB:HideAccentGroup(state)
    end,
})
