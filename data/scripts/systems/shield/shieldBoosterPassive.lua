--Passive Shield Booster by Greeve
-- Recharges small amounts of Shield, need energy depending on shield size Energy

package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

energyPerShield = 10000   --50k
FixedEnergyRequirement = false
updateinterval = 1
local energyNeeded = 0

function getUpdateInterval()
    return updateinterval
end

function update(timePassed)
    --eversy 5 seconds, load shoul be trivial
    local rechargeAmountPercent,shieldAmplification, energySavePercent  = getBonuses(getSeed(), getRarity(), getPermanent()) -- in % of max shields
    local maxShield = Entity().shieldMaxDurability -- loaded, can change in combat when blocks get destroyed
    Entity():healShield((maxShield/100)*rechargeAmountPercent)
    energyNeeded= maxShield * energyPerShield* energySavePercent
end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)
    local energySavePercent =1
    local bonusmaxRechargeAmountPercent =  ((((math.random()*0.125) +0.125 )* (rarity.value +1) /12  ))
    local shieldAmplification = 12.5 + (math.random() *(rarity.value) * 2.5)

    if permanent then
        bonusmaxRechargeAmountPercent = bonusmaxRechargeAmountPercent * 1.5
        energySavePercent = 1 - (((rarity.value +1) /6)*((math.random()*0.25) +0.25 )) -- 1 - 0.5
    end
    bonusmaxRechargeAmountPercent= bonusmaxRechargeAmountPercent
    
    return bonusmaxRechargeAmountPercent , (shieldAmplification /100) ,energySavePercent
end

function onInstalled(seed, rarity, permanent)
 
    local rechargeAmountPercent,shieldAmplification  = getBonuses(seed, rarity, permanent)
    addBaseMultiplier(StatsBonuses.ShieldDurability, shieldAmplification)

end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Passive Shield Booster MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/shield-boost.png"
end

function getEnergy(seed, rarity, permanent)
    return energyNeeded 
end

function getPrice(seed, rarity)
    local rechargeAmountPercentBonus,shieldAmplificationBonus, energy  = getBonuses(seed, rarity, false)
    local price = (rechargeAmountPercentBonus * 10000 * 250 + shieldAmplificationBonus*1000 )* 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}

    local rechargeAmountPercent,shieldAmplification  = getBonuses(seed, rarity, permanent)
    local rechargeAmountPercentnormal,shieldAmplificationBase  = getBonuses(seed, rarity, false)
    local rechargeAmountPercentBonus,shieldAmplificationBonus, energy  = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Recharges percent of the shield."%_t, rtext = string.format("%02.2f",  round(rechargeAmountPercent,2)), icon = "data/textures/icons/health-normal.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Recharges percent of the shield."%_t, rtext = string.format("%02.2f", round(rechargeAmountPercentnormal,2)*1.5), icon = "data/textures/icons/health-normal.png"})

    table.insert(texts, {ltext = "Shield durability"%_t, rtext = string.format("%i%%", round(shieldAmplification * 100)), icon = "data/textures/icons/shield.png"})
    table.insert(bonuses, {ltext = "Shield durability"%_t, rtext = string.format("%i%%", round(shieldAmplificationBase * 100 * 0.5)), icon = "data/textures/icons/shield.png"})

    table.insert(bonuses, {ltext =  "Energy saved."%_t, rtext = string.format("%02.2f%%",round(100-(energy*100),2) ), icon = "data/textures/icons/power-unit.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Recharges a percentage of the shields every ".. updateinterval .." seconds."%_t})
    table.insert(texts, {ltext = "Extends the shield by a small amount."%_t, rtext = "", icon = ""})
    table.insert(texts, {ltext = "WARNING: Permanently Drains energy depending on maximum shield size."%_t, lcolor = ColorRGB(0.8, 0.4, 0)})
 
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
