TurretIngredients[WeaponType.Autocannon] =
{
    {name = "Servo",                amount = 15,    investable = 8,     minimum = 5,    rarityFactor = 0.75, weaponStat = "fireRate", investFactor = 0.3, },
    {name = "High Pressure Tube",   amount = 1,     investable = 3,                     weaponStat = "reach", investFactor = 1.5},
    {name = "Ammunition M",         amount = 5,     investable = 10,    minimum = 1,    weaponStat = "damage", investFactor = 0.25},
    {name = "Explosive Charge",     amount = 2,     investable = 4,     minimum = 1,    weaponStat = "damage", investFactor = 0.75},
    {name = "Steel",                amount = 5,     investable = 10,    minimum = 3,},
    {name = "Aluminum",            amount = 7,     investable = 5,     minimum = 3,},
    {name = "Targeting System",     amount = 0,     investable = 2,     minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.Beamlaser] =
{
    {name = "Laser Head",           amount = 4,    investable = 4,              weaponStat = "damage", investFactor = 0.1, },
    {name = "Laser Compressor",     amount = 2,    investable = 2,              weaponStat = "damage", investFactor = 0.2, },
    {name = "High Capacity Lens",   amount = 2,    investable = 4,              weaponStat = "reach", investFactor = 2.0, },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 2,},
    {name = "Power Unit",           amount = 5,    investable = 3,  minimum = 3, turretStat = "maxHeat", investfactor = 1},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Crystal",              amount = 2,    investable = 10, minimum = 1,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.Pulselaser] =
{
    {name = "Laser Head",           amount = 4,    investable = 4,              weaponStat = "damage", investFactor = 0.1, },
    {name = "Laser Compressor",     amount = 2,    investable = 2,              weaponStat = "damage", investFactor = 0.2, },
    {name = "High Capacity Lens",   amount = 2,    investable = 4,              weaponStat = "reach", investFactor = 2.0, },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 2,},
    {name = "Power Unit",           amount = 5,    investable = 3,  minimum = 3, turretStat = "maxHeat", investfactor = 1},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Crystal",              amount = 2,    investable = 10, minimum = 1,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}


TurretIngredients[WeaponType.Blaster] =
{
    {name = "Plasma Cell",          amount = 8,    investable = 4,  minimum = 1,   weaponStat = "damage",   },
    {name = "Energy Tube",          amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Conductor",            amount = 5,    investable = 6,  minimum = 1,},
    {name = "Energy Container",     amount = 5,    investable = 6,  minimum = 1,},
    {name = "Power Unit",           amount = 5,    investable = 3,  minimum = 3,    turretStat = "maxHeat", investFactor = 1.5},
    {name = "Steel",                amount = 4,    investable = 10, minimum = 3,},
    {name = "Crystal",              amount = 2,    investable = 10, minimum = 1,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.Artillery] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,  weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Warhead",              amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage",  },
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Explosive Charge",     amount = 2,    investable = 6,  minimum = 1,    weaponStat = "damage", investFactor = 0.5,},
    {name = "Steel",                amount = 8,    investable = 10, minimum = 3,},
    {name = "Wire",                 amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.LRM] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,  weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Rocket",               amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage",  },
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Fuel",                 amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", investFactor = 0.5,},
    {name = "Steel",                amount = 8,    investable = 10, minimum = 3,},
    {name = "Wire",                 amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}
TurretIngredients[WeaponType.SRM] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,  weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Rocket",               amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage",  },
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Fuel",                 amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", investFactor = 0.5,},
    {name = "Steel",                amount = 8,    investable = 10, minimum = 3,},
    {name = "Wire",                 amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}
TurretIngredients[WeaponType.Schienenkanone] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,   weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Electromagnetic Charge",amount = 5,   investable = 6,  minimum = 1,   weaponStat = "damage", investFactor = 0.75,},
    {name = "Electro Magnet",       amount = 8,    investable = 10, minimum = 3,    weaponStat = "reach", investFactor = 0.75,},
    {name = "Gauss Rail",           amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", investFactor = 0.75,},
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach",  investFactor = 0.75,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Copper",               amount = 2,    investable = 10, minimum = 1,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}
TurretIngredients[WeaponType.PPC] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,   weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Electromagnetic Charge",amount = 5,   investable = 6,  minimum = 1,   weaponStat = "damage", investFactor = 0.75,},
    {name = "Electro Magnet",       amount = 8,    investable = 10, minimum = 3,    weaponStat = "reach", investFactor = 0.75,},
    {name = "Gauss Rail",           amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", investFactor = 0.75,},
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach",  investFactor = 0.75,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Copper",               amount = 2,    investable = 10, minimum = 1,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}


