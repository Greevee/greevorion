package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local credits = 10 * 1000 * ( (rarity.value+2) ^ 3) * ((math.random()+1)^5)
    return credits
end

function onInstalled(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Credit Card"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/sell.png"
end

function getEnergy(seed, rarity, permanent)
    return 0
end

function getPrice(seed, rarity)
    local credits = getBonuses(seed, rarity)
    return credits
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}

    local credits = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Charged Credits"%_t, rtext = string.format("%+i", credits), icon = "data/textures/icons/sell.png", boosted = permanent})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "A dropped Credit Storage."%_t})
    table.insert(texts, {ltext = "Money... Money... Money..."%_t})
    return texts
end

function getComparableValues(seed, rarity)
    local credits = getBonuses(seed, rarity, false)
    local base = {}
    local bonus = {}

    return base, bonus
end
