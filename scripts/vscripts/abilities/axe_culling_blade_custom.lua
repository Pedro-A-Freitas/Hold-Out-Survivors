axe_culling_blade_custom = class({})

-- Links dos Modificadores
LinkLuaModifier("modifier_axe_culling_blade_custom_buff", "abilities/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_culling_blade_armor_stack", "abilities/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE)

-- TRAVA DE NÍVEL (6/12/18) - Impede que o nível 4 seja alcançado antes da hora ou sequer exista
function axe_culling_blade_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999 -- Nível 4 bloqueado (precisaria de nível 999 do herói)
end

function axe_culling_blade_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    local heroLevel = caster:GetLevel()
    
    -- Se por algum motivo o nível for maior que 3, a gente força voltar pra 3
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

function axe_culling_blade_custom:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local level = self:GetLevel()

    if not target or target:IsInvulnerable() then return end

    -- VALORES DE EXECUÇÃO (Proteção contra nível 4: se for 4, usa os valores do 3)
    local kill_threshold = ({250, 350, 450})[level] or 450
    local damage_if_not_kill = ({150, 250, 300})[level] or 300
    
    -- QUANTIDADE DE ARMADURA (Limitada no máximo a 3)
    local armor_per_kill = level
    if armor_per_kill > 3 then armor_per_kill = 3 end

    local target_health = target:GetHealth()
    caster:EmitSound("Hero_Axe.Culling_Blade_Cast")

    if target_health <= kill_threshold then
        target:Kill(self, caster)
        
        -- RESET
        self:EndCooldown()
        self:RefundManaCost()

        -- EFEITOS VISUAIS
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)
        caster:EmitSound("Hero_Axe.Culling_Blade_Success")

        -- 1. APLICA ARMADURA PERMANENTE
        local armor_modifier = caster:FindModifierByName("modifier_axe_culling_blade_armor_stack")
        if not armor_modifier then
            armor_modifier = caster:AddNewModifier(caster, self, "modifier_axe_culling_blade_armor_stack", {})
        end
        if armor_modifier then
            armor_modifier:SetStackCount(armor_modifier:GetStackCount() + armor_per_kill)
        end

        -- 2. BÔNUS TEMPORÁRIO (VELOCIDADE)
        local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for _, ally in pairs(allies) do
            ally:AddNewModifier(caster, self, "modifier_axe_culling_blade_custom_buff", { duration = 6.0 })
        end
    else
        ApplyDamage({victim = target, attacker = caster, damage = damage_if_not_kill, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
        caster:EmitSound("Hero_Axe.Culling_Blade_Fail")
    end
end

-- Os Modificadores ficam iguais lá embaixo...
modifier_axe_culling_blade_armor_stack = class({})
function modifier_axe_culling_blade_armor_stack:IsHidden() return false end
function modifier_axe_culling_blade_armor_stack:IsPurgable() return false end
function modifier_axe_culling_blade_armor_stack:RemoveOnDeath() return false end
function modifier_axe_culling_blade_armor_stack:DeclareFunctions() return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS } end
function modifier_axe_culling_blade_armor_stack:GetModifierPhysicalArmorBonus() return self:GetStackCount() end
function modifier_axe_culling_blade_armor_stack:GetTexture() return "axe_culling_blade" end

modifier_axe_culling_blade_custom_buff = class({})
function modifier_axe_culling_blade_custom_buff:IsHidden() return false end
function modifier_axe_culling_blade_custom_buff:IsPurgable() return true end
function modifier_axe_culling_blade_custom_buff:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end
function modifier_axe_culling_blade_custom_buff:GetModifierAttackSpeedBonus_Constant() return 40 end
function modifier_axe_culling_blade_custom_buff:GetModifierMoveSpeedBonus_Percentage() return 30 end
function modifier_axe_culling_blade_custom_buff:GetEffectName() return "particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf" end