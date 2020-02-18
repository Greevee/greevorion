package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- dynamic stats
local rechargeReady = 0
local recharging = 0
local rechargeSpeed = 0

-- static stats
rechargeDelay = 600
rechargeTime = 5
rechargeAmount = 0.30

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getUpdateInterval()
    return 0.25
end

function updateServer(timePassed)
    rechargeReady = math.max(0, rechargeReady - timePassed)

    if recharging > 0 then
        recharging = recharging - timePassed
        Entity():healShield(rechargeSpeed * timePassed)
    end

end

function startCharging()

    if rechargeReady == 0 then
        local shield = Entity().shieldMaxDurability
        if shield > 0 then
            rechargeReady = rechargeDelay
            recharging = rechargeTime
            rechargeSpeed = shield * rechargeAmount / rechargeTime
        end
    end

end

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local durability = 20 -- base value, in percent

    -- add randomized percentage, span is based on rarity
    durability = (durability + (rarity.value  * 4)) * (2/3) -- add random value between 0% (worst rarity) and +60% (best rarity)
    durability = durability / 100

    local emergencyRecharge = 0

    if permanent then
        durability = durability * 1.5
        if rarity.value >= 2 then
            emergencyRecharge = 1
        end
    end

    return durability, emergencyRecharge
end

function onInstalled(seed, rarity, permanent)
    local durability, emergencyRecharge = getBonuses(seed, rarity, permanent)

    addBaseMultiplier(StatsBonuses.ShieldDurability, durability)

    if emergencyRecharge == 1 then
        Entity():registerCallback("onShieldDeactivate", "startCharging")
    else
        -- delete this function so it won't be called by the game
        -- -> saves performance
        updateServer = nil
    end

end

function onUninstalled(seed, rarity, permanent)

end

function getName(seed, rarity)
    return "Emergency Shield Extender MK${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/shield.png"
end

function getEnergy(seed, rarity, permanent)
    local durability, emergencyRecharge = getBonuses(seed, rarity)
    return (durability * 0.75) * 1000 * 1000 * 1000
end

function getPrice(seed, rarity)
    local durability,  emergencyRecharge = getBonuses(seed, rarity)
    local price = durability * 100 * 250 + emergencyRecharge * 15000
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}
    local durability, emergencyRecharge = getBonuses(seed, rarity, permanent)
    local baseDurability, baseEmergencyRecharge = getBonuses(seed, rarity, false)
    local _, bonusEmergencyRecharge = getBonuses(seed, rarity, true)

    if durability ~= 0 then
        table.insert(texts, {ltext = "Shield Durability"%_t, rtext = string.format("%+i%%", round(durability * 100)), icon = "data/textures/icons/health-normal.png", boosted = permanent})
        table.insert(bonuses, {ltext = "Shield Durability"%_t, rtext = string.format("%+i%%", round(baseDurability * 0.5 * 100)), icon = "data/textures/icons/health-normal.png"})
    end

    if emergencyRecharge ~= 0 then
        table.insert(texts, {ltext = "Emergency Recharge on Depletion"%_t, rtext = string.format("%i%%", round(rechargeAmount * 100)), icon = "data/textures/icons/shield-charge.png", boosted = permanent})
    end

    if bonusEmergencyRecharge ~= 0 then
        table.insert(bonuses, {ltext = "Emergency Recharge on Depletion"%_t, rtext = string.format("%i%%", round(rechargeAmount * 100)), icon = "data/textures/icons/shield-charge.png", })
    end

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local durability, emergencyRecharge = getBonuses(seed, rarity, permanent)
    local _, bonusEmergencyRecharge = getBonuses(seed, rarity, true)

    local texts = {}
    table.insert(texts, {ltext = "Extends the shield by a medium amount."%_t, rtext = "", icon = ""})
    if bonusEmergencyRecharge ~= 0 then
        table.insert(texts, {ltext = string.format("Upon depletion: Recharges %i%% of your shield."%_t, rechargeAmount * 100)})
        table.insert(texts, {ltext = "This effect can only occur every 10 minutes."%_t, lcolor = ColorRGB(1, 0.5, 0)})
    end

    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}

    local baseDurability, baseEmergencyRecharge = getBonuses(seed, rarity, false)
    local _, bonusEmergencyRecharge = getBonuses(seed, rarity, true)

    table.insert(base, {name = "Shield Durability"%_t, key = "durability", value = round(baseDurability * 100), comp = UpgradeComparison.MoreIsBetter})
    table.insert(base, {name = "Emergency Recharge Upon Depletion"%_t, key = "recharge_on_depletion", value = 0, comp = UpgradeComparison.MoreIsBetter})

    table.insert(bonus, {name = "Shield Durability"%_t, key = "durability", value = round(baseDurability * 0.5 * 100), comp = UpgradeComparison.MoreIsBetter})
    table.insert(bonus, {name = "Emergency Recharge Upon Depletion"%_t, key = "recharge_on_depletion", value = bonusEmergencyRecharge, comp = UpgradeComparison.MoreIsBetter})

    return base, bonus
end
