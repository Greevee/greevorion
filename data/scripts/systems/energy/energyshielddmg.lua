     --Active Armor Repaur by Greeve

     package.path = package.path .. ";data/scripts/systems/?.lua"
     package.path = package.path .. ";data/scripts/lib/?.lua"
     include ("basesystem")
     include ("utility")
     include ("randomext")
     
     updateCycle = 5
     
     FixedEnergyRequirement = true  -- must be dynamic
     
     function getUpdateInterval()
         return updateCycle
     end
     
     function update(timePassed)
     
        local rng= math.random()
        print(rng)
        if rng <= 0.04 then

            local maxShield = Entity().shieldMaxDurability

            local dmg=math.random()*0.5*maxShield

            Entity():healShield(-dmg)

        end
     end
     
     function getBonuses(seed, rarity, permanent)
         math.randomseed(seed)

         local energy = 15 -- base value, in percent
        -- add flat percentage based on rarity
        energy = energy + (rarity.value + 1) * 10 -- add 0% (worst rarity) to +60% (best rarity)

        -- add randomized percentage, span is based on rarity
        energy = energy + math.random() * ((rarity.value + 1) * 8) -- add random value between 0% (worst rarity) and +48% (best rarity)
        energy = energy * 0.6
        energy = energy / 100

        local charge = 15 -- base value, in percent
        -- add flat percentage based on rarity
        charge = charge + (rarity.value + 1) * 4 -- add 0% (worst rarity) to +24% (best rarity)

        -- add randomized percentage, span is based on rarity
        charge = charge + math.random() * ((rarity.value + 1) * 4) -- add random value between 0% (worst rarity) and +24% (best rarity)
        charge = charge * 0.6
        charge = charge / 100

        if permanent then
            energy = energy * 1.7
            charge = charge * 1.7
        end
         return energy, charge
     end
     
     function onInstalled(seed, rarity, permanent)
         local energy, charge   = getBonuses(seed, rarity, permanent) 
         addBaseMultiplier(StatsBonuses.GeneratedEnergy, energy)
         addBaseMultiplier(StatsBonuses.BatteryRecharge, charge)
     end
     
     function onUninstalled(seed, rarity, permanent)
     end
     
     function getName(seed, rarity)
         return "FusionCore Experimental Reactor Prototype ${mark}"%_t % {mark = toRomanLiterals(rarity.value + 2)}
     end
     
     function getIcon(seed, rarity)
        return "data/textures/icons/energy-inverter.png"
     end
     
     function getEnergy(seed, rarity, permanent)
         return 0
     end
     
     function getPrice(seed, rarity)
        local energy, charge = getBonuses(seed, rarity)
        local price = energy * 100 * 400 + charge * 100 * 300
        return price* 5 * 2.5 ^ rarity.value
     end
     
     function getTooltipLines(seed, rarity, permanent)
     
        local texts = {}
        local bonuses = {}
        local energy, charge = getBonuses(seed, rarity, permanent)
        local baseEnergy, baseCharge = getBonuses(seed, rarity, false)
        local permEnergy, permCharge = getBonuses(seed, rarity, true)
    
        if energy ~= 0 then
            table.insert(texts, {ltext = "Generated Energy"%_t, rtext = string.format("%+i%%", round(energy * 100)), icon = "data/textures/icons/electric.png", boosted = permanent})
            table.insert(bonuses, {ltext = "Generated Energy"%_t, rtext = string.format("%+i%%", round((permEnergy-baseEnergy) * 100)), icon = "data/textures/icons/electric.png"})
        end
    
        if charge ~= 0 then
            table.insert(texts, {ltext = "Battery Recharge Rate"%_t, rtext = string.format("%+i%%", round(charge * 100)), icon = "data/textures/icons/power-unit.png", boosted = permanent})
            table.insert(bonuses, {ltext = "Battery Recharge Rate"%_t, rtext = string.format("%+i%%", round((permCharge - baseCharge)* 100)), icon = "data/textures/icons/power-unit.png"})
        end
         return texts, bonuses
     end
     
     function getDescriptionLines(seed, rarity, permanent)
         local texts = {}
         table.insert(texts, {ltext = "Dangerous: Instable Tech"%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
         table.insert(texts, {ltext = "Shielddamage can occur everytime."%_t, lcolor = ColorRGB(1, 0.5, 0.5)})
         table.insert(texts, {ltext = "The sun isn't the only unstable reactor."%_t, lcolor = ColorRGB(0.3, 0.3, 0.3)})

         return texts
     end
     
     function getComparableValues(seed, rarity)
         local base = {}
         local bonus = {}
         -- no :<
         return base, bonus
     end
     