skywrath_mystic_flare_custom = class({})

-- Link do Modifier de Dano (vamos criar ele lá embaixo)
LinkLuaModifier("modifier_skywrath_mystic_flare_lua_thinker", "abilities/skywrath_mystic_flare_custom", LUA_MODIFIER_MOTION_NONE)

-- TRAVA DE NÍVEL (IGUAL A DA LEGION)
function skywrath_mystic_flare_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 99
end

function skywrath_mystic_flare_custom:OnUpgrade()
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

-- LÓGICA AO CONJURAR
function skywrath_mystic_flare_custom:OnSpellStart()
    local caster = self:GetCaster()
    local target_point = self:GetCursorPosition()
    
    -- Dispara a Ult Principal
    self:CreateFlareInstance(target_point)

    -- AGHANIM: Se tiver Cetro, procura outro alvo num raio de 700
    if caster:HasScepter() then
        local extra_targets = FindUnitsInRadius(
            caster:GetTeamNumber(),
            target_point,
            nil,
            700,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
            FIND_ANY_ORDER,
            false
        )

        for _, unit in pairs(extra_targets) do
            -- Se o inimigo estiver fora da área da primeira ult, taca a segunda nele
            if (unit:GetAbsOrigin() - target_point):Length2D() > 150 then
                self:CreateFlareInstance(unit:GetAbsOrigin())
                break -- Limita a apenas uma extra
            end
        end
    end
end

-- Função para criar o "Pensador" da Ult
function skywrath_mystic_flare_custom:CreateFlareInstance(position)
    local caster = self:GetCaster()
    
    -- Cria uma unidade invisível no chão que vai carregar o dano
    CreateModifierThinker(
        caster,
        self,
        "modifier_skywrath_mystic_flare_lua_thinker",
        { duration = 2.4 }, -- Duração da Ult
        position,
        caster:GetTeamNumber(),
        false
    )
end

--------------------------------------------------------------------------------
-- MODIFIER QUE DÁ O DANO (O "CÉREBRO" DA SKILL)
--------------------------------------------------------------------------------
modifier_skywrath_mystic_flare_lua_thinker = class({})

function modifier_skywrath_mystic_flare_lua_thinker:OnCreated()
    if not IsServer() then return end
    
    local ability = self:GetAbility()
    local level = ability:GetLevel()
    
    -- Configurações
    self.radius = 310
    self.interval = 0.1
    
    -- Dano Total
    local damage_total = 800
    if level == 2 then damage_total = 1200
    elseif level == 3 then damage_total = 1600 end
    
    -- Dano por tick (Duração total é 2.4s)
    self.damage_per_tick = (damage_total / 2.4) * self.interval

    -- Partícula
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 2.4, self.interval))
    
    -- Som
    self:GetParent():EmitSound("Hero_SkywrathMage.MysticFlare.Cast")

    -- Começa a dar dano a cada 0.1s
    self:StartIntervalThink(self.interval)
end

function modifier_skywrath_mystic_flare_lua_thinker:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local position = parent:GetAbsOrigin()

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        position,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- Pega creeps e heróis
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )

    if #enemies > 0 then
        local damage_split = self.damage_per_tick / #enemies
        for _, enemy in pairs(enemies) do
            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = damage_split,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            })
        end
    end
end

function modifier_skywrath_mystic_flare_lua_thinker:OnDestroy()
    if not IsServer() then return end
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
    end
end