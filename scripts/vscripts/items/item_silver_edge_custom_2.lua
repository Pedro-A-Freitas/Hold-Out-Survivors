LinkLuaModifier("modifier_item_silver_edge_custom_2", "items/item_silver_edge_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_silver_edge_custom_2_invis", "items/item_silver_edge_custom_2", LUA_MODIFIER_MOTION_NONE)

item_silver_edge_custom_2 = class({})

function item_silver_edge_custom_2:GetIntrinsicModifierName()
    return "modifier_item_silver_edge_custom_2"
end

function item_silver_edge_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    caster:EmitSound("DOTA_Item.InvisibilitySword.Activate")
    caster:AddNewModifier(caster, self, "modifier_item_silver_edge_custom_2_invis", {duration = 17})
end

--------------------------------------------------------------------------------
-- PASSIVO (CORRIGIDO: ADICIONEI A DEFINIÇÃO DA CLASSE ABAIXO)
--------------------------------------------------------------------------------
modifier_item_silver_edge_custom_2 = class({})

function modifier_item_silver_edge_custom_2:IsHidden() return true end
function modifier_item_silver_edge_custom_2:IsPurgable() return false end
function modifier_item_silver_edge_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_silver_edge_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- Nome da propriedade
    }
end

function modifier_item_silver_edge_custom_2:GetModifierPreAttack_BonusDamage()
    return 140
end

-- O NOME DA FUNÇÃO TEM QUE SER EXATAMENTE ESSE (IGUAL SUA MKB):
function modifier_item_silver_edge_custom_2:GetModifierAttackSpeedBonus_Constant()
    return 70
end

--------------------------------------------------------------------------------
-- INVISIBILIDADE
--------------------------------------------------------------------------------
modifier_item_silver_edge_custom_2_invis = class({})

function modifier_item_silver_edge_custom_2_invis:IsHidden() return false end
function modifier_item_silver_edge_custom_2_invis:IsPurgable() return false end

function modifier_item_silver_edge_custom_2_invis:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_item_silver_edge_custom_2_invis:GetModifierInvisibilityLevel() return 1 end
function modifier_item_silver_edge_custom_2_invis:GetModifierMoveSpeedBonus_Percentage() return 35 end

function modifier_item_silver_edge_custom_2_invis:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() then
        if params.target:IsBuilding() then return end -- Não gasta em torres
        
        ApplyDamage({
            victim = params.target,
            attacker = params.attacker,
            damage = 600,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility()
        })
        
        params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_silver_edge_debuff", {duration = 5})
        params.attacker:EmitSound("DOTA_Item.SilverEdge.Target")
        self:Destroy()
    end
end

function modifier_item_silver_edge_custom_2_invis:CheckState()
    return { [MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
end