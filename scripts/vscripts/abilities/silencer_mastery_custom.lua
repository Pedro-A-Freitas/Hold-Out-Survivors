silencer_mastery_custom = class({})

-- Define que esta é uma habilidade de Ultimate
function silencer_mastery_custom:GetAbilityType()
    return DOTA_ABILITY_TYPE_ULTIMATE
end

-- Define os níveis necessários para upar (6, 12, 18)
function silencer_mastery_custom:GetHeroLevelRequiredToUpgrade()
    local level = self:GetLevel()
    if level == 0 then return 6 end
    if level == 1 then return 12 end
    if level == 2 then return 18 end
    return 999
end

-- Impede o upgrade se o herói não tiver o nível necessário (Garante a trava)
function silencer_mastery_custom:OnUpgrade()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local nLevel = self:GetLevel()
    local hLevel = caster:GetLevel()
    
    -- Tabela de requisitos
    local requirements = {
        [1] = 6,
        [2] = 12,
        [3] = 18
    }
    
    if requirements[nLevel] and hLevel < requirements[nLevel] then
        -- Se o nível do herói for menor que o requisito, volta um nível da skill e devolve o ponto
        self:SetLevel(nLevel - 1)
        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
        
        -- Mensagem de erro na tela (Opcional)
        -- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "display_custom_error", { message = "Nível Insuficiente (6/12/18)" })
    end
end

-- A Skill 2 (Glaives) lê o nível desta habilidade para decidir os Bounces:
-- Nível 1: 1 Bounce
-- Nível 2: 2 Bounces
-- Nível 3: 3 Bounces