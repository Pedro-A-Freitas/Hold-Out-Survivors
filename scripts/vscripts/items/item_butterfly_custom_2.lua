item_butterfly_custom_2 = class({})
LinkLuaModifier("modifier_item_butterfly_custom_2", "items/item_butterfly_custom_2", LUA_MODIFIER_MOTION_NONE)

function item_butterfly_custom_2:GetIntrinsicModifierName()
    return "modifier_item_butterfly_custom_2"
end

--------------------------------------------------------------------------------

modifier_item_butterfly_custom_2 = class({})

function modifier_item_butterfly_custom_2:IsHidden() return true end
function modifier_item_butterfly_custom_2:IsPurgable() return false end
function modifier_item_butterfly_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_butterfly_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,           -- +70 Agi (dobrado)
        MODIFIER_PROPERTY_EVASION_CONSTANT,              -- +45% Evasion (conforme pedido)
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,        -- +50 Dano (dobrado)
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,        -- +30% Base Attack Speed (conforme pedido)
    }
end

function modifier_item_butterfly_custom_2:GetModifierBonusStats_Agility() return 70 end
function modifier_item_butterfly_custom_2:GetModifierEvasion_Constant() return 45 end
function modifier_item_butterfly_custom_2:GetModifierPreAttack_BonusDamage() return 50 end
function modifier_item_butterfly_custom_2:GetModifierAttackSpeedPercentage() return 30 end