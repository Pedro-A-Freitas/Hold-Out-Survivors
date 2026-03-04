rubick_dagon_custom = class({})

function rubick_dagon_custom:GetMaxLevel()
    return 3
end

-- TRAVA DE NÍVEL DE ULTIMATE (6/12/18)
function rubick_dagon_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999 
end

function rubick_dagon_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()

    if nLevel > 3 then
        self:SetLevel(3)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        return
    end

    local heroLevel = caster:GetLevel()
    local requiredLevel = (nLevel == 1 and 6) or (nLevel == 2 and 12) or (nLevel == 3 and 18) or 0
    if heroLevel < requiredLevel then
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

function rubick_dagon_custom:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local level = self:GetLevel()

    if not target or target:IsNull() or target:IsInvulnerable() then return end
    if target:TriggerSpellAbsorb(self) then return end

    -- Tabela de dano original
    local damageTable = {400, 700, 1000}
    local damage = damageTable[level] or 400

    -- 1º RAIO (O que já existia)
    self:ShootDagon(caster, target, damage, Vector(0, 255, 0)) -- Verde

    -- --- LÓGICA DO AGHANIM ---
    if caster:HasScepter() then
        -- Criamos um "pensamento" no herói para disparar o 2º raio após 0.5 segundos
        caster:SetContextThink(DoUniqueString("dagon_double"), function()
            -- Verificamos se o alvo ainda existe e está vivo após o delay
            if target and not target:IsNull() and target:IsAlive() then
                -- 2º RAIO (Mesmo dano)
                self:ShootDagon(caster, target, damage, Vector(255, 255, 255)) -- Branco para diferenciar
            end
            return nil -- Importante: nil faz o cronômetro parar
        end, 0.5)
    end
end

-- Função auxiliar para não repetir código de partícula e dano
function rubick_dagon_custom:ShootDagon(caster, target, damage, color)
    -- Efeito Visual
    local pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(pfx, 2, color) 
    ParticleManager:ReleaseParticleIndex(pfx)

    target:EmitSound("Item.Dagon.Target")

    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    })
end