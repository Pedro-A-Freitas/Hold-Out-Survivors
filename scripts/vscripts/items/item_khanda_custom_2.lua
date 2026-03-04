LinkLuaModifier("modifier_item_khanda_custom_2", "items/item_khanda_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_khanda_custom_2_slow", "items/item_khanda_custom_2", LUA_MODIFIER_MOTION_NONE)

item_khanda_custom_2 = class({})

function item_khanda_custom_2:GetIntrinsicModifierName()
    return "modifier_item_khanda_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_khanda_custom_2 = class({})

function modifier_item_khanda_custom_2:IsHidden() return true end
function modifier_item_khanda_custom_2:IsPurgable() return false end
function modifier_item_khanda_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_khanda_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

-- Stats Dobrados (2x)
function modifier_item_khanda_custom_2:GetModifierHealthBonus() return 900 end
function modifier_item_khanda_custom_2:GetModifierManaBonus() return 900 end
function modifier_item_khanda_custom_2:GetModifierBonusStats_Strength() return 16 end
function modifier_item_khanda_custom_2:GetModifierBonusStats_Agility() return 16 end
function modifier_item_khanda_custom_2:GetModifierBonusStats_Intellect() return 16 end
function modifier_item_khanda_custom_2:GetModifierConstantHealthRegen() return 14 end
function modifier_item_khanda_custom_2:GetModifierConstantManaRegen() return 6 end

-- Lógica do Proc (Empower Spell)
function modifier_item_khanda_custom_2:OnAbilityExecuted(params)
    if not IsServer() then return end

    local parent = self:GetParent()
    local ability = self:GetAbility()
    local target = params.target

    -- Verifica se foi uma magia de alvo, se o item está fora de cooldown e se o alvo é inimigo
    if params.unit == parent and target and target:GetTeamNumber() ~= parent:GetTeamNumber() and not target:IsBuilding() then
        if ability:IsCooldownReady() then
            
            -- Aplica 500 de dano mágico (250 x 2)
            local damage_table = {
                victim = target,
                attacker = parent,
                damage = 500,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability
            }
            ApplyDamage(damage_table)

            -- Aplica o Slow e o BREAK (Desabilita Passivas)
            target:AddNewModifier(parent, ability, "modifier_item_khanda_custom_2_slow", {duration = 4.0})

            -- Efeito Visual e Som
            target:EmitSound("Item.Khanda.Target")
            local pfx = ParticleManager:CreateParticle("particles/items3_fx/khanda.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:ReleaseParticleIndex(pfx)

            -- Inicia o Cooldown de 9 segundos
            ability:StartCooldown(9.0)
        end
    end
end

--------------------------------------------------------------------------------
-- DEBUFF: SLOW 50% + BREAK (SILVER EDGE EFFECT)
--------------------------------------------------------------------------------
modifier_item_khanda_custom_2_slow = class({})

function modifier_item_khanda_custom_2_slow:IsDebuff() return true end
function modifier_item_khanda_custom_2_slow:IsPurgable() return true end

function modifier_item_khanda_custom_2_slow:CheckState()
    return { [MODIFIER_STATE_PASSIVES_DISABLED] = true } -- EFEITO BREAK
end

function modifier_item_khanda_custom_2_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_item_khanda_custom_2_slow:GetModifierMoveSpeedBonus_Percentage()
    return -50
end

function modifier_item_khanda_custom_2_slow:GetEffectName()
    return "particles/items3_fx/khanda_slow.vpcf"
end