LinkLuaModifier("modifier_item_rapier_custom_2", "items/item_rapier_custom_2", LUA_MODIFIER_MOTION_NONE)

item_rapier_custom_2 = class({})

function item_rapier_custom_2:GetIntrinsicModifierName()
    return "modifier_item_rapier_custom_2"
end

-- Lógica do Toggle (Troca entre Dano e Spell Amp)
function item_rapier_custom_2:OnToggle()
    if not IsServer() then return end
    local caster = self:GetCaster()
    
    if self:GetToggleState() then
        caster:EmitSound("DOTA_Item.Refresher.Activate") -- Som de ativação (Exemplo)
    else
        caster:EmitSound("DOTA_Item.Refresher.Deactivate") -- Som de desativação
    end
end

--------------------------------------------------------------------------------

modifier_item_rapier_custom_2 = class({})

function modifier_item_rapier_custom_2:IsHidden() return true end
function modifier_item_rapier_custom_2:IsPurgable() return false end
function modifier_item_rapier_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_rapier_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

-- Dano Fixo (+200) + Bônus do Toggle (+250)
function modifier_item_rapier_custom_2:GetModifierPreAttack_BonusDamage()
    local damage = 200 -- Dobro do seu valor base de 100
    
    -- Se o Toggle estiver LIGADO (Modo 1: Ataque)
    if self:GetAbility():GetToggleState() then
        damage = damage + 500
    end
    
    return damage
end

-- Spell Amp (Apenas se o Toggle estiver DESLIGADO)
function modifier_item_rapier_custom_2:GetModifierSpellAmplify_Percentage()
    -- Se o Toggle estiver DESLIGADO (Modo 2: Spell Amp)
    if not self:GetAbility():GetToggleState() then
        return 50
    end
    return 0
end