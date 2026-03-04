LinkLuaModifier("modifier_item_mjollnir_custom_2", "items/item_mjollnir_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_2_static_shield", "items/item_mjollnir_custom_2", LUA_MODIFIER_MOTION_NONE)

item_mjollnir_custom_2 = class({})

function item_mjollnir_custom_2:GetIntrinsicModifierName()
    return "modifier_item_mjollnir_custom_2"
end

function item_mjollnir_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    -- Ativa o Escudo Estático por 15 segundos
    target:AddNewModifier(caster, self, "modifier_item_mjollnir_custom_2_static_shield", {duration = 15.0})
    target:EmitSound("Item.Mjollnir.Activate")
end

--------------------------------------------------------------------------------
-- PASSIVO: STATS + CHAIN LIGHTNING
--------------------------------------------------------------------------------
modifier_item_mjollnir_custom_2 = class({})

function modifier_item_mjollnir_custom_2:IsHidden() return true end
function modifier_item_mjollnir_custom_2:IsPurgable() return false end
function modifier_item_mjollnir_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_mjollnir_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_item_mjollnir_custom_2:GetModifierPreAttack_BonusDamage() return 50 end
function modifier_item_mjollnir_custom_2:GetModifierAttackSpeedBonus_Constant() return 180 end

function modifier_item_mjollnir_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() or params.target:IsBuilding() then return end

    -- 35% de chance de Chain Lightning
    if RollPercentage(35) then
        local target = params.target
        local caster = params.attacker
        local damage = 360 -- 180 (2x)
        
        -- Efeito visual do raio
        target:EmitSound("Item.Mjollnir.Target")
        
        -- O motor do Dota já tem uma função para o Chain Lightning
        -- Se não funcionar como esperado, usamos uma lógica de busca de alvos manual
        local lightningChain = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(lightningChain, 0, caster:GetAbsOrigin() + Vector(0,0,100))
        ParticleManager:SetParticleControl(lightningChain, 1, target:GetAbsOrigin() + Vector(0,0,100))

        -- Dano em área (simplificado para os 12 alvos)
        local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        
        local count = 0
        for _, unit in pairs(units) do
            if count < 12 then
                ApplyDamage({
                    victim = unit,
                    attacker = caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                })
                count = count + 1
            end
        end
    end
end

--------------------------------------------------------------------------------
-- ATIVO: ESCUDO ESTÁTICO (STATIC CHARGE)
--------------------------------------------------------------------------------
modifier_item_mjollnir_custom_2_static_shield = class({})

function modifier_item_mjollnir_custom_2_static_shield:IsDebuff() return false end
function modifier_item_mjollnir_custom_2_static_shield:IsPurgable() return true end

function modifier_item_mjollnir_custom_2_static_shield:GetEffectName()
    return "particles/items2_fx/mjollnir_shield.vpcf"
end

function modifier_item_mjollnir_custom_2_static_shield:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_item_mjollnir_custom_2_static_shield:OnTakeDamage(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() or not params.attacker or params.attacker:IsBuilding() then return end

    -- 30% de chance de contra-atacar com raio
    if RollPercentage(30) then
        local target = params.attacker
        local caster = self:GetParent()
        local owner = self:GetCaster()
        local ability = self:GetAbility()
        local damage = 450 -- 225 (2x)

        caster:EmitSound("Item.Mjollnir.Static")

        -- Atinge o atacante e mais 8 alvos (4 x 2)
        local units = FindUnitsInRadius(owner:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        
        local count = 0
        for _, unit in pairs(units) do
            if count < 9 then -- Atacante + 8 extras
                ApplyDamage({
                    victim = unit,
                    attacker = owner,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = ability
                })
                
                -- Visual do raio saindo do escudo
                local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_static_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(pfx)
                
                count = count + 1
            end
        end
    end
end