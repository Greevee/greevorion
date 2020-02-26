-- Active Armor Repair by Greeve
package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

updateCycle = 5

FixedEnergyRequirement = true  -- must be dynamic

function getUpdateInterval()
    return updateCycle
end

function update(timePassed)
    local maxHull = Entity().maxDurability -- loaded, can change in combat when blocks get destroyed
    local durability = Entity().durability
    local rng = math.random()
    if rng <= 0.1 then
        local dmg = math.random() * 0.05 * maxHull
        Entity().durability = durability - dmg
    end
end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local perc = 60 -- base value, in percent
    -- add flat percentage based on rarity
    perc = perc + rarity.value * 4 -- add -4% (worst rarity) to +20% (best rarity)

    -- add randomized percentage, span is based on rarity
    perc = perc + math.random() * (rarity.value * 4) -- add random value between -4% (worst rarity) and +20% (best rarity)
    perc = perc / 100
    if permanent then perc = perc * 1.5 end

    return perc
end

function onInstalled(seed, rarity, permanent)
    local perc,dmgPerTick = getBonuses(seed, rarity, permanent)
    addBaseMultiplier(StatsBonuses.CargoHold, perc)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Experimental Cargo Expander Prototype ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/cargo-hold.png"
end

function getEnergy(seed, rarity, permanent)
    return 0
end

function getPrice(seed, rarity)
    local percBase = getBonuses(seed, rarity, false)
    return (percBase * 100000 ) * 2.5 ^ rarity.value -- oof, whats fair? how much is the fish?
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local perc = getBonuses(seed, rarity, permanent)
    local percBase = getBonuses(seed, rarity, false)

    table.insert(texts, {ltext = "Cargo Hold"%_t, rtext = string.format("%+i%%", round(perc * 100,2)), icon = "data/textures/icons/crate.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Cargo Hold"%_t, rtext = string.format("%+i%%", round(percBase  * 100* 0.5 ,2)), icon = "data/textures/icons/crate.png", boosted = permanent})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Dangerous: Instable Tech"%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
    table.insert(texts, {ltext = "Internal damage will occour every.".. updateCycle .." seconds."%_t})
    table.insert(texts, {ltext = "Thats the price you will have to pay. ".. updateCycle .." seconds."%_t})
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
