LinkLuaModifier("modifier_item_daedalus_custom_2", "items/item_daedalus_custom_2", LUA_MODIFIER_MOTION_NONE)

item_daedalus_custom_2 = class({})

function item_daedalus_custom_2:GetIntrinsicModifierName()
    return "modifier_item_daedalus_custom_2"
end

--------------------------------------------------------------------------------

modifier_item_daedalus_custom_2 = class({})

function modifier_item_daedalus_custom_2:IsHidden() return true end
function modifier_item_daedalus_custom_2:IsPurgable() return false end
function modifier_item_daedalus_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_daedalus_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end

function modifier_item_daedalus_custom_2:GetModifierPreAttack_BonusDamage()
    return 176
end

-- Crítico de 40% de chance para 350% de dano
function modifier_item_daedalus_custom_2:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        if RollPercentage(40) then
            -- Som de crítico original da Daedalus
            self:GetParent():EmitSound("DOTA_Item.Daedalus.Crit")
            return 350
        end
    end
end