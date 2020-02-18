package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")

-- this teleporter key is given by the Haatii

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
Unique = true

function onInstalled(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "XSTN-K I"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key1.png"
end

function getPrice(seed, rarity)
    return 1000000
end

function getTooltipLines(seed, rarity, permanent)
    return
    {
        {ltext = "This artifact seems to function as"%_t, rtext = "", icon = ""},
        {ltext = "some kind of ancient key."%_t, rtext = "", icon = ""},
    }
end

function getDescriptionLines(seed, rarity, permanent)
    return
    {
        {ltext = "This system has a vertical /* continues with 'scratch on its surface.' */"%_t, rtext = "", icon = ""},
        {ltext = "scratch on its surface. /* Continued from 'This system has a vertical'*/"%_t, rtext = "", icon = ""}
    }
end
