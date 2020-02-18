package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
PermanentInstallationOnly = true
Unique = true

function getNumTurrets(seed, rarity, permanent)
    return ((rarity.value +2) / 10)+1 
end

function onInstalled(seed, rarity, permanent)
    if not permanent then return end
    addMultiplier(StatsBonuses.ArbitraryTurrets, getNumTurrets(seed, rarity, permanent))
    addMultiplier(StatsBonuses.ArmedTurrets, getNumTurrets(seed, rarity, permanent))
    addMultiplier(StatsBonuses.UnarmedTurrets, getNumTurrets(seed, rarity, permanent))
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Omega Turret Control System"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/technology-part.png"
end

function getEnergy(seed, rarity, permanent)
    return 5000000000 * (1.2 ^ rarity.value)
end

function getPrice(seed, rarity)
    local price = 5000000
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}
    local numTurrets=getNumTurrets(seed, rarity, permanent)

    table.insert(texts, {ltext = "Armed or Unarmed Turret Slots x"%_t, rtext = string.format("%+f", round(numTurrets,1)), icon = "data/textures/icons/turret.png", boosted = permanent})
    table.insert(bonuses, {ltext = "Armed or Unarmed Turret Slots x"%_t, rtext = string.format("%+f", round(numTurrets,1)), icon = "data/textures/icons/turret.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Lost Tech"%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
    table.insert(texts, {ltext = "Omega Turret Controll System"%_t, rtext = "", icon = ""})
    return texts
end
