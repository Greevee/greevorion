package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    math.randomseed(seed)

    local shieldAmplification = 25 + (math.random() *(rarity.value) * 5)

    if permanent then
        shieldAmplification = shieldAmplification * 1.5
    end

    return  (shieldAmplification /100)
end

function onInstalled(seed, rarity, permanent)
    local amplification = getBonuses(seed, rarity, permanent)
    addBaseMultiplier(StatsBonuses.ShieldDurability, amplification)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Passive Shield Extender MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/shield.png"
end

function getPrice(seed, rarity)
    local amplification = getBonuses(seed, rarity)
    local price = 7500 * amplification;
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local amplification = getBonuses(seed, rarity, permanent)
    local baseAmplification = getBonuses(seed, rarity, false)

    table.insert(texts, {ltext = "Shield durability"%_t, rtext = string.format("%i%%", round(amplification * 100)), icon = "data/textures/icons/shield.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Shield Durability"%_t, rtext = string.format("%+i%%", round(baseAmplification  * 0.5* 100)), icon = "data/textures/icons/shield.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Extends the shield by a large amount."%_t})
    table.insert(texts, {ltext = "How boring.. Shields are for the weak!"%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})
    return texts
end

function getComparableValues(seed, rarity)
    local baseAmplification, baseEnergy = getBonuses(seed, rarity, false)

    return
    {
        {name = "Shield Durability"%_t, key = "durability", value = round(baseAmplification * 100), comp = UpgradeComparison.MoreIsBetter},
    },
    {
        {name = "Shield Durability"%_t, key = "durability", value = round(baseAmplification * 0.4 * 100), comp = UpgradeComparison.MoreIsBetter},
    }
end
