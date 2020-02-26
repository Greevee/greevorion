package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)
    local perc = 10 -- base value, in percent
    -- add flat percentage based on rarity
    perc = perc + rarity.value * 4 -- add -4% (worst rarity) to +20% (best rarity)
    -- add randomized percentage, span is based on rarity
    perc = perc + math.random() * (rarity.value * 4) -- add random value between -4% (worst rarity) and +20% (best rarity)
    perc = perc / 100
    if permanent then perc = perc * 1.5 end

    local fighterCargoPickup = 0

    if rarity.value >= RarityType.Rare then
        fighterCargoPickup = 1
    end

    return perc, fighterCargoPickup
end

function onInstalled(seed, rarity, permanent)
    local perc,fighterCargoPickup = getBonuses(seed, rarity, permanent)
    addBaseMultiplier(StatsBonuses.CargoHold, perc)
    addAbsoluteBias(StatsBonuses.TransporterRange, 1000)
    addAbsoluteBias(StatsBonuses.FighterCargoPickup, fighterCargoPickup)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Logistic Upgrade MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/cargo-hold.png"
end

function getEnergy(seed, rarity, permanent)
    local perc = getBonuses(seed, rarity)
    return perc * 1.5 * 1000 * 1000 * 1000
end

function getPrice(seed, rarity)
    local perc = getBonuses(seed, rarity)
    local price = perc * 100 * 450
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local perc, fighterCargoPickup = getBonuses(seed, rarity, permanent)
    local basePerc,fighterCargoPickup = getBonuses(seed, rarity, false)

    table.insert(texts, {ltext = "Cargo Hold (relative)"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = "data/textures/icons/crate.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Cargo Hold (relative)"%_t, rtext = string.format("%+i%%", round(basePerc * 0.5 * 100)), icon = "data/textures/icons/crate.png", boosted = permanent})

    if fighterCargoPickup > 0 then
        table.insert(bonuses, {ltext = "Fighter Cargo Pickup"%_t, icon = "data/textures/icons/fighter.png", boosted = permanent})
    end

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    local perc, fighterCargoPickup = getBonuses(seed, rarity, permanent)

    table.insert(texts, {ltext = "Logistic Software included! (Transport blocks still needed)"%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
    table.insert(texts, {ltext = "Increases cargo by a medium amount."%_t})

    if fighterCargoPickup > 0 then
        table.insert(texts, {ltext = "Allows fighters to pick up cargo"%_t, rtext = "", icon = ""})
    end
    return texts
end

function getComparableValues(seed, rarity)
    local perc, flat = getBonuses(seed, rarity, false)

    local base = {}
    local bonus = {}
    if perc ~= 0 then
        table.insert(base, {name = "Cargo Hold (relative)"%_t, key = "cargo_hold_relative", value = round(perc * 100), comp = UpgradeComparison.MoreIsBetter})
        table.insert(bonus, {name = "Cargo Hold (relative)"%_t, key = "cargo_hold_relative", value = round(perc * 0.5 * 100), comp = UpgradeComparison.MoreIsBetter})
    end

    if flat ~= 0 then
        table.insert(base, {name = "Cargo Hold"%_t, key = "cargo_hold", value = round(flat), comp = UpgradeComparison.MoreIsBetter})
        table.insert(bonus, {name = "Cargo Hold"%_t, key = "cargo_hold", value = round(flat * 0.5), comp = UpgradeComparison.MoreIsBetter})
    end

    return base, bonus
end
