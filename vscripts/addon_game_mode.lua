if CAddonTemplateGameMode == nil then
    CAddonTemplateGameMode = class({})
end

local waveAlive = 0
local waveNumber = 1
local waveCooldown = false
local nextWaveTime = nil

function Activate()
    GameRules.AddonTemplate = CAddonTemplateGameMode()
    GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    GameRules:SetTimeOfDay(0.25)
    GameRules:SetUseUniversalShopMode(true)

    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride(true)
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible(false)

    GameRules:SetHeroSelectionTime(25)
    GameRules:SetPreGameTime(10)
    GameRules:SetStrategyTime(10)
    GameRules:SetShowcaseTime(0)

    GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 1)

    players = 0

end

function CAddonTemplateGameMode:OnThink()

    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

        if players == 0 then
            players = PlayerResource:GetPlayerCount()
        end

    end

    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        return 1
    end

    local currentTime = GameRules:GetGameTime()

    if not self.waveStarted then
        self.waveStarted = true
        self:StartWave()
    end

    if nextWaveTime and currentTime >= nextWaveTime then
        nextWaveTime = nil
        self:StartWave()
    end

    if not self.visionApplied then
        self.visionApplied = true
        ApplyVisionToAllHeroes()
    end

    return 0.5
end

function ApplyVisionToAllHeroes()

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do

        if PlayerResource:IsValidPlayerID(playerID) then

            local hero = PlayerResource:GetSelectedHeroEntity(playerID)

            if hero and not hero:IsNull() then

                hero:SetDayTimeVisionRange(1200)
                hero:SetNightTimeVisionRange(1200)

            end
        end
    end
end

