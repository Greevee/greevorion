
function WeaponGenerator.generateBlaster(rand, dps, tech, material, rarity)

    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(0.4, 0.5)

    local reachMod = 1
    local dmgMod = 1
    local type = rand:getInt(1,3)
    if type == 1 then
        weapon.name = "Electron Blaster /* Weapon Name*/"%_t
        weapon.prefix = "Electron Blaster /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        weapon.name = "Ion Blaster /* Weapon Name*/"%_t
        weapon.prefix = "Ion Blaster /* Weapon Prefix*/"%_t
    else
        weapon.name = "Neutron Blaster /* Weapon Name*/"%_t
        weapon.prefix = "Neutron Blaster /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end
    local reach = rand:getFloat(400, 600) * reachMod
    local damage = dps * fireDelay *dmgMod
    local speed = rand:getFloat(600, 800)* getRangeMod(rarity, 0.5)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.PlasmaGun

    weapon.icon = "data/textures/icons/plasma-gun.png"
    weapon.sound = "plasma"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.1)

    weapon.damage = damage
    weapon.damageType = DamageType.Energy
    weapon.impactParticles = ImpactParticles.Energy
    weapon.impactSound = 1
    weapon.pshape = ProjectileShape.Plasma

    weapon.psize = 0.5
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(180, 1, 0.5)

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    weapon.recoil = weapon.damage * 10
    return weapon
end

