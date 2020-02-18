package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

materialLevel = 0
range = 0
amount = 0
interestingEntities = {}
detections = {}
highlightRange = 0

local entityId

-- this variable gets reset on the client every time the player changes sectors because the script is recreated
local chatMessageDisplayed = false


-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local detections = {"entity/claim.lua"}
    if rarity.value >= RarityType.Common then
        table.insert(detections, "entity/wreckagetoship.lua")
    end

    if rarity.value >= RarityType.Uncommon then
        table.insert(detections, "entity/stash.lua")
        table.insert(detections, "entity/story/exodusbeacon.lua")
    end

    local highlightRange = 0
    if rarity.value >= RarityType.Rare then
        highlightRange = 500 + math.random() * 200
    end

    if rarity.value >= RarityType.Exceptional then
        highlightRange = 900 + math.random() * 200
    end

    if rarity.value >= RarityType.Exotic then
        highlightRange = math.huge
    end


    local range = 200 -- base value
    -- add flat range based on rarity
    range = range + (rarity.value + 1) * 80 -- add 0 (worst rarity) to +480 (best rarity)
    -- add randomized range, span is based on rarity
    range = range + math.random() * ((rarity.value + 1) * 20) -- add random value between 0 (worst rarity) and 120 (best rarity)

    local material = rarity.value + 1
    if math.random() < 0.25 then
        material = material + 1
    end

    local amount = 3
    -- add flat amount based on rarity
    amount = amount + (rarity.value + 1) * 2 -- add 0 (worst rarity) to +120 (best rarity)
    -- add randomized amount, span is based on rarity
    amount = amount + math.random() * ((rarity.value + 1) * 5) -- add random value between 0 (worst rarity) and 60 (best rarity)

    if permanent then
        range = range * 1.5
        amount = amount * 1.5
        material = material + 1
    end


    return detections, highlightRange, material, range, amount
end

function onInstalled(seed, rarity, permanent)
end

function onUninstalled(seed, rarity, permanent)
end


if onClient() then

function onInstalled(seed, rarity, permanent)
    local player = Player()
    if valid(player) then
        player:registerCallback("onPreRenderHud", "onPreRenderHud")
        player:registerCallback("onShipChanged", "detectAndSignal")
    end

    detections, highlightRange, material, range, amount= getBonuses(seed, rarity, permanent)
    addAbsoluteBias(StatsBonuses.ScannerMaterialReach, range)
    detectAndSignal()
end

function onUninstalled(seed, rarity, permanent)

end

function onDelete()
    if entityId then
        removeShipProblem("ValuablesDetector", entityId)
    end
end

function detectAndSignal()

    local player = Player()
    if valid(player) and player.craftIndex == Entity().index then
        -- check for valuables and send a signal
        interestingEntities = {}
        local entities = {Sector():getEntitiesByComponent(ComponentType.Scripts)}
        for _, entity in pairs(entities) do
            for _, script in pairs(detections) do
                if entity:hasScript(script) then
                    table.insert(interestingEntities, entity)
                    break
                end
            end
        end
    end

    signal()

end

function signal()
    local player = Player()

    if valid(player) and player.craftIndex == Entity().index then
        if #interestingEntities > 0 then
            if not chatMessageDisplayed then
                displayChatMessage("Valuable objects detected."%_t, "Object Detector"%_t, 3)
                chatMessageDisplayed = true
            end

            entityId = Entity().id
            addShipProblem("ValuablesDetector", entityId, "Valuable objects detected."%_t, "data/textures/icons/hazard-sign.png", ColorRGB(0, 1, 1))
        end
    end

end

function onSectorChanged()
    detectAndSignal()
end

function onPreRenderHud()

    if not highlightRange or highlightRange == 0 then return end

    local player = Player()
    if not player then return end
    if player.state == PlayerStateType.BuildCraft or player.state == PlayerStateType.BuildTurret then return end

    local shipPos = Entity().translationf

    -- detect all objects in range
    local renderer = UIRenderer()

    for i, entity in pairs(interestingEntities) do
        if not valid(entity) then
            interestingEntities[i] = nil
        end
    end

    for i, entity in pairs(interestingEntities) do
        local d = distance2(entity.translationf, shipPos)

        if d <= highlightRange * highlightRange then
            renderer:renderEntityTargeter(entity, ColorRGB(0, 0, 1));
            renderer:renderEntityArrow(entity, 30, 10, 250, ColorRGB(0, 0, 1));
        end
    end

    renderer:display()
