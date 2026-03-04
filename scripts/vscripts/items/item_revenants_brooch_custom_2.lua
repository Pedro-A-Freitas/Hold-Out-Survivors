LinkLuaModifier("modifier_item_revenants_brooch_custom_2", "items/item_revenants_brooch_custom_2", LUA_MODIFIER_MOTION_NONE)

item_revenants_brooch_custom_2 = class({})

function item_revenants_brooch_custom_2:GetIntrinsicModifierName()
    return "modifier_item_revenants_brooch_custom_2"
end

--------------------------------------------------------------------------------
modifier_item_revenants_brooch_custom_2 = class({})

function modifier_item_revenants_brooch_custom_2:IsHidden() return true end
function modifier_item_revenants_brooch_custom_2:IsPurgable() return false end
function modifier_item_revenants_brooch_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_revenants_brooch_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFICATION_UNIQUE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- Stats
function modifier_item_revenants_brooch_custom_2:GetModifierPreAttack_BonusDamage() return 70 end
function modifier_item_revenants_brooch_custom_2:GetModifierSpellLifestealAmplificationUnique() return 28 end

function modifier_item_revenants_brooch_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    
    if params.attacker == self:GetParent() and not params.target:IsBuilding() then
        
        -- Efeito: 40% de chance de dar 100% do dano de ataque como Dano Mágico
        if RollPercentage(40) then
            local target = params.target
            local caster = params.attacker
            local ability = self:GetAbility()
            
            -- O dano base do proc é 100% do dano que o ataque causou
            local extra_damage = params.damage 

            local damage_table = {
                victim = target,
                attacker = caster,
                damage = extra_damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
                damage_flags = DOTA_DAMAGE_FLAG_SPELL_LIFESTEAL -- FORÇA O RECONHECIMENTO DO SPELL LIFESTEAL
            }
            
            local actual_damage = ApplyDamage(damage_table)

            -- SE O DOTA AINDA NÃO CURAR AUTOMATICAMENTE, FAZEMOS O CÁLCULO MANUAL:
            if actual_damage > 0 then
                local lifesteal_pct = 28 / 100
                local heal_amount = actual_damage * lifesteal_pct
                
                -- Cura o herói
                caster:Heal(heal_amount, ability)
                
                -- Efeito visual de partículas verdes (Lifesteal)
                local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
            end

            -- Efeito Visual Roxo do Proc
            local pfx = ParticleManager:CreateParticle("particles/items3_fx/revenants_brooch.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:ReleaseParticleIndex(pfx)
            target:EmitSound("Item.RevenantsBrooch.Action")
        end
    end
end