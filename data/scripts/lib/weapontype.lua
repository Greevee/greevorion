function WeaponTypes.getRandom(rand)
    return rand:getInt(WeaponType.Blaster, WeaponType.Judgement)
end

-- hybrid weapon
WeaponTypes.addType("Blaster", "Blaster /* Weapon Type */"%_t, armed)
WeaponTypes.addType("Railgun", "Railgun /* Weapon Type */"%_t, armed)
WeaponTypes.addType("PPC", "PPC /* Weapon Type */"%_t, armed)  -- shield dmg, wenig armor dmg


-- missile weapon
WeaponTypes.addType("LRM", "LRM /* Weapon Type */"%_t, armed)
WeaponTypes.addType("SRM", "SRM /* Weapon Type */"%_t, armed)

-- balistic weapon
WeaponTypes.addType("Autocannon", "Autocannon /* Weapon Type */"%_t, armed)
WeaponTypes.addType("Artillery", "Artillery /* Weapon Type */"%_t, armed)

-- Laser weapons
WeaponTypes.addType("Beamlaser", "Beamlaser /* Weapon Type */"%_t, armed)
WeaponTypes.addType("Pulselaser", "Pulselaser /* Weapon Type */"%_t, armed)

--mining and salavaging
WeaponTypes.addType("Miner",       "Miner /* Weapon Type */"%_t, unarmed)
WeaponTypes.addType("DeepCoreMiner",       "Miner /* Weapon Type */"%_t, unarmed)

WeaponTypes.addType("Salvager",       "Salvager /* Weapon Type */"%_t, unarmed)
WeaponTypes.addType("Redeemer",       "Redeemer /* Weapon Type */"%_t, unarmed)

WeaponTypes.addType("TorpedoLauncher",       "TorpedoLauncher /* Weapon Type */"%_t, armed)
WeaponTypes.addType("LBX",       "LBX /* Weapon Type */"%_t, armed)
WeaponTypes.addType("HCG",       "HCG /* Weapon Type */"%_t, armed)

--experimental
WeaponTypes.addType("Judgement", "Judgement /* Weapon Type */"%_t, armed)
