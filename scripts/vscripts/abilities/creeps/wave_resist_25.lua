wave_resist_25 = class({})

LinkLuaModifier(
    "modifier_wave_resist_25",
    "abilities/creeps/wave_resist_25",
    LUA_MODIFIER_MOTION_NONE
)

function wave_resist_25:GetIntrinsicModifierName()
    return "modifier_wave_resist_25"
end

------------------------------------------------

modifier_wave_resist_25 = class({})

function modifier_wave_resist_25:IsHidden() return true end
function modifier_wave_resist_25:IsPurgable() return false end

function modifier_wave_resist_25:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end

function modifier_wave_resist_25:GetModifierMagicalResistanceBonus()
    return 25
end

function modifier_wave_resist_25:GetModifierStatusResistanceStacking()
    return 25
end