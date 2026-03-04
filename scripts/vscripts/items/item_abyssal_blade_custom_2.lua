LinkLuaModifier("modifier_item_abyssal_blade_custom_2", "items/item_abyssal_blade_custom_2", LUA_MODIFIER_MOTION_NONE)

item_abyssal_blade_custom_2 = class({})

function item_abyssal_blade_custom_2:GetIntrinsicModifierName()
    return "modifier_item_abyssal_blade_custom_2"
end

-- EFEITO ATIVO (Cooldown de 35s visual no item)
function item_abyssal_blade_custom_2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then return end

    target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
    target:AddNewModifier(caster, self, "modifier_bashed", {duration = 1.5})
    
    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = 240,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    })
end

--------------------------------------------------------------------------------
-- MODIFICADOR PASSIVO
--------------------------------------------------------------------------------
modifier_item_abyssal_blade_custom_2 = class({})

function modifier_item_abyssal_blade_custom_2:IsHidden() return true end
function modifier_item_abyssal_blade_custom_2:IsPurgable() return false end
function modifier_item_abyssal_blade_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_abyssal_blade_custom_2:OnCreated()
    self.last_bash_time = 0
    self.bash_cooldown = 2.5 -- Cooldown interno da passiva
end

function modifier_item_abyssal_blade_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_SLOW_RESISTANCE_STACKING,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_item_abyssal_blade_custom_2:GetModifierPreAttack_BonusDamage() return 70 end
function modifier_item_abyssal_blade_custom_2:GetModifierBonusStats_Strength() return 52 end
function modifier_item_abyssal_blade_custom_2:GetModifierHPRegenAmplify_Percentage() return 30 end
function modifier_item_abyssal_blade_custom_2:GetModifierSlowResistance_Stacking() return 35 end

-- EFEITO PASSIVO: BASH COM COOLDOWN INTERNO
function modifier_item_abyssal_blade_custom_2:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and not params.target:IsBuilding() and not params.target:IsOther() then
        
        -- Verifica se o tempo atual permite um novo Bash (ignora o cooldown da ativa)
        local time_now = GameRules:GetGameTime()
        if time_now >= (self.last_bash_time + self.bash_cooldown) then
            
            local chance = 35
            if params.attacker:IsRangedAttacker() then
                chance = 15
            end

            if RollPercentage(chance) then
                -- Registra o tempo do último bash
                self.last_bash_time = time_now
                
                params.target:EmitSound("DOTA_Item.AbyssalBlade.Target")
                params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_bashed", {duration = 1.5})
                
                ApplyDamage({
                    victim = params.target,
                    attacker = params.attacker,
                    damage = 240,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                })
            end
        end
    end
end