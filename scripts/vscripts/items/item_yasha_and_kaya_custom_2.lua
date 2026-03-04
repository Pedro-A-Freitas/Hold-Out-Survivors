LinkLuaModifier("modifier_item_yasha_and_kaya_custom_2", "items/item_yasha_and_kaya_custom_2", LUA_MODIFIER_MOTION_NONE)

item_yasha_and_kaya_custom_2 = class({})

function item_yasha_and_kaya_custom_2:GetIntrinsicModifierName()
    return "modifier_item_yasha_and_kaya_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_yasha_and_kaya_custom_2 = class({})

function modifier_item_yasha_and_kaya_custom_2:IsHidden() return true end
function modifier_item_yasha_and_kaya_custom_2:IsPurgable() return false end
function modifier_item_yasha_and_kaya_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_yasha_and_kaya_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFICATION,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING, -- Cast Speed/Range logic
    }
end

-- Stats Dobrados (2x)
function modifier_item_yasha_and_kaya_custom_2:GetModifierBonusStats_Agility() return 32 end
function modifier_item_yasha_and_kaya_custom_2:GetModifierBonusStats_Intellect() return 32 end
function modifier_item_yasha_and_kaya_custom_2:GetModifierAttackSpeedBonus_Constant() return 40 end
function modifier_item_yasha_and_kaya_custom_2:GetModifierMoveSpeedBonus_Percentage() return 24 end
function modifier_item_yasha_and_kaya_custom_2:GetModifierSpellAmplify_Percentage() return 24 end

-- Mana Regen Amp (75% - Não mudar)
function modifier_item_yasha_and_kaya_custom_2:GetModifierMPRegenAmplification() return 75 end

-- Cast Speed (Dobrado para 50% - usando a propriedade de cast point reduction)
function modifier_item_yasha_and_kaya_custom_2:GetModifierPercentageCastPointReduction()
    return 50
end