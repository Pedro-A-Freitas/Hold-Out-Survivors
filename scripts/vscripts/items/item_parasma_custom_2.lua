LinkLuaModifier("modifier_item_parasma_custom_2", "items/item_parasma_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_parasma_custom_2_poison", "items/item_parasma_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_parasma_custom_2_debuff", "items/item_parasma_custom_2", LUA_MODIFIER_MOTION_NONE)

item_parasma_custom_2 = class({})

function item_parasma_custom_2:GetIntrinsicModifierName()
    return "modifier_item_parasma_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_parasma_custom_2 = class({})

function modifier_item_parasma_custom_2:IsHidden() return true end
function modifier_item_parasma_custom_2:IsPurgable() return false end
function modifier_item_parasma_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_parasma_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TRANSIENT_ATTACK_TRUE_STRIKE,
    }
end

function modifier_item_parasma_custom_2:GetModifierBonusStats_Intellect() return 80 end
function modifier_item_parasma_custom_2:GetModifierAttackSpeedBonus_Constant() return 80 end
function modifier_item_parasma_custom_2:GetModifierPhysicalArmorBonus() return 14 end
function modifier_item_parasma_custom_2:GetModifierConstantManaRegen() return 3.0 end
function modifier_item_parasma_custom_2:GetModifierProjectileSpeedBonus() return 300 end

-- TRUE STRIKE apenas quando a habilidade não está em cooldown
function modifier_item_parasma_custom_2:GetModifierTransientAttack_TrueStrike()
    local ability = self:GetAbility()
    if ability and ability:IsCooldownReady() then
        return 1
    end
    return 0
end

function modifier_item_parasma_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and not params.target:IsBuilding() then
        local target = params.target
        local caster = params.attacker
        local ability = self:GetAbility()

        -- Efeito 2: Magic Corruption (Sempre aplica, não tem cooldown)
        target:AddNewModifier(caster, ability, "modifier_item_parasma_custom_2_debuff", {duration = 4.0})

        -- Efeito 1: Witch Blade Poison (Verifica o Cooldown de 7s)
        if ability and ability:IsCooldownReady() then
            -- Inicia o cooldown visual no item
            ability:StartCooldown(7.0)
            
            target:EmitSound("Item.Parasma.Target")
            
            -- Aplica o modificador que processa os 4 ticks de dano
            target:AddNewModifier(caster, ability, "modifier_item_parasma_custom_2_poison", {duration = 4.0})
        end
    end
end

--------------------------------------------------------------------------------
-- MODIFICADOR DO VENENO (DANO POR SEGUNDO)
--------------------------------------------------------------------------------
modifier_item_parasma_custom_2_poison = class({})

function modifier_item_parasma_custom_2_poison:IsHidden() return false end
function modifier_item_parasma_custom_2_poison:IsPurgable() return true end
function modifier_item_parasma_custom_2_poison:GetTexture() return "item_devastator" end

function modifier_item_parasma_custom_2_poison:OnCreated()
    if not IsServer() then return end
    local caster = self:GetCaster()
    -- Dano por tick (1 * INT)
    self.damage_per_tick = caster:GetIntellect(false) * 1
    
    -- Primeiro tick imediato
    self:OnIntervalThink()
    -- Próximos 3 ticks (1 a cada segundo)
    self:StartIntervalThink(1.0)
end

function modifier_item_parasma_custom_2_poison:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage_per_tick,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    })
    
    -- Efeito visual de dano
    local pfx = ParticleManager:CreateParticle("particles/items3_fx/witch_blade_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_item_parasma_custom_2_poison:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_item_parasma_custom_2_poison:GetModifierMoveSpeedBonus_Percentage() return -25 end

--------------------------------------------------------------------------------
-- MODIFICADOR DA REDUÇÃO DE RESISTÊNCIA
--------------------------------------------------------------------------------
modifier_item_parasma_custom_2_debuff = class({})
function modifier_item_parasma_custom_2_debuff:IsHidden() return false end
function modifier_item_parasma_custom_2_debuff:GetTexture() return "item_devastator" end
function modifier_item_parasma_custom_2_debuff:DeclareFunctions() return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS } end
function modifier_item_parasma_custom_2_debuff:GetModifierMagicalResistanceBonus() return -20 end