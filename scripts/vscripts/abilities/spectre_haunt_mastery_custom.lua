spectre_haunt_mastery_custom = class({})
LinkLuaModifier("modifier_spectre_haunt_mastery", "abilities/spectre_haunt_mastery_custom", LUA_MODIFIER_MOTION_NONE)

function spectre_haunt_mastery_custom:GetIntrinsicModifierName()
    return "modifier_spectre_haunt_mastery"
end

-- Trava de nível 6/12/18 (Mantido como você pediu)
function spectre_haunt_mastery_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999
end

function spectre_haunt_mastery_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local level_req = {[1]=6, [2]=12, [3]=18}
    if caster:GetLevel() < (level_req[self:GetLevel()] or 0) then
        self:SetLevel(self:GetLevel() - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR DA PASSIVA
--------------------------------------------------------------------------------
modifier_spectre_haunt_mastery = class({})

function modifier_spectre_haunt_mastery:IsHidden() return true end

function modifier_spectre_haunt_mastery:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_spectre_haunt_mastery:OnAttackLanded(params)
    if not IsServer() then return end
    
    local caster = self:GetParent()
    local target = params.target
    local ability = self:GetAbility()
    local level = ability:GetLevel()

    -- Filtros de segurança
    if params.attacker ~= caster or caster:IsIllusion() or level <= 0 then return end
    if target:IsInvulnerable() or target:IsBuilding() then return end

    -- 1. LÓGICA DO AGHANIM (Dano Puro em TODOS os ataques)
    if caster:HasScepter() then
        local pure_damage = ({20, 40, 60})[level] or 20

        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = pure_damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = ability
        })

        -- Efeito visual roxo do Desolate
        local pfx_desol = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(pfx_desol)
        target:EmitSound("Hero_Spectre.Desolate")
    end

    -- 2. LÓGICA DO ATAQUE DUPLO
    -- Adicionada trava self.extra_attack_active para evitar qualquer chance de loop
    if ability:IsCooldownReady() and not params.no_attack_cooldown and not self.extra_attack_active then
        
        -- Cooldown escala: 5.0 / 3.5 / 2.0
        local cd = ({5.0, 3.5, 2.0})[level] or 5.0
        
        -- AGHANIM: Diminui o CD em 1 segundo
        if caster:HasScepter() then
            cd = math.max(cd - 1, 0.5) -- Não deixa o CD ser menor que 0.5s para não bugar
        end
        
        ability:StartCooldown(cd)

        -- Criamos um pequeno delay de 0.08s para o som e o visual do segundo hit aparecerem
        caster:SetContextThink(DoUniqueString("haunt_extra_hit"), function()
            if target and not target:IsNull() and target:IsAlive() then
                
                -- Som de ataque e visual do Haunt (Agora você vai ouvir o hit)
                target:EmitSound("Hero_Spectre.Attack")
                target:EmitSound("Hero_Spectre.HauntCast")
                
                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_haunt_appear.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                ParticleManager:ReleaseParticleIndex(pfx)

                -- Executa o ataque extra
                self.extra_attack_active = true
                caster:PerformAttack(target, true, true, true, true, false, false, false)
                self.extra_attack_active = false
            end
            return nil
        end, 0.2)
    end
end