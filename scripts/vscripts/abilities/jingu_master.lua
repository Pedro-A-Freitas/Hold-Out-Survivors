jingu_master = class({})
LinkLuaModifier("modifier_jingu_master_passive", "abilities/jingu_master.lua", LUA_MODIFIER_MOTION_NONE)

function jingu_master:GetIntrinsicModifierName()
    return "modifier_jingu_master_passive"
end

--------------------------------------------------------------------------------
modifier_jingu_master_passive = class({})

function modifier_jingu_master_passive:IsHidden() return false end
function modifier_jingu_master_passive:IsPurgable() return false end
function modifier_jingu_master_passive:RemoveOnDeath() return false end

function modifier_jingu_master_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

-- DANO BLINDADO POR NÍVEL
function modifier_jingu_master_passive:GetModifierPreAttack_BonusDamage()
    if not self:GetAbility() then return 0 end
    local level = self:GetAbility():GetLevel()
    
    if level == 1 then return 25
    elseif level == 2 then return 50
    elseif level == 3 then return 75
    elseif level == 4 then return 100
    else return 0
    end
end

-- LIFESTEAL BLINDADO POR NÍVEL
function modifier_jingu_master_passive:OnAttackLanded(params)
    if not IsServer() then return end
    
    if params.attacker == self:GetParent() then
        if params.target:IsBuilding() or params.target:IsOther() then return end
        
        local level = self:GetAbility():GetLevel()
        if level == 0 then return end
        
        local lifesteal_pct = 0
        if level == 1 then lifesteal_pct = 5
        elseif level == 2 then lifesteal_pct = 10
        elseif level == 3 then lifesteal_pct = 15
        elseif level == 4 then lifesteal_pct = 20
        end

        local heal_amount = params.damage * (lifesteal_pct / 100)
        params.attacker:Heal(heal_amount, self:GetAbility())
        
        -- Efeito visual de cura
        local p = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(p)
    end
end