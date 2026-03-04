LinkLuaModifier("modifier_item_meteor_hammer_custom_2", "items/item_meteor_hammer_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_custom_2_burn", "items/item_meteor_hammer_custom_2", LUA_MODIFIER_MOTION_NONE)

item_meteor_hammer_custom_2 = class({})

-- Propriedades Básicas
function item_meteor_hammer_custom_2:GetIntrinsicModifierName()
    return "modifier_item_meteor_hammer_custom_2"
end

function item_meteor_hammer_custom_2:GetAOERadius()
    return 400
end

function item_meteor_hammer_custom_2:GetChannelTime()
    return 1.0
end

-- Lógica do Ativo
function item_meteor_hammer_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    self.vTargetPos = point
    
    -- Partícula do canalizador
    self.pfxChannel = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.pfxChannel, 0, point)
    ParticleManager:SetParticleControl(self.pfxChannel, 1, Vector(400, 0, 0))
    
    EmitSoundOnLocationWithCaster(point, "DOTA_Item.MeteorHammer.Cast", caster)
end

function item_meteor_hammer_custom_2:OnChannelFinish(bInterrupted)
    if self.pfxChannel then
        ParticleManager:DestroyParticle(self.pfxChannel, false)
        ParticleManager:ReleaseParticleIndex(self.pfxChannel)
    end

    if bInterrupted then return end

    local caster = self:GetCaster()
    local point = self.vTargetPos
    local radius = 400
    local landing_time = 0.5

    -- Partícula do meteoro caindo
    local pfxMeteor = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfxMeteor, 0, point + Vector(0,0,1000))
    ParticleManager:SetParticleControl(pfxMeteor, 1, point)
    ParticleManager:SetParticleControl(pfxMeteor, 2, Vector(landing_time, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfxMeteor)

    EmitSoundOnLocationWithCaster(point, "DOTA_Item.MeteorHammer.Activate", caster)

    -- Delay do impacto (0.5s)
    caster:SetContextThink(DoUniqueString("meteor_impact"), function()
        EmitSoundOnLocationWithCaster(point, "DOTA_Item.MeteorHammer.Impact", caster)
        GridNav:DestroyTreesAroundPoint(point, radius, false)

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false)

        for _, enemy in pairs(enemies) do
            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = 260,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self
            })

            enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.0})
            enemy:AddNewModifier(caster, self, "modifier_item_meteor_hammer_custom_2_burn", {duration = 6.0})
        end
        return nil
    end, landing_time)
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (STATUS)
--------------------------------------------------------------------------------
modifier_item_meteor_hammer_custom_2 = class({})

function modifier_item_meteor_hammer_custom_2:IsHidden() return true end
function modifier_item_meteor_hammer_custom_2:IsPurgable() return false end
function modifier_item_meteor_hammer_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_meteor_hammer_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_meteor_hammer_custom_2:GetModifierBonusStats_Strength() return 12 end
function modifier_item_meteor_hammer_custom_2:GetModifierBonusStats_Agility() return 12 end
function modifier_item_meteor_hammer_custom_2:GetModifierBonusStats_Intellect() return 48 end
function modifier_item_meteor_hammer_custom_2:GetModifierSpellAmplify_Percentage() return 20 end
function modifier_item_meteor_hammer_custom_2:GetModifierMPRegenAmplify_Percentage() return 80 end

--------------------------------------------------------------------------------
-- MODIFICADOR DE QUEIMAÇÃO
--------------------------------------------------------------------------------
modifier_item_meteor_hammer_custom_2_burn = class({})

function modifier_item_meteor_hammer_custom_2_burn:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1.0)
end

function modifier_item_meteor_hammer_custom_2_burn:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = 100,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    })
end

function modifier_item_meteor_hammer_custom_2_burn:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_item_meteor_hammer_custom_2_burn:GetModifierMoveSpeedBonus_Percentage() return -40 end
function modifier_item_meteor_hammer_custom_2_burn:GetEffectName() return "particles/items4_fx/meteor_hammer_spell_burn.vpcf" end