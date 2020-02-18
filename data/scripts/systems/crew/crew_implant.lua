package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

FixedEnergyRequirement = true
Unique = true

function getBonuses(seed, rarity, permanent)
	math.randomseed(seed)
    
	local perc = 10 
    perc = perc +((rarity.value) * 2 )

    -- add randomized percentage, span is based on rarity
    perc = perc + (math.random() * (rarity.value * 2))
    perc = perc / 100
    if permanent then
        perc= perc*1.5
    end
    return perc
end

function onInstalled(seed, rarity, permanent) 
    local perc = getBonuses(seed, rarity, permanent)

	addBaseMultiplier(StatsBonuses.Engineers, perc)
    addBaseMultiplier(StatsBonuses.Mechanics, perc)
    addBaseMultiplier(StatsBonuses.Gunners, perc)
    addBaseMultiplier(StatsBonuses.Miners, perc)
    addBaseMultiplier(StatsBonuses.Security, perc)
    addBaseMultiplier(StatsBonuses.Attackers, perc)
end

function onUninstalled(seed, rarity, permanent)

end

function getName(seed, rarity)
    return "Implant Crew Upgrade MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/crew.png"
end

function getEnergy(seed, rarity, permanent)
    local perc = getBonuses(seed, rarity, permanent)
    return perc * (5 ^ rarity.value) *1000
end

function getPrice(seed, rarity)
    local perc = getBonuses(seed, rarity)
    local price = perc * 100 * 25 * 75
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)

    local texts = {}
    local bonuses = {}
    local perc = getBonuses(seed, rarity, permanent)
    local basePerc = getBonuses(seed, rarity, false)
    local boostedPerc = getBonuses(seed, rarity, true)

    table.insert(texts, {ltext = "Engineers efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Engineers efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(texts, {ltext = "Mechanics efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Mechanics efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(texts, {ltext = "Gunners efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Gunners efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(texts, {ltext = "Miners efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Miners efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(texts, {ltext = "Security efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Security efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(texts, {ltext = "Attackers efficency"%_t, rtext = string.format("%+i%%", round(perc * 100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})
    table.insert(bonuses, {ltext = "Attackers efficency"%_t, rtext = string.format("%+i%%", round((boostedPerc-basePerc)*100)), icon = CrewProfession(CrewProfessionType.None).icon, boosted = permanent})

    return texts, texts
end

function getDescriptionLines(seed, rarity, permanent)
    return
    {
        {ltext = "Implant upgrade for most crew members and their efficency."%_t, lcolor = ColorRGB(1, 1, 1)}
    }
end
