terrorblade_reflection_custom = class({})

function terrorblade_reflection_custom:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local level = ability:GetLevel()
    
    -- Pega a posição onde você clicou (igual stun da Lina)
    local target_pos = self:GetCursorPosition()
    local radius = 400 -- Raio da área de efeito (AOE)

    local duration = ({2, 3, 4, 5})[level] or 2
    local damage_pct = ({25, 35, 45, 55})[level] or 25

    -- Aumenta o efeito visual no local do clique
    local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(cast_pfx, 0, target_pos)
    ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 1, 1))
    ParticleManager:ReleaseParticleIndex(cast_pfx)

    -- Busca inimigos na área do clique
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    for _, enemy in pairs(enemies) do
        -- Cria 1 ilusão para CADA inimigo
        local illusions = CreateIllusions(caster, caster, {
            outgoing_damage = damage_pct,
            incoming_damage = 0,
            duration = duration
        }, 1, 0, false, true)

        for _, illusion in pairs(illusions) do
            illusion:SetForceAttackTarget(enemy)
            illusion:SetNeverMoveToClearSpace(true)
            illusion:SetRenderColor(150, 0, 255) -- Cor Roxa
            
            -- Lógica para sumir se o alvo morrer (opcional se tiver Timers)
            if Timers then
                Timers:CreateTimer(0.1, function()
                    if not enemy:IsAlive() or enemy:IsNull() then
                        illusion:ForceKill(false)
                        return nil
                    end
                    return 0.1
                end)
            end
        end
    end

    EmitSoundOnLocationWithCaster(target_pos, "Hero_Terrorblade.Reflection", caster)
end

-- Força o círculo azul de alcance do cursor
function terrorblade_reflection_custom:GetAOERadius()
    return 400
end

-- Força o comportamento de clicar no chão (Point Target)
function terrorblade_reflection_custom:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

-- Força o alcance da conjuração
function terrorblade_reflection_custom:GetCastRange(vLocation, hTarget)
    return 700
end