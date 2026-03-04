LinkLuaModifier("modifier_item_manta_custom_2", "items/item_manta_custom_2", LUA_MODIFIER_MOTION_NONE)

item_manta_custom_2 = class({})

function item_manta_custom_2:GetIntrinsicModifierName()
    return "modifier_item_manta_custom_2"
end

function item_manta_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    
    -- Efeito de som e Dispel (Remove debuffs ao usar)
    caster:EmitSound("Item.Manta.Activate")
    caster:Purge(false, true, false, false, false)

    -- Configurações das Ilusões
    local duration = 30.0
    local outgoing = 60 -- 60% de dano causado
    local incoming = 200 -- 200% de dano recebido
    
    -- Cria 2 ilusões
    local illusions = CreateIllusions(
        caster, 
        caster, 
        {
            outgoing_damage = outgoing,
            incoming_damage = incoming,
            duration = duration
        }, 
        2, 72, true, true
    )
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (STATS DOBRADOS)
--------------------------------------------------------------------------------
modifier_item_manta_custom_2 = class({})

function modifier_item_manta_custom_2:IsHidden() return true end
function modifier_item_manta_custom_2:IsPurgable() return false end
function modifier_item_manta_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_manta_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_manta_custom_2:GetModifierBonusStats_Strength() return 20 end
function modifier_item_manta_custom_2:GetModifierBonusStats_Agility() return 52 end
function modifier_item_manta_custom_2:GetModifierBonusStats_Intellect() return 20 end
function modifier_item_manta_custom_2:GetModifierAttackSpeedBonus_Constant() return 30 end
function modifier_item_manta_custom_2:GetModifierMoveSpeedBonus_Percentage() return 20 end