package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
PermanentInstallationOnly = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    -- rarity -1 is -1 / 2 + 1 * 50 = 0.5 * 100 = 50
    -- rarity 5 is 5 / 2 + 1 * 50 = 3.5 * 100 = 350
    local range = (rarity.value / 2 + 1 + round(getFloat(0.0, 0.4), 1)) * 100 * (1 + math.random())

    local fighterCargoPickup = 0
    if rarity.value >= RarityType.Rare then
        fighterCargoPickup = 1
    end

    local lootrange = (rarity.value + 2 + getFloat(0.0, 0.75)) * 2 * (1.3 ^ rarity.value) * 3  * 4-- one unit is 10 meters

    if permanent then
        lootrange = lootrange 
    end

    lootrange = round(lootrange)

    return range, fighterCargoPickup, lootrange
end

function onInstalled(seed, rarity, permanent)
    if not permanent then return end

    local range, fighterCargoPickup, lootrange = getBonuses(seed, rarity, permanent)
    addAbsoluteBias(StatsBonuses.TransporterRange, range)
    addAbsoluteBias(StatsBonuses.FighterCargoPickup, fighterCargoPickup)
    addAbsoluteBias(StatsBonuses.LootCollectionRange, lootrange)

end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "Logistic Software MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/processor.png"
end

function getEnergy(seed, rarity, permanent)
    return 0
end

function getPrice(seed, rarity)
    local range, fighterCargoPickup = getBonuses(seed, rarity, true)
    return range * 250 * 2
end

function getTooltipLines(seed, rarity, permanent)
    local range, fighterCargoPickup, lootrange = getBonuses(seed, rarity, permanent)
    local _ ,_ ,baselootrange = getBonuses(seed, rarity, false)

    local texts = {}
    local bonuses = {}

    
    table.insert(texts, {ltext = "Docking Distance"%_t, rtext = "+${distance} km"%_t % {distance = round((range / 100),2)}, icon = "data/textures/icons/solar-system.png", boosted = permanent})
    

    if fighterCargoPickup > 0 then
        table.insert(texts, {ltext = "Fighter Cargo Pickup"%_t, icon = "data/textures/icons/fighter.png", boosted = permanent})
    end

    table.insert(texts, {ltext = "Loot Collection lootrange"%_t, rtext = "+${distance} km"%_t % {distance = round(lootrange / 100, 2)}, icon = "data/textures/icons/sell.png", boosted = permanent})
    table.insert(bonuses,  {ltext = "Loot Collection lootrange"%_t, rtext = "+${distance} km"%_t % {distance = round(baselootrange * 2 / 100, 2)}, icon = "data/textures/icons/sell.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local range, fighterCargoPickup = getBonuses(seed, rarity, permanent)

    local texts =
    {
        {ltext = "Software for Transporter Blocks"%_t, rtext = "", icon = ""},
        {ltext = "Transporter Block on your ship required to work"%_t, rtext = "", icon = ""},
    }

    if fighterCargoPickup > 0 then
        table.insert(texts, {ltext = "Allows fighters to pick up cargo"%_t, rtext = "", icon = ""})
    end

    return texts
end

function getComparableValues(seed, rarity)
    local range, fighterCargoPickup = getBonuses(seed, rarity, permanent)

    local base = {}
    local bonus = {}
    return base, bonus
end
