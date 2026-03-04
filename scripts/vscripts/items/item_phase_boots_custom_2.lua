LinkLuaModifier("modifier_item_phase_boots_custom_2", "items/item_phase_boots_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_phase_boots_custom_2_active", "items/item_phase_boots_custom_2", LUA_MODIFIER_MOTION_NONE)

item_phase_boots_custom_2 = class({})

-- CORRIGIDO: Agora apontando para o modificador certo da Phase Boots
function item_phase_boots_custom_2:GetIntrinsicModifierName()
    return "modifier_item_phase_boots_custom_2"
end

function item_phase_boots_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local duration = 3.0
    local cooldown = 8.0

    -- Força o cooldown no LUA
    self:StartCooldown(cooldown)

    caster:EmitSound("DOTA_Item.PhaseBoots.Activate")
    caster:AddNewModifier(caster, self, "modifier_item_phase_boots_custom_2_active", {duration = duration})
end

--------------------------------------------------------------------------------
-- PASSIVO
--------------------------------------------------------------------------------
modifier_item_phase_boots_custom_2 = class({})

function modifier_item_phase_boots_custom_2:IsHidden() return true end
function modifier_item_phase_boots_custom_2:IsPurgable() return false end
function modifier_item_phase_boots_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_phase_boots_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_phase_boots_custom_2:GetModifierMoveSpeedBonus_Constant() return 70 end
function modifier_item_phase_boots_custom_2:GetModifierPreAttack_BonusDamage() return 45 end
function modifier_item_phase_boots_custom_2:GetModifierPhysicalArmorBonus() return 12 end

--------------------------------------------------------------------------------
-- ATIVO (O BUFF DA PHASE)
--------------------------------------------------------------------------------
modifier_item_phase_boots_custom_2_active = class({})

function modifier_item_phase_boots_custom_2_active:IsHidden() return false end
function modifier_item_phase_boots_custom_2_active:IsPurgable() return false end

function modifier_item_phase_boots_custom_2_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_phase_boots_custom_2_active:GetModifierMoveSpeedBonus_Percentage() 
    return 20 
end

function modifier_item_phase_boots_custom_2_active:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_item_phase_boots_custom_2_active:GetEffectName()
    return "particles/items_fx/phase_boots.vpcf"
end