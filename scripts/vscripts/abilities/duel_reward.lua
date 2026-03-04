duel_reward = class({})

-- 1. LINK DO MODIFICADOR DE STACKS (DANO PERMANENTE)
LinkLuaModifier("modifier_duel_reward_buff", "abilities/duel_reward", LUA_MODIFIER_MOTION_NONE)

-- 2. TRAVA DE NÍVEL (IGUAL DA LEGION ORIGINAL)
function duel_reward:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 99
end

function duel_reward:OnUpgrade()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    local heroLevel = caster:GetLevel()
    local requiredLevel = (nLevel == 1 and 6) or (nLevel == 2 and 12) or (nLevel == 3 and 18) or 0
    
    if heroLevel < requiredLevel then
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        EmitSoundOnClient("General.CastFail_InvalidTarget_Unit", caster:GetPlayerOwner())
    end
end

-- 3. LÓGICA AO USAR A SKILL
function duel_reward:OnSpellStart()
    local caster = self:GetCaster()
    local level = self:GetLevel()
    
    -- Dano base por nível: 10 / 20 / 30
    local damage_gain = 0
    if level == 1 then damage_gain = 10
    elseif level == 2 then damage_gain = 20
    elseif level == 3 then damage_gain = 30
    end

    -- BÔNUS DO AGHANIM: +10 em qualquer nível
    if caster:HasScepter() then
        damage_gain = damage_gain + 10
    end

    -- Aplica ou atualiza o Buff de Dano Permanente
    local modifier = caster:FindModifierByName("modifier_duel_reward_buff")
    if not modifier then
        modifier = caster:AddNewModifier(caster, self, "modifier_duel_reward_buff", {})
    end

    if modifier then
        local current_stacks = modifier:GetStackCount()
        modifier:SetStackCount(current_stacks + damage_gain)
        
        -- Atualiza o ataque do herói imediatamente
        caster:CalculateStatBonus(true)
    end

    -- Efeitos Visuais e Som de Vitória
    caster:EmitSound("Hero_LegionCommander.Duel.Victory")
    local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(nFXIndex)
end

--------------------------------------------------------------------------------
-- MODIFICADOR DE ATRIBUTO (O QUE SEGURA O DANO)
--------------------------------------------------------------------------------
modifier_duel_reward_buff = class({})

function modifier_duel_reward_buff:IsHidden() return false end
function modifier_duel_reward_buff:IsPurgable() return false end
function modifier_duel_reward_buff:RemoveOnDeath() return false end -- Dano é permanente
function modifier_duel_reward_buff:AllowIllusionDuplicate() return true end

function modifier_duel_reward_buff:DeclareFunctions()
    return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_duel_reward_buff:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

-- Opcional: Mostra o efeito de vitória ao criar os primeiros stacks
function modifier_duel_reward_buff:GetTexture()
    return "legion_commander_press_the_attack"
end