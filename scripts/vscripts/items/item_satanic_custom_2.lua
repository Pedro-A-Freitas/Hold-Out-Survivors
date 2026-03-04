LinkLuaModifier("modifier_item_satanic_custom_2", "items/item_satanic_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satanic_custom_2_active", "items/item_satanic_custom_2", LUA_MODIFIER_MOTION_NONE)

item_satanic_custom_2 = class({})

function item_satanic_custom_2:GetIntrinsicModifierName()
    return "modifier_item_satanic_custom_2"
end

function item_satanic_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    -- Ativa o Unholy Rage por 10 segundos
    caster:AddNewModifier(caster, self, "modifier_item_satanic_custom_2_active", {duration = 10.0})
    caster:EmitSound("Item.Satanic.Activate")
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (STATS + 40% LIFESTEAL)
--------------------------------------------------------------------------------
modifier_item_satanic_custom_2 = class({})

function modifier_item_satanic_custom_2:IsHidden() return true end
function modifier_item_satanic_custom_2:IsPurgable() return false end
function modifier_item_satanic_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_satanic_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_item_satanic_custom_2:GetModifierBonusStats_Strength() return 50 end -- 25 * 2
function modifier_item_satanic_custom_2:GetModifierPreAttack_BonusDamage() return 50 end -- 25 * 2

function modifier_item_satanic_custom_2:OnTakeDamage(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.unit:IsBuilding() or params.unit == params.attacker then return end
    if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end

    -- Lifesteal Passivo: 40%
    local lifesteal_pct = 40 / 100
    
    -- Se a ativa estiver ligada, esse lifesteal passivo NÃO soma (o da ativa é maior)
    if self:GetParent():HasModifier("modifier_item_satanic_custom_2_active") then return end

    local heal = params.damage * lifesteal_pct
    if heal > 0 then
        self:GetParent():Heal(heal, self:GetAbility())
        local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(pfx)
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR ATIVO (200% LIFESTEAL)
--------------------------------------------------------------------------------
modifier_item_satanic_custom_2_active = class({})

function modifier_item_satanic_custom_2_active:IsPurgable() return false end
function modifier_item_satanic_custom_2_active:GetTexture() return "item_satanic" end

function modifier_item_satanic_custom_2_active:GetEffectName()
    return "particles/items2_fx/satanic_active.vpcf"
end

function modifier_item_satanic_custom_2_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_satanic_custom_2_active:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_item_satanic_custom_2_active:OnTakeDamage(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.unit:IsBuilding() or params.unit == params.attacker then return end
    if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end

    -- Lifesteal Ativo: 200%
    local lifesteal_active_pct = 200 / 100
    local heal = params.damage * lifesteal_active_pct
    
    if heal > 0 then
        self:GetParent():Heal(heal, self:GetAbility())
        local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(pfx)
    end
end