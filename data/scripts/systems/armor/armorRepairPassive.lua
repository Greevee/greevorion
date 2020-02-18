--Passive Shield Booster by Greeve
-- Recharges small amounts of Shield, need energy depending on shield size Energy

package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

local energyPerHull = 50000
FixedEnergyRequirement = false
local energyNeeded = 0

updateCycle= 1

function getUpdateInterval()
    return updateCycle
end

function update(timePassed)
    local repairAmountPercent , energySavePercent= getBonuses(getSeed(), getRarity(), getPermanent()) -- in % of max shields

    local maxHull = Entity().maxDurability -- loaded, can change in combat when blocks get destroyed
    local durability = Entity().durability
    local repairAmount = (maxHull/100) *repairAmountPercent

    
    Entity().durability= durability + repairAmount
    energyNeeded= maxHull * energyPerHull * energySavePercent

end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local baseamountRepair= ((rarity.value +1) /6)*(1/10) * math.random()
    local bonusRepairAmountPercent =  ((((math.random()*0.25) +0.25 )* ((rarity.value +1) /6)))/5 -- 0 - 1%
    local energySavePercent =1


    if permanent then
        bonusRepairAmountPercent = bonusRepairAmountPercent * 2
        energySavePercent = 1 - (((rarity.value +1) /6)*((math.random()*0.25) +0.25 )) -- 1 - 0.5
    end
    return baseamountRepair+bonusRepairAmountPercent, energySavePercent
end

function onInstalled(seed, rarity, permanent)

end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Regenerativ Hull MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/mod-uploaded.png"
end

function getEnergy(seed, rarity, permanent)
    return energyNeeded 
end

function getPrice(seed, rarity)
    local repairAmountPercent, energySavePercent  = getBonuses(seed, rarity, false)
    return (repairAmountPercent * 100000 +energySavePercent*100000 )*2.5 ^ rarity.value -- oof, whats fair? how much is the fish?
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}

    local repairAmountPercent, energySavePercent  = getBonuses(seed, rarity, permanent)
    local repairAmountPercentnormal , energySavePercentnormal = getBonuses(seed, rarity, false)
    local repairAmountPercentboost , energySavePercentboost = getBonuses(seed, rarity, true)

    print(energySavePercent)
    table.insert(texts, {ltext = "Repairs percent of the hull."%_t, rtext = string.format("%02.2f%%",  round(repairAmountPercentnormal,2)), icon = "data/textures/icons/repair.png", boosted = permanent})
    table.insert(bonuses, {ltext =  "Repairs percent of the hull."%_t, rtext = string.format("%02.2f%%", round(repairAmountPercentboost-repairAmountPercentnormal,2)), icon = "data/textures/icons/repair.png"})

    table.insert(bonuses, {ltext =  "Energy saved."%_t, rtext = string.format("%02.2f%%",round(100-(energySavePercentboost*100),2) ), icon = "data/textures/icons/power-unit.png"})


    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Repairs a percentage of the hull every "..updateCycle .." seconds."%_t})
    table.insert(texts, {ltext = "Nanomachines!"%_t, lcolor = ColorRGB(0, 0.7, 0.7)})
    table.insert(texts, {ltext = "WARNING: Permanently Drains energy depending on maximum hull size."%_t, lcolor = ColorRGB(0.8, 0.4, 0)})
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
