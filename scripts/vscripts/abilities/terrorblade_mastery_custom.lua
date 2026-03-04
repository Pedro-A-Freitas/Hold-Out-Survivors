terrorblade_mastery_custom = class({})
LinkLuaModifier("modifier_terrorblade_mastery_passive", "abilities/terrorblade_mastery_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_mastery_buff", "abilities/terrorblade_mastery_custom", LUA_MODIFIER_MOTION_NONE)

function terrorblade_mastery_custom:GetIntrinsicModifierName() return "modifier_terrorblade_mastery_passive" end

function terrorblade_mastery_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999
end

function terrorblade_mastery_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local level = self:GetLevel()
    local hero_level = caster:GetLevel()
    local requirements = { [1] = 6, [2] = 12, [3] = 18 }
    if requirements[level] and hero_level < requirements[level] then
        self:SetLevel(level - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR PAI (Fica no Terrorblade)
--------------------------------------------------------------------------------
modifier_terrorblade_mastery_passive = class({})
function modifier_terrorblade_mastery_passive:IsHidden() return true end

function modifier_terrorblade_mastery_passive:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.5) -- Checa a cada meio segundo por novas ilusões
end

function modifier_terrorblade_mastery_passive:OnIntervalThink()
    local caster = self:GetParent()
    local ability = self:GetAbility()
    
    -- Procura todas as unidades do jogador no mapa
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 0, false)

    for _, unit in pairs(units) do
        if unit:IsIllusion() and unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
            -- Se for uma ilusão minha, dou o buff de dano da Ult
            unit:AddNewModifier(caster, ability, "modifier_terrorblade_mastery_buff", {})
        end
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR DE DANO (Vai nas Ilusões)
--------------------------------------------------------------------------------
modifier_terrorblade_mastery_buff = class({})

function modifier_terrorblade_mastery_buff:DeclareFunctions()
    return { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE }
end

function modifier_terrorblade_mastery_buff:GetModifierDamageOutgoing_Percentage()
    if not self:GetAbility() then return 0 end
    local level = self:GetAbility():GetLevel()
    -- Bônus: 25% / 50% / 75%
    return ({25, 50, 75})[level] or 0
end 