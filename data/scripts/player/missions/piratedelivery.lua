function generateTurret()
    local weaponTypes = {}
	
	weaponTypes[WeaponType.Blaster] = 1
	weaponTypes[WeaponType.Schienenkanone]= 1
	weaponTypes[WeaponType.LRM] = 1
	weaponTypes[WeaponType.SRM] = 1
	weaponTypes[WeaponType.Autocannon] = 1
	weaponTypes[WeaponType.Artillery] = 1
	weaponTypes[WeaponType.Beamlaser] = 1
	weaponTypes[WeaponType.Pulselaser] = 1


    local rarities = {}
    rarities[RarityType.Rare] = 3
    rarities[RarityType.Exceptional] = 4
    rarities[RarityType.Exotic] = 1


    local probabilities = Balancing_GetMaterialProbability(Sector():getCoordinates())
    local materials = {}
    materials[0] = probabilities[0]
    materials[1] = probabilities[1]
    materials[2] = probabilities[2]
    materials[3] = probabilities[3]
    materials[4] = probabilities[4]
    materials[5] = probabilities[5]
    materials[6] = probabilities[6]

    local x, y = Sector():getCoordinates()

    local rarity = selectByWeight(random(), rarities)
    local material = selectByWeight(random(), materials)
    local weaponType = selectByWeight(random(), weaponTypes)

    return InventoryTurret(SectorTurretGenerator():generate(x, y, 0, Rarity(rarity), weaponType, Material(material)))
end