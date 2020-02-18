package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")

-- this key is sold by the travelling merchant

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
Unique = true

function onInstalled(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "XSTN-K IV"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key4.png"
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
        {ltext = "This system has 4 vertical /* continues with 'scratches on its surface.' */"%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface. /* continued from 'This system has 4 vertical' */"%_t, rtext = "", icon = ""}
    }
end
