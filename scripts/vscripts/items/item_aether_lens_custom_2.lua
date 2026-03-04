LinkLuaModifier("modifier_item_aether_lens_custom_2", "items/item_aether_lens_custom_2", LUA_MODIFIER_MOTION_NONE)

item_aether_lens_custom_2 = class({})

function item_aether_lens_custom_2:GetIntrinsicModifierName()
    return "modifier_item_aether_lens_custom_2"
end

--------------------------------------------------------------------------------
-- PASSIVO (Stats Dobrados)
--------------------------------------------------------------------------------
modifier_item_aether_lens_custom_2 = class({})

function modifier_item_aether_lens_custom_2:IsHidden() return true end
function modifier_item_aether_lens_custom_2:IsPurgable() return false end
function modifier_item_aether_lens_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_aether_lens_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING, -- Cast Range que acumula
    }
end

function modifier_item_aether_lens_custom_2:GetModifierManaBonus()
    return 600 -- 300 x 2
end

function modifier_item_aether_lens_custom_2:GetModifierConstantManaRegen()
    return 5.0 -- 2.5 x 2
end

function modifier_item_aether_lens_custom_2:GetModifierCastRangeBonusStacking()
    return 450 -- 225 x 2
end