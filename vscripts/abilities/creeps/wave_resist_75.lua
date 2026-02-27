wave_resist_75 = class({})

LinkLuaModifier(
    "modifier_wave_resist_75",
    "abilities/creeps/wave_resist_75",
    LUA_MODIFIER_MOTION_NONE
)

function wave_resist_75:GetIntrinsicModifierName()
    return "modifier_wave_resist_75"
end

------------------------------------------------

modifier_wave_resist_75 = class({})

function modifier_wave_resist_75:IsHidden() return true end
function modifier_wave_resist_75:IsPurgable() return false end

function modifier_wave_resist_75:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end

function modifier_wave_resist_75:GetModifierMagicalResistanceBonus()
    return 75
end

function modifier_wave_resist_75:GetModifierStatusResistanceStacking()
    return 75
end