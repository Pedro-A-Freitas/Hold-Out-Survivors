skywrath_concussive_shot_custom = class({})

function skywrath_concussive_shot_custom:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

    if #targets > 0 then
        local function Launch(target)
            local info = {
                Target = target,
                Source = caster,
                Ability = ability,
                EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf",
                iMoveSpeed = 800,
                bDodgeable = true
            }
            ProjectileManager:CreateTrackingProjectile(info)
        end

        Launch(targets[1]) -- Primeiro tiro
        
        if caster:HasScepter() and #targets > 1 then
            Launch(targets[2]) -- Segundo tiro do Aghanim
        end
        caster:EmitSound("Hero_SkywrathMage.ConcussiveShot.Cast")
    else
        self:RefundManaCost()
        self:EndCooldown()
    end
end

function skywrath_concussive_shot_custom:OnProjectileHit(target, location)
    if not target then return end
    local caster = self:GetCaster()
    local dmg = 120 + (self:GetLevel() * 80) -- Dano base simples pra testar
    
    target:EmitSound("Hero_SkywrathMage.ConcussiveShot.Target")
    
    local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    for _, unit in pairs(units) do
        ApplyDamage({victim = unit, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
        unit:AddNewModifier(caster, self, "modifier_skywrath_mage_concussive_shot_slow", {duration = 4})
    end
    return true
end