-- Active Armor Repaur by Greeve

package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

local energyNeeded = 0

energyPerDamage = 10000000  -- todo balance
FixedEnergyRequirement = false  -- must be dynamic
updateCycle = 1

function getUpdateInterval()
    return updateCycle
end

function update(timePassed)
    -- eversy 1 seconds, load shoul be trivial
    local maxRechargeAmountPercent, energySavePercent =getBonuses(getSeed(), getRarity(), getPermanent()) -- in % of max shields

    local maxHull = Entity().maxDurability -- loaded, can change in combat when blocks get destroyed
    local durability = Entity().durability

    local maxRepair=(maxHull/100)* maxRechargeAmountPercent
    local hullDmg=maxHull-durability

    if hullDmg >= maxRepair then
        energyNeeded= energyPerDamage * maxRepair * energySavePercent
        Entity().durability= durability + maxRepair
    else
        energyNeeded= energyPerDamage * hullDmg * energySavePercent
        Entity().durability= durability+ hullDmg
    end
end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local energySavePercent =1

    local baseamountRepair= ((rarity.value +1) /12)*(1/4) * math.random()
    local bonusmaxRechargeAmountPercent =  ((math.random() * (rarity.value +1 )  )/40)

    if permanent then
        bonusmaxRechargeAmountPercent = bonusmaxRechargeAmountPercent * 2    --- max  2 * 1%
        energySavePercent = 1 - (((rarity.value +1) /6)*((math.random()*0.25) +0.25 )) -- 1 - 0.5
    end
    local repairPercent =  ((bonusmaxRechargeAmountPercent + baseamountRepair) / updateCycle)

    return repairPercent, energySavePercent
end

function onInstalled(seed, rarity, permanent)
    local nvm,mechanicFactor   = getBonuses(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Active Armor Pump MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/mod-uploaded.png"
end

function getEnergy(seed, rarity, permanent)
    return energyNeeded
end

function getPrice(seed, rarity)
    local maxRechargeAmountPercentnormal,energySavePercentnormal  = getBonuses(seed, rarity, false)
    return (2.5 ^ rarity.value) * (maxRechargeAmountPercentnormal* 100000 + energySavePercentnormal * 100000 )
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local maxRechargeAmountPercent,energySavePercent  = getBonuses(seed, rarity, permanent)
    local maxRechargeAmountPercentnormal,energySavePercentnormal  = getBonuses(seed, rarity, false)
    local maxRechargeAmountPercentpermanent,energySavePercentboost  = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Repairs percent of the armor."%_t, rtext = string.format("%02.2f%%",  round(maxRechargeAmountPercentnormal,2)), icon = "data/textures/icons/repair.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Repairs percent of the shield."%_t, rtext = string.format("%02.2f%%", round(maxRechargeAmountPercentpermanent-maxRechargeAmountPercentnormal,2)), icon = "data/textures/icons/repair.png"})
    table.insert(bonuses, {ltext =  "Energy saved."%_t, rtext = string.format("%02.2f%%",round(100-(energySavePercentboost*100),2) ), icon = "data/textures/icons/power-unit.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Repairs a percentage of the hull damage every ".. updateCycle .. " seconds."%_t})
    table.insert(texts, {ltext = "WARNING: Drains a lot of energy depending on the amount of repaired hull."%_t, lcolor = ColorRGB(1, 0.5, 0)})
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
