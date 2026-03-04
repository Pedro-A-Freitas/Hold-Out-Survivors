LinkLuaModifier("modifier_item_sange_and_yasha_custom_2", "items/item_sange_and_yasha_custom_2", LUA_MODIFIER_MOTION_NONE)

item_sange_and_yasha_custom_2 = class({})

function item_sange_and_yasha_custom_2:GetIntrinsicModifierName()
    return "modifier_item_sange_and_yasha_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_sange_and_yasha_custom_2 = class({})

function modifier_item_sange_and_yasha_custom_2:IsHidden() return true end
function modifier_item_sange_and_yasha_custom_2:IsPurgable() return false end
function modifier_item_sange_and_yasha_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_sange_and_yasha_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFICATION,
        MODIFIER_PROPERTY_SLOW_RESISTANCE_STACKING,
    }
end

-- Stats Dobrados (2x)
function modifier_item_sange_and_yasha_custom_2:GetModifierBonusStats_Strength() return 32 end
function modifier_item_sange_and_yasha_custom_2:GetModifierBonusStats_Agility() return 32 end
function modifier_item_sange_and_yasha_custom_2:GetModifierStatusResistanceStacking() return 30 end -- 15% * 2
function modifier_item_sange_and_yasha_custom_2:GetModifierAttackSpeedBonus_Constant() return 40 end
function modifier_item_sange_and_yasha_custom_2:GetModifierMoveSpeedBonus_Percentage() return 24 end
function modifier_item_sange_and_yasha_custom_2:GetModifierHPRegenAmplification() return 40 end -- 20% * 2
function modifier_item_sange_and_yasha_custom_2:GetModifierSlowResistanceStacking() return 50 end -- 25% * 2