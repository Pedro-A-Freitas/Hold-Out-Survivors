modifier_wave_status_res = class({})

function modifier_wave_status_res:IsHidden() return true end
function modifier_wave_status_res:IsPurgable() return false end
function modifier_wave_status_res:RemoveOnDeath() return false end

function modifier_wave_status_res:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end

function modifier_wave_status_res:GetModifierStatusResistanceStacking()
    return 30
end