TurretIngredients[WeaponType.Miner] =
{
    {name = "Laser Compressor",     amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 0,    weaponStat = "stoneRefinedEfficiency", investFactor = 0.075, changeType = StatChanges.Flat },
    {name = "High Capacity Lens",   amount = 2,    investable = 6,  minimum = 0,    weaponStat = "reach",  investFactor = 2.0,},
    {name = "Conductor",            amount = 5,    investable = 6,  minimum = 2,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.DeepCoreMiner] =
{
    {name = "Laser Compressor",     amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 0,    weaponStat = "stoneRawEfficiency", investFactor = 0.075, changeType = StatChanges.Flat },
    {name = "High Capacity Lens",   amount = 2,    investable = 6,  minimum = 0,    weaponStat = "reach",  investFactor = 2.0,},
    {name = "Conductor",            amount = 5,    investable = 6,  minimum = 2,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.Salvager] =
{
    {name = "Laser Compressor",     amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 0,    weaponStat = "stoneRefinedEfficiency", investFactor = 0.075, changeType = StatChanges.Flat },
    {name = "High Capacity Lens",   amount = 2,    investable = 6,  minimum = 0,    weaponStat = "reach",  investFactor = 2.0,},
    {name = "Conductor",            amount = 5,    investable = 6,  minimum = 2,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.Redeemer] =
{
    {name = "Laser Compressor",     amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage", },
    {name = "Laser Modulator",      amount = 2,    investable = 4,  minimum = 0,    weaponStat = "stoneRawEfficiency", investFactor = 0.075, changeType = StatChanges.Flat },
    {name = "High Capacity Lens",   amount = 2,    investable = 6,  minimum = 0,    weaponStat = "reach",  investFactor = 2.0,},
    {name = "Conductor",            amount = 5,    investable = 6,  minimum = 2,},
    {name = "Steel",                amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}


TurretIngredients[WeaponType.TorpedoLauncher] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,  weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Rocket",               amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage",  },
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Fuel",                 amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", investFactor = 0.5,},
    {name = "Steel",                amount = 8,    investable = 10, minimum = 3,},
    {name = "Wire",                 amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}

TurretIngredients[WeaponType.LBX] =
{
    {name = "Servo",                amount = 15,   investable = 10, minimum = 5,  weaponStat = "fireRate", investFactor = 1.0, changeType = StatChanges.Percentage},
    {name = "Rocket",               amount = 5,    investable = 6,  minimum = 1,    weaponStat = "damage",  },
    {name = "High Pressure Tube",   amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", },
    {name = "Fuel",                 amount = 2,    investable = 6,  minimum = 1,    weaponStat = "reach", investFactor = 0.5,},
    {name = "Steel",                amount = 8,    investable = 10, minimum = 3,},
    {name = "Wire",                 amount = 5,    investable = 10, minimum = 3,},
    {name = "Targeting System",     amount = 0,    investable = 2,  minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}
TurretIngredients[WeaponType.HCG] =
{
    {name = "Servo",                amount = 15,    investable = 8,     minimum = 5,    rarityFactor = 0.75, weaponStat = "fireRate", investFactor = 0.3, },
    {name = "High Pressure Tube",   amount = 1,     investable = 3,                     weaponStat = "reach", investFactor = 1.5},
    {name = "Ammunition M",         amount = 5,     investable = 10,    minimum = 1,    weaponStat = "damage", investFactor = 0.25},
    {name = "Explosive Charge",     amount = 2,     investable = 4,     minimum = 1,    weaponStat = "damage", investFactor = 0.75},
    {name = "Steel",                amount = 5,     investable = 10,    minimum = 3,},
    {name = "Aluminum",            amount = 7,     investable = 5,     minimum = 3,},
    {name = "Targeting System",     amount = 0,     investable = 2,     minimum = 0, turretStat = "automatic", investFactor = 1, changeType = StatChanges.Flat},
}
