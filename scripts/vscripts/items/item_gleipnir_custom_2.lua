LinkLuaModifier("modifier_item_gleipnir_custom_2", "items/item_gleipnir_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gleipnir_custom_2_root", "items/item_gleipnir_custom_2", LUA_MODIFIER_MOTION_NONE)

item_gleipnir_custom_2 = class({})

function item_gleipnir_custom_2:GetIntrinsicModifierName()
    return "modifier_item_gleipnir_custom_2"
end

-- ADICIONADO: Isso faz o círculo azul de pre-cast aparecer
function item_gleipnir_custom_2:GetAOERadius()
    return 350
end

-- ATIVO: Eternal Chains
function item_gleipnir_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = 350
    local duration = 2.0

    -- Efeito visual do Gleipnir
    local pfx = ParticleManager:CreateParticle("particles/items3_fx/gleipnir_active.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, point)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
    
    EmitSoundOnLocationWithCaster(point, "Item.Gleipnir.Cast", caster)

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), 
        point, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        0, 
        0, 
        false
    )

    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, self, "modifier_item_gleipnir_custom_2_root", {duration = duration})
    end
end

--------------------------------------------------------------------------------
-- PASSIVO
--------------------------------------------------------------------------------
modifier_item_gleipnir_custom_2 = class({})

function modifier_item_gleipnir_custom_2:IsHidden() return true end
function modifier_item_gleipnir_custom_2:IsPurgable() return false end
function modifier_item_gleipnir_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_gleipnir_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
    }
end

function modifier_item_gleipnir_custom_2:GetModifierBonusStats_Intellect() return 24 end
function modifier_item_gleipnir_custom_2:GetModifierHealthBonus() return 900 end
function modifier_item_gleipnir_custom_2:GetModifierManaBonus() return 400 end

--------------------------------------------------------------------------------
-- MODIFICADOR DO ROOT
--------------------------------------------------------------------------------
modifier_item_gleipnir_custom_2_root = class({})
function modifier_item_gleipnir_custom_2_root:CheckState() return { [MODIFIER_STATE_ROOTED] = true } end
function modifier_item_gleipnir_custom_2_root:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end
function modifier_item_gleipnir_custom_2_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end