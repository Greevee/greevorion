function FighterFactory.getStats(rarity, material, sizePoints, durabilityPoints, turningSpeedPoints, velocityPoints)
    sizePoints, durabilityPoints, turningSpeedPoints, velocityPoints = FighterFactory.addMaterialBonuses(material, sizePoints, durabilityPoints, turningSpeedPoints, velocityPoints)

    local size = round(lerp(sizePoints, 0, 9, 2.0, 1.0), 1)

    local durability   = round(lerp(durabilityPoints, 0, 13, 5, 35, true), 1) * 2
    local turningSpeed = round(lerp(turningSpeedPoints, 0, 13, 1.0, 3.5, true), 1)
    local maxVelocity  = round(lerp(velocityPoints, 0, 13, 15, 60, true), 1) * 5

    return size, durability, turningSpeed, maxVelocity
end
