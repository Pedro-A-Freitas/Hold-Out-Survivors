LinkLuaModifier("modifier_item_refresher_custom_2", "items/item_refresher_custom_2", LUA_MODIFIER_MOTION_NONE)

item_refresher_custom_2 = class({})

function item_refresher_custom_2:GetIntrinsicModifierName()
    return "modifier_item_refresher_custom_2"
end

function item_refresher_custom_2:OnSpellStart()
    local caster = self:GetCaster()

    -- Efeito sonoro e visual original
    caster:EmitSound("Item.Refresher.Activate")
    local pfx = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(pfx)

    -- Reseta o Cooldown de todas as habilidades
    for i = 0, caster:GetAbilityCount() - 1 do
        local ability = caster:GetAbilityByIndex(i)
        if ability and ability ~= self then
            ability:EndCooldown()
        end
    end

    -- Reseta o Cooldown de todos os itens (exceto outros Refreshers para evitar loop infinito)
    for i = 0, 8 do
        local item = caster:GetItemInSlot(i)
        if item and item ~= self then
            -- Lista de itens que NÃO podem ser resetados (padrão do Dota)
            if item:GetAbilityName() ~= "item_refresher" and 
               item:GetAbilityName() ~= "item_refresher_shard" and
               item:GetAbilityName() ~= "item_refresher_custom_2" then
                item:EndCooldown()
            end
        end
    end
end

--------------------------------------------------------------------------------
-- PASSIVO (REGENS DOBRADOS)
--------------------------------------------------------------------------------
modifier_item_refresher_custom_2 = class({})

function modifier_item_refresher_custom_2:IsHidden() return true end
function modifier_item_refresher_custom_2:IsPurgable() return false end
function modifier_item_refresher_custom_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_refresher_custom_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_item_refresher_custom_2:GetModifierConstantHealthRegen() return 24 end -- 12(x2)
function modifier_item_refresher_custom_2:GetModifierConstantManaRegen() return 12 end -- 6(x2)