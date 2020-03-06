package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local perc = 40 -- base value, in percent
    -- add flat percentage based on rarity
    perc = perc + rarity.value * 4 -- add -4% (worst rarity) to +20% (best rarity)

    -- add randomized percentage, span is based on rarity
    perc = perc + math.random() * (rarity.value * 5) -- add random value between -4% (worst rarity) and +20% (best rarity)
    perc = perc * 0.8
    perc = perc / 100
    if permanent then perc = perc * 1.5 end

    local slow = 50
    slow= slow - ( math.random() * (rarity.value * 5))

    if permanent then
        slow = slow * 0.5
    end

    slow = slow / 100
    return perc, slow
end

function onInstalled(seed, rarity, permanent)
    local perc, slow = getBonuses(seed, rarity, permanent)
    addBaseMultiplier(StatsBonuses.CargoHold, perc)
    addBaseMultiplier(StatsBonuses.Velocity, -slow)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "T1M-LRD-Tech Cargo Upgrade MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/cargo-hold.png"
end

function getEnergy(seed, rarity, permanent)
    local perc, slow = getBonuses(seed, rarity, permanent)
    return perc * 3 * 1000 * 1000 * 1000
end

function getPrice(seed, rarity)
    local perc, flat = getBonuses(seed, rarity)
    local price = perc * 100 * 900
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local perc, slow = getBonuses(seed, rarity, permanent)
    local basePerc, slowBase = getBonuses(seed, rarity, false)
    local bonusPerc, slowBonus = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Cargo Hold"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = "data/textures/icons/crate.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Cargo Hold"%_t, rtext = string.format("%+i%%", round(basePerc * 0.5 * 100)), icon = "data/textures/icons/crate.png", boosted = permanent})

    table.insert(texts, {ltext = "Maximum velocity"%_t, rtext = string.format("%+i%%", round(-1*slow*100)), icon = "data/textures/icons/crate.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Maximum velocity"%_t, rtext = string.format("%+i%%", round(slowBase*0.5*100)), icon = "data/textures/icons/crate.png", boosted = permanent})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Increases cargo by a medium amount."%_t})
    return texts
end

function getComparableValues(seed, rarity)
    local perc, flat = getBonuses(seed, rarity, false)
    local base = {}
    local bonus = {}

    return base, bonus
end
