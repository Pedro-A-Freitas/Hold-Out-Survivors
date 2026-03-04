LinkLuaModifier("modifier_item_shivas_custom_2", "items/item_shivas_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_custom_2_aura", "items/item_shivas_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_custom_2_active_debuff", "items/item_shivas_custom_2", LUA_MODIFIER_MOTION_NONE)

item_shivas_custom_2 = class({})

function item_shivas_custom_2:GetIntrinsicModifierName()
    return "modifier_item_shivas_custom_2"
end

function item_shivas_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local radius = 900 -- Raio da onda crescendo
    local speed = 350
    local damage = 400 -- 200(x2)
    local duration = 4.0 -- Slow duration
    local debuff_duration = 16.0 -- Spell Amp duration

    caster:EmitSound("Item.ShivasGuard.Activate")

    -- Efeito visual da explosão de gelo
    local pfx = ParticleManager:CreateParticle("particles/items_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, speed, radius))
    ParticleManager:ReleaseParticleIndex(pfx)

    -- Busca inimigos no raio da onda
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _, enemy in pairs(enemies) do
        -- Dano Mágico
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        })

        -- Aplica o Debuff (Slow + Spell Amp + Visual de Gelo)
        enemy:AddNewModifier(caster, ability, "modifier_item_shivas_custom_2_active_debuff", {duration = debuff_duration})
    end
end

--------------------------------------------------------------------------------
-- PASSIVO (STATS E AURA)
--------------------------------------------------------------------------------
modifier_item_shivas_custom_2 = class({})

function modifier_item_shivas_custom_2:IsHidden() return true end
function modifier_item_shivas_custom_2:IsPurgable() return false end
function modifier_item_shivas_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_shivas_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_shivas_custom_2:GetModifierBonusStats_Strength() return 10 end
function modifier_item_shivas_custom_2:GetModifierBonusStats_Agility() return 10 end
function modifier_item_shivas_custom_2:GetModifierBonusStats_Intellect() return 10 end
function modifier_item_shivas_custom_2:GetModifierConstantHealthRegen() return 10 end
function modifier_item_shivas_custom_2:GetModifierPhysicalArmorBonus() return 30 end

-- Configuração da Aura de Redução de Atk Speed
function modifier_item_shivas_custom_2:IsAura() return true end
function modifier_item_shivas_custom_2:GetAuraRadius() return 1200 end
function modifier_item_shivas_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_shivas_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_shivas_custom_2:GetModifierAura() return "modifier_item_shivas_custom_2_aura" end

--------------------------------------------------------------------------------
-- AURA (REDUÇÃO DE ATK SPEED)
--------------------------------------------------------------------------------
modifier_item_shivas_custom_2_aura = class({})
function modifier_item_shivas_custom_2_aura:IsDebuff() return true end
function modifier_item_shivas_custom_2_aura:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end
function modifier_item_shivas_custom_2_aura:GetModifierAttackSpeedBonus_Constant() return -90 end -- 45(x2)

--------------------------------------------------------------------------------
-- DEBUFF ATIVO (SLOW + SPELL AMP 30%)
--------------------------------------------------------------------------------
modifier_item_shivas_custom_2_active_debuff = class({})

function modifier_item_shivas_custom_2_active_debuff:IsDebuff() return true end
function modifier_item_shivas_custom_2_active_debuff:GetEffectName() return "particles/status_fx/status_effect_shivas_slow.vpcf" end

function modifier_item_shivas_custom_2_active_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPify_UNIQUE, -- Usado para Spell Amp
    }
end

function modifier_item_shivas_custom_2_active_debuff:GetModifierMoveSpeedBonus_Percentage() return -60 end
function modifier_item_shivas_custom_2_active_debuff:GetModifierMagicalResistanceDecrepifyUnique() return -30 end -- 15%(x2) Spell Amp