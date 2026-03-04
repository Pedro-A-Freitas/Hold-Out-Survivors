LinkLuaModifier("modifier_item_kaya_and_sange_custom_2", "items/item_kaya_and_sange_custom_2", LUA_MODIFIER_MOTION_NONE)

item_kaya_and_sange_custom_2 = class({})

function item_kaya_and_sange_custom_2:GetIntrinsicModifierName()
    return "modifier_item_kaya_and_sange_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_kaya_and_sange_custom_2 = class({})

function modifier_item_kaya_and_sange_custom_2:IsHidden() return true end
function modifier_item_kaya_and_sange_custom_2:IsPurgable() return false end
function modifier_item_kaya_and_sange_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_kaya_and_sange_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SLOW_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFICATION,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFICATION,
        MODIFIER_PROPERTY_MANA_COST_REDUCTION_PERCENTAGE,
    }
end

-- Stats Dobrados (2x)
function modifier_item_kaya_and_sange_custom_2:GetModifierBonusStats_Strength() return 32 end
function modifier_item_kaya_and_sange_custom_2:GetModifierBonusStats_Intellect() return 32 end
function modifier_item_kaya_and_sange_custom_2:GetModifierSlowResistanceStacking() return 50 end -- 25% * 2 (Imunidade a Slow!)
function modifier_item_kaya_and_sange_custom_2:GetModifierSpellAmplify_Percentage() return 24 end
function modifier_item_kaya_and_sange_custom_2:GetModifierHPRegenAmplification() return 40 end
function modifier_item_kaya_and_sange_custom_2:GetModifierManaCostReductionPercentage() return 50 end -- 25% * 2

-- Mana Regen Amp (75% - Fixo)
function modifier_item_kaya_and_sange_custom_2:GetModifierMPRegenAmplification() return 75 end