function CAddonTemplateGameMode:SpawnEnemy(unitName, amount)

    amount = amount or 1

    -- lista de spawns, você pode adicionar offsets diferentes
    local spawns = {
        Entities:FindByName(nil, "enemy_spawn"),  -- spawn principal
        Entities:FindByName(nil, "enemy_spawn2")  -- segundo spawn
    }

    local goal = Entities:FindByName(nil, "enemy_goal")
    if not goal then
        print("Goal não encontrado")
        return
    end

    for _, spawn in pairs(spawns) do
        if not spawn then
            print("Spawn não encontrado")
        else
            for i = 1, amount do
                -- calcular posição com pequeno deslocamento aleatório para não sobrepor
                local spawnPos = spawn:GetAbsOrigin() + RandomVector(RandomFloat(0, 100))

                local unit = CreateUnitByName(
                    unitName,
                    spawnPos,
                    true,
                    nil,
                    nil,
                    DOTA_TEAM_BADGUYS
                )

                unit:SetMinimumGoldBounty(0)
                unit:SetMaximumGoldBounty(0)
                unit:SetDeathXP(0)
                unit:SetIdleAcquire(false)

                waveAlive = waveAlive + 1

				local upskill1 = unit:FindAbilityByName("tidehunter_kraken_shell")
                if upskill1 then
                    upskill1:SetLevel(4)
                end

				local upskill2 = unit:FindAbilityByName("axe_counter_helix")
                if upskill2 then
                    upskill2:SetLevel(4)
                end

				local upskill3 = unit:FindAbilityByName("antimage_mana_break")
                if upskill3 then
                    upskill3:SetLevel(4)
                end

				local upskill4 = unit:FindAbilityByName("roshan_bash")
                if upskill4 then
                    upskill4:SetLevel(1)
                end

				local upskill5 = unit:FindAbilityByName("troll_warlord_fervor")
                if upskill5 then
                    upskill5:SetLevel(4)
                end

				local upskill6 = unit:FindAbilityByName("juggernaut_blade_dance")
                if upskill6 then
                    upskill6:SetLevel(4)
                end

                local upskill8 = unit:FindAbilityByName("dawnbreaker_luminosity")
                if upskill8 then
                    upskill8:SetLevel(4)
                end

                local upskill12 = unit:FindAbilityByName("spirit_breaker_greater_bash")
                if upskill12 then
                    upskill12:SetLevel(4)
                end

                local upskill13 = unit:FindAbilityByName("sniper_headshot")
                if upskill13 then
                    upskill13:SetLevel(4)
                end

                local upskill14 = unit:FindAbilityByName("slardar_bash")
                if upskill14 then
                    upskill14:SetLevel(4)
                end

                local upskill15 = unit:FindAbilityByName("faceless_void_time_lock")
                if upskill15 then
                    upskill15:SetLevel(4)
                end

                local upskill16 = unit:FindAbilityByName("shredder_reactive_armor")
                if upskill16 then
                    upskill16:SetLevel(4)
                end

                local upskill17 = unit:FindAbilityByName("dragon_knight_dragon_blood")
                if upskill17 then
                    upskill17:SetLevel(4)
                end

                local upskill18 = unit:FindAbilityByName("spectre_dispersion")
                if upskill18 then
                    upskill18:SetLevel(4)
                end

                local upskill20 = unit:FindAbilityByName("skeleton_king_mortal_strike")
                if upskill20 then
                    upskill20:SetLevel(4)
                end

                local upskill21 = unit:FindAbilityByName("sven_great_cleave")
                if upskill21 then
                    upskill21:SetLevel(4)
                end

                local upskill22 = unit:FindAbilityByName("abyssal_underlord_atrophy_aura")
                if upskill22 then
                    upskill22:SetLevel(4)
                end

                local upskill23 = unit:FindAbilityByName("chaos_knight_chaos_strike")
                if upskill23 then
                    upskill23:SetLevel(4)
                end

                local upskill24 = unit:FindAbilityByName("phantom_assassin_immaterial")
                if upskill24 then
                    upskill24:SetLevel(4)
                end

                local upskill25 = unit:FindAbilityByName("legion_commander_moment_of_courage")
                if upskill25 then
                    upskill25:SetLevel(4)
                end

                local upskill26 = unit:FindAbilityByName("elder_titan_natural_order")
                if upskill26 then
                    upskill26:SetLevel(4)
                end

                local upskill27 = unit:FindAbilityByName("venomancer_poison_sting")
                if upskill27 then
                    upskill27:SetLevel(4)
                end

                local upskill28 = unit:FindAbilityByName("medusa_mana_shield")
                if upskill28 then
                    upskill28:SetLevel(1)
                end

                local upskill29 = unit:FindAbilityByName("alchemist_corrosive_weaponry")
                if upskill29 then
                    upskill29:SetLevel(4)
                end

                local upskill30 = unit:FindAbilityByName("riki_backstab")
                if upskill30 then
                    upskill30:SetLevel(3)
                end

                local upskill31 = unit:FindAbilityByName("bristleback_bristleback")
                if upskill31 then
                    upskill31:SetLevel(4)
                end

                local upskill32 = unit:FindAbilityByName("enchantress_untouchable")
                if upskill32 then
                    upskill32:SetLevel(3)
                end

                local upskill33 = unit:FindAbilityByName("pangolier_lucky_shot")
                if upskill33 then
                    upskill33:SetLevel(4)
                end

                local upskill34 = unit:FindAbilityByName("skeleton_king_spectral_blade")
                if upskill34 then
                    upskill34:SetLevel(4)
                end

                local upskill35 = unit:FindAbilityByName("necrolyte_heartstopper_aura")
                if upskill35 then
                    upskill35:SetLevel(4)
                end

                local upskill36 = unit:FindAbilityByName("nevermore_dark_lord")
                if upskill36 then
                    upskill36:SetLevel(4)
                end

                local upskill38 = unit:FindAbilityByName("bloodseeker_thirst")
                if upskill38 then
                    upskill38:SetLevel(4)
                end

                local upskill39 = unit:FindAbilityByName("broodmother_incapacitating_bite")
                if upskill39 then
                    upskill39:SetLevel(4)
                end

                local upskill40 = unit:FindAbilityByName("life_stealer_feast")
                if upskill40 then
                    upskill40:SetLevel(4)
                end

                local upskill41 = unit:FindAbilityByName("naga_siren_rip_tide")
                if upskill41 then
                    upskill41:SetLevel(4)
                end
                
                local upskill43 = unit:FindAbilityByName("phantom_assassin_coup_de_grace")
                if upskill43 then
                    upskill43:SetLevel(3)
                end

                local upskill44 = unit:FindAbilityByName("ursa_fury_swipes")
                if upskill44 then
                    upskill44:SetLevel(4)
                end

                -- Attack move AI
                unit:SetContextThink("WaveAI_"..unit:entindex(), function()

                    if not unit:IsAlive() then return nil end

                    local enemies = FindUnitsInRadius(
                        unit:GetTeam(),
                        unit:GetAbsOrigin(),
                        nil,
                        2000,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO,
                        DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                        FIND_CLOSEST,
                        false
)

                    -- Se existe hero próximo → atacar
                    if #enemies > 0 then

                        ExecuteOrderFromTable({
                            UnitIndex = unit:entindex(),
                            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                            TargetIndex = enemies[1]:entindex(),
                            Queue = false
                        })

                    else

                        -- Caso contrário → seguir wave path
                        ExecuteOrderFromTable({
                            UnitIndex = unit:entindex(),
                            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                            Position = goal:GetAbsOrigin(),
                            Queue = false
                        })

                    end

                    return 0.8

                end, 0.1)

                -- Death watcher
                unit:SetContextThink("DeathWatcher_"..unit:entindex(), function()
                    if not unit:IsAlive() then
                        waveAlive = waveAlive - 1
                        if waveAlive <= 0 then
                            waveAlive = 0
                            GiveWaveReward()
                            EmitGlobalSound("DOTA_Item.Hand_Of_Midas")
                            RefreshAllPlayers()
                            EmitGlobalSound("DOTA_Item.Refresher.Activate")
                            waveNumber = waveNumber + 1
                            nextWaveTime = GameRules:GetGameTime() + 10
                        end
                        return nil
                    end
                    return 1
                end, 1)
            end
        end
    end

