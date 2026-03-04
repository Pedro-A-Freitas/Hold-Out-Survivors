LinkLuaModifier("modifier_item_bfury_custom_2", "items/item_bfury_custom_2", LUA_MODIFIER_MOTION_NONE)

item_bfury_custom_2 = class({})

function item_bfury_custom_2:GetIntrinsicModifierName()
    return "modifier_item_bfury_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_bfury_custom_2 = class({})

function modifier_item_bfury_custom_2:IsHidden() return true end
function modifier_item_bfury_custom_2:IsPurgable() return false end
function modifier_item_bfury_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bfury_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- Stats Dobrados
function modifier_item_bfury_custom_2:GetModifierPreAttack_BonusDamage() return 100 end
function modifier_item_bfury_custom_2:GetModifierConstantHealthRegen() return 15.0 end
function modifier_item_bfury_custom_2:GetModifierConstantManaRegen() return 5.5 end

-- Lógica do Cleave (Apenas Melee)
function modifier_item_bfury_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    
    local attacker = params.attacker
    local target = params.target
    local ability = self:GetAbility()

    -- Verifica se o atacante é o dono do item, se não é uma estrutura e se é MELEE
    if attacker == self:GetParent() and not target:IsBuilding() and not attacker:IsRangedAttacker() then
        
        -- Configurações do Cleave (100% de dano em 650 de raio)
        local cleave_damage = params.damage * 1.0 -- 100%
        local start_radius = 150
        local end_radius = 650
        local distance = 650
        
        DoCleaveAttack(
            attacker, 
            target, 
            ability, 
            cleave_damage, 
            start_radius, 
            end_radius, 
            distance, 
            "particles/items_fx/battlefury_cleave.vpcf"
        )
    end
end