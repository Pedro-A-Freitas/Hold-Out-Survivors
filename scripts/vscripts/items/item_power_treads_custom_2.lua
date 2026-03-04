LinkLuaModifier("modifier_item_power_treads_custom_2", "items/item_power_treads_custom_2", LUA_MODIFIER_MOTION_NONE)

item_power_treads_custom_2 = class({})

function item_power_treads_custom_2:GetIntrinsicModifierName()
    return "modifier_item_power_treads_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO
--------------------------------------------------------------------------------
modifier_item_power_treads_custom_2 = class({})

function modifier_item_power_treads_custom_2:IsHidden() return true end
function modifier_item_power_treads_custom_2:IsPurgable() return false end
function modifier_item_power_treads_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_power_treads_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

-- Stats seguindo o padrão que funcionou na Skadi:
function modifier_item_power_treads_custom_2:GetModifierBonusStats_Strength() 
    return 20 
end

function modifier_item_power_treads_custom_2:GetModifierBonusStats_Agility() 
    return 20 
end

function modifier_item_power_treads_custom_2:GetModifierBonusStats_Intellect() 
    return 20 
end

-- Velocidades:
function modifier_item_power_treads_custom_2:GetModifierMoveSpeedBonus_Constant() 
    return 70 
end

function modifier_item_power_treads_custom_2:GetModifierAttackSpeedBonus_Constant() 
    return 50 
end