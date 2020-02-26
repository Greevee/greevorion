


--weapon probabilities


-- new weapons
weaponProbabilities[WeaponType.Blaster] = {p = 1.0}
weaponProbabilities[WeaponType.Railgun] = {d = 0.7, p = 0.5}
weaponProbabilities[WeaponType.LRM] = {p = 1.0}
weaponProbabilities[WeaponType.SRM] = {p = 1.0}
weaponProbabilities[WeaponType.Autocannon] = {p = 1.0}
weaponProbabilities[WeaponType.Artillery] = {d = 0.8, p = 0.5}
weaponProbabilities[WeaponType.Beamlaser] = {d = 0.6, p = 0.6}
weaponProbabilities[WeaponType.Pulselaser] = {p = 1.0}
weaponProbabilities[WeaponType.PPC] = {d = 0.5, p = 0.4}
weaponProbabilities[WeaponType.TorpedoLauncher] = {d = 0.5, p = 0.5}
weaponProbabilities[WeaponType.LBX] = {d = 0.6, p = 0.4}
weaponProbabilities[WeaponType.HCG] = {d = 0.7, p = 0.4}

-- mining
weaponProbabilities[WeaponType.Miner] = {p = 0.8}
weaponProbabilities[WeaponType.DeepCoreMiner] = {d = 0.8,p = 0.2}
weaponProbabilities[WeaponType.Salvager] = {p = 0.8}
weaponProbabilities[WeaponType.Redeemer] = {d = 0.5,p = 0.2}


weaponProbabilities[WeaponType.PointDefenseChainGun] = {p = 1}
weaponProbabilities[WeaponType.PointDefenseLaser] =    {d = 1, p = 0.5}
weaponProbabilities[WeaponType.AntiFighter] =          {d = 0.7, p = 0.5}

-- doomsday
weaponProbabilities[WeaponType.Judgement] = {d = 0.1, p = 0.0}

weaponProbabilities[WeaponType.ChainGun] =             {p = 0}
weaponProbabilities[WeaponType.MiningLaser] =          {p = 0}
weaponProbabilities[WeaponType.RawMiningLaser] =       {d = 0.85, p = 0}
weaponProbabilities[WeaponType.SalvagingLaser] =       {p = 0}
weaponProbabilities[WeaponType.RawSalvagingLaser] =    {d = 0.85, p = 0}
weaponProbabilities[WeaponType.Bolter] =               {d = 0.9, p = 0}
weaponProbabilities[WeaponType.ForceGun] =             {d = 0.85, p = 0}
weaponProbabilities[WeaponType.Laser] =                {d = 0.75, p = 0}
weaponProbabilities[WeaponType.TeslaGun] =             {d = 0.73, p = 0}
weaponProbabilities[WeaponType.PulseCannon] =          {d = 0.73, p = 0}
weaponProbabilities[WeaponType.Cannon] =               {d = 0.65, p = 0}
weaponProbabilities[WeaponType.RepairBeam] =           {d = 0.65, p = 0}
weaponProbabilities[WeaponType.PlasmaGun] =            {d = 0.6, p = 0}
weaponProbabilities[WeaponType.RocketLauncher] =       {d = 0.6, p = 0}
weaponProbabilities[WeaponType.RailGun] =              {d = 0.6, p = 0}
weaponProbabilities[WeaponType.LightningGun] =         {d = 0.4, p = 0}



local turretsInCenter = 50

function Balancing_GetSectorShipVolume(x, y)
    -- sectors near the center shall be have bigger ships in them

    local coords = vec2(x, y)

    local maxDist = Balancing_GetDimensions() / 2
    local dist = length(coords)

    if dist > maxDist then dist = maxDist end
    local linFactor = 1.0 - (dist / maxDist) -- range 0 to 1, 0 at the edge (not corner)
    local linFactorOverall = linFactor -- range 0 to 1, 0 at the edge (not corner)
    local linFactorOuter = math.min(1.0, math.max(0.0, 1.0 - (dist / 400))) -- range 0 to 1, 0 at 400
    local linFactorMid = math.min(1.0, math.max(0.0, 1.0 - (dist / 300))) -- etc


    local b = 150
    local q = 1000
    local loverall = 1000
    local louter = 2500
    local lmid = 2500

    local distFactor = linFactor * 3 + 1.0 -- range 1 to 4
    distFactor = math.pow(distFactor, 4) - 1 -- rise from 0 to 255

    local shipVolume = distFactor * (q / 255) -- flat in the beginning, more steep at the center
    shipVolume = shipVolume + linFactorOverall * loverall -- add a linear factor for the outer regions, so some progress is visible.
    shipVolume = shipVolume + linFactorOuter * louter *2.5-- add a linear factor for the inner regions, so the difficulty rises after the early game
    shipVolume = shipVolume + linFactorMid * lmid * 5 -- add a linear factor for the inner regions, so the difficulty rises after the early game

    shipVolume = shipVolume * (shipVolumeInCenter / (q + loverall + louter + lmid))

    shipVolume = shipVolume + b -- add a small basic factor so there are no ships with volume 0 in the outer regions

    return shipVolume 
end

function Balancing_GetEnemySectorTurrets(x, y)
    return math.floor(Balancing_GetEnemySectorTurretsUnrounded(x, y))
end

function Balancing_GetSectorWeaponDPS(x, y)

    -- this function creates a dps ratio to the hp so an average player ship with average numbers of turrets
    -- takes 15 seconds to destroy another average ship
    local coords = vec2(x, y)

    local dist = length(coords)

    local la = math.min(1.0, math.max(0.0, 1.0 - (dist / 800))) -- range 0 to 1, 0 at 800
    local lb = math.min(1.0, math.max(0.0, 1.0 - (dist / 560))) -- etc
    local lc = math.min(1.0, math.max(0.0, 1.0 - (dist / 470)))
    local ld = math.min(1.0, math.max(0.0, 1.0 - (dist / 430)))
    local le = math.min(1.0, math.max(0.0, 1.0 - (dist / 360)))
    local lf = math.min(1.0, math.max(0.0, 1.0 - (dist / 310)))
    local lg = math.min(1.0, math.max(0.0, 1.0 - (dist / 220)))
    local lmin = math.min(1.0, math.max(0.0, 1.0 - (dist / 220)))

    local dps = 0
    dps = math.max(dps, 95 * la)
    dps = math.max(dps, 190 * lb)
    dps = math.max(dps, 310 * lc)
    dps = math.max(dps, 370 * ld)
    dps = math.max(dps, 470 * le)
    dps = math.max(dps, 550 * lf)
    dps = math.max(dps, 650 * lg)

    -- add a cap so dps won't explode towards the middle
    dps = math.min(dps, 100 * lmin + 500)

    -- finally apply the size factor here, too, since this one should scale with the ship sizes from Balancing_GetSectorShipVolume
    local maximumHP = Balancing_GetSectorShipHP(0, 0)
    local maximumTurrets = Balancing_GetSectorTurretsUnrounded(0, 0)
    local maximumDps = maximumHP / maximumTurrets / (15.0 )-- assuming it should this many seconds to destroy an average ship with a fully armed ship in the center
-- 100 / 25 -> 4
-- 100 / 50 -> 2
    -- print (maximumDps)

    dps = dps * (maximumDps / 600)

    dps = math.max(dps, 18)

    return dps, Balancing_GetTechLevel(x, y)
end