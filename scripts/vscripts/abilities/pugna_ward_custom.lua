pugna_ward_custom = class({})

LinkLuaModifier("modifier_pugna_ward_attack_thinker", "abilities/pugna_ward_custom", LUA_MODIFIER_MOTION_NONE)

-- Removi a trava de nível de Ultimate (6/12/18) para ser uma skill normal (1/3/5/7 por exemplo)
function pugna_ward_custom:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local level = self:GetLevel()

    -- GARANTIA: Se o nível for bugado, ele usa pelo menos o 1
    if level < 1 then level = 1 end
    if level > 4 then level = 4 end

    local unit_name = "npc_dota_pugna_nether_ward_" .. level
    local duration = 30 

    -- Tenta criar a unidade
    local ward = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
    
    if ward then
        ward:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
        ward:AddNewModifier(caster, self, "modifier_pugna_ward_attack_thinker", {})
        caster:EmitSound("Hero_Pugna.NetherWard")
    else
        -- Se cair aqui, o erro é no NOME da unidade no KV
        print("--- ERRO CRÍTICO ---")
        print("O Jogo nao achou a unidade: " .. unit_name)
    end
end

--------------------------------------------------------------------------------
-- LÓGICA DE ATAQUE
--------------------------------------------------------------------------------
modifier_pugna_ward_attack_thinker = class({})

function modifier_pugna_ward_attack_thinker:IsHidden() return true end

function modifier_pugna_ward_attack_thinker:OnCreated()
    if not IsServer() then return end
    
    local ability = self:GetAbility()
    local level = ability:GetLevel()

    -- TABELA DE INTERVALO (Attack Rate por nível)
    local intervalTable = {1.5, 1.2, 0.9, 0.6}
    local interval = intervalTable[level] or 1.5

    self:StartIntervalThink(interval) 
end

function modifier_pugna_ward_attack_thinker:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    
    -- ALCANCE DO ATAQUE (Pode mudar para 800 ou 900 se o mapa for maior)
    local radius = 1000 
    local max_targets = 5 
    
    -- DANO POR NÍVEL (4 níveis)
    local damageTable = {60, 90, 120, 150}
    local damage = damageTable[ability:GetLevel()] or 50

    local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_ANY_ORDER,
        false
    )

    local count = 0
    for _, enemy in pairs(enemies) do
        if count < max_targets then
            -- Partícula do Raio
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
            ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(pfx)

            enemy:EmitSound("Hero_Pugna.NetherWard.Attack")

            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability
            })

            count = count + 1
        end
    end
end