end

function GiveWaveReward()

    local rewardGold = 0
    local rewardXP   = 0

    -- Waves 1–20
    if waveNumber >= 1 and waveNumber <= 10 then
        rewardGold = 1000
        rewardXP   = 1000

    elseif waveNumber >= 11 and waveNumber <= 20 then
        rewardGold = 1500
        rewardXP   = 1500

    else
        rewardGold = 2000
        rewardXP   = 2000
    end

    print("Wave "..waveNumber.." recompensa: "..rewardGold.." gold / "..rewardXP.." xp")

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
        if PlayerResource:IsValidPlayerID(playerID) then
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)
            if hero then
                hero:ModifyGold(rewardGold, true, DOTA_ModifyGold_Unspecified)
                hero:AddExperience(rewardXP, DOTA_ModifyXP_Unspecified, false, true)
            end
        end
    end

end

function RefreshAllPlayers()
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) then
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)

            if hero and not hero:IsNull() then

                -- Resetar habilidades
                for i = 0, hero:GetAbilityCount() - 1 do
                    local ability = hero:GetAbilityByIndex(i)
                    if ability and ability:GetLevel() > 0 then
                        ability:EndCooldown()
                    end
                end

                -- Resetar itens
                for i = 0, 8 do
                    local item = hero:GetItemInSlot(i)
                    if item then
                        item:EndCooldown()
                    end
                end

                hero:SetHealth(hero:GetMaxHealth())
                hero:SetMana(hero:GetMaxMana())

                -- Partícula refresher
                local particle = ParticleManager:CreateParticle(
                    "particles/items2_fx/refresher.vpcf",
                    PATTACH_ABSORIGIN_FOLLOW,
                    hero
                )
                ParticleManager:ReleaseParticleIndex(particle)

            end
        end
    end
end

function Precache(context)
    PrecacheResource("particle", "particles/items2_fx/refresher.vpcf", context)
