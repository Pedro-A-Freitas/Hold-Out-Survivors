LinkLuaModifier("modifier_item_skadi_custom_2", "items/item_skadi_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_custom_2_slow", "items/item_skadi_custom_2", LUA_MODIFIER_MOTION_NONE)

item_skadi_custom_2 = class({})

function item_skadi_custom_2:GetIntrinsicModifierName()
    return "modifier_item_skadi_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (STATS)
--------------------------------------------------------------------------------
modifier_item_skadi_custom_2 = class({})

function modifier_item_skadi_custom_2:IsHidden() return true end
function modifier_item_skadi_custom_2:IsPurgable() return false end
function modifier_item_skadi_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_skadi_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- Stats Dobrados (35x2 = 70)
function modifier_item_skadi_custom_2:GetModifierBonusStats_Strength() return 70 end
function modifier_item_skadi_custom_2:GetModifierBonusStats_Agility() return 70 end
function modifier_item_skadi_custom_2:GetModifierBonusStats_Intellect() return 70 end

function modifier_item_skadi_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.target:IsBuilding() then return end

    -- Aplica o Cold Attack (Slow)
    -- 3 segundos de duração para Melee e Ranged (conforme padrão simplificado)
    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_skadi_custom_2_slow", {duration = 3.0})
end

--------------------------------------------------------------------------------
-- DEBUFF: COLD ATTACK (SLOW)
--------------------------------------------------------------------------------
modifier_item_skadi_custom_2_slow = class({})

function modifier_item_skadi_custom_2_slow:IsDebuff() return true end
function modifier_item_skadi_custom_2_slow:IsPurgable() return true end

function modifier_item_skadi_custom_2_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_skadi_custom_2_slow:GetModifierMoveSpeedBonus_Percentage() return -50 end
function modifier_item_skadi_custom_2_slow:GetModifierAttackSpeedBonus_Constant() return -40 end

function modifier_item_skadi_custom_2_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_item_skadi_custom_2_slow:GetEffectName()
    return "particles/generic_gameplay/generic_slow_status.vpcf"
end