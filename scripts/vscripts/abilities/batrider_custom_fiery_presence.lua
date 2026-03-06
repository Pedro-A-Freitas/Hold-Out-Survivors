batrider_custom_fiery_presence = class({})
LinkLuaModifier("modifier_batrider_custom_fiery_presence", "abilities/batrider_custom_fiery_presence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_batrider_custom_fiery_presence_burn", "abilities/batrider_custom_fiery_presence.lua", LUA_MODIFIER_MOTION_NONE)

function batrider_custom_fiery_presence:GetIntrinsicModifierName()
    return "modifier_batrider_custom_fiery_presence"
end

-- TRAVA DE NÍVEL (6/12/18) - Igual ao seu Axe
function batrider_custom_fiery_presence:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999 
end

-- VERIFICAÇÃO FORÇADA NO UPGRADE
function batrider_custom_fiery_presence:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    local heroLevel = caster:GetLevel()
    
    if nLevel > 3 then
        self:SetLevel(3)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        return
    end

    local requiredLevel = (nLevel == 1 and 6) or (nLevel == 2 and 12) or (nLevel == 3 and 18) or 0
    if heroLevel < requiredLevel then
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

--------------------------------------------------------------------------------
-- Modificador do Herói (Aura)
modifier_batrider_custom_fiery_presence = class({})

function modifier_batrider_custom_fiery_presence:IsHidden() return false end
function modifier_batrider_custom_fiery_presence:IsPurgable() return false end

function modifier_batrider_custom_fiery_presence:IsAura() 
    return self:GetAbility():GetLevel() > 0 
end

function modifier_batrider_custom_fiery_presence:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_batrider_custom_fiery_presence:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_batrider_custom_fiery_presence:GetModifierAura() return "modifier_batrider_custom_fiery_presence_burn" end
function modifier_batrider_custom_fiery_presence:GetAuraRadius() return 600 end

--------------------------------------------------------------------------------
-- Modificador de Queimadura (0.2s)
modifier_batrider_custom_fiery_presence_burn = class({})

function modifier_batrider_custom_fiery_presence_burn:IsHidden() return false end

function modifier_batrider_custom_fiery_presence_burn:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.2)
end

function modifier_batrider_custom_fiery_presence_burn:OnIntervalThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return end
    
    local level = ability:GetLevel()
    if level == 0 then return end
    
    local damage_table = {10, 20, 30}
    local damage = damage_table[level] or 0

    if caster:HasScepter() then
        damage = damage + 10
    end

    ApplyDamage({
        victim = self:GetParent(),
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    })

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)
end