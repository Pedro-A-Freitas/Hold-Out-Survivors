underlord_custom_abyssal_retribution = class({})
LinkLuaModifier("modifier_underlord_custom_abyssal_retribution", "abilities/underlord_custom_abyssal_retribution.lua", LUA_MODIFIER_MOTION_NONE)

-- Trava de Nível Hardcoded (6/12/18)
function underlord_custom_abyssal_retribution:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999 
end

function underlord_custom_abyssal_retribution:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    if nLevel > 3 then
        self:SetLevel(3)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        return
    end

    local requiredLevel = (nLevel == 1 and 6) or (nLevel == 2 and 12) or (nLevel == 3 and 18) or 0
    if caster:GetLevel() < requiredLevel then
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

function underlord_custom_abyssal_retribution:OnSpellStart()
    local caster = self:GetCaster()
    local level = self:GetLevel()
    
    -- VALORES HARDCODED (Não lê do KV)
    local duration_table = {3.0, 4.0, 5.0}
    local duration = duration_table[level] or 3.0
    local radius = 300 

    -- Som e Partícula para feedback instantâneo
    caster:EmitSound("Hero_AbyssalUnderlord.DarkPortal.Cast")
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abyssal_underlord/abyssal_underlord_dark_rift_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(pfx)

    -- Forçar ataque nos inimigos próximos
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        enemy:SetForceAttackTarget(caster)
        enemy:MoveToTargetToAttack(caster)
    end

    -- Aplica o Modificador
    caster:AddNewModifier(caster, self, "modifier_underlord_custom_abyssal_retribution", { duration = duration })
end

--------------------------------------------------------------------------------
modifier_underlord_custom_abyssal_retribution = class({})

function modifier_underlord_custom_abyssal_retribution:IsHidden() return false end
function modifier_underlord_custom_abyssal_retribution:IsPurgable() return false end

function modifier_underlord_custom_abyssal_retribution:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    -- Trava de Silêncio e Desarmar (Hardcoded)
    if not self:GetParent():HasScepter() then
        state[MODIFIER_STATE_DISARMED] = true
        state[MODIFIER_STATE_SILENCED] = true
    end

    return state
end

function modifier_underlord_custom_abyssal_retribution:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

-- Imunidade Total Hardcoded
function modifier_underlord_custom_abyssal_retribution:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_underlord_custom_abyssal_retribution:GetAbsoluteNoDamageMagical() return 1 end
function modifier_underlord_custom_abyssal_retribution:GetAbsoluteNoDamagePure() return 1 end

function modifier_underlord_custom_abyssal_retribution:OnTakeDamage(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    if params.attacker == self:GetParent() or params.attacker:IsBuilding() then return end

    -- Reflexo 100% Puro Hardcoded
    ApplyDamage({
        victim = params.attacker,
        attacker = self:GetParent(),
        damage = params.original_damage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self:GetAbility()
    })

    -- Efeito de Blade Mail no atacante
    local pfx_reflect = ParticleManager:CreateParticle("particles/items_fx/blademail_vfx.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
    ParticleManager:ReleaseParticleIndex(pfx_reflect)
end

function modifier_underlord_custom_abyssal_retribution:OnDestroy()
    if not IsServer() then return end
    -- Limpa o comando de ataque forçado
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    for _, enemy in pairs(enemies) do
        enemy:SetForceAttackTarget(nil)
    end
end