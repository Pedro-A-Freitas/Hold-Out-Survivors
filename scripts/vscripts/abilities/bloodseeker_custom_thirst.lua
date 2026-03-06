bloodseeker_custom_thirst = class({})
LinkLuaModifier("modifier_bloodseeker_custom_thirst", "abilities/bloodseeker_custom_thirst.lua", LUA_MODIFIER_MOTION_NONE)

function bloodseeker_custom_thirst:GetIntrinsicModifierName()
    return "modifier_bloodseeker_custom_thirst"
end

--------------------------------------------------------------------------------
modifier_bloodseeker_custom_thirst = class({})

function modifier_bloodseeker_custom_thirst:IsHidden() return false end
function modifier_bloodseeker_custom_thirst:IsPurgable() return false end
function modifier_bloodseeker_custom_thirst:RemoveOnDeath() return false end

function modifier_bloodseeker_custom_thirst:CheckState()
    return {
        -- True Strike permanente em todos os níveis
        [MODIFIER_STATE_CANNOT_MISS] = true,
    }
end

function modifier_bloodseeker_custom_thirst:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- BÔNUS DE MOVE SPEED (5% 10% 15% 20%)
function modifier_bloodseeker_custom_thirst:GetModifierMoveSpeedBonus_Percentage()
    if not self:GetAbility() then return 0 end
    local level = self:GetAbility():GetLevel()
    if level == 0 then return 0 end
    
    local ms_table = {5, 10, 15, 20}
    return ms_table[level] or 0
end

function modifier_bloodseeker_custom_thirst:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsBuilding() or params.target:IsOther() then return end

    local ability = self:GetAbility()
    local level = ability:GetLevel()
    if level == 0 then return end

    -- DANO MÁGICO (50 100 150 200)
    local damage_table = {50, 100, 150, 200}
    local damage_extra = damage_table[level] or 0

    -- Aplica o dano mágico
    ApplyDamage({
        victim = params.target,
        attacker = self:GetParent(),
        damage = damage_extra,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    })

    -- Feedback Visual (Número subindo na tela)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, damage_extra, nil)

    -- Sons e Partículas idênticos ao MKB que você já testou
    params.target:EmitSound("DOTA_Item.MonkeyKingBar.Target")
    local pfx = ParticleManager:CreateParticle("particles/items_fx/monkey_king_bar_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
    ParticleManager:ReleaseParticleIndex(pfx)
end