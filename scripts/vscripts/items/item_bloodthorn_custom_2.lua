item_bloodthorn_custom_2 = class({})
LinkLuaModifier("modifier_item_bloodthorn_custom_2", "items/item_bloodthorn_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodthorn_custom_2_debuff", "items/item_bloodthorn_custom_2", LUA_MODIFIER_MOTION_NONE)

function item_bloodthorn_custom_2:GetIntrinsicModifierName()
    return "modifier_item_bloodthorn_custom_2"
end

function item_bloodthorn_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then return end

    target:EmitSound("DOTA_Item.Bloodthorn.Activate")
    target:AddNewModifier(caster, self, "modifier_item_bloodthorn_custom_2_debuff", {duration = 5})
end

--------------------------------------------------------------------------------
-- MODIFIER PASSIVO (Atributos + MKB Lite)
--------------------------------------------------------------------------------
modifier_item_bloodthorn_custom_2 = class({})
function modifier_item_bloodthorn_custom_2:IsHidden() return true end
function modifier_item_bloodthorn_custom_2:IsPurgable() return false end
function modifier_item_bloodthorn_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bloodthorn_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_item_bloodthorn_custom_2:GetModifierBonusStats_Intellect() return 20 end
function modifier_item_bloodthorn_custom_2:GetModifierAttackSpeedBonus_Constant() return 190 end
function modifier_item_bloodthorn_custom_2:GetModifierConstantManaRegen() return 6.5 end
function modifier_item_bloodthorn_custom_2:GetModifierConstantHealthRegen() return 13 end
function modifier_item_bloodthorn_custom_2:GetModifierPreAttack_BonusDamage() return 20 end

function modifier_item_bloodthorn_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsBuilding() or params.target:IsOther() then return end

    -- Passiva Estilo MKB (40% chance / 60 dano)
    if RollPercentage(40) then
        local pfx = ParticleManager:CreateParticle("particles/items_fx/monkey_king_bar_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
        ParticleManager:ReleaseParticleIndex(pfx)
        ApplyDamage({
            victim = params.target, attacker = self:GetParent(), damage = 120,
            damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()
        })
    end
end

--------------------------------------------------------------------------------
-- MODIFIER ATIVO (Soul Rend / Silence)
--------------------------------------------------------------------------------
modifier_item_bloodthorn_custom_2_debuff = class({})

function modifier_item_bloodthorn_custom_2_debuff:IsPurgable() return true end

function modifier_item_bloodthorn_custom_2_debuff:OnCreated()
    if not IsServer() then return end
    self.total_damage_taken = 0
end

function modifier_item_bloodthorn_custom_2_debuff:CheckState()
    return { [MODIFIER_STATE_SILENCED] = true }
end

function modifier_item_bloodthorn_custom_2_debuff:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_item_bloodthorn_custom_2_debuff:OnTakeDamage(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end

    -- Acumula o dano total recebido
    self.total_damage_taken = self.total_damage_taken + params.damage

    -- Bônus de 50 de dano mágico POR ATAQUE recebido
    if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
        ApplyDamage({
            victim = params.unit, attacker = params.attacker, damage = 100,
            damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()
        })
    end
end

function modifier_item_bloodthorn_custom_2_debuff:OnDestroy()
    if not IsServer() then return end
    -- Aplica 60% do dano acumulado como dano mágico no fim
    local end_damage = self.total_damage_taken * 0.60
    if end_damage > 0 then
        ApplyDamage({
            victim = self:GetParent(), attacker = self:GetCaster(), damage = end_damage,
            damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()
        })
        -- Efeito visual de explosão no final
        local pfx = ParticleManager:CreateParticle("particles/items_fx/bloodthorn_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(pfx)
    end
end

function modifier_item_bloodthorn_custom_2_debuff:GetEffectName()
    return "particles/items_fx/bloodthorn_target.vpcf"
end
function modifier_item_bloodthorn_custom_2_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end