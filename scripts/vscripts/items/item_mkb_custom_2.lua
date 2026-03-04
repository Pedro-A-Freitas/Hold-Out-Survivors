item_mkb_custom_2 = class({})
LinkLuaModifier("modifier_item_mkb_custom_2", "items/item_mkb_custom_2", LUA_MODIFIER_MOTION_NONE)

function item_mkb_custom_2:GetIntrinsicModifierName()
    return "modifier_item_mkb_custom_2"
end

--------------------------------------------------------------------------------

modifier_item_mkb_custom_2 = class({})

function modifier_item_mkb_custom_2:IsHidden() return true end
function modifier_item_mkb_custom_2:IsPurgable() return false end
function modifier_item_mkb_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_mkb_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_CHECK_ACCESS_TO_TRUE_STRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- BÔNUS DE DANO HARDCODED (80)
function modifier_item_mkb_custom_2:GetModifierPreAttack_BonusDamage()
    return 80
end

-- BÔNUS DE ATTACK SPEED HARDCODED (90)
function modifier_item_mkb_custom_2:GetModifierAttackSpeedBonus_Constant()
    return 90
end

-- TRUE STRIKE
function modifier_item_mkb_custom_2:GetModifierCheckAccessToTrueStrike()
    return 1
end

-- LÓGICA DO PROC (80% / 140 dano)
function modifier_item_mkb_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    if params.target:IsBuilding() or params.target:IsOther() then return end

    -- Usando valores fixos aqui também para evitar falhas do KV
    local chance = 80
    local damage = 140

    if RollPercentage(chance) then
        params.target:EmitSound("DOTA_Item.MonkeyKingBar.Target")
        
        local pfx = ParticleManager:CreateParticle("particles/items_fx/monkey_king_bar_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
        ParticleManager:ReleaseParticleIndex(pfx)

        ApplyDamage({
            victim = params.target,
            attacker = self:GetParent(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        })
    end
end