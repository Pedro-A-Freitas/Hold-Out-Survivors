LinkLuaModifier("modifier_item_heart_custom_2", "items/item_heart_custom_2", LUA_MODIFIER_MOTION_NONE)

item_heart_custom_2 = class({})

function item_heart_custom_2:GetIntrinsicModifierName()
    return "modifier_item_heart_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO
--------------------------------------------------------------------------------
modifier_item_heart_custom_2 = class({})

function modifier_item_heart_custom_2:IsHidden() return true end
function modifier_item_heart_custom_2:IsPurgable() return false end
function modifier_item_heart_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_heart_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

-- Bonus de Força Dobrado: 40 x 2 = 80
function modifier_item_heart_custom_2:GetModifierBonusStats_Strength()
    return 80
end

-- Regeneração Baseada no HP Máximo: 2.5% fixo
function modifier_item_heart_custom_2:GetModifierHealthRegenPercentage()
    return 2.5
end