end

function CAddonTemplateGameMode:StartWave()

    print("Spawnando Wave "..waveNumber)

    SpawnWave(waveNumber)

end

function SpawnWave(n)

    if n == 1 then
        SpawnWave1()

    elseif n == 2 then
        SpawnWave2()

    elseif n == 3 then
        SpawnWave3()

    elseif n == 4 then
        SpawnWave4()

    elseif n == 5 then
        SpawnWave5()

    elseif n == 6 then
        SpawnWave6()

    elseif n == 7 then
        SpawnWave7()
    
    elseif n == 8 then
        SpawnWave8()

    elseif n == 9 then
        SpawnWave9()

    elseif n == 10 then
        SpawnWave10()

    elseif n == 11 then
        SpawnWave11()

    elseif n == 12 then
        SpawnWave12()

    elseif n == 13 then
        SpawnWave13()

    elseif n == 14 then
        SpawnWave14()

    elseif n == 15 then
        SpawnWave15()

    elseif n == 16 then
        SpawnWave16()

    elseif n == 17 then
        SpawnWave17()

    elseif n == 18 then
        SpawnWave18()

    elseif n == 19 then
        SpawnWave19()

    elseif n == 20 then
        SpawnWave20()
    
    elseif n == 21 then
        SpawnWave21()
    
    elseif n == 22 then
        SpawnWave22()
    
    elseif n == 23 then
        SpawnWave23()
    
    elseif n == 24 then
        SpawnWave24()

    elseif n == 25 then
        SpawnWave25()

    elseif n == 26 then
        SpawnWave26()

    elseif n == 27 then
        SpawnWave27()

    elseif n == 28 then
        SpawnWave28()

    elseif n == 29 then
        SpawnWave29()

    elseif n == 30 then
        SpawnWave30()

    elseif n == 31 then
        SpawnWave31()

    elseif n == 32 then
        SpawnWave32()

    elseif n == 33 then
        SpawnWave33()

    elseif n == 34 then
        SpawnWave34()

    elseif n == 35 then
        SpawnWave35()
    
    end

end

-- WAVES --

function SpawnWave1()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_kobold_melee_wave1", players)
end

function SpawnWave2()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_creep_melee_wave2")
	GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_creep_range_wave2")
end

function SpawnWave3()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_gnoll_range_wave3")
end

function SpawnWave4()
	GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_golem_melee_wave4")
end

function SpawnWave5()
	GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_summuner_range_wave5")
end

function SpawnWave6()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_dragon_range_wave6")
end

function SpawnWave7()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_siege_range_wave7")
end

function SpawnWave8()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_creep_melee_wave8")
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_creep_range_wave8")
end

function SpawnWave9()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_satyr_range_wave9")
end

function SpawnWave10()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_roshan_melee_wave10")
end

function SpawnWave11()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_priest_range_wave11")
end

function SpawnWave12()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_golem_melee_wave12")
end

function SpawnWave13()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_ghost_range_wave13")
end

function SpawnWave14()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_wolf_melee_wave14")
end

function SpawnWave15()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_harpy_range_wave15")
end

function SpawnWave16()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_centaur_melee_wave16")
end

function SpawnWave17()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_frog_range_wave17")
end

function SpawnWave18()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_kobold_melee_wave18")
end

function SpawnWave19()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_troll_range_wave19")
end

function SpawnWave20()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_roshan_melee_wave20")
end

function SpawnWave21()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_harpy_range_wave21")
end

function SpawnWave22()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_furbolg_melee_wave22")
end

function SpawnWave23()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_dragonspawn_range_wave23")
end

function SpawnWave24()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_satyr_melee_wave24")
end

function SpawnWave25()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_spawn_range_wave25")
end

function SpawnWave26()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_ogre_melee_wave26")
end

function SpawnWave27()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_lizard_range_wave27")
end

function SpawnWave28()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_vulture_melee_wave28")
end

function SpawnWave29()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_lizard_range_wave29")
end

function SpawnWave30()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_roshan_melee_wave30")
end

function SpawnWave31()

    if Wave31Started then return end
    Wave31Started = true

    local waves = {
        {
            "npc_dota_neutral_kobold_melee_wave1"
        },
        {
            "npc_dota_neutral_creep_melee_wave2",
            "npc_dota_neutral_creep_range_wave2"
        },
        {
            "npc_dota_neutral_gnoll_range_wave3"
        },
        {
            "npc_dota_neutral_golem_melee_wave4"
        },
        {
            "npc_dota_neutral_summuner_range_wave5"
        },
        {
            "npc_dota_neutral_dragon_range_wave6"
        },
        {
            "npc_dota_neutral_siege_range_wave7"
        },
        {
            "npc_dota_neutral_creep_melee_wave8",
            "npc_dota_neutral_creep_range_wave8"
        },
        {
            "npc_dota_neutral_satyr_range_wave9"
        },
        {
            "npc_dota_neutral_roshan_melee_wave10"
        }
    }

    local index = 1
    local spawnDelay = 5

    GameRules:GetGameModeEntity():SetContextThink("Wave31Think", function()

        if index > #waves then
            return nil
        end

        for _, unitName in ipairs(waves[index]) do
            GameRules.AddonTemplate:SpawnEnemy(unitName, 1)
        end

        index = index + 1

        return spawnDelay

    end, 0)

end

function SpawnWave32()

    if Wave32Started then return end
    Wave32Started = true

    local waves = {
        {
            "npc_dota_neutral_priest_range_wave11"
        },
        {
            "npc_dota_neutral_golem_melee_wave12"
        },
        {
            "npc_dota_neutral_ghost_range_wave13"
        },
        {
            "npc_dota_neutral_wolf_melee_wave14"
        },
        {
            "npc_dota_neutral_harpy_range_wave15"
        },
        {
            "npc_dota_neutral_centaur_melee_wave16"
        },
        {
            "npc_dota_neutral_frog_range_wave17"
        },
        {
            "npc_dota_neutral_kobold_melee_wave18"
        },
        {
            "npc_dota_neutral_troll_range_wave19"
        },
        {
            "npc_dota_neutral_roshan_melee_wave20"
        }
    }

    local index = 1
    local spawnDelay = 5

    GameRules:GetGameModeEntity():SetContextThink("Wave32Think", function()

        if index > #waves then
            return nil
        end

        for _, unitName in ipairs(waves[index]) do
            GameRules.AddonTemplate:SpawnEnemy(unitName, 1)
        end

        index = index + 1

        return spawnDelay

    end, 0)

end

function SpawnWave33()

    if Wave33Started then return end
    Wave33Started = true

    local waves = {
        {
            "npc_dota_neutral_harpy_range_wave21"
        },
        {
            "npc_dota_neutral_furbolg_melee_wave22"
        },
        {
            "npc_dota_neutral_dragonspawn_range_wave23"
        },
        {
            "npc_dota_neutral_satyr_melee_wave24"
        },
        {
            "npc_dota_neutral_spawn_range_wave25"
        },
        {
            "npc_dota_neutral_ogre_melee_wave26"
        },
        {
            "npc_dota_neutral_lizard_range_wave27"
        },
        {
            "npc_dota_neutral_vulture_melee_wave28"
        },
        {
            "npc_dota_neutral_lizard_range_wave29"
        },
        {
            "npc_dota_neutral_roshan_melee_wave30"
        }
    }

    local index = 1
    local spawnDelay = 5

    GameRules:GetGameModeEntity():SetContextThink("Wave33Think", function()

        if index > #waves then
            return nil
        end

        for _, unitName in ipairs(waves[index]) do
            GameRules.AddonTemplate:SpawnEnemy(unitName, 1)
        end

        index = index + 1

        return spawnDelay

    end, 0)

end

function SpawnWave34()
    GameRules.AddonTemplate:SpawnEnemy("npc_dota_neutral_dragon_range_wave34")
end