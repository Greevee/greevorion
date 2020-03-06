function The4.createHealingTurret()
    -- create custom heal turrets
    local turret = SectorTurretGenerator(Seed(153)):generate(150, 0, 0, Rarity(RarityType.Common), WeaponType.SRM)
    local weapons = {turret:getWeapons()}
    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        weapon.reach = 800
        weapon.blength = 800

        weapon.shieldRepair = 250
        weapon.hullRepair = 0
        weapon.bouterColor = ColorRGB(0.1, 0.2, 0.4);
        weapon.binnerColor = ColorRGB(0.2, 0.4, 0.9);
        weapon.shieldPenetration = 0.0
        turret:addWeapon(weapon)

        weapon.hullRepair = 250
        weapon.shieldRepair = 0
        weapon.bouterColor = ColorRGB(0.1, 0.5, 0.1);
        weapon.binnerColor = ColorRGB(1.0, 1.0, 1.0);
        weapon.shieldPenetration = 1.0
        turret:addWeapon(weapon)
    end

    turret.turningSpeed = 2.0
    turret.crew = Crew()

    return turret
end

function The4.createPlasmaTurret()
    -- create custom plasma turrets

    local turret = SectorTurretGenerator(Seed(151)):generate(150, 0, 0, Rarity(RarityType.Common), WeaponType.Blaster)
    local weapons = {turret:getWeapons()}
    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        weapon.reach = 800
        weapon.reach = 800
        weapon.pmaximumTime = weapon.reach / weapon.pvelocity
        weapon.hullDamageMultiplicator = 0.25
        turret:addWeapon(weapon)
    end

    turret.turningSpeed = 2.0
    turret.crew = Crew()

    return turret
end

function The4.createRailgunTurret()
    -- create custom railgun turrets

    local turret = SectorTurretGenerator(Seed(151)):generate(150, 0, 0, Rarity(RarityType.Common), WeaponType.Railgun)
    local weapons = {turret:getWeapons()}
    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        weapon.reach = 800
        weapon.blength = 800
        weapon.shieldDamageMultiplicator = 0.1
        turret:addWeapon(weapon)
    end

    turret.turningSpeed = 2.0
    turret.crew = Crew()

    return turret
end

function The4.createLaserTurret()
    -- create custom heal turrets
    local turret = SectorTurretGenerator(Seed(152)):generate(450, 0, 0, Rarity(RarityType.Petty), WeaponType.Beamlaser)
    local weapons = {turret:getWeapons()}
    turret:clearWeapons()
    for _, weapon in pairs(weapons) do
        weapon.reach = 600
        weapon.blength = 600
        turret:addWeapon(weapon)
    end

    turret.turningSpeed = 2.0
    turret.crew = Crew()

    return turret
end
