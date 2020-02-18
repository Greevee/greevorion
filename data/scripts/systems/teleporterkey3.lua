package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")

-- this key is dropped by Boss Swoks

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true
Unique = true

function onInstalled(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end

function getName(seed, rarity)
    return "XSTN-K III"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/key3.png"
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
        {ltext = "This system has 3 vertical /* continues with 'scratches on its surface.' */"%_t, rtext = "", icon = ""},
        {ltext = "scratches on its surface. /* continued from 'This system has 3 vertical' */"%_t, rtext = "", icon = ""}
    }
end
