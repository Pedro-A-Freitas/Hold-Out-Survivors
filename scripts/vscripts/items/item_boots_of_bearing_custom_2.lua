LinkLuaModifier("modifier_item_boots_of_bearing_custom_2", "items/item_boots_of_bearing_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_boots_of_bearing_custom_2_aura", "items/item_boots_of_bearing_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_boots_of_bearing_custom_2_active", "items/item_boots_of_bearing_custom_2", LUA_MODIFIER_MOTION_NONE)

item_boots_of_bearing_custom_2 = class({})

function item_boots_of_bearing_custom_2:GetIntrinsicModifierName()
    return "modifier_item_boots_of_bearing_custom_2"
end

function item_boots_of_bearing_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local radius = 1200
    local duration = 6.0

    -- Efeito sonoro e visual original
    caster:EmitSound("Item.BootsOfBearing.Activate")
    local pfx = ParticleManager:CreateParticle("particles/items4_fx/boots_of_bearing_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)

    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    for _, ally in pairs(allies) do
        ally:AddNewModifier(caster, self, "modifier_item_boots_of_bearing_custom_2_active", {duration = duration})
    end
end

--------------------------------------------------------------------------------
-- PASSIVO (Stats + Lógica da Aura)
--------------------------------------------------------------------------------
modifier_item_boots_of_bearing_custom_2 = class({})

function modifier_item_boots_of_bearing_custom_2:IsHidden() return true end
function modifier_item_boots_of_bearing_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_boots_of_bearing_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- Alterado para Bonus Constant
    }
end

function modifier_item_boots_of_bearing_custom_2:GetModifierBonusStats_Strength() return 16 end
function modifier_item_boots_of_bearing_custom_2:GetModifierBonusStats_Intellect() return 16 end
function modifier_item_boots_of_bearing_custom_2:GetModifierConstantHealthRegen() return 36 end

-- Isso garante os 70 de velocidade flat da bota
function modifier_item_boots_of_bearing_custom_2:GetModifierMoveSpeedBonus_Constant() 
    return 70 
end

-- Configuração da Aura
function modifier_item_boots_of_bearing_custom_2:IsAura() return true end
function modifier_item_boots_of_bearing_custom_2:GetAuraRadius() return 1200 end
function modifier_item_boots_of_bearing_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_boots_of_bearing_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_boots_of_bearing_custom_2:GetModifierAura() return "modifier_item_boots_of_bearing_custom_2_aura" end

--------------------------------------------------------------------------------
-- MODIFICADOR DA AURA (Passivo Move Speed)
--------------------------------------------------------------------------------
modifier_item_boots_of_bearing_custom_2_aura = class({})
function modifier_item_boots_of_bearing_custom_2_aura:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end
function modifier_item_boots_of_bearing_custom_2_aura:GetModifierMoveSpeedBonus_Constant() return 20 end

--------------------------------------------------------------------------------
-- MODIFICADOR ATIVO (Bônus de 6s)
--------------------------------------------------------------------------------
modifier_item_boots_of_bearing_custom_2_active = class({})
function modifier_item_boots_of_bearing_custom_2_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_item_boots_of_bearing_custom_2_active:GetModifierAttackSpeedBonus_Constant() return 100 end
function modifier_item_boots_of_bearing_custom_2_active:GetModifierMoveSpeedBonus_Percentage() return 30 end
function modifier_item_boots_of_bearing_custom_2_active:GetEffectName() return "particles/items4_fx/boots_of_bearing_active_buff.vpcf" end