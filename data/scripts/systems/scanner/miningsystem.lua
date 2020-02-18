package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

materialLevel = 0
range = 0
amount = 0

-- optimization so that energy requirement doesn't have to be read every frame
FixedEnergyRequirement = true

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local range = 200 -- base value
    -- add flat range based on rarity
    range = range + (rarity.value + 1) * 80 -- add 0 (worst rarity) to +480 (best rarity)
    -- add randomized range, span is based on rarity
    range = range + math.random() * ((rarity.value + 1) * 20) -- add random value between 0 (worst rarity) and 120 (best rarity)
    range = range * 2

    local material = rarity.value + 1
    if math.random() < 0.25 then
        material = material + 1
    end
    if math.random() < 0.25 then
        material = material + 1
    end

    local amount = 3
    -- add flat amount based on rarity
    amount = amount + (rarity.value + 1) * 2 -- add 0 (worst rarity) to +120 (best rarity)
    -- add randomized amount, span is based on rarity
    amount = amount + (math.random()*2) * ((rarity.value + 1) * 5) -- add random value between 0 (worst rarity) and 60 (best rarity)

    if permanent then
        range = range * 1.5
        amount = amount * 1.5
        material = material + 1
    end

    return material, range, amount
end

function onInstalled(seed, rarity, permanent)
    if onClient() and valid(Player()) then
        Player():registerCallback("onPreRenderHud", "onPreRenderHud")
    end

    materialLevel, range, amount = getBonuses(seed, rarity, permanent)

    addAbsoluteBias(StatsBonuses.ScannerMaterialReach, range)
end

function onUninstalled(seed, rarity, permanent)

end

function sort(a, b)
    return a.distance < b.distance
end

function onPreRenderHud()

    local player = Player()
    if not player then return end
    if player.state == PlayerStateType.BuildCraft or player.state == PlayerStateType.BuildTurret then return end

    local ship = Entity()
    if player.craftIndex ~= ship.index then return end

    local shipPos = ship.translationf

    local sphere = Sphere(shipPos, range)
    local nearby = {Sector():getEntitiesByLocation(sphere)}
    local displayed = {}

    -- detect all asteroids in range
    for _, entity in pairs(nearby) do

        if entity.type == EntityType.Asteroid then
            local resources = entity:getMineableResources()
            if resources ~= nil and resources > 0 then
                local material = entity:getMineableMaterial()

                if material.value <= materialLevel then

                    local d = distance2(entity.translationf, shipPos)

                    table.insert(displayed, {material = material, asteroid = entity, distance = d})
                end
            end
        end

    end

    -- sort by distance
    table.sort(displayed, sort)

    -- display nearest x
    local renderer = UIRenderer()

    for i = 1, math.min(#displayed, amount) do
        local tuple = displayed[i]
        renderer:renderEntityTargeter(tuple.asteroid, tuple.material.color);
        renderer:renderEntityArrow(tuple.asteroid, 30, 10, 250, tuple.material.color);
    end

    renderer:display()
end

function getName(seed, rarity)
    return "Mining System MK ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
end

function getIcon(seed, rarity)
    return "data/textures/icons/mining.png"
end

function getEnergy(seed, rarity, permanent)
    local materialLevel, range, amount = getBonuses(seed, rarity)

    return (range * 0.0005 * materialLevel * 1000 * 1000 * 1000) + (amount * 5 * 1000 * 1000)
end

function getPrice(seed, rarity)
    local materialLevel, range, amount = getBonuses(seed, rarity)

    local price = materialLevel * 5000 + amount * 750 + range * 1.5;

    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity, permanent)
    local texts = {}
    local bonuses = {}

    local materialLevel, range, amount = getBonuses(seed, rarity, permanent)
    materialLevel = math.max(0, math.min(materialLevel, NumMaterials() - 1))
    local material = Material(materialLevel)

    table.insert(texts, {ltext = "Material"%_t, rtext = material.name%_t, rcolor = material.color, icon = "data/textures/icons/metal-bar.png", boosted = permanent})
    table.insert(texts, {ltext = "Range"%_t, rtext = string.format("%g", round(range / 100, 2)), icon = "data/textures/icons/rss.png", boosted = permanent})
    table.insert(texts, {ltext = "Asteroids"%_t, rtext = string.format("%i", amount), icon = "data/textures/icons/rock.png", boosted = permanent})

    local _, baseRange, baseAmount = getBonuses(seed, rarity, false)
    table.insert(bonuses, {ltext = "Material Level"%_t, rtext = "+1", icon = "data/textures/icons/metal-bar.png"})
    table.insert(bonuses, {ltext = "Range"%_t, rtext = string.format("+%g", round(baseRange * 0.5 / 100, 2)), icon = "data/textures/icons/rss.png"})
    table.insert(bonuses, {ltext = "Asteroids"%_t, rtext = string.format("+%i", round(amount * 0.5)), icon = "data/textures/icons/rock.png"})

    return texts, bonuses
end

function getDescriptionLines(seed, rarity, permanent)
    local texts = {}

    table.insert(texts, {ltext = "Displays amount of resources in objects"%_t})
    table.insert(texts, {ltext = "Highlights nearby mineable objects"%_t})

    return texts
end

function getComparableValues(seed, rarity)
    local base = {}
    local bonus = {}

    local materialLevel, range, amount = getBonuses(seed, rarity, permanent)
    materialLevel = math.max(0, math.min(materialLevel, NumMaterials() - 1))
    local _, baseRange, baseAmount = getBonuses(seed, rarity, false)

    table.insert(base, {name = "Material"%_t, key = "material", value = materialLevel, comp = UpgradeComparison.MoreIsBetter})
    table.insert(base, {name = "Range"%_t, key = "range", value = round(range / 100, 2), comp = UpgradeComparison.MoreIsBetter})
    table.insert(base, {name = "Asteroids"%_t, key = "asteroids", value = round(amount), comp = UpgradeComparison.MoreIsBetter})

    table.insert(bonus, {name = "Material Level"%_t, key = "material", value = 1, comp = UpgradeComparison.MoreIsBetter})
    table.insert(bonus, {name = "Range"%_t, key = "range", value = round(baseRange * 0.5 / 100, 2), comp = UpgradeComparison.MoreIsBetter})
    table.insert(bonus, {name = "Asteroids"%_t, key = "asteroids", value = round(amount * 0.5), comp = UpgradeComparison.MoreIsBetter})

    return base, bonus
end
