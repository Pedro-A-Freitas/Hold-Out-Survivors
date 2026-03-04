LinkLuaModifier("modifier_item_ethereal_blade_custom_2", "items/item_ethereal_blade_custom_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_custom_2_ethereal", "items/item_ethereal_blade_custom_2", LUA_MODIFIER_MOTION_NONE)

item_ethereal_blade_custom_2 = class({})

function item_ethereal_blade_custom_2:GetIntrinsicModifierName()
    return "modifier_item_ethereal_blade_custom_2"
end

function item_ethereal_blade_custom_2:OnSpellStart()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- Proteção contra alvos nulos ou Linken's
    if not target or target:TriggerSpellAbsorb(self) then return end

    -- Som de ativação
    target:EmitSound("DOTA_Item.EtherealBlade.Target")
    
    -- 1. Aplicar o Ghost Form (Ethereal)
    target:AddNewModifier(caster, self, "modifier_item_ethereal_blade_custom_2_ethereal", { duration = 4.0 })

    -- 2. Pegar os atributos TOTAIS (Base + Itens) usando o parâmetro 'true'
    -- Isso evita o erro "expected 2 arguments" que apareceu no console
    local str = 0
    local agi = 0
    local int = 0

    if caster.GetStrength then str = caster:GetStrength() end
    if caster.GetAgility then agi = caster:GetAgility() end
    if caster.GetIntellect then int = caster:GetIntellect(true) end 
    
    -- Nota: Em algumas versões da API, GetStrength e GetAgility não pedem o 'true' 
    -- mas o GetIntellect sim. Para garantir, vamos usar o cálculo seguro:
    local total_stats = str + agi + int
    local damage_total = total_stats + 100

    -- 3. Atraso de 1 frame para o dano entrar com o amplificador mágico
    caster:SetContextThink(DoUniqueString("eblade_dmg"), function()
        if target and not target:IsNull() and target:IsAlive() then
            local damageTable = {
                victim = target,
                attacker = caster,
                damage = damage_total,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self
            }
            ApplyDamage(damageTable)
            
            -- Print para você conferir no console se o valor está certo agora
            print("Dano da E-Blade aplicado: " .. damage_total)
        end
        return nil
    end, 0.03)
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO (Stats 48)
--------------------------------------------------------------------------------
modifier_item_ethereal_blade_custom_2 = class({})
function modifier_item_ethereal_blade_custom_2:IsHidden() return true end
function modifier_item_ethereal_blade_custom_2:IsPurgable() return false end
function modifier_item_ethereal_blade_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_ethereal_blade_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_item_ethereal_blade_custom_2:GetModifierBonusStats_Strength() return 48 end
function modifier_item_ethereal_blade_custom_2:GetModifierBonusStats_Agility() return 48 end
function modifier_item_ethereal_blade_custom_2:GetModifierBonusStats_Intellect() return 48 end

--------------------------------------------------------------------------------
-- DEBUFF ATIVO (ETHEREAL + SLOW + AMP)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- DEBUFF ATIVO (ETHEREAL + SLOW + AMP)
--------------------------------------------------------------------------------
modifier_item_ethereal_blade_custom_2_ethereal = class({})
function modifier_item_ethereal_blade_custom_2_ethereal:IsDebuff() return true end
function modifier_item_ethereal_blade_custom_2_ethereal:IsPurgable() return true end

function modifier_item_ethereal_blade_custom_2_ethereal:CheckState()
    return {
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end

function modifier_item_ethereal_blade_custom_2_ethereal:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, -- Usando o bônus direto (mais confiável)
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

-- Reduz a resistência em 60 pontos fixos. 
-- Se o inimigo tem 25%, ele vai para -35%. O dano vai ser massivo!
function modifier_item_ethereal_blade_custom_2_ethereal:GetModifierMagicalResistanceBonus()
    return -60
end

function modifier_item_ethereal_blade_custom_2_ethereal:GetModifierMoveSpeedBonus_Percentage()
    return -80
end

function modifier_item_ethereal_blade_custom_2_ethereal:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ethereal_blade_custom_2_ethereal:StatusEffectPriority()
    return 100
end