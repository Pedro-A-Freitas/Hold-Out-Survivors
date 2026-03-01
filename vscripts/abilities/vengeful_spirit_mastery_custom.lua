vengeful_spirit_mastery_custom = class({})

LinkLuaModifier("modifier_vengeful_spirit_mastery_passive", "abilities/vengeful_spirit_mastery_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_spirit_mastery_armor_debuff", "abilities/vengeful_spirit_mastery_custom", LUA_MODIFIER_MOTION_NONE)

function vengeful_spirit_mastery_custom:GetIntrinsicModifierName()
    return "modifier_vengeful_spirit_mastery_passive"
end

function vengeful_spirit_mastery_custom:Spawn()
    if not IsServer() then return end
    self:SetLevel(0) -- Garante que comece zerada
end

-- Essa função força a trava visual e lógica
function vengeful_spirit_mastery_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999
end

-- Se o cara tentar upar no lvl 1 usando comando ou se o jogo "deixar", 
-- a gente remove o nível e devolve o ponto na hora.
function vengeful_spirit_mastery_custom:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local level = self:GetLevel()
    local hero_level = caster:GetLevel()

    local requirements = { [1] = 6, [2] = 12, [3] = 18 }
    local req = requirements[level]

    if req and hero_level < req then
        self:SetLevel(level - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        
        -- Mensagem na tela para o jogador entender o que houve
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "display_custom_error", { message = "Nivel 6 necessario" })
    end
end



--------------------------------------------------------------------------------
-- PASSIVA (STATUS)
--------------------------------------------------------------------------------
modifier_vengeful_spirit_mastery_passive = class({})

function modifier_vengeful_spirit_mastery_passive:IsHidden() return false end
function modifier_vengeful_spirit_mastery_passive:IsPurgable() return false end

function modifier_vengeful_spirit_mastery_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED, -- Detecta o impacto do ataque
    }
end

function modifier_vengeful_spirit_mastery_passive:GetModifierBonusStats_Agility()
    local level = self:GetAbility():GetLevel()
    return ({20, 40, 60})[level] or 0
end

function modifier_vengeful_spirit_mastery_passive:GetModifierAttackRangeBonus()
    local level = self:GetAbility():GetLevel()
    return ({100, 200, 300})[level] or 0
end

function modifier_vengeful_spirit_mastery_passive:GetModifierPreAttack_BonusDamage()
    local level = self:GetAbility():GetLevel()
    return ({30, 60, 90})[level] or 0
end

-- LOGICA DA REMOÇÃO DE ARMADURA (ESTILO DESOLATOR)
function modifier_vengeful_spirit_mastery_passive:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsBuilding() then return end -- Não reduz de prédios (opcional)

    local duration = 5.0
    params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_mastery_armor_debuff", { duration = duration })
    
    -- Efeito visual de "estilhaço" no alvo (tipo a Desolator)
    local pfx = ParticleManager:CreateParticle("particles/items_fx/desolator_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_vengeful_spirit_mastery_passive:GetTexture() return "vengefulspirit_nether_swap" end

--------------------------------------------------------------------------------
-- DEBUFF DE ARMADURA (O QUE O INIMIGO SENTE)
--------------------------------------------------------------------------------
modifier_vengeful_spirit_mastery_armor_debuff = class({})

function modifier_vengeful_spirit_mastery_armor_debuff:IsHidden() return false end
function modifier_vengeful_spirit_mastery_armor_debuff:IsDebuff() return true end

function modifier_vengeful_spirit_mastery_armor_debuff:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_vengeful_spirit_mastery_armor_debuff:GetModifierPhysicalArmorBonus()
    local level = self:GetAbility():GetLevel()
    -- Redução Fixa: -4 / -8 / -12 de Armadura
    local armor_reduction = ({4, 8, 12})[level] or 4
    return -armor_reduction
end