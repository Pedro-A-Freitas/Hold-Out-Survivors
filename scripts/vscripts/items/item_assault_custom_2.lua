LinkLuaModifier("modifier_item_assault_custom_2", "items/item_assault_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_assault_custom_2_buff", "items/item_assault_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_assault_custom_2_debuff", "items/item_assault_custom_2", LUA_MODIFIER_MOTION_NONE)

item_assault_custom_2 = class({})

function item_assault_custom_2:GetIntrinsicModifierName()
    return "modifier_item_assault_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PRINCIPAL (DONO DO ITEM)
--------------------------------------------------------------------------------
modifier_item_assault_custom_2 = class({})

function modifier_item_assault_custom_2:IsHidden() return true end
function modifier_item_assault_custom_2:IsPurgable() return false end
function modifier_item_assault_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_assault_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

-- Stats do herói que carrega o item (20 Armor e 60 Atk Speed)
function modifier_item_assault_custom_2:GetModifierPhysicalArmorBonus() return 20 end
function modifier_item_assault_custom_2:GetModifierAttackSpeedBonus_Constant() return 60 end

--------------------------------------------------------------------------------
-- LÓGICA DAS AURAS (DUAS AURAS SIMULTÂNEAS)
--------------------------------------------------------------------------------
function modifier_item_assault_custom_2:IsAura() return true end
function modifier_item_assault_custom_2:GetAuraRadius() return 1200 end
function modifier_item_assault_custom_2:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_assault_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING end

-- Essa função decide qual aura aplicar baseado no time
function modifier_item_assault_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_item_assault_custom_2:GetModifierAura()
    return "modifier_item_assault_custom_2_buff" -- O padrão é o buff, mas vamos filtrar dentro
end

-- O "Pulo do Gato": Criamos uma lógica que aplica o debuff manualmente se for inimigo
function modifier_item_assault_custom_2:GetAuraEntityReject(hEntity)
    if hEntity:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        -- Se for inimigo, rejeita o BUFF e aplica o DEBUFF na mão
        hEntity:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_assault_custom_2_debuff", {duration = 0.5})
        return true 
    end
    return false -- Se for aliado, aceita o BUFF normal da aura
end

--------------------------------------------------------------------------------
-- MODIFICADOR: BUFF (ALIADOS)
--------------------------------------------------------------------------------
modifier_item_assault_custom_2_buff = class({})
function modifier_item_assault_custom_2_buff:GetTexture() return "item_assault" end
function modifier_item_assault_custom_2_buff:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
end
function modifier_item_assault_custom_2_buff:GetModifierPhysicalArmorBonus() return 10 end
function modifier_item_assault_custom_2_buff:GetModifierAttackSpeedBonus_Constant() return 60 end

--------------------------------------------------------------------------------
-- MODIFICADOR: DEBUFF (INIMIGOS)
--------------------------------------------------------------------------------
modifier_item_assault_custom_2_debuff = class({})
function modifier_item_assault_custom_2_debuff:IsDebuff() return true end
function modifier_item_assault_custom_2_debuff:GetTexture() return "item_assault" end
function modifier_item_assault_custom_2_debuff:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end
function modifier_item_assault_custom_2_debuff:GetModifierPhysicalArmorBonus() return -10 end