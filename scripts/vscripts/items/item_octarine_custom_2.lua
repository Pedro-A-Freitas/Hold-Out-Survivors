LinkLuaModifier("modifier_item_octarine_custom_2", "items/item_octarine_custom_2", LUA_MODIFIER_MOTION_NONE)

item_octarine_custom_2 = class({})

function item_octarine_custom_2:GetIntrinsicModifierName()
    return "modifier_item_octarine_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO
--------------------------------------------------------------------------------
modifier_item_octarine_custom_2 = class({})

function modifier_item_octarine_custom_2:IsHidden() return true end
function modifier_item_octarine_custom_2:IsPurgable() return false end
function modifier_item_octarine_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_octarine_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, 
    }
end

-- Stats Dobrados (450 x 2 = 900)
function modifier_item_octarine_custom_2:GetModifierHealthBonus() return 900 end
function modifier_item_octarine_custom_2:GetModifierManaBonus() return 900 end
function modifier_item_octarine_custom_2:GetModifierConstantManaRegen() return 12 end -- 6(x2)

-- Redução de Cooldown (35% fixo)
function modifier_item_octarine_custom_2:GetModifierPercentageCooldown()
    return 35
end