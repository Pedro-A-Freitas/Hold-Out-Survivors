zeus_thundergods_wrath_custom = class({})

-- TRAVA DE NÍVEL (6/12/18) - O herói só consegue upar nos níveis certos
function zeus_thundergods_wrath_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 99
end

function zeus_thundergods_wrath_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    local heroLevel = caster:GetLevel()
    local requiredLevel = (nLevel == 1 and 6) or (nLevel == 2 and 12) or (nLevel == 3 and 18) or 0
    if heroLevel < requiredLevel then
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

-- LÓGICA DE QUANDO VOCÊ APERTA O BOTÃO DA SKILL
function zeus_thundergods_wrath_custom:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local level = ability:GetLevel()

    -- 1. CONFIGURAÇÃO DE DANO (Pode mudar os números aqui se quiser)
    local damage = 300
    if level == 2 then damage = 450
    elseif level == 3 then damage = 600 end

    -- 2. SOM GLOBAL (Todo mundo no mapa ouve o Zeus gritando)
    EmitGlobalSound("Hero_Zuus.GodsWrath")

    -- 3. BUSCA TODOS OS INIMIGOS NO MAPA INTEIRO (Ignora a névoa/escuro)
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        FIND_UNITS_EVERYWHERE, -- Busca no mapa todo
        DOTA_UNIT_TARGET_TEAM_ENEMY, -- Que sejam inimigos
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- Heróis e Creeps
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- Pega até quem tá imune a magia (mas o dano não pega se não for dano puro)
        0,
        false
    )

    -- 4. APLICA O RAIO EM CADA UM QUE ENCONTRAR
    for _, enemy in pairs(enemies) do
        -- FILTRO: Só entra aqui se NÃO for neutro da jungle
        if enemy:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
            
            -- Cria o raio visual caindo do céu
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, 1000))
            ParticleManager:ReleaseParticleIndex(pfx)

            -- Som do raio batendo no bicho
            enemy:EmitSound("Hero_Zuus.GodsWrath.Target")

            -- Dá o dano de verdade
            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability
            })

            -- Revela o inimigo no mapa por 3 segundos (abre a névoa em volta dele)
            AddFOWViewer(caster:GetTeamNumber(), enemy:GetAbsOrigin(), 300, 3.0, false)
        end
    end
end