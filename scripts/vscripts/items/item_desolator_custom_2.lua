LinkLuaModifier("modifier_item_desolator_custom_2", "items/item_desolator_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_desolator_custom_2_corruption", "items/item_desolator_custom_2", LUA_MODIFIER_MOTION_NONE)

item_desolator_custom_2 = class({})

function item_desolator_custom_2:GetIntrinsicModifierName()
    return "modifier_item_desolator_custom_2"
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (GERENCIA CARGAS E STATUS)
--------------------------------------------------------------------------------
modifier_item_desolator_custom_2 = class({})

function modifier_item_desolator_custom_2:IsHidden() return false end
function modifier_item_desolator_custom_2:IsPurgable() return false end
function modifier_item_desolator_custom_2:RemoveOnDeath() return false end
function modifier_item_desolator_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_custom_2:OnCreated()
    if not IsServer() then return end
    if not self:GetAbility().charges then self:GetAbility().charges = 0 end
    self:StartIntervalThink(0.1)
end

function modifier_item_desolator_custom_2:OnIntervalThink()
    if IsServer() then
        -- Sincroniza as cargas da habilidade com o stack do modifier para aparecer no ícone
        self:SetStackCount(self:GetAbility().charges)
    end
end

function modifier_item_desolator_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_DEATH,
    }
end

-- Dano: 110 (Base) + (Cargas * 4)
function modifier_item_desolator_custom_2:GetModifierPreAttack_BonusDamage()
    local bonus_per_charge = 4 -- +2 (original) x 2
    return 110 + (self:GetStackCount() * bonus_per_charge)
end

-- Aplica o Debuff de Armor ao atacar
function modifier_item_desolator_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and not params.target:IsBuilding() then
        params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_desolator_custom_2_corruption", {duration = 7.0})
    end
end

-- Lógica de Cargas: Ganha 0.1 carga se qualquer unidade morrer com o debuff
function modifier_item_desolator_custom_2:OnDeath(params)
    if not IsServer() then return end
    local victim = params.unit
    local ability = self:GetAbility()
    local caster = self:GetParent()
    local max_charges = 60 

    -- Verifica se a unidade que morreu tinha o debuff da Desolator
    if victim:HasModifier("modifier_item_desolator_custom_2_corruption") then
        if ability.charges < max_charges then
            ability.charges = math.min(ability.charges + 0.1, max_charges)
            
            -- CRIAR E DESTRUIR A PARTÍCULA (Para não ficar a bolinha parada no chão)
            local pfx = ParticleManager:CreateParticle("particles/items_fx/desolator_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
            -- Faz a bolinha voar em direção ao herói que ganhou a carga (efeito visual maneiro)
            ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
    end
end

--------------------------------------------------------------------------------
-- DEBUFF DE CORRUPÇÃO (-12 ARMOR)
--------------------------------------------------------------------------------
modifier_item_desolator_custom_2_corruption = class({})

function modifier_item_desolator_custom_2_corruption:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_item_desolator_custom_2_corruption:GetModifierPhysicalArmorBonus()
    return -12 -- 6 x 2
end

function modifier_item_desolator_custom_2_corruption:GetTexture() return "item_desolator" end