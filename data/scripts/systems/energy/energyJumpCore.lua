package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local energy = 15 -- base value, in percent
    -- add flat percentage based on rarity
    energy = energy + (rarity.value + 1) * 10 -- add 0% (worst rarity) to +60% (best rarity)

    -- add randomized percentage, span is based on rarity
    energy = energy + math.random() * ((rarity.value + 1) * 8) -- add random value between 0% (worst rarity) and +48% (best rarity)
    energy = energy * 0.10
    energy = energy / 100

    local charge = 15 -- base value, in percent
    -- add flat percentage based on rarity
    charge = charge + (rarity.value + 1) * 4 -- add 0% (worst rarity) to +24% (best rarity)

    -- add randomized percentage, span is based on rarity
    charge = charge + math.random() * ((rarity.value + 1) * 4) -- add random value between 0% (worst rarity) and +24% (best rarity)
    charge = charge * 0.8
    charge = charge / 100

    local cdfactor = 0
    local efactor = 0

    if permanent then
        energy = energy * 1.5
        charge = charge * 1.5

        cdfactor = 5 -- base value, in percent
        -- add flat percentage based on rarity
        cdfactor = cdfactor + (rarity.value + 1) * 3 -- add 0% (worst rarity) to +18% (best rarity)
    
        -- add randomized percentage, span is based on rarity
        cdfactor = cdfactor + math.random() * ((rarity.value + 1) * 4) -- add random value between 0% (worst rarity) and +18% (best rarity)
        cdfactor = -cdfactor / 100
    
        efactor = 5 -- base value, in percent
        -- add flat percentage based on rarity
        efactor = efactor + (rarity.value + 1) * 3 -- add 0% (worst rarity) to +18% (best rarity)
    
        -- add randomized percentage, span is based on rarity
        efactor = efactor + math.random() * ((rarity.value + 1) * 5) -- add random value between 0% (worst rarity) and +24% (best rarity)
        efactor = -efactor / 100
    end

    local probability = math.max(0, rarity.value * 0.34)
    if math.random() > probability then
        -- only 1 will be used
        if math.random() < 0.5 then
            cdfactor = 0
        else
            efactor = 0
        end
    end

    return energy, charge, cdfactor, efactor
end

function onInstalled(seed, rarity, permanent)
    local energy, charge, cdfactor, efactor = getBonuses(seed, rarity, permanent)

    addBaseMultiplier(StatsBonuses.GeneratedEnergy, energy)
    addBaseMultiplier(StatsBonuses.BatteryRecharge, charge)
    addBaseMultiplier(StatsBonuses.HyperspaceCooldown, cdfactor)
    addBaseMultiplier(StatsBonuses.HyperspaceRechargeEnergy, efactor)
end

function onUninstalled(seed, rarity, permanent)

end

function getName(seed, rarity)
    return "Plasma-JumpCore-Bridge"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/plasma-cell.png"
end

function getEnergy(seed, rarity, permanent)
    return 0
end

function getPrice(seed, rarity)
    local energy, charge = getBonuses(seed, rarity)
    local price = energy * 100 * 400 + charge * 100 * 300
    return 5* price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}
    local energy, charge, cdfactor, efactor = getBonuses(seed, rarity, permanent)
    local baseEnergy, baseCharge, basecdfactor, baseefactor = getBonuses(seed, rarity, false)
    local permEnergy, permCharge, permcdfactor, permefactor = getBonuses(seed, rarity, true)

    if energy ~= 0 then
        table.insert(texts, {ltext = "Generated Energy"%_t, rtext = string.format("%+i%%", round(energy * 100)), icon = "data/textures/icons/electric.png", boosted = permanent})
        table.insert(bonuses, {ltext = "Generated Energy"%_t, rtext = string.format("%+i%%", round(baseEnergy * 0.5 * 100)), icon = "data/textures/icons/electric.png"})
    end

    if charge ~= 0 then
        table.insert(texts, {ltext = "Battery Recharge Rate"%_t, rtext = string.format("%+i%%", round(charge * 100)), icon = "data/textures/icons/power-unit.png", boosted = permanent})
        table.insert(bonuses, {ltext = "Battery Recharge Rate"%_t, rtext = string.format("%+i%%", round(baseCharge * 0.5 * 100)), icon = "data/textures/icons/power-unit.png"})
    end

    if permcdfactor ~= 0 then
        if permanent then
            table.insert(texts, {ltext = "Hyperspace Cooldown"%_t, rtext = string.format("%+i%%", round(permcdfactor * 100)), icon = "data/textures/icons/hourglass.png", boosted = permanent})
        end
        table.insert(bonuses, {ltext = "Hyperspace Cooldown"%_t, rtext = string.format("%+i%%", round(permcdfactor * 100)), icon = "data/textures/icons/hourglass.png", boosted = permanent})
    end

    if permefactor ~= 0 then
        table.insert(bonuses, {ltext = "Jumpcore Energy Recharge"%_t, rtext = string.format("%+i%%", round(permefactor * 100)), icon = "data/textures/icons/electric.png"})
    end
    return texts, bonuses
end

     
function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Direct Reactor-Jumpcore bypass."%_t})
    return texts
end

function getComparableValues(seed, rarity)
    local energy, charge = getBonuses(seed, rarity, false)

    local base = {}
    local bonus = {}
    if energy ~= 0 then
        table.insert(base, {name = "Generated Energy"%_t, key = "generated_energy", value = round(energy * 100), comp = UpgradeComparison.MoreIsBetter})
        table.insert(bonus, {name = "Generated Energy"%_t, key = "generated_energy", value = round(energy * 0.5 * 100), comp = UpgradeComparison.MoreIsBetter})
    end

    if charge ~= 0 then
        table.insert(base, {name = "Recharge Rate"%_t, key = "recharge_rate", value = round(charge * 100), comp = UpgradeComparison.MoreIsBetter})
        table.insert(bonus, {name = "Recharge Rate"%_t, key = "recharge_rate", value = round(charge * 0.5 * 100), comp = UpgradeComparison.MoreIsBetter})
    end

    return base, bonus
end
