function initializePlayer(player)

    local galaxy = Galaxy()
    local server = Server()

    local random = Random(server.seed)

    -- get a random angle, fixed for the server seed
    local angle = random:getFloat(2.0 * math.pi)


    -- for each player registered, add a small amount on top of this angle
    -- this way, all players are near each other
    local home = {x = 0, y = 0}
    local faction

    local distFromCenter = 450.0

    local distBetweenPlayers = 1 + random:getFloat(0, 1) -- distance between the home sectors of different players

    for i = 1, 3000 do
        -- we're looking at a distance of 500, so the perimeter is ~1413
        -- with every failure we walk a distance of 3 on the perimeter, so we're finishing a complete round about every 500 failing iterations
        -- every failed round we reduce the radius by several sectors to cover a bigger area.
        local offset = math.floor(i / 500) * 15

        home.x = math.cos(angle) * (distFromCenter - offset)
        home.y = math.sin(angle) * (distFromCenter - offset)

        -- try to place the player in the area of a faction
        faction = galaxy:getLocalFaction(home.x, home.y)
        if faction then
            -- found a faction we can place the player to - stop looking if we don't need different start sectors
            if server.sameStartSector then break end

            -- in case we need different starting sectors: keep looking
            if galaxy:sectorExists(home.x, home.y) then
                angle = angle + (distBetweenPlayers / distFromCenter)
            else
                break
            end
        else
            angle = angle + (3 / distFromCenter)
        end
    end

    player:setHomeSectorCoordinates(home.x, home.y)
    player:setRespawnSectorCoordinates(home.x, home.y)

    -- make sure the player has an early ally
    if not faction then
        faction = Galaxy():getNearestFaction(home.x, home.y)
    end

    faction:setValue("enemy_faction", -1) -- this faction won't participate in faction wars
    Galaxy():setFactionRelations(faction, player, 85000)
    player:setValue("start_ally", faction.index)

    local random = Random(SectorSeed(home.x, home.y) + player.index)

    if server.difficulty == Difficulty.Beginner then
        player:receive(100000, 10000)
    elseif server.difficulty == Difficulty.Easy then
        player:receive(50000, 10000)
    else
        player:receive(30000, 10000)
    end

    -- create turret generator
    local generator = SectorTurretGenerator()

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.Blaster, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.SRM, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.Autocannon, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.LRM, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.Miner, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    local turret = InventoryTurret(generator:generate(450, 0, nil, Rarity(RarityType.Common), WeaponType.Salvager, Material(MaterialType.Iron)))
    player:getInventory():add(turret, false)
    player:getInventory():add(turret, false)

    player:getInventory():addOrDrop(SystemUpgradeTemplate("data/scripts/systems/turrets/arbitrarytcs.lua", Rarity(RarityType.Uncommon), Seed(0)))
    player:getInventory():addOrDrop(SystemUpgradeTemplate("data/scripts/systems/turrets/arbitrarytcs.lua", Rarity(RarityType.Common), Seed(0)))
    player:getInventory():addOrDrop(SystemUpgradeTemplate("data/scripts/systems/turrets/arbitrarytcs.lua", Rarity(RarityType.Common), Seed(0)))


    player:createShipStyle("TestStyle")

end