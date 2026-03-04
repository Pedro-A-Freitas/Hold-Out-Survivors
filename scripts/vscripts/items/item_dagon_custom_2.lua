LinkLuaModifier("modifier_item_dagon_custom_2", "items/item_dagon_custom_2", LUA_MODIFIER_MOTION_NONE)

item_dagon_custom_2 = class({})

function item_dagon_custom_2:GetIntrinsicModifierName()
    return "modifier_item_dagon_custom_2"
end

function item_dagon_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local damage = 2000
    
    -- Som original da Dagon
    caster:EmitSound("DOTA_Item.Dagon.Activate")
    target:EmitSound("DOTA_Item.Dagon5.Target")

    -- Partícula do Raio Vermelho (Nível 5 para ser a mais forte)
    local pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(pfx, 2, Vector(damage, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)

    -- Aplica o Dano Mágico
    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    })
end

--------------------------------------------------------------------------------
-- PASSIVO
--------------------------------------------------------------------------------
modifier_item_dagon_custom_2 = class({})

function modifier_item_dagon_custom_2:IsHidden() return true end
function modifier_item_dagon_custom_2:IsPurgable() return false end
function modifier_item_dagon_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_dagon_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE, -- Spell Lifesteal
    }
end

function modifier_item_dagon_custom_2:GetModifierBonusStats_Strength() return 30 end
function modifier_item_dagon_custom_2:GetModifierBonusStats_Agility() return 30 end
function modifier_item_dagon_custom_2:GetModifierBonusStats_Intellect() return 30 end
function modifier_item_dagon_custom_2:GetModifierSpellLifestealAmplifyPercentage() return 30 end