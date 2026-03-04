LinkLuaModifier("modifier_item_guardian_greaves_custom_2", "items/item_guardian_greaves_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_greaves_custom_2_aura", "items/item_guardian_greaves_custom_2", LUA_MODIFIER_MOTION_NONE)

item_guardian_greaves_custom_2 = class({})

function item_guardian_greaves_custom_2:GetIntrinsicModifierName()
    return "modifier_item_guardian_greaves_custom_2"
end

function item_guardian_greaves_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local radius = 1200
    local hp_restore = 650 -- 325 x 2
    local mana_restore = 400 -- 200 x 2

    -- 1. Basic Dispel apenas no usuário
    caster:Purge(false, true, false, false, false)

    -- 2. Efeito visual e som
    caster:EmitSound("Item.GuardianGreaves.Activate")
    local pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx)

    -- 3. Restaurar aliados no raio
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    for _, ally in pairs(allies) do
        ally:Heal(hp_restore, self)
        ally:GiveMana(mana_restore)
        
        -- Partícula em cada aliado
        local pfx_ally = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
        ParticleManager:ReleaseParticleIndex(pfx_ally)
    end
end

--------------------------------------------------------------------------------
-- PASSIVO (Stats + Aura)
--------------------------------------------------------------------------------
modifier_item_guardian_greaves_custom_2 = class({})

function modifier_item_guardian_greaves_custom_2:IsHidden() return true end
function modifier_item_guardian_greaves_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_guardian_greaves_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_guardian_greaves_custom_2:GetModifierPhysicalArmorBonus() return 10 end
function modifier_item_guardian_greaves_custom_2:GetModifierConstantManaRegen() return 3.0 end
function modifier_item_guardian_greaves_custom_2:GetModifierMoveSpeedBonus_Constant() return 75 end

-- Configuração da Aura Guardian
function modifier_item_guardian_greaves_custom_2:IsAura() return true end
function modifier_item_guardian_greaves_custom_2:GetAuraRadius() return 1200 end
function modifier_item_guardian_greaves_custom_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_guardian_greaves_custom_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_guardian_greaves_custom_2:GetModifierAura() return "modifier_item_guardian_greaves_custom_2_aura" end

--------------------------------------------------------------------------------
-- MODIFICADOR DA AURA (HP e Mana Regen para aliados)
--------------------------------------------------------------------------------
modifier_item_guardian_greaves_custom_2_aura = class({})

function modifier_item_guardian_greaves_custom_2_aura:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_item_guardian_greaves_custom_2_aura:GetModifierConstantHealthRegen() return 5.0 end
function modifier_item_guardian_greaves_custom_2_aura:GetModifierConstantManaRegen() return 3.0 end