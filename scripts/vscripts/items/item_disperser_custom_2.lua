LinkLuaModifier("modifier_item_disperser_custom_2", "items/item_disperser_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_disperser_custom_2_active_aura", "items/item_disperser_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_disperser_custom_2_effect", "items/item_disperser_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_disperser_custom_2_caster_buff", "items/item_disperser_custom_2", LUA_MODIFIER_MOTION_NONE)

item_disperser_custom_2 = class({})

function item_disperser_custom_2:GetAOERadius() return 300 end
function item_disperser_custom_2:GetIntrinsicModifierName() return "modifier_item_disperser_custom_2" end

function item_disperser_custom_2:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    caster:EmitSound("DOTA_Item.Disperser.Cast")
    CreateModifierThinker(caster, self, "modifier_item_disperser_custom_2_active_aura", {duration = 6}, point, caster:GetTeamNumber(), false)
    caster:AddNewModifier(caster, self, "modifier_item_disperser_custom_2_caster_buff", {duration = 6})
end

--------------------------------------------------------------------------------
-- MODIFIER PASSIVO (ATRIBUTOS + INJEÇÃO DA SKILL DO AM)
--------------------------------------------------------------------------------
modifier_item_disperser_custom_2 = class({})

function modifier_item_disperser_custom_2:IsHidden() return true end
function modifier_item_disperser_custom_2:IsPurgable() return false end
function modifier_item_disperser_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_disperser_custom_2:OnCreated()
    if not IsServer() then return end
    local parent = self:GetParent()
    -- Se o herói não tem a passiva do AM, a gente adiciona "escondida"
    if not parent:HasAbility("antimage_mana_break") then
        local ab = parent:AddAbility("antimage_mana_break")
        if ab then
            ab:SetLevel(4) -- Level 4 do AM queima 64 de mana (mais perto dos 80 que vc quer)
            ab:SetHidden(true) -- Ninguém vai ver que ela está lá
        end
    end
end

function modifier_item_disperser_custom_2:OnDestroy()
    if not IsServer() then return end
    local parent = self:GetParent()
    -- Quando solta o item, remove a skill do AM (a menos que ele SEJA o AM)
    if parent:GetUnitName() ~= "npc_dota_hero_antimage" then
        parent:RemoveAbility("antimage_mana_break")
    end
end

function modifier_item_disperser_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_item_disperser_custom_2:GetModifierBonusStats_Agility() return 80 end
function modifier_item_disperser_custom_2:GetModifierBonusStats_Intellect() return 20 end

--------------------------------------------------------------------------------
-- BUFFS DE VELOCIDADE (Mantidos)
--------------------------------------------------------------------------------
modifier_item_disperser_custom_2_caster_buff = class({})
function modifier_item_disperser_custom_2_caster_buff:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end
function modifier_item_disperser_custom_2_caster_buff:GetModifierMoveSpeedBonus_Percentage() return 25 end

modifier_item_disperser_custom_2_active_aura = class({})
function modifier_item_disperser_custom_2_active_aura:IsAura() return true end
function modifier_item_disperser_custom_2_active_aura:GetAuraRadius() return 300 end
function modifier_item_disperser_custom_2_active_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_disperser_custom_2_active_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_disperser_custom_2_active_aura:GetModifierAura() return "modifier_item_disperser_custom_2_effect" end

modifier_item_disperser_custom_2_effect = class({})
function modifier_item_disperser_custom_2_effect:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end
function modifier_item_disperser_custom_2_effect:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return 25 else return -25 end
end