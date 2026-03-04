LinkLuaModifier("modifier_item_bracer_custom_2", "items/item_bracer_custom_2", LUA_MODIFIER_MOTION_NONE)
item_bracer_custom_2 = class({})
function item_bracer_custom_2:GetIntrinsicModifierName() return "modifier_item_bracer_custom_2" end

modifier_item_bracer_custom_2 = class({})
function modifier_item_bracer_custom_2:IsHidden() return true end
function modifier_item_bracer_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_bracer_custom_2:DeclareFunctions()
    return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_HEALTH_BONUS}
end
function modifier_item_bracer_custom_2:GetModifierBonusStats_Strength() return 20 end
function modifier_item_bracer_custom_2:GetModifierBonusStats_Agility() return 8 end
function modifier_item_bracer_custom_2:GetModifierBonusStats_Intellect() return 8 end
function modifier_item_bracer_custom_2:GetModifierConstantHealthRegen() return 4 end
function modifier_item_bracer_custom_2:GetModifierHealthBonus() return 200 end