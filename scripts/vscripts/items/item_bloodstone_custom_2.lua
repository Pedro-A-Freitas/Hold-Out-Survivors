LinkLuaModifier("modifier_item_bloodstone_custom_2", "items/item_bloodstone_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodstone_custom_2_active", "items/item_bloodstone_custom_2", LUA_MODIFIER_MOTION_NONE)

item_bloodstone_custom_2 = class({})

function item_bloodstone_custom_2:GetIntrinsicModifierName()
    return "modifier_item_bloodstone_custom_2"
end

function item_bloodstone_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local duration = 5.0

    caster:AddNewModifier(caster, self, "modifier_item_bloodstone_custom_2_active", {duration = duration})
    caster:EmitSound("Item.Bloodstone.Cast")
end

--------------------------------------------------------------------------------
-- PASSIVO (STATS DOBRADOS + 40% SPELL LIFESTEAL)
--------------------------------------------------------------------------------
modifier_item_bloodstone_custom_2 = class({})

function modifier_item_bloodstone_custom_2:IsHidden() return true end
function modifier_item_bloodstone_custom_2:IsPurgable() return false end
function modifier_item_bloodstone_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bloodstone_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_item_bloodstone_custom_2:GetModifierHealthBonus() return 900 end -- 450(x2)
function modifier_item_bloodstone_custom_2:GetModifierManaBonus() return 900 end -- 450(x2)
function modifier_item_bloodstone_custom_2:GetModifierConstantManaRegen() return 6 end -- 3(x2)

-- Lógica de Spell Lifesteal Passivo (40%)
function modifier_item_bloodstone_custom_2:OnTakeDamage(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.unit == self:GetParent() then return end
    if params.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL or params.damage <= 0 then return end

    local heal = params.damage * 0.40
    self:GetParent():Heal(heal, self:GetAbility())
    
    local pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)
end

--------------------------------------------------------------------------------
-- ATIVO (80% SPELL LIFESTEAL)
--------------------------------------------------------------------------------
modifier_item_bloodstone_custom_2_active = class({})

function modifier_item_bloodstone_custom_2_active:IsBuff() return true end
function modifier_item_bloodstone_custom_2_active:GetEffectName() return "particles/items3_fx/bloodstone_active.vpcf" end

function modifier_item_bloodstone_custom_2_active:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_item_bloodstone_custom_2_active:OnTakeDamage(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.unit == self:GetParent() then return end
    if params.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL or params.damage <= 0 then return end

    -- Ativo dá 80%. Como o passivo já dá 40%, aqui curamos mais 40% (Total 80%) ou limpamos o cálculo:
    local heal = params.damage * 0.80
    self:GetParent():Heal(heal, self:GetAbility())
end