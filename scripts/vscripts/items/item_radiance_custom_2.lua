item_radiance_custom_2 = class({})
LinkLuaModifier("modifier_item_radiance_custom_2", "items/item_radiance_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_custom_2_burn", "items/item_radiance_custom_2", LUA_MODIFIER_MOTION_NONE)

function item_radiance_custom_2:GetIntrinsicModifierName()
    return "modifier_item_radiance_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFIER PASSIVO (Atributos + Lógica da Aura)
--------------------------------------------------------------------------------
modifier_item_radiance_custom_2 = class({})

function modifier_item_radiance_custom_2:IsHidden() return true end
function modifier_item_radiance_custom_2:IsPurgable() return false end
function modifier_item_radiance_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_radiance_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end

function modifier_item_radiance_custom_2:GetModifierPreAttack_BonusDamage() return 110 end -- 55 x 2
function modifier_item_radiance_custom_2:GetModifierEvasion_Constant() return 35 end     -- 25 -> 35

-- Configuração da Aura
function modifier_item_radiance_custom_2:IsAura() return true end
function modifier_item_radiance_custom_2:GetModifierAura() return "modifier_item_radiance_custom_2_burn" end
function modifier_item_radiance_custom_2:GetAuraRadius() return 700 end
function modifier_item_radiance_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_radiance_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

--------------------------------------------------------------------------------
-- MODIFIER DO DANO (Burn)
--------------------------------------------------------------------------------
modifier_item_radiance_custom_2_burn = class({})

function modifier_item_radiance_custom_2_burn:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1.0)
end

function modifier_item_radiance_custom_2_burn:OnIntervalThink()
    local damage = 120 -- 60 x 2
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    })
end

function modifier_item_radiance_custom_2_burn:GetEffectName()
    return "particles/items_fx/radiance_burn.vpcf"
end