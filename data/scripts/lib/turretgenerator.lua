function TurretGenerator.addSpecialties(rand, turret, type)

    turret:updateStaticStats()

    local specialties = {}
   
    -- direct specilistation need to be inserted here

    for _, s in pairs(possibleSpecialties[type]) do
        table.insert(specialties, s)
    end
    local firstWeapon = turret:getWeapons()
    local maxNumSpecialties = rand:getInt(0, 1 + math.modf(firstWeapon.rarity.value / 2)) -- round to zero

    -- select unique
    if maxNumSpecialties < #specialties then
        local tmp = {}
        while tablelength(tmp) < maxNumSpecialties do
            local element = specialties[rand:getInt(1, #specialties)]
            tmp[element] = element
        end

        specialties = {}
        for _, s in pairs(tmp) do
            table.insert(specialties, s)
        end
    end

    if type == WeaponType.PointDefenseChainGun or type == WeaponType.PointDefenseLaser or type == WeaponType.AntiFighter then
        table.insert(specialties, Specialty.AutomaticFire)
    elseif rand:test(0.5) then
        table.insert(specialties, Specialty.AutomaticFireDPSReduced)
    end

    if type == WeaponType.LRM or type == WeaponType.SRM  then
        table.insert(specialties, Specialty.AutomaticFire)
    end

    table.sort(specialties)

  
    for a, s in pairs(specialties) do
        print(a)
    end

    -- this is a random number between 0 and 1, with a tendency to be higher when the rarity is higher
    local rarityFactor = rand:getFloat(0, turret.rarity.value / HighestRarity().value)

    local weapons = {turret:getWeapons()}

    for _, s in pairs(specialties) do
        if s == Specialty.AutomaticFire then
            turret.automatic = true
            turret.coaxial = false
        elseif s == Specialty.AutomaticFireDPSReduced then
            turret.automatic = true
            turret.coaxial = false
            local factor = 0.9

            for _, weapon in pairs(weapons) do
                weapon.damage = weapon.damage * factor

                if weapon.shieldRepair ~= 0 then
                    weapon.shieldRepair = weapon.shieldRepair * factor
                end

                if weapon.hullRepair ~= 0 then
                    weapon.hullRepair = weapon.hullRepair * factor
                end
            end
        
        elseif s == Specialty.ExtendedRange then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            for _, weapon in pairs(weapons) do
                weapon.reach = weapon.reach * (1 + increase)
                
            end

            local addition = math.floor(increase * 100)
            turret:addDescription("Extended Range: %s%% Range"%_T, string.format("%+i", addition))
           
        elseif s == Specialty.Dampener then
            local maxIncrease = 0.25
            local increase = 0.15 + rarityFactor * maxIncrease

            for _, weapon in pairs(weapons) do
                weapon.recoil = weapon.recoil * (1 - increase)
                
            end

            local addition = math.floor(increase * 100)
            turret:addDescription("Advanced Dampener: -%s%% Recoil"%_T, string.format("%-i", addition))
        elseif s == Specialty.Hypercharged then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            turret.heatPerShot =  turret.heatPerShot  * (1 + increase)
            for _, weapon in pairs(weapons) do
                weapon.damage = weapon.damage * (1 + increase)
            end
            local addition = math.floor(increase * 100)
            turret:addDescription("Hypercharge: %s%% Energydrain and Damage"%_T, string.format("%+i", addition))

        elseif s == Specialty.Efficient then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            turret.heatPerShot =  turret.heatPerShot  * (1 - increase)

            local addition = math.floor(increase * 100)
            turret:addDescription("Efficient: -%s%% Energydrain"%_T, string.format("%-i", addition))
        elseif s == Specialty.ArmorShred then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            local percentage
            for _, weapon in pairs(weapons) do
                weapon.hullDamageMultiplicator = weapon.hullDamageMultiplicator + increase
                if percentage == nil then percentage = weapon.hullDamageMultiplicator end
            end

            percentage = math.floor(percentage * 100 - 100 + 0.00001) -- TODO rounding
            turret:addDescription("ArmorShred: %s%% Hulldamage"%_T, string.format("%+i", percentage))
        elseif s == Specialty.ShieldShred then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            local percentage
            for _, weapon in pairs(weapons) do
                weapon.shieldDamageMultiplicator = weapon.shieldDamageMultiplicator + increase
                if percentage == nil then percentage = weapon.shieldDamageMultiplicator end
            end

            percentage = math.floor(percentage * 100 - 100)
            turret:addDescription("Shieldshred: %s%% Shielddamage"%_T, string.format("%+i", percentage))
        elseif s == Specialty.HighExplosiv then
            local maxIncrease = 0.15
            local increase = 0.05 + rarityFactor * maxIncrease

            local percentage
            for _, weapon in pairs(weapons) do
                weapon.explosionRadius =  weapon.explosionRadius * (1+increase)
            end

            local addition = math.floor(increase * 100)
            turret:addDescription("HighExplosiv: %s%% Explosionradius"%_T, string.format("%+i", addition))
        elseif s == Specialty.ShieldPenetration then
            local maxChance = 0.1
            local chance = 0.1 + rarityFactor * maxChance

            for _, weapon in pairs(weapons) do
                weapon.shieldPenetration = chance
            end

            local percentage = math.floor(chance * 100 + 0.0000001) -- TODO rounding
            turret:addDescription("Shieldpenetration: %s%% Penetrationchance"%_T, string.format("%i", percentage))
        elseif s == Specialty.Coax then
            turret.automatic = false
            turret.coaxial = true
            for _, weapon in pairs(weapons) do
                weapon.damage = weapon.damage * (1 + 0.5)
            end
        end
    end
    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        turret:addWeapon(weapon)
    end
end
function TurretGenerator.getScale(type, tech)
    for _, scale in pairs(scales[type]) do
        if tech >= scale.from and tech <= scale.to then return scale end
    end

    return {from = 0, to = 0, size = 1, usedSlots = 1}
end
function TurretGenerator.scale(rand, turret, type, tech, turnSpeedFactor)
    local scaleTech = tech
    if rand:test(0.5) then
        scaleTech = math.floor(math.max(1, scaleTech * rand:getFloat(0, 1)))
    end

    local scale = TurretGenerator.getScale(type, scaleTech)
    turret.size = scale.size
    turret.slots = scale.usedSlots
    turret.turningSpeed = lerp(turret.size, 0.5, 3, 1, 0.3) * rand:getFloat(0.8, 1.2) * turnSpeedFactor

    local weapons = {turret:getWeapons()}
    local nrWeapons= #weapons
    local dmgMod = 1
    if nrWeapons >1 then
        dmgMod = ((nrWeapons*0.05 )+1) / nrWeapons
        print("DMG MOD: ".. dmgMod .. " nrWeapon: " .. nrWeapons)
    end

    for _, weapon in pairs(weapons) do
        weapon.localPosition = weapon.localPosition * scale.size
        weapon.shotsFired= nrWeapons
       
            -- scale damage, etc. linearly with amount of used slots
            if weapon.damage ~= 0 then
                weapon.damage = weapon.damage * scale.usedSlots * (1+ (tech/52)) * dmgMod
            end

            if weapon.hullRepair ~= 0 then
                weapon.hullRepair = weapon.hullRepair * scale.usedSlots * (1+ (tech/52)) *dmgMod
            end

            if weapon.shieldRepair ~= 0 then
                weapon.shieldRepair = weapon.shieldRepair * scale.usedSlots * (1+ (tech/52))*dmgMod
            end

            if weapon.selfForce ~= 0 then
                weapon.selfForce = weapon.selfForce * scale.usedSlots* (1+ (tech/52))
            end

            if weapon.otherForce ~= 0 then
                weapon.otherForce = weapon.otherForce * scale.usedSlots * (1+ (tech/52)) 
            end

            
            local increase = 0
            if type == WeaponType.Miner or type == WeaponType.DeepCoreMiner then
                -- mining and salvaging laser reach is scaled more
                increase = (scale.usedSlots - 1) * 0.5
            else
                -- scale reach a little
                increase = (scale.usedSlots - 1) * 0.15
            end

            weapon.reach = weapon.reach * (1 + increase)

            local shotSizeFactor = scale.size * 2
            if weapon.isProjectile then weapon.psize = weapon.psize * shotSizeFactor end
            if weapon.isBeam then weapon.bwidth = weapon.bwidth * shotSizeFactor end
        

    end

    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        turret:addWeapon(weapon)
    end
end

Specialty = {
    AutomaticFire = 0,
    AutomaticFireDPSReduced = 1,
    ExtendedRange = 2,
    Dampener = 3,
    Hypercharged =4,
    Efficient =5,
    ArmorShred=6,
    HighExplosiv=7,
    ShieldShred=8,
    ShieldPenetration=9,
    Coax=10,
}


scales[WeaponType.Schienenkanone] = {
    {from = 0, to = 28, size = 1.0, usedSlots = 2},
    {from = 29, to = 35, size = 1.5, usedSlots = 3},
    {from = 36, to = 42, size = 2.0, usedSlots = 4},
    {from = 43, to = 49, size = 3.0, usedSlots = 6},
    {from = 50, to = 52, size = 4, usedSlots = 8},
}
scales[WeaponType.Blaster] = {
    {from = 0, to = 30, size = 0.5, usedSlots = 1},
    {from = 31, to = 39, size = 1.0, usedSlots = 2},
    {from = 40, to = 48, size = 1.5, usedSlots = 3},
    {from = 49, to = 52, size = 2.0, usedSlots = 4},
}
scales[WeaponType.HCG] = {
    {from = 0, to = 30, size = 0.5, usedSlots = 1},
    {from = 31, to = 39, size = 1.0, usedSlots = 2},
    {from = 40, to = 48, size = 1.5, usedSlots = 3},
    {from = 49, to = 52, size = 2.0, usedSlots = 4},
}
scales[WeaponType.Judgement] = {
    {from = 0, to = 48, size = 1.0, usedSlots = 2},
    {from = 29, to = 35, size = 1.5, usedSlots = 3},
    {from = 36, to = 42, size = 2.0, usedSlots = 4},
    {from = 43, to = 49, size = 3.0, usedSlots = 5},
    {from = 50, to = 52, size = 10, usedSlots = 20},
}
scales[WeaponType.Autocannon] = {
    {from = 0, to = 12, size = 0.5, usedSlots = 1},
    {from = 13, to = 30, size = 1.0, usedSlots = 2},
    {from = 31, to = 49, size = 1.5, usedSlots = 3},
    {from = 50, to = 52, size = 3.5, usedSlots = 6},
}
scales[WeaponType.Artillery] = {
    {from = 0, to = 12, size = 1.5, usedSlots = 2},
    {from = 13, to = 30, size = 2.5, usedSlots = 4},
    {from = 31, to = 49, size = 3, usedSlots = 6},
    {from = 50, to = 52, size = 5, usedSlots = 8},
}
scales[WeaponType.PPC] = {
    {from = 0, to = 12, size = 1.5, usedSlots = 2},
    {from = 13, to = 30, size = 2.5, usedSlots = 4},
    {from = 31, to = 49, size = 3, usedSlots = 6},
    {from = 50, to = 52, size = 5, usedSlots = 8},
}
scales[WeaponType.LRM] = {
    {from = 0, to = 12, size = 0.5, usedSlots = 1},
    {from = 13, to = 30, size = 1.0, usedSlots = 2},
    {from = 31, to = 49, size = 1.5, usedSlots = 3},
    {from = 50, to = 52, size = 3.5, usedSlots = 6},
}
scales[WeaponType.SRM] = {
    {from = 0, to = 12, size = 0.5, usedSlots = 1},
    {from = 13, to = 30, size = 1.0, usedSlots = 2},
    {from = 31, to = 49, size = 1.5, usedSlots = 3},
    {from = 50, to = 52, size = 2.5, usedSlots = 4},
}
scales[WeaponType.Beamlaser] = {
    {from = 0, to = 28, size = 1.0, usedSlots = 1},
    {from = 29, to = 35, size = 1.5, usedSlots = 2},
    {from = 36, to = 48, size = 2.0, usedSlots = 4},
    {from = 49, to = 52, size = 3.0, usedSlots = 6},
}
scales[WeaponType.Pulselaser] = {
    {from = 0, to = 30, size = 0.5, usedSlots = 1},
    {from = 31, to = 39, size = 1.0, usedSlots = 2},
    {from = 40, to = 48, size = 1.5, usedSlots = 3},
    {from = 49, to = 52, size = 2.0, usedSlots = 4},
}
scales[WeaponType.Miner] = {
    {from = 0, to = 12, size = 0.5, usedSlots = 1},
    {from = 13, to = 30, size = 1.0, usedSlots = 2},
    {from = 31, to = 49, size = 1.5, usedSlots = 3},
    {from = 50, to = 52, size = 3.5, usedSlots = 6},
}
scales[WeaponType.DeepCoreMiner] = {
    {from = 0, to = 12, size = 2, usedSlots = 4},
    {from = 13, to = 30, size = 3, usedSlots = 6},
    {from = 31, to = 49, size = 4.5, usedSlots = 12},
    {from = 50, to = 52, size = 6, usedSlots = 16},
}
scales[WeaponType.Salvager] = {
    {from = 0, to = 12, size = 0.5, usedSlots = 1},
    {from = 13, to = 30, size = 1.0, usedSlots = 2},
    {from = 31, to = 49, size = 1.5, usedSlots = 3},
    {from = 50, to = 52, size = 3.5, usedSlots = 6},
}
scales[WeaponType.Redeemer] = {
    {from = 0, to = 12, size = 2, usedSlots = 4},
    {from = 13, to = 30, size = 3, usedSlots = 6},
    {from = 31, to = 49, size = 4.5, usedSlots = 12},
    {from = 50, to = 52, size = 6, usedSlots = 16},
}
scales[WeaponType.TorpedoLauncher] = {
    {from = 0, to = 12, size = 1.5, usedSlots = 2},
    {from = 13, to = 30, size = 2.5, usedSlots = 4},
    {from = 31, to = 49, size = 3, usedSlots = 6},
    {from = 50, to = 52, size = 5, usedSlots = 8},
}
scales[WeaponType.LBX] = {
    {from = 0, to = 12, size = 1.5, usedSlots = 2},
    {from = 13, to = 30, size = 2.5, usedSlots = 4},
    {from = 31, to = 49, size = 3, usedSlots = 6},
    {from = 50, to = 52, size = 5, usedSlots = 8},
}

possibleSpecialties[WeaponType.Judgement] = {
}
possibleSpecialties[WeaponType.SRM] = {
    Specialty.ArmorShred,
    Specialty.HighExplosiv,
    Specialty.ShieldPenetration,

}
possibleSpecialties[WeaponType.LRM] = {
    Specialty.ArmorShred,
    Specialty.HighExplosiv,
    Specialty.ShieldPenetration,
}
possibleSpecialties[WeaponType.Blaster] = {
    Specialty.ExtendedRange,
    Specialty.Hypercharged,
    Specialty.Efficient,
    Specialty.ShieldShred,
}
possibleSpecialties[WeaponType.Schienenkanone] = {
    Specialty.ExtendedRange,
    Specialty.Dampener,
    Specialty.Hypercharged,
    Specialty.Efficient,
    Specialty.Coax
}
possibleSpecialties[WeaponType.Autocannon] = {
    Specialty.ExtendedRange,
    Specialty.ArmorShred,
}
possibleSpecialties[WeaponType.Artillery] = {
    Specialty.ExtendedRange,
    Specialty.Dampener,
    Specialty.ArmorShred,
    Specialty.HighExplosiv,
    Specialty.Coax
}
possibleSpecialties[WeaponType.PPC] = {
    Specialty.ExtendedRange,
    Specialty.Dampener,
    Specialty.Hypercharged,
    Specialty.Efficient,
    Specialty.HighExplosiv,
    Specialty.ShieldShred,
    Specialty.Coax
}
possibleSpecialties[WeaponType.Miner] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
}
possibleSpecialties[WeaponType.DeepCoreMiner] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
    Specialty.Hypercharged,
}
possibleSpecialties[WeaponType.Salvager] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
}
possibleSpecialties[WeaponType.Redeemer] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
    Specialty.Hypercharged,
}
possibleSpecialties[WeaponType.Beamlaser] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
    Specialty.Hypercharged,
    Specialty.ShieldShred,
}
possibleSpecialties[WeaponType.Pulselaser] = {
    Specialty.ExtendedRange,
    Specialty.Efficient,
    Specialty.Hypercharged,
    Specialty.ShieldShred,
}
possibleSpecialties[WeaponType.TorpedoLauncher] = {
    Specialty.ArmorShred,
    Specialty.HighExplosiv,
}
possibleSpecialties[WeaponType.LBX] = {
    Specialty.ArmorShred,
    Specialty.Dampener,
    Specialty.ExtendedRange,
    Specialty.Coax
}
possibleSpecialties[WeaponType.HCG] = {
    Specialty.ArmorShred,
    Specialty.ExtendedRange,
}






function TurretGenerator.generateBlaster(rand, dps, tech, material, rarity)
    local result = TurretTemplate()
    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

  
    -- generate weapons
    local dmgMod=  1.4
    local weapons = {2, 2, 2, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateBlaster(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 100 *dps -- 
    local capacity= 10
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)

    TurretGenerator.scale(rand, result, WeaponType.Blaster, tech, 0.75)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Blaster)



    return result
end

function TurretGenerator.generateSchienenkanone(rand, dps, tech, material, rarity)

    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.8
    local weapons = {1, 1, 2, 3}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateSchienenkanone(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 120* dps
    local capacity = 5-- number of shots
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)

    TurretGenerator.scale(rand, result, WeaponType.Schienenkanone, tech, 0.4)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Schienenkanone)
    return result
end

function TurretGenerator.generateJudgement(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local numWeapons = 1

    local weapon = WeaponGenerator.generateJudgement(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons

    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local shootingTime = 10 
    local coolingTime = 360
    TurretGenerator.createStandardCooling(result, coolingTime, shootingTime)

    TurretGenerator.scale(rand, result, WeaponType.Judgement, tech, 0.1)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Judgement)

    return result
end
function TurretGenerator.generateLRM(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.3
    local weapons = {1, 1, 2, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateLRM(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    TurretGenerator.scale(rand, result, WeaponType.LRM, tech, 0.6)
    TurretGenerator.addSpecialties(rand, result, WeaponType.LRM)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateTorpedoLauncher(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  3
    local weapons = {1, 1, 1, 2, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateTorpedoLauncher(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local capacity= 3
    TurretGenerator.createCoolDownDynamic(result, capacity, 0.4)
    
    TurretGenerator.scale(rand, result, WeaponType.TorpedoLauncher, tech, 0.3)
    TurretGenerator.addSpecialties(rand, result, WeaponType.TorpedoLauncher)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateSRM(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.8
    local weapons = {2, 2, 4, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateSRM(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    TurretGenerator.scale(rand, result, WeaponType.SRM, tech, 0.6)
    TurretGenerator.addSpecialties(rand, result, WeaponType.SRM)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateArtillery(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  1
    local weapons = {1, 1, 1, 2}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateArtillery(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)


    TurretGenerator.scale(rand, result, WeaponType.Artillery, tech, 0.3)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Artillery)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generatePPC(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    result:addDescription("Energy Explosion on impact","")
    result:addDescription("High damage to shields","")
    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.9
    local weapons = {1, 1, 1, 2, 2}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generatePPC(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 300* dps
    local capacity = 5-- number of shots
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)



    TurretGenerator.scale(rand, result, WeaponType.PPC, tech, 0.5)
    TurretGenerator.addSpecialties(rand, result, WeaponType.PPC)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateAutocannon(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  1
    local weapons = {1, 2, 3, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateAutocannon(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    TurretGenerator.scale(rand, result, WeaponType.Autocannon, tech, 1)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Autocannon)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateMiner(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Miner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.5
    local numWeapons = 1

    local weapon = WeaponGenerator.generateMiner(rand, dps, tech, material, rarity)
    weapon.damage = weapon.damage / numWeapons 
    weapon.damage = weapon.damage * dmgMod

    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local percentage = math.floor(weapon.stoneDamageMultiplicator * 100)
    result:addDescription("%s%% Damage to Stone"%_T, string.format("%+i", percentage))


    local energyMultiplayer = 25 *dps -- 
    local capacity= 10
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)

    TurretGenerator.scale(rand, result, WeaponType.Miner, tech, 1)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Miner)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateDeepCoreMiner(rand, dps, tech, material, rarity)
    local result = TurretTemplate()
    

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew*2, CrewMan(CrewProfessionType.Miner))
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Repair))
    result.crew = crew

    -- generate weapons
    local numWeapons = 1
    local dmgMod=  0.75

    local weapon = WeaponGenerator.generateDeepCoreMiner(rand, dps, tech, material, rarity)
    weapon.damage = weapon.damage / numWeapons
    weapon.damage = weapon.damage * dmgMod

    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local percentage = math.floor(weapon.stoneDamageMultiplicator * 100)
    result:addDescription("%s%% Damage to Stone"%_T, string.format("%+i", percentage))

    local energyMultiplayer = 1000
    local finalenergyMultiplayer = TurretGenerator.getEnergyDrainFactorMining(result, dps,material, energyMultiplayer)
    local capacity = 10-- number of shots
    TurretGenerator.createBatteryDrainConstant(result, finalenergyMultiplayer, capacity)

    TurretGenerator.scale(rand, result, WeaponType.DeepCoreMiner, tech, 0.5)
    TurretGenerator.addSpecialties(rand, result, WeaponType.DeepCoreMiner)

    result:updateStaticStats()

    return result
end


function TurretGenerator.generateBeamlaser(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.7
    local weapons = {1, 2}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateBeamlaser(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod

    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 200 *dps -- 
    local capacity= 10
    TurretGenerator.createBatteryDrainDynamic(result, energyMultiplayer, capacity, 0.66)

    -- attach weapons to turret
    TurretGenerator.scale(rand, result, WeaponType.Pulselaser, tech, 1)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Pulselaser)

    result:updateStaticStats()
    return result
end

function TurretGenerator.generatePulselaser(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  1.7
    local weapons = {1, 2, 3}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generatePulselaser(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod

    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 200 *dps -- 
    local capacity= 10
    TurretGenerator.createBatteryDrainDynamic(result, energyMultiplayer, capacity, 0.5)

    -- attach weapons to turret
    TurretGenerator.scale(rand, result, WeaponType.Pulselaser, tech, 1.5)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Pulselaser)

    result:updateStaticStats()
    return result
end

function TurretGenerator.generateSalvager(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Miner))
    result.crew = crew

    -- generate weapons
    local weapons = {1, 1, 2, 2 , 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]
    local dmgMod=  0.6

    local weapon = WeaponGenerator.generateSalvager(rand, dps, tech, material, rarity)
    weapon.damage = weapon.damage / numWeapons
    weapon.damage = weapon.damage * dmgMod

    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    -- normal mining lasers don't need cooling

    
    local energyMultiplayer = 10 *dps -- 
    local capacity= 50
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)


    TurretGenerator.scale(rand, result, WeaponType.Salvager, tech, 1)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Salvager)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateRedeemer(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Miner))
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Repair))
    result.crew = crew

    -- generate weapons
    local weapons = {1, 1, 1, 2}
    local numWeapons = weapons[rand:getInt(1, #weapons)]
    local dmgMod=  1

    local weapon = WeaponGenerator.generateRedeemer(rand, dps, tech, material, rarity)
    weapon.damage = weapon.damage / numWeapons
    weapon.damage = weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    
    local energyMultiplayer = 400 *dps -- 
    local capacity= 20
    TurretGenerator.createBatteryDrainConstant(result, energyMultiplayer, capacity)
    -- normal mining lasers don't need cooling
    TurretGenerator.scale(rand, result, WeaponType.Redeemer, tech, 0.5)
    TurretGenerator.addSpecialties(rand, result, WeaponType.Redeemer)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generatePointDefenseChaingunTurret(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local numWeapons = rand:getInt(1,4)
    local dmgMod=  1

    local weapon = WeaponGenerator.generatePointDefenseChaingun(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage = weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    -- chainguns don't need cooling
    TurretGenerator.scale(rand, result, WeaponType.PointDefenseChainGun, tech, 2)
    TurretGenerator.addSpecialties(rand, result, WeaponType.PointDefenseChainGun)


    result:addDescription("Increased Damage to Fighters + Torpedoes"%_T, "")

    result:updateStaticStats()

    return result
end

function TurretGenerator.generatePointDefenseLaserTurret(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    local dmgMod=  2
    local numWeapons = 1

    local weapon = WeaponGenerator.generatePointDefenseLaser(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage = weapon.damage * dmgMod

    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local energyMultiplayer = 200 *rarity.value -- 
    local capacity= 100
    TurretGenerator.createBatteryDrainDynamic(result, energyMultiplayer, capacity, 0.5)

    TurretGenerator.scale(rand, result, WeaponType.PointDefenseLaser, tech, 2)
    TurretGenerator.addSpecialties(rand, result, WeaponType.PointDefenseLaser)

    result:addDescription("Increased Damage to Fighters + Torpedoes"%_T, "")

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateLBX(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  500
    local weapons = {1}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateLBX(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    local capacity= 20
    TurretGenerator.createCoolDownDynamic(result, capacity, 0.002)

    TurretGenerator.scale(rand, result, WeaponType.LBX, tech, 0.6)
    TurretGenerator.addSpecialties(rand, result, WeaponType.LBX)

    result:updateStaticStats()

    return result
end

function TurretGenerator.generateHCG(rand, dps, tech, material, rarity)
    local result = TurretTemplate()

    -- generate turret
    local requiredCrew = TurretGenerator.dpsToRequiredCrew(dps)
    local crew = Crew()
    crew:add(requiredCrew, CrewMan(CrewProfessionType.Gunner))
    result.crew = crew

    -- generate weapons
    local dmgMod=  0.8
    local weapons = {2, 2, 4, 4}
    local numWeapons = weapons[rand:getInt(1, #weapons)]

    local weapon = WeaponGenerator.generateHCG(rand, dps, tech, material, rarity)
    weapon.fireDelay = weapon.fireDelay * numWeapons
    weapon.damage= weapon.damage * dmgMod
    -- attach weapons to turret
    TurretGenerator.attachWeapons(rand, result, weapon, numWeapons)

    TurretGenerator.scale(rand, result, WeaponType.HCG, tech, 4)
    TurretGenerator.addSpecialties(rand, result, WeaponType.HCG)

    result:updateStaticStats()

    return result
end


function TurretGenerator.getEnergyDrainFactorMining(turret, dps,material, modifier)
    local drainmod = turret.slots * dps * ((material.value*2)+1) * modifier
    return drainmod
end

function TurretGenerator.createBatteryDrainConstant(turret, energyfactor, capacity)
    TurretGenerator.createBatteryDrainDynamic(turret, energyfactor, capacity, 1.1)
end

function TurretGenerator.createBatteryDrainDynamic(turret, energyfactor, capacity, uptime)
    turret:updateStaticStats()
    
    

    turret.coolingType = CoolingType.BatteryCharge
    -- how many shots till empty
    turret.maxHeat = (1/turret.firingsPerSecond) * capacity * energyfactor
    -- 
    local heatPerShot= (1/turret.firingsPerSecond) * energyfactor
    turret.heatPerShot = heatPerShot
    turret.coolingRate = energyfactor * uptime
    turret:addDescription("Drains ".. round((turret.heatPerShot/1000),2) .." GWs per Shot. (".. round((energyfactor/1000),2) .."per second)","")
end

function TurretGenerator.createCoolDownDynamic(turret, capacity, uptime)
    turret:updateStaticStats()

    turret.coolingType = CoolingType.Standard
    -- how many shots till empty
    turret.maxHeat = (1/turret.firingsPerSecond) * capacity   -- 0.02
    -- 
    local heatPerShot= (1/turret.firingsPerSecond)  -- 0.001
    turret.heatPerShot = heatPerShot  -- 0.001
    turret.coolingRate =  uptime --
end


generatorFunction[WeaponType.Blaster] = TurretGenerator.generateBlaster
generatorFunction[WeaponType.Schienenkanone] = TurretGenerator.generateSchienenkanone
generatorFunction[WeaponType.LRM] = TurretGenerator.generateLRM
generatorFunction[WeaponType.SRM] = TurretGenerator.generateSRM
generatorFunction[WeaponType.Autocannon] = TurretGenerator.generateAutocannon
generatorFunction[WeaponType.Artillery] = TurretGenerator.generateArtillery
generatorFunction[WeaponType.Beamlaser] = TurretGenerator.generateBeamlaser
generatorFunction[WeaponType.Pulselaser] = TurretGenerator.generatePulselaser
generatorFunction[WeaponType.PPC] = TurretGenerator.generatePPC
generatorFunction[WeaponType.TorpedoLauncher] = TurretGenerator.generateTorpedoLauncher
generatorFunction[WeaponType.LBX] = TurretGenerator.generateLBX
generatorFunction[WeaponType.HCG] = TurretGenerator.generateHCG

generatorFunction[WeaponType.Miner] = TurretGenerator.generateMiner
generatorFunction[WeaponType.DeepCoreMiner] = TurretGenerator.generateDeepCoreMiner

generatorFunction[WeaponType.Salvager] = TurretGenerator.generateSalvager
generatorFunction[WeaponType.Redeemer] = TurretGenerator.generateRedeemer

