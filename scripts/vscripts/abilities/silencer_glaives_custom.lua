silencer_glaives_custom = class({})
LinkLuaModifier("modifier_silencer_glaives_custom", "abilities/silencer_glaives_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_int_stack", "abilities/silencer_glaives_custom", LUA_MODIFIER_MOTION_NONE)

function silencer_glaives_custom:GetIntrinsicModifierName()
    return "modifier_silencer_glaives_custom"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PRINCIPAL
--------------------------------------------------------------------------------
modifier_silencer_glaives_custom = class({})

function modifier_silencer_glaives_custom:IsHidden() return true end
function modifier_silencer_glaives_custom:IsPurgable() return false end

function modifier_silencer_glaives_custom:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_silencer_glaives_custom:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.attacker:IsIllusion() then return end

    local caster = self:GetParent()
    local ability = self:GetAbility()
    local target = params.target
    local level = ability:GetLevel()

    if level <= 0 then return end

    -- Verifica Auto-cast ou clique manual
    if ability:IsOwnersManaEnough() and (ability:GetAutoCastState() or caster:GetCurrentActiveAbility() == ability) then
        
        caster:SpendMana(ability:GetManaCost(-1), ability)

        -- 1. GANHO DE INT POR HIT
        local duration = ({10, 20, 30, 40})[level] or 10
        caster:AddNewModifier(caster, ability, "modifier_silencer_int_stack", {duration = duration})

        -- 2. CÁLCULO DO DANO PURO (% da INT)
        local int_pct = ({15, 35, 55, 75})[level] or 15
        
        -- BÔNUS DO AGHANIM (+25% de Int em dano)
        if caster:HasScepter() then
            int_pct = int_pct + 25
        end

        local damage = caster:GetIntellect(false) * (int_pct / 100)

        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = ability
        })

        target:EmitSound("Hero_Silencer.GlaivesOfWisdom.Damage")

        -- 3. LÓGICA DA MASTERY (BOUNCES)
        local ult = caster:FindAbilityByName("silencer_mastery_custom")
        if ult and ult:GetLevel() > 0 then
            local bounces = ({1, 2, 3})[ult:GetLevel()] or 0
            local bounce_range = 500
            local last_target = target
            local hit_units = {target}

            for i = 1, bounces do
                local enemies = FindUnitsInRadius(
                    caster:GetTeamNumber(), 
                    last_target:GetAbsOrigin(), 
                    nil, 
                    bounce_range, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
                    FIND_CLOSEST, 
                    false
                )

                local found = false
                for _, unit in pairs(enemies) do
                    local already_hit = false
                    for _, hit in pairs(hit_units) do if unit == hit then already_hit = true end end

                    if not already_hit then
                        ApplyDamage({
                            victim = unit,
                            attacker = caster,
                            damage = damage,
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = ability
                        })
                        
                        -- Partícula de Ricochete
                        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf", PATTACH_ABSORIGIN_FOLLOW, last_target)
                        ParticleManager:SetParticleControlEnt(pfx, 0, last_target, PATTACH_POINT_FOLLOW, "attach_hitloc", last_target:GetAbsOrigin(), true)
                        ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(pfx)

                        table.insert(hit_units, unit)
                        last_target = unit
                        found = true
                        break
                    end
                end
                if not found then break end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR DE STACK DE INTELIGÊNCIA
--------------------------------------------------------------------------------
modifier_silencer_int_stack = class({})

function modifier_silencer_int_stack:IsHidden() return false end
function modifier_silencer_int_stack:IsPurgable() return false end
function modifier_silencer_int_stack:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS } end
function modifier_silencer_int_stack:GetModifierBonusStats_Intellect() return self:GetStackCount() end

function modifier_silencer_int_stack:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(1)
end

function modifier_silencer_int_stack:OnRefresh()
    if not IsServer() then return end
    self:IncrementStackCount()
end