wave_resist_50 = class({})

LinkLuaModifier(
    "modifier_wave_resist_50",
    "abilities/creeps/wave_resist_50",
    LUA_MODIFIER_MOTION_NONE
)

function wave_resist_50:GetIntrinsicModifierName()
    return "modifier_wave_resist_50"
end

------------------------------------------------

modifier_wave_resist_50 = class({})

function modifier_wave_resist_50:IsHidden() return true end
function modifier_wave_resist_50:IsPurgable() return false end

function modifier_wave_resist_50:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end

function modifier_wave_resist_50:GetModifierMagicalResistanceBonus()
    return 50
end

function modifier_wave_resist_50:GetModifierStatusResistanceStacking()
    return 50
end