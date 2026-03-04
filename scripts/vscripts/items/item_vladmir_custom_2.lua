LinkLuaModifier("modifier_item_vladmir_custom_2", "items/item_vladmir_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_custom_2_aura", "items/item_vladmir_custom_2", LUA_MODIFIER_MOTION_NONE)

item_vladmir_custom_2 = class({})

function item_vladmir_custom_2:GetIntrinsicModifierName()
    return "modifier_item_vladmir_custom_2"
end

--------------------------------------------------------------------------------
-- PASSIVO (Item no Inventário)
--------------------------------------------------------------------------------
modifier_item_vladmir_custom_2 = class({})
function modifier_item_vladmir_custom_2:IsHidden() return true end
function modifier_item_vladmir_custom_2:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MANA_REGEN_CONSTANT }
end
function modifier_item_vladmir_custom_2:GetModifierPhysicalArmorBonus() return 2 end
function modifier_item_vladmir_custom_2:GetModifierConstantManaRegen() return 2.0 end

-- AURA
function modifier_item_vladmir_custom_2:IsAura() return true end
function modifier_item_vladmir_custom_2:GetAuraRadius() return 1200 end
function modifier_item_vladmir_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_vladmir_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_vladmir_custom_2:GetModifierAura() return "modifier_item_vladmir_custom_2_aura" end

--------------------------------------------------------------------------------
-- MODIFICADOR DA AURA
--------------------------------------------------------------------------------
modifier_item_vladmir_custom_2_aura = class({})

function modifier_item_vladmir_custom_2_aura:IsHidden() return false end

function modifier_item_vladmir_custom_2_aura:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- Se o dinâmico falhou, vamos travar em 30 de novo só pra você ver o número
-- Se você quiser 30%, e seu dano é 45, coloque 14 aqui manualmente por enquanto.
function modifier_item_vladmir_custom_2_aura:GetModifierPreAttack_BonusDamage()
    return 30
end

function modifier_item_vladmir_custom_2_aura:GetModifierPhysicalArmorBonus() return 4 end
function modifier_item_vladmir_custom_2_aura:GetModifierConstantManaRegen() return 2.0 end

function modifier_item_vladmir_custom_2_aura:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and not params.target:IsBuilding() then
        local lifesteal = params.damage * 0.30
        params.attacker:Heal(lifesteal, self:GetAbility())
        local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex(pfx)
    end
end