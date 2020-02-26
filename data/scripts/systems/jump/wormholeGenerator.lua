package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
Unique = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local reach = 0
    local efactor = 0
    local cdfactor = 0

    reach = math.max(1, rarity.value + 1)

    if permanent then
        reach = reach * 2.5 + ((math.random())*(rarity.value+1) ^ 2 ) / 2
        cdfactor = 0

        cdfactor = 20 -- base value, in percent
        -- add flat percentage based on rarity
        cdfactor = cdfactor + (rarity.value + 1) * 3 -- add 0% (worst rarity) to +18% (best rarity)

        -- add randomized percentage, span is based on rarity
        cdfactor = cdfactor + math.random() * ((rarity.value + 1) * 3) -- add random value between 0% (worst rarity) and +18% (best rarity)
        cdfactor = -cdfactor / 100

    else
        cdfactor = reach * 3 * (math.random()+1 )
        cdfactor = cdfactor / 100
    end
    efactor = reach / 2

    return reach, cdfactor, efactor
end

function onInstalled(seed, rarity, permanent)
    local reach, cooldown, energy = getBonuses(seed, rarity, permanent)
    addMultiplyableBias(StatsBonuses.HyperspaceReach, reach)
    addBaseMultiplier(StatsBonuses.HyperspaceCooldown, cooldown)
    addBaseMultiplier(StatsBonuses.HyperspaceRechargeEnergy, energy)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    local reach, cooldown, energy = getBonuses(seed, rarity)
    return "Einstein-Rosen-Bridge Generator MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/vortex.png"
end

function getEnergy(seed, rarity, permanent)
    local reach, cdfactor, efactor = getBonuses(seed, rarity, permanent)
    return math.abs(cdfactor) * 2.5 * 1000 * 1000 * 1000 + reach * 125 * 1000 * 10000
end

function getPrice(seed, rarity)
    local reach, _, efactor = getBonuses(seed, rarity, false)
    local _, cdfactor, _= getBonuses(seed, rarity, true)
    local price = math.abs(cdfactor) * 100 * 350 + math.abs(efactor) * 100 * 250 + reach * 3000
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}
    local reach, cdfactor, efactor = getBonuses(seed, rarity, permanent)
    local baseReach, _, baseefactor = getBonuses(seed, rarity, false)
    local permReach, permcdfactor, permefactor = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Jump Range"%_t, rtext = string.format("%+i", reach), icon = "data/textures/icons/star-cycle.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Jump Range"%_t, rtext = string.format("%+i", round(permReach-baseReach)), icon = "data/textures/icons/star-cycle.png", boosted = permanent})

    table.insert(texts, {ltext = "Hyperspace Cooldown"%_t, rtext = string.format("%+i%%", round(cdfactor * 100)), icon = "data/textures/icons/hourglass.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Hyperspace Cooldown"%_t, rtext = string.format("%+i%%", round((-cdfactor + permcdfactor) * 100)), icon = "data/textures/icons/hourglass.png", boosted = permanent})

    table.insert(texts, {ltext = "Recharge Energy"%_t, rtext = string.format("%+i%%", round(efactor * 100)), icon = "data/textures/icons/electric.png"})
    table.insert(bonuses, {ltext = "Recharge Energy"%_t, rtext = string.format("%+i%%", round((permefactor-efactor) * 100)), icon = "data/textures/icons/hourglass.png", boosted = permanent})

    if #bonuses == 0 then bonuses = nil end

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Creates a Einstein-Rosen-Bridge to travel."%_t})
    table.insert(texts, {ltext = "INFO: Final consists of normal - permanent cooldown"%_t, lcolor = ColorRGB(0.5, 0.5, 0.5)})
    table.insert(texts, {ltext = "WARNING: Consumes MASSIV amounts of energy to charge."%_t, lcolor = ColorRGB(1, 0.5, 0)})
    table.insert(texts, {ltext = "WARNING: Increases cooldown if not installed permanently."%_t, lcolor = ColorRGB(1, 0.5, 0)})
    table.insert(texts, {ltext = "..the beginning and the end of time."%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})
    table.insert(texts, {ltext = "These are the same thing, as everybody"%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})
    table.insert(texts, {ltext = "knows who came into this universe via a wormhole."%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})

    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}

    return base, bonus
end
