--Active Shield Booster by Greeve
-- Recharges Shield, needs much Energy, reduces Shieldamount

package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

local energyNeeded= 0

Unique = true -- like the highlander, more doesnt make sense cause decreasing shield an boosting recharge would equalize itself

energyPerDamage = 5000000  -- todo balance  10 mio
FixedEnergyRequirement = false  -- must be dynamic

updateCycle = 1

function getUpdateInterval()
    return updateCycle
end

function update(timePassed)

        --eversy 5 seconds, load shoul be trivial
    maxRechargeAmountPercent, sa, energySavePercent =getBonuses(getSeed(), getRarity(), getPermanent()) -- in % of max shields
    --todo: should  use the save and restore to save the variables?
    local maxShield = Entity().shieldMaxDurability -- loaded, can change in combat when blocks get destroyed
    local curShield = Entity().shieldDurability

    local maxRechage = (maxShield/100)*maxRechargeAmountPercent
    local shieldDmg = maxShield-curShield

    if shieldDmg >= maxRechage then
        energyNeeded = energyPerDamage * maxRechage * energySavePercent
        Entity():healShield(maxRechage)
    else
        energyNeeded = energyPerDamage * shieldDmg * energySavePercent
        Entity():healShield(shieldDmg)
    end

end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local energySavePercent = 1
    local bonusmaxRechargeAmountPercent = ((rarity.value +1)/24) + ((math.random() * (rarity.value +1) )/24)
    local shieldAmplification = -50 + (math.random() *(rarity.value) * 5)

    if permanent then
        bonusmaxRechargeAmountPercent = bonusmaxRechargeAmountPercent * 1.5
        energySavePercent = 1 - (((rarity.value +1) /6)*((math.random()*0.25) +0.25 )) -- 1 - 0.5
    end

    return bonusmaxRechargeAmountPercent, (shieldAmplification /100) , energySavePercent
end

function onInstalled(seed, rarity, permanent)

    local maxRechargeAmountPercent,shieldAmplification  = getBonuses(seed, rarity, permanent)
    addMultiplier(StatsBonuses.ShieldDurability, 1+shieldAmplification)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Active Shield Booster MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/shield-boost.png"
end

function getEnergy(seed, rarity, permanent)
    return energyNeeded
end

function getPrice(seed, rarity)
    local rechargeBase,shieldBase = getBonuses(seed, rarity, false)
    local price = rechargeBase * 100000 * 250
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}

    local recharge,shieldAmplification = getBonuses(seed, rarity, permanent)
    local rechargeBase,shieldBase = getBonuses(seed, rarity, false)
    local rechargePerm,shieldPerm,energy = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Recharges percent of the shield."%_t, rtext = string.format("%02.2f%%",  round(recharge,2)), icon = "data/textures/icons/health-normal.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Recharges percent of the shield."%_t, rtext = string.format("%02.2f%%", round(rechargePerm-rechargeBase,2)), icon = "data/textures/icons/health-normal.png"})

    table.insert(texts, {ltext = "Shield durability"%_t, rtext = string.format("%i%%", round( round(1-shieldAmplification) )), icon = "data/textures/icons/shield.png"})
    table.insert(bonuses, {ltext = "Energy saved."%_t, rtext = string.format("%02.2f%%",round(100-(energy*100),2) ), icon = "data/textures/icons/power-unit.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Recharges a percentage of the shields every ".. updateCycle .." seconds."%_t})
    table.insert(texts, {ltext = "Reduced max shield capacity."%_t})
    table.insert(texts, {ltext = "WARNING: Drains energy depends on the amount of recharged shield."%_t, lcolor = ColorRGB(0.8, 0.4, 0)})
    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}
    -- no :<
    return base, bonus
end