end
end

function getName(seed, rarity)
    return "SM45 Scanmatrix MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/movement-sensor.png"
end

function getEnergy(seed, rarity, permanent)
    local detections, highlightRange = getBonuses(seed, rarity)
    highlightRange = math.min(highlightRange, 1500)

    return (highlightRange * 0.0005 * 1000 * 1000 * 1000) + (#detections * 15 * 1000 * 1000)
end

function getPrice(seed, rarity)
    local detections, range = getBonuses(seed, rarity)
    range = math.min(range, 1500)

    local price = #detections * 750 + range * 1.5;

    return 6 * price * 2.5 ^ rarity.value 
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}

    local _, range,materialLevel, mrange, amount = getBonuses(seed, rarity, permanent)
    local _,_, _, basemRange, baseAmount = getBonuses(seed, rarity, false)

    if range > 0 then
        local rangeText = "Sector"%_t
        if range < math.huge then
            rangeText = string.format("%g", round(range / 100, 2))
        end

        table.insert(texts, {ltext = "Highlight Range"%_t, rtext = rangeText, icon = "data/textures/icons/rss.png"})
    end

    table.insert(texts, {ltext = "Detection Range"%_t, rtext = "Sector"%_t, icon = "data/textures/icons/rss.png"})


   
    materialLevel = math.max(0, math.min(materialLevel, NumMaterials() - 1))
    local material = Material(materialLevel)

    table.insert(texts, {ltext = "Material Level"%_t, rtext = material.name%_t, rcolor = material.color, icon = "data/textures/icons/metal-bar.png", boosted = permanent})
    table.insert(texts, {ltext = "Scan Range"%_t, rtext = string.format("%g", round(mrange / 100, 2)), icon = "data/textures/icons/rss.png", boosted = permanent})
    table.insert(texts, {ltext = "Asteroids marked"%_t, rtext = string.format("%i", amount), icon = "data/textures/icons/rock.png", boosted = permanent})

    
    table.insert(bonuses, {ltext = "Material Level"%_t, rtext = "+1", icon = "data/textures/icons/metal-bar.png"})
    table.insert(bonuses, {ltext = "Scan Range"%_t, rtext = string.format("+%g", round(basemRange * 0.5 / 100, 2)), icon = "data/textures/icons/rss.png"})
    table.insert(bonuses, {ltext = "Asteroids marked"%_t, rtext = string.format("+%i", round(amount * 0.5)), icon = "data/textures/icons/rock.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}
    table.insert(texts, {ltext = "Omnisystems"%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
    if rarity.value == RarityType.Petty then
        table.insert(texts, {ltext = "Detects claimable asteroids"%_t, amount})
    elseif rarity.value == RarityType.Common then
        table.insert(texts, {ltext = "Detects claimable asteroids and wreckages"%_t, amount})
    elseif rarity.value == RarityType.Uncommon then
        table.insert(texts, {ltext = "Detects claimable asteroids, wreckages and stashes"%_t, amount})
    else
        table.insert(texts, {ltext = "Detects & highlights all interesting objects"%_t, amount})
    end


    table.insert(texts, {ltext = "Displays a notification when /* continues with 'interesting items were detected'*/"%_t})
    table.insert(texts, {ltext = "interesting items were detected /* continued from 'Displays a notification when'*/"%_t})
    table.insert(texts, {ltext = "Displays amount of resources in objects"%_t})
    table.insert(texts, {ltext = "Highlights nearby mineable objects"%_t})
    table.insert(texts, {ltext = "Ultimate combined scan systems"%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})
    

    return texts
end

function getComparableValues(seed, rarity)
    local _, range = getBonuses(seed, rarity, false)

    local base = {}
    local bonus = {}


    return base, bonus
end
