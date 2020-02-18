package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("randomext")
include ("utility")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
PermanentInstallationOnly = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local scanner = 1
    local crew = -500
    crew= -1 * (2^(rarity.value + 1))

    scanner = 5 -- base value, in percent
    -- add flat percentage based on rarity
    scanner = scanner + (rarity.value + 2) * 15 -- add +15% (worst rarity) to +105% (best rarity)

    -- add randomized percentage, span is based on rarity
    scanner = scanner + math.random() * ((rarity.value + 1) * 15) -- add random value between +0% (worst rarity) and +90% (best rarity)
    scanner = scanner / 100

    local range = (rarity.value / 2 + 1 + round(getFloat(0.0, 0.4), 1)) * 100
    local fighterCargoPickup = 0
    if rarity.value >= RarityType.Rare then
        fighterCargoPickup = 1
    end

    return scanner, crew, range , fighterCargoPickup
end

function onInstalled(seed, rarity, permanent)
    local scanner,crew,range, fighterCargoPickup = getBonuses(seed, rarity, permanent)

    addBaseMultiplier(StatsBonuses.ScannerReach, scanner)
    addAbsoluteBias(StatsBonuses.PilotsPerFighter, crew)
    addAbsoluteBias(StatsBonuses.MinersPerTurret, crew)
    addAbsoluteBias(StatsBonuses.MechanicsPerTurret, crew)
    addAbsoluteBias(StatsBonuses.GunnersPerTurret, crew)

    addAbsoluteBias(StatsBonuses.TransporterRange, range)
    if fighterCargoPickup == 1 then
        addAbsoluteBias(StatsBonuses.FighterCargoPickup, fighterCargoPickup)
    end
end

function onUninstalled(seed, rarity, permanent)

end

function getName(seed, rarity)
    return "AI based Systems"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/processor.png"
end

function getEnergy(seed, rarity, permanent)
    local scanner = getBonuses(seed, rarity)
    return scanner * 550 * 1000 * 1000
end

function getPrice(seed, rarity)
    local scanner = getBonuses(seed, rarity)
    local price = scanner * 100 * 250
    return 500* price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}
    local scanner, crew, range,fighterCargoPickup  = getBonuses(seed, rarity, permanent)
    local baseScanner, basecrew = getBonuses(seed, rarity, false)

  
    table.insert(texts, {ltext = "Scanner Range"%_t, rtext = string.format("%+i%%", round(scanner * 100)), icon = "data/textures/icons/signal-range.png", boosted = permanent})
    table.insert(texts, {ltext = "Pilots less Required", rtext = string.format("%+i", crew), icon = CrewProfession(CrewProfessionType.Pilot).icon, boosted = permanent})
    table.insert(texts, {ltext = "Gunners less Required", rtext = string.format("%+i", crew), icon = CrewProfession(CrewProfessionType.Gunner).icon, boosted = permanent})
    table.insert(texts, {ltext = "Miners less Required", rtext = string.format("%+i", crew), icon = CrewProfession(CrewProfessionType.Miner).icon, boosted = permanent})
    table.insert(texts, {ltext = "Docking Distance"%_t, rtext = "+${distance} km"%_t % {distance = range / 100}, icon = "data/textures/icons/solar-system.png", boosted = permanent})

    if fighterCargoPickup > 0 then
        table.insert(texts, {ltext = "Fighter Cargo Pickup"%_t, icon = "data/textures/icons/fighter.png", boosted = permanent})
    end

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    return
    {
        {ltext = "Lost Tech"%_t, lcolor = ColorRGB(1, 0.5, 0.5)},
        {ltext = "AI-driven object analysis enabled."%_t, rtext = "", icon = ""},
        {ltext = "Replaces Gunners and Pilots with AIs"%_t, rtext = "", icon = ""},
    }
end

function getComparableValues(seed, rarity)
    local scanner = getBonuses(seed, rarity, false)

    local base = {}
    local bonus = {}
    table.insert(base, {name = "Scanner Range"%_t, key = "range", value = round(scanner * 100), comp = UpgradeComparison.MoreIsBetter})
    table.insert(bonus, {name = "Scanner Range"%_t, key = "range", value = round(scanner * 100), comp = UpgradeComparison.MoreIsBetter})

    return base, bonus
end
