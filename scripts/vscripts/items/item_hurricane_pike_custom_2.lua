LinkLuaModifier("modifier_item_hurricane_pike_custom_2", "items/item_hurricane_pike_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hurricane_pike_custom_2_active", "items/item_hurricane_pike_custom_2", LUA_MODIFIER_MOTION_NONE)

item_hurricane_pike_custom_2 = class({})

function item_hurricane_pike_custom_2:GetIntrinsicModifierName()
    return "modifier_item_hurricane_pike_custom_2"
end

function item_hurricane_pike_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ability = self

    if target == caster or target:GetTeamNumber() == caster:GetTeamNumber() then
        -- CASO ALIADO: Empurra 600 para frente
        local push_distance = 600
        local push_duration = 0.4

        local knockback = {
            should_stun = 0,
            knockback_duration = push_duration,
            duration = push_duration,
            knockback_distance = push_distance,
            knockback_height = 0,
            center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x,
            center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y,
            center_z = caster:GetAbsOrigin().z
        }
        target:AddNewModifier(caster, ability, "modifier_knockback", knockback)
        target:EmitSound("Item.ForceStaff.Activate")
    else
        -- CASO INIMIGO: Empurra ambos 450 para trás e ganha buff
        local push_distance = 450
        local push_duration = 0.4

        -- Empurra Caster para trás
        local kb_caster = {
            should_stun = 0, knockback_duration = push_duration, duration = push_duration,
            knockback_distance = push_distance, knockback_height = 0,
            center_x = target:GetAbsOrigin().x, center_y = target:GetAbsOrigin().y, center_z = target:GetAbsOrigin().z
        }
        caster:AddNewModifier(caster, ability, "modifier_knockback", kb_caster)

        -- Empurra Inimigo para trás
        local kb_target = {
            should_stun = 0, knockback_duration = push_duration, duration = push_duration,
            knockback_distance = push_distance, knockback_height = 0,
            center_x = caster:GetAbsOrigin().x, center_y = caster:GetAbsOrigin().y, center_z = caster:GetAbsOrigin().z
        }
        target:AddNewModifier(caster, ability, "modifier_knockback", kb_target)

        -- Aplica o Buff de ataques infinitos no Caster (Apenas se for Ranged)
        if not caster:IsRangedAttacker() then return end
        caster:AddNewModifier(caster, ability, "modifier_item_hurricane_pike_custom_2_active", {duration = 6, target_entindex = target:entindex()})
        
        target:EmitSound("Item.HurricanePike.Activate")
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (STATS DOBRADOS)
--------------------------------------------------------------------------------
modifier_item_hurricane_pike_custom_2 = class({})
function modifier_item_hurricane_pike_custom_2:IsHidden() return true end
function modifier_item_hurricane_pike_custom_2:IsPurgable() return false end
function modifier_item_hurricane_pike_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hurricane_pike_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

function modifier_item_hurricane_pike_custom_2:GetModifierBonusStats_Strength() return 30 end
function modifier_item_hurricane_pike_custom_2:GetModifierBonusStats_Agility() return 40 end
function modifier_item_hurricane_pike_custom_2:GetModifierBonusStats_Intellect() return 30 end
function modifier_item_hurricane_pike_custom_2:GetModifierHealthBonus() return 400 end
function modifier_item_hurricane_pike_custom_2:GetModifierAttackRangeBonus()
    if self:GetParent():IsRangedAttacker() then return 280 end
    return 0
end

--------------------------------------------------------------------------------
-- MODIFICADOR ATIVO (ATAQUES INFINITOS E +100 ATK SPEED)
--------------------------------------------------------------------------------
modifier_item_hurricane_pike_custom_2_active = class({})
function modifier_item_hurricane_pike_custom_2_active:IsPurgable() return true end

function modifier_item_hurricane_pike_custom_2_active:OnCreated(params)
    if not IsServer() then return end
    self.target = EntIndexToHScript(params.target_entindex)
    self.attacks_left = 5
end

function modifier_item_hurricane_pike_custom_2_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSIENT_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK,
    }
end

function modifier_item_hurricane_pike_custom_2_active:GetModifierAttackSpeedBonus_Constant() return 100 end
function modifier_item_hurricane_pike_custom_2_active:GetModifierTransientAttackRangeBonus() return 999999 end

function modifier_item_hurricane_pike_custom_2_active:OnAttack(params)
    if params.attacker ~= self:GetParent() or params.target ~= self.target then return end
    self.attacks_left = self.attacks_left - 1
    if self.attacks_left <= 0 then self:Destroy() end
end