function WeaponGenerator.generateRailgun(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()
    local rarityFactor = rand:getFloat(0, rarity.value / HighestRarity().value)
    local fireDelay = rand:getFloat(5.5, 6.5)
    local reachMod = 1
    local dmgMod = 1
    local type = rand:getInt(1,3)
    if type == 1 then
        local name = ((material.value+1)*10)*9
        weapon.name = name.."mm Railgun /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Railgun /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        local name = ((material.value+1)*10)*10
        weapon.name = name.."mm Railgun /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Railgun /* Weapon Prefix*/"%_t
    else
        local name = ((material.value+1)*10)*11
        weapon.name = name.."mm Railgun /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Railgun /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end
    local reach = rand:getFloat(1300, 1400)* getRangeMod(rarity, 0.5) * reachMod
    local damage = dps * fireDelay *dmgMod

    weapon.fireDelay = fireDelay
    weapon.appearanceSeed = rand:getInt()
    weapon.reach = reach
    weapon.continuousBeam = false
    weapon.appearance = WeaponAppearance.RailGun
    weapon.icon = "data/textures/icons/rail-gun.png" -- previously beam.png
    weapon.sound = "railgun"
    weapon.accuracy = 0.999 - rand:getFloat(0, 0.01)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    --weapon.shieldDamageMultiplicator = 0.6 - rand:getFloat(0, 0.2) + (rarityFactor * 0.2)
    weapon.impactParticles = ImpactParticles.Physical
    weapon.impactSound = 1
    weapon.blockPenetration = rand:getInt(1, 3 + rarity.value * 2)

    weapon.blength = weapon.reach
    weapon.bshape = BeamShape.Straight
    weapon.bwidth = 0.5
    weapon.bauraWidth = 3
    weapon.banimationSpeed = 1
    weapon.banimationAcceleration = -2

    if rand:getBool() then
        -- shades of red
        weapon.bouterColor = ColorHSV(rand:getFloat(10, 60), rand:getFloat(0.5, 1), rand:getFloat(0.1, 0.5))
        weapon.binnerColor = ColorHSV(rand:getFloat(10, 60), rand:getFloat(0.1, 0.5), 1)
    else
        -- shades of blue
        weapon.bouterColor = ColorHSV(rand:getFloat(180, 260), rand:getFloat(0.5, 1), rand:getFloat(0.1, 0.5))
        weapon.binnerColor = ColorHSV(rand:getFloat(180, 260), rand:getFloat(0.1, 0.5), 1)
    end

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    weapon.recoil = weapon.damage * 20
    return weapon
end

function WeaponGenerator.generateLRM(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()
    local fireDelay = rand:getFloat(5, 5)
    local reach = rand:getFloat(1500, 2000) * getRangeMod(rarity, 0.5)
    local damage = dps * fireDelay
    local speed = rand:getFloat(180, 200)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.seeker = 1
    weapon.appearance = WeaponAppearance.RocketLauncher
    weapon.name = "LRM - Long Range Missiles /* Weapon Name*/"%_t
    weapon.prefix = "LRM - Long Range Missiles /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/rocket-launcher.png" -- previously missile-swarm.png
    weapon.sound = "launcher"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.02)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    weapon.psize = rand:getFloat(0.4, 0.5)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pshape = ProjectileShape.Rocket

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 20
    -- reduce
    weapon.explosionRadius = math.sqrt(weapon.damage)

    return weapon
end
function WeaponGenerator.generateSRM(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(2,2.5)
    local reach = rand:getFloat(300, 400) * getRangeMod(rarity, 0.5)
    local damage = dps * fireDelay
    local speed = rand:getFloat(100, 150)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.seeker = 1
    weapon.appearance = WeaponAppearance.RocketLauncher
    weapon.name = "SRM - Shor range Missiles /* Weapon Name*/"%_t
    weapon.prefix = "SRM - Short Range Missiles /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/rocket-launcher.png" -- previously missile-swarm.png
    weapon.sound = "launcher"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.09)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    weapon.psize = rand:getFloat(0.4, 0.5)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pshape = ProjectileShape.Rocket

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 20
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    return weapon
end

function WeaponGenerator.generateAutocannon(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(0.3, 0.4)
    local velocity = rand:getFloat(500, 700)
    local reachMod = 1
    local dmgMod = 1
    local type = rand:getInt(1,3)
    if type == 1 then
        local name = ((material.value+1)*10)*14
        weapon.name = name.."mm Autocannon /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Autocannon /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        local name = ((material.value+1)*10)*15
        weapon.name = name.."mm Autocannon /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Autocannon /* Weapon Prefix*/"%_t
    else
        local name = ((material.value+1)*10)*16
        weapon.name = name.."mm Autocannon /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Autocannon /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end

    local damage = dps * fireDelay * dmgMod
    local reach = rand:getFloat(550, 650) * getRangeMod(rarity, 0.5) *reachMod
    local maximumTime = reach / velocity

    weapon.pvelocity = velocity
    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.ChainGun
    weapon.icon = "data/textures/icons/chaingun.png" -- previously sentry-gun.png
    weapon.sound = "bolter"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.03)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Physical
    weapon.impactSound = 1

    weapon.psize = rand:getFloat(0.15, 0.25)
    weapon.pmaximumTime = maximumTime
    local color = Color()
    color:setHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pcolor = color

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    weapon.recoil = weapon.damage * 16

    return weapon
end

function WeaponGenerator.generateArtillery(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(8, 10)
    local speed = rand:getFloat(800, 900)


    local reachMod = 1
    local dmgMod = 1
    local type = rand:getInt(1,3)
    if type == 1 then
        local name = ((material.value+1)*10)*45
        weapon.name = name.."mm Artillery /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Artillery /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        local name = ((material.value+1)*10)*50
        weapon.name = name.."mm Artillery /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Artillery /* Weapon Prefix*/"%_t
    else
        local name = ((material.value+1)*10)*55
        weapon.name = name.."mm Artillery /* Weapon Name*/"%_t
        weapon.prefix = name.."mm Artillery /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end

    local damage = dps * fireDelay *dmgMod
    local reach = (rand:getFloat(1000, 1200)) * getRangeMod(rarity, 0.5) *reachMod
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.Cannon
    weapon.icon = "data/textures/icons/cannon.png" -- previously hypersonic-bolt.png
    weapon.sound = "cannon"
    weapon.accuracy = 0.98 - rand:getFloat(0, 0.02)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    weapon.psize = rand:getFloat(0.2, 0.5)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 500

    -- rethink
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    return weapon
end

function WeaponGenerator.generatePPC(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(6, 7)
    local reach = (rand:getFloat(900,1000)) * getRangeMod(rarity, 0.5)

    local damage = dps * fireDelay
    local speed = rand:getFloat(800, 900)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.Cannon
    weapon.name = "PPC /* Weapon Name*/"%_t
    weapon.prefix = "PPC /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/lightning-turret.png" -- previously hypersonic-bolt.png
    weapon.sound = "cannon"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.01)

    weapon.shieldDamageMultiplicator = 1.5

    weapon.damage = damage
    weapon.damageType = DamageType.Energy
    weapon.impactParticles = ImpactParticles.Energy
    weapon.impactSound = 1
    weapon.impactExplosion = true
    weapon.pshape = ProjectileShape.Plasma

    weapon.psize = rand:getFloat(0.8, 1)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(180, 1, 0.5)
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 100

    -- rethink
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    return weapon
end

function WeaponGenerator.generateMiner(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()
    local raw = true
    local efficencyMod = 1


    weapon.fireDelay = 0.2
    weapon.appearanceSeed = rand:getInt()
    weapon.reach = rand:getFloat(200, 250)
    weapon.recoil = 0
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.MiningLaser

        weapon.name = "Raw-Miner /* Weapon Name*/"%_t
        weapon.prefix = "Raw-Miner /* Weapon Prefix*/"%_t
        weapon.stoneRawEfficiency = math.abs(0.63 + rand:getFloat(0, 0.06) + rarity.value * 0.06)

    weapon.icon = "data/textures/icons/mining-laser.png"
    weapon.sound = "mining"
    weapon.damage = dps * weapon.fireDelay
    weapon.damageType = DamageType.Energy
    weapon.smaterial = material
    weapon.stoneDamageMultiplicator = WeaponGenerator.getStoneDamageMultiplicator()
    weapon.shieldDamageMultiplicator = 0

    weapon.blength = weapon.reach
    weapon.bshape = BeamShape.Straight
    weapon.bouterColor = ColorRGB(0.1, 0.1, 0.1)
    weapon.binnerColor = ColorARGB(material.color.a * 0.5, material.color.r * 0.5, material.color.g * 0.5, material.color.b * 0.5)
    weapon.bwidth = 0.5
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 4

    WeaponGenerator.adaptMiningLaser(rand, weapon, tech, material, rarity)

    return weapon
end

function WeaponGenerator.generateDeepCoreMiner(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()
    local raw = true

    weapon.continuousBeam = true
    weapon.fireDelay = 0.6
    weapon.appearanceSeed = rand:getInt()
    weapon.reach = rand:getFloat(300, 350)
    weapon.recoil = 0
    weapon.continuousBeam = false
    weapon.appearance = WeaponAppearance.MiningLaser

    weapon.name = "Deep Core Mining Drill /* Weapon Name*/"%_t
    weapon.prefix = "Deep Core Mining Drill /* Weapon Prefix*/"%_t
    weapon.stoneRawEfficiency = math.abs(0.73 + rand:getFloat(0, 0.06) + rarity.value * 0.06)

    weapon.icon = "data/textures/icons/mining-laser.png"
    weapon.sound = "mining"
    local dmgMod = 1
    weapon.damage = dps * weapon.fireDelay * dmgMod
    weapon.damageType = DamageType.Energy
    weapon.smaterial = material
    weapon.stoneDamageMultiplicator = WeaponGenerator.getStoneDamageMultiplicator()
    weapon.shieldDamageMultiplicator = 0

    weapon.stoneRawEfficiency = math.abs(0.63 + rand:getFloat(0, 0.06) + rarity.value * 0.06)

    weapon.blength = weapon.reach
    weapon.bshape = BeamShape.Swirly
     weapon.bouterColor = ColorRGB(0.5, 0.5, 0.5)
    weapon.binnerColor = ColorARGB(material.color.a * 0.8, material.color.r * 0.8, material.color.g * 0.8, material.color.b * 0.8)
    weapon.bwidth = 0.5
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 4
    weapon.recoil = weapon.damage * 100
    WeaponGenerator.adaptMiningLaser(rand, weapon, tech, material, rarity)

    return weapon
end

function WeaponGenerator.generateBeamlaser(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    local reachMod = 1
    local dmgMod = 1
    local type=rand:getInt(1,3)
    if type == 1 then
        weapon.name = "Light Beamlaser /* Weapon Name*/"%_t
        weapon.prefix = "Light Beamlaser /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        weapon.name = "Medium Beamlaser /* Weapon Name*/"%_t
        weapon.prefix = "Medium Beamlaser /* Weapon Prefix*/"%_t
    else
        weapon.name = "Heavy Beamlaser /* Weapon Name*/"%_t
        weapon.prefix = "Heavy Beamlaser /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end

    local fireDelay = 0.1
    local reach = rand:getFloat(700, 800)* getRangeMod(rarity, 0.5) *reachMod
    local damage = dps * fireDelay * dmgMod

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.Laser

    weapon.icon = "data/textures/icons/laser-gun.png" -- previously laser-blast.png
    weapon.sound = "laser"


    weapon.damage = damage
    weapon.damageType = DamageType.Energy
    weapon.blength = weapon.reach

    weapon.bouterColor = ColorRGB(0.5, 0.5, 0.5)
    weapon.binnerColor = ColorARGB(material.color.a * 0.8, material.color.r * 0.8, material.color.g * 0.8, material.color.b * 0.8)
    weapon.bshape = BeamShape.Swirly
    weapon.bwidth = 1
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 20

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)
    return weapon
end

function WeaponGenerator.generatePulselaser(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    local reachMod = 1
    local dmgMod = 1
    local type=rand:getInt(1,3)
    if type == 1 then
        weapon.name = "Gatling Pulselaser /* Weapon Name*/"%_t
        weapon.prefix = "Gatling Pulselaser /* Weapon Prefix*/"%_t
        dmgMod = 0.9
        reachMod = 0.9
    elseif type == 2 then
        weapon.name = "Mega Pulselaser /* Weapon Name*/"%_t
        weapon.prefix = "Mega Pulselaser /* Weapon Prefix*/"%_t
    else
        weapon.name = "Giga Pulselaser /* Weapon Name*/"%_t
        weapon.prefix = "Giga Pulselaser /* Weapon Prefix*/"%_t
        dmgMod = 1.1
        reachMod = 1.1
    end

    local fireDelay = 0.3 -- always the same with beams, does not really matter
    local reach = rand:getFloat(300, 350) * getRangeMod(rarity, 0.5) * reachMod
    local damage = dps * fireDelay *dmgMod

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.continuousBeam = false
    weapon.appearance = WeaponAppearance.Laser

    weapon.icon = "data/textures/icons/laser-gun.png" -- previously laser-blast.png
    weapon.sound = "plasma"


    weapon.damage = damage
    weapon.damageType = DamageType.Energy
    weapon.blength = weapon.reach

    weapon.bouterColor = ColorRGB(0.5, 0.5, 0.5)
    weapon.binnerColor = ColorARGB(material.color.a * 0.8, material.color.r * 0.8, material.color.g * 0.8, material.color.b * 0.8)
    weapon.bshape = BeamShape.Swirly
    weapon.bwidth = 1
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 40

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)
    return weapon
end

function WeaponGenerator.generateSalvager(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    weapon.fireDelay = 0.2
    weapon.appearanceSeed = rand:getInt()
    weapon.reach = rand:getFloat(650,750) * getRangeMod(rarity, 0.5)
    weapon.recoil = 0
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.Laser
    weapon.name = "Salvager /* Weapon Name*/"%_t
    weapon.prefix = "Salvager /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/salvage-laser.png"
    weapon.sound = "mining"

    weapon.damage = dps * weapon.fireDelay
    weapon.damageType = DamageType.Energy
    weapon.smaterial = material
    weapon.stoneDamageMultiplicator = 0.01
    weapon.shieldDamageMultiplicator = 0
    weapon.metalRawEfficiency = math.abs(0.45 + rand:getFloat(0, 0.05) + rarity.value * 0.05)

    weapon.blength = weapon.reach
    weapon.bshape = BeamShape.Straight
    weapon.bouterColor = ColorRGB(0.1, 0.1, 0.1)
    weapon.binnerColor = ColorARGB(material.color.a * 0.5, material.color.r * 0.5, material.color.g * 0.5, material.color.b * 0.5)
    weapon.bwidth = 0.5
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 4

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    return weapon
end

function WeaponGenerator.generateRedeemer(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    weapon.fireDelay = 0.2
    weapon.appearanceSeed = rand:getInt()
    weapon.reach = rand:getFloat(200,300)* getRangeMod(rarity, 0.5)
    weapon.recoil = 0
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.Laser
    weapon.name = "Redeemer /* Weapon Name*/"%_t
    weapon.prefix = "Redeemer /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/salvage-laser.png"
    weapon.sound = "mining"

    weapon.damage = dps * weapon.fireDelay
    weapon.damageType = DamageType.Energy
    weapon.smaterial = material
    weapon.stoneDamageMultiplicator = 0.01
    weapon.shieldDamageMultiplicator = 0
    weapon.metalRawEfficiency = math.abs(0.45 + rand:getFloat(0, 0.05) + rarity.value * 0.05)

    weapon.blength = weapon.reach
    weapon.bshape = BeamShape.Swirly
    weapon.bouterColor = ColorRGB(0.1, 0.1, 0.1)
    weapon.binnerColor = ColorARGB(material.color.a * 0.8, material.color.r * 0.8, material.color.g * 0.8, material.color.b * 0.8)
    weapon.bwidth = 0.5
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 4 *1.5


    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    return weapon
end

function WeaponGenerator.generatePointDefenseChaingun(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(0.075, 0.1)
    local reach = rand:getFloat(700, 750) * getRangeMod(rarity, 0.5)
    local damage = (1.5 + (rarity.value * 0.25)) * 0.1
    local speed = rand:getFloat(1000, 1100)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.ChainGun
    weapon.name = "PDC - Point Defense Chaingun /* Weapon Name*/"%_t
    weapon.prefix = "PDC - Point Defense Chaingun /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/point-defense-chaingun.png" -- previously minigun.png
    weapon.sound = "chaingun"
    weapon.accuracy = 0.99

    weapon.damage = damage
    weapon.damageType = DamageType.Fragments
    weapon.impactParticles = ImpactParticles.Physical
    weapon.impactSound = 1

    weapon.psize = rand:getFloat(0.05, 0.2)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    weapon.recoil = weapon.damage * 10

    return weapon
end

function WeaponGenerator.generatePointDefenseLaser(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    local fireDelay = 0.2 -- always the same with beams, does not really matter
    local reach = rand:getFloat(300, 400)* getRangeMod(rarity, 0.5)
    local damage = (1.5 + (rarity.value * 0.25)) * 0.1

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.Laser
    weapon.name = "PDL - Point Defense Laser /* Weapon Name*/"%_t
    weapon.prefix = "PDL - Point Defense Laser /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/laser-gun.png" -- previously laser-blast.png
    weapon.sound = "laser"

    local hue = rand:getFloat(0, 360)

    weapon.damage = damage
    weapon.damageType = DamageType.Fragments
    weapon.blength = weapon.reach

    weapon.bouterColor = ColorHSV(hue, 1, rand:getFloat(0.1, 0.3))
    weapon.binnerColor = ColorHSV(hue + rand:getFloat(-120, 120), 0.3, rand:getFloat(0.7, 0.8))
    weapon.bshape = BeamShape.Straight
    weapon.bwidth = 0.5
    weapon.bauraWidth = 1
    weapon.banimationSpeed = 4

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    return weapon
end

function WeaponGenerator.generateAntiFighterGun(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    dps = dps * 0.1

    local fireDelay = rand:getFloat(0.2, 0.3)
    local reach = rand:getFloat(150, 250) * getRangeMod(rarity, 0.5)
    local damage = dps * fireDelay
    local speed = rand:getFloat(300, 400)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.AntiFighter
    weapon.name = "Flak/* Weapon Name */"%_t
    weapon.prefix = "Flak /* Weapon Prefix */"%_t
    weapon.icon = "data/textures/icons/anti-fighter-gun.png" -- previously flak.png
    weapon.sound = "bolter"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.03)

    weapon.damage = damage
    weapon.damageType = DamageType.Fragments
    weapon.impactParticles = ImpactParticles.DustExplosion
    weapon.impactSound = 1
    weapon.deathExplosion = true
    weapon.timedDeath = true
    weapon.explosionRadius = 35

    weapon.psize = rand:getFloat(0.3, 0.3)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 75 -- x75 to make up for the reduction to default damage above

    return weapon
end

function WeaponGenerator.generateTorpedoLauncher(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()
    local fireDelay = rand:getFloat(10, 11)
    local reach = rand:getFloat(800, 1000)* getRangeMod(rarity, 0.5)
    local damage = dps * fireDelay
    local speed = rand:getFloat(80, 90)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.seeker = 1
    weapon.appearance = WeaponAppearance.RocketLauncher
    weapon.name = "Liquidator Torpedo Launcher /* Weapon Name*/"%_t
    weapon.prefix = "Liquidator Torpedo Launcher /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/rocket-launcher.png" -- previously missile-swarm.png
    weapon.sound = "launcher"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.02)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    weapon.psize = rand:getFloat(0.4, 0.5) *3
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pshape = ProjectileShape.Rocket

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 50
    -- reduce
    weapon.explosionRadius = math.sqrt(weapon.damage)*1.5

    return weapon
end

function WeaponGenerator.generateLBX(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = 0.001
    local reach = rand:getFloat(300, 400) * getRangeMod(rarity, 0.5)
    local damage = dps * fireDelay
    local speed = rand:getFloat(100, 150)
    local existingTime = reach / speed

    weapon.accuracy = 0.90 - rand:getFloat(0, 0.05)

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()

    weapon.appearance = WeaponAppearance.RocketLauncher
    weapon.name = "Short Range Spread Rocket Launcher /* Weapon Name*/"%_t
    weapon.prefix = "Short Range Spread Rocket Launcher /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/missile-swarm.png" -- previously missile-swarm.png
    weapon.sound = "launcher"

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    weapon.psize = rand:getFloat(0.4, 0.5)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pshape = ProjectileShape.Rocket

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 10
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    return weapon
end

function WeaponGenerator.generateHCG(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(0.2, 0.25)
    local velocity = rand:getFloat(500, 600)

    weapon.name = "Heavy Chain Gun /* Weapon Name*/"%_t
    weapon.prefix = "Heavy Chain Gun /* Weapon Prefix*/"%_t

    local damage = dps * fireDelay
    local reach = rand:getFloat(400, 500) * getRangeMod(rarity, 0.5)
    local maximumTime = reach / velocity

    weapon.pvelocity = velocity
    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.appearance = WeaponAppearance.ChainGun
    weapon.icon = "data/textures/icons/chaingun.png" -- previously sentry-gun.png
    weapon.sound = "chaingun"
    weapon.accuracy = 0.93 - rand:getFloat(0, 0.05)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Physical
    weapon.impactSound = 1

    weapon.psize = rand:getFloat(0.15, 0.25)
    weapon.pmaximumTime = maximumTime
    local color = Color()
    color:setHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pcolor = color

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    weapon.recoil = weapon.damage * 5

    return weapon
end

function getRangeMod(rarity, maxMod)
    return 1+ (((rarity.value+1)/6)*maxMod)
end

generatorFunction[WeaponType.Blaster]         = WeaponGenerator.generateBlaster
generatorFunction[WeaponType.PPC]             = WeaponGenerator.generatePPC -- particle projector cannon. remove? we have a blaster
generatorFunction[WeaponType.Railgun]         = WeaponGenerator.generateRailgun
generatorFunction[WeaponType.LBX]             = WeaponGenerator.generateLBX -- dumb fire swarm missile. doubdt someone will ever use it
generatorFunction[WeaponType.SRM]             = WeaponGenerator.generateSRM -- short range missile
generatorFunction[WeaponType.LRM]             = WeaponGenerator.generateLRM -- long range missile
generatorFunction[WeaponType.Autocannon]      = WeaponGenerator.generateAutocannon
generatorFunction[WeaponType.HCG]             = WeaponGenerator.generateHCG -- heavy chaingun
generatorFunction[WeaponType.Artillery]       = WeaponGenerator.generateArtillery
generatorFunction[WeaponType.Beamlaser]       = WeaponGenerator.generateBeamlaser
generatorFunction[WeaponType.Pulselaser]      = WeaponGenerator.generatePulselaser
generatorFunction[WeaponType.TorpedoLauncher] = WeaponGenerator.generateTorpedoLauncher

generatorFunction[WeaponType.Miner]           = WeaponGenerator.generateMiner
generatorFunction[WeaponType.DeepCoreMiner]   = WeaponGenerator.generateDeepCoreMiner
generatorFunction[WeaponType.Salvager]        = WeaponGenerator.generateSalvager
generatorFunction[WeaponType.Redeemer]        = WeaponGenerator.generateRedeemer

--experimental
generatorFunction[WeaponType.Judgement]       = WeaponGenerator.Judgement


function WeaponGenerator.generateJudgement(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setBeam()

    local fireDelay = 60 -- always the same with beams, does not really matter
    local reach = rand:getFloat(2000, 3000)
    local damage = dps * fireDelay

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.continuousBeam = true
    weapon.appearance = WeaponAppearance.Laser
    weapon.name = "Judgement /* Weapon Name*/"%_t
    weapon.prefix = "Judgement /* Weapon Prefix*/"%_t
    weapon.icon = "data/textures/icons/laser-gun.png" -- previously laser-blast.png
    weapon.sound = "laser"

    local hue = rand:getFloat(360)

    weapon.damage = damage
    weapon.damageType = DamageType.Energy
    weapon.blength = weapon.reach

    weapon.bouterColor = ColorHSV(350, 14, 0.5)
    weapon.binnerColor = ColorHSV(350, 14, 0.9)
    weapon.bshape = BeamShape.Swirly
    weapon.bwidth = 30
    weapon.bauraWidth = 9
    weapon.banimationSpeed = 10

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    return weapon
end
