
scripts = {}

-- modified or new modules
-- turrets  -- modded
add("data/scripts/systems/turrets/arbitrarytcs.lua", 2)
add("data/scripts/systems/turrets/militarytcs.lua", 2)
add("data/scripts/systems/turrets/civiltcs.lua", 2)
add("data/scripts/systems/turrets/lostTech_TurretControl.lua",0.01)

-- shieldmodules
add("data/scripts/systems/shield/shieldBoosterActive.lua", 0.3) --very strong active regen , high
add("data/scripts/systems/shield/shieldBoosterPassive.lua",0.3) -- strong actrive regen, medium energy costs
add("data/scripts/systems/shield/shieldExtender.lua",1) -- extends shields by a lot
add("data/scripts/systems/shield/shieldExtenderEmergency.lua", 0.5) -- extends shields by some, emergency shield
add("data/scripts/systems/shield/shieldHardener.lua",0.5) -- impenetrable shierld, custs energy
--armor
add("data/scripts/systems/armor/armorRepairActive.lua",0.3) -- impenetrable shierld, custs energy
add("data/scripts/systems/armor/armorRepairPassive.lua",0.3) -- impenetrable shierld, custs energy
add("data/scripts/systems/armor/cargologistic.lua",0.5) -- impenetrable shierld, custs energy
add("data/scripts/systems/armor/cargospeed.lua",0.5)
add("data/scripts/systems/armor/cargohulldmg.lua",0.3)


add("data/scripts/systems/crew/crew_implant.lua",0.5)
add("data/scripts/systems/crew/lostTech_AI.lua",0.01)

add("data/scripts/systems/energy/energyshielddmg.lua",0.1)
add("data/scripts/systems/energy/energybooster.lua",1)
add("data/scripts/systems/energy/energyJumpCore.lua",0.2)

add("data/scripts/systems/etc/creditCard.lua",0.5)
add("data/scripts/systems/etc/logisticModule.lua",0.5)

add("data/scripts/systems/jump/hyperspacebooster.lua",1)
add("data/scripts/systems/jump/wormholeGenerator.lua",0.1)

add("data/scripts/systems/movement/enginebooster.lua",1)

add("data/scripts/systems/scanner/omniscan.lua",0.3)
add("data/scripts/systems/scanner/miningsystem.lua",1)
add("data/scripts/systems/scanner/radarbooster.lua",1)
add("data/scripts/systems/scanner/scannerbooster.lua",1)

add("data/scripts/systems/teleporterkey1.lua", 0.01)
add("data/scripts/systems/teleporterkey2.lua", 0.01)
add("data/scripts/systems/teleporterkey3.lua", 0.01)
add("data/scripts/systems/teleporterkey4.lua", 0.01)
add("data/scripts/systems/teleporterkey5.lua", 0.01)
add("data/scripts/systems/teleporterkey6.lua", 0.01)
add("data/scripts/systems/teleporterkey7.lua", 0.01)
add("data/scripts/systems/teleporterkey8.lua", 0.01)

add("data/scripts/systems/tradingoverview.lua", 1)


function removeEntry(script)
    local index= findElementFromTable(script)
    scripts.remove(index)
end

function findElementFromTable(el)
    for index, value in pairs(scripts) do
        if value == el then
            return index
        end 
    end
end
-- original files
-- simple boosters


