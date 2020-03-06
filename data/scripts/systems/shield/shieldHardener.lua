--Passive Shield Booster by Greeve
-- Recharges small amounts of Shield, need energy depending on shield size Energy
package.path = package.path .. ";data/scripts/systems/shield/?.lua"
package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

energyCostMultiplier = 100000  -- 200k
PermanentInstallationOnly = true
FixedEnergyRequirement = false

Unique = true
local energyNeeded = 0

function getUpdateInterval()
    return 5
end

function update(timePassed)
    local shieldAmplification , energySavePercent = getBonuses(getSeed(), getRarity(), getPermanent())
    local shield = Entity().shieldDurability -- loaded, can change in combat when blocks get destroyed
    energyNeeded = shield * energyCostMultiplier * energySavePercent
end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local shieldAmplification = -30 + ((math.random() *(rarity.value+1) * 3)) --  -30
    shieldAmplification = 1 + (shieldAmplification /100)
    local energySavePercent = 1

    if permanent then
        energySavePercent = 1 - (((rarity.value +1) /6)*((math.random()*0.25) +0.25 )) -- 1 - 0.5
    end
    return  shieldAmplification , energySavePercent
end

function onInstalled(seed, rarity, permanent)
    local shieldAmplification  = getBonuses(seed, rarity, permanent)

    if permanent then
        addAbsoluteBias(StatsBonuses.ShieldImpenetrable, 1)
        addMultiplier(StatsBonuses.ShieldDurability, shieldAmplification)
    end
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Shield Hardener MK${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/shield.png"
end

function getEnergy(seed, rarity, permanent)
    return energyNeeded
end

function getPrice(seed, rarity)
    local shieldAmplificationBase, shieldAmplificationBase  = getBonuses(seed, rarity, false)
    local price = shieldAmplificationBase * 100 * 250 + shieldAmplificationBase * 15000
    return price * 2.5 ^ rarity.value

end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}

    local shieldAmplification , energySavePercent = getBonuses(seed, rarity, permanent)
    local shieldAmplificationBase, energySavePercentbase = getBonuses(seed, rarity, false)
    local shieldAmplificationBoosted, energySavePercentBoosted = getBonuses(seed, rarity, true)


    table.insert(bonuses, {ltext = "Shield durability"%_t, rtext = string.format("%f%%", round( 1-shieldAmplification,2)), icon = "data/textures/icons/shield.png"})

    table.insert(bonuses, {ltext = "Impenetrable Shields"%_t, rtext = "Yes"%_t, icon = "data/textures/icons/shield.png", boosted = permanent})
    table.insert(bonuses, {ltext =  "Energy saved."%_t, rtext = string.format("%02.2f%%",round(100-(energySavePercentBoosted*100),2) ), icon = "data/textures/icons/power-unit.png"})


    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Permanent Installation:"%_t})
    table.insert(texts, {ltext = "Shields can't be penetrated by shots or torpedoes."%_t})
    table.insert(texts, {ltext = "Durability is diverted to reinforce shield membrane."%_t})
    table.insert(texts, {ltext = ""%_t})
    table.insert(texts, {ltext = "WARNING: Drains more energy the more shield is reinforced."%_t, lcolor = ColorRGB(0.8, 0.4, 0)})
    table.insert(texts, {ltext = "The current shield value is important, not the maximum."%_t, lcolor = ColorRGB(1, 0.5, 0)})
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
