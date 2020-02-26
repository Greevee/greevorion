function Scrapyard.initUI()

    local res = getResolution()
    local size = vec2(700, 650)

    local menu = ScriptUI()
    local mainWindow = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))
    menu:registerWindow(mainWindow, "Scrapyard"%_t)
    mainWindow.caption = "Scrapyard"%_t
    mainWindow.showCloseButton = 1
    mainWindow.moveable = 1

    -- create a tabbed window inside the main window
    tabbedWindow = mainWindow:createTabbedWindow(Rect(vec2(10, 10), size - 10))

    -- create a "Sell" tab inside the tabbed window
    local sellTab = tabbedWindow:createTab("Sell Ship"%_t, "data/textures/icons/sell-ship.png", "Sell your ship to the scrapyard"%_t)
    size = sellTab.size

    planDisplayer = sellTab:createPlanDisplayer(Rect(0, 0, size.x - 20, size.y - 60))
    planDisplayer.showStats = 0

    sellButton = sellTab:createButton(Rect(0, size.y - 40, 150, size.y), "Sell Ship"%_t, "onSellButtonPressed")
    sellWarningLabel = sellTab:createLabel(vec2(200, size.y - 30), "Warning! You will not get refunds for crews or turrets!"%_t, 15)
    sellWarningLabel.color = ColorRGB(1, 1, 0)

    -- create a second tab
    local salvageTab = tabbedWindow:createTab("Salvaging /*UI Tab title*/"%_t, "data/textures/icons/recycle-arrows.png", "Buy a salvaging license"%_t)
    size = salvageTab.size -- not really required, all tabs have the same size

    local textField = salvageTab:createTextField(Rect(0, 0, size.x, 50), "You can buy a temporary salvaging license here. This license makes it legal to damage or mine wreckages in this sector."%_t)
    textField.padding = 7

    salvageTab:createButton(Rect(size.x - 210, 80,  200 + size.x - 210, 40 + 80),  "Buy License"%_t, "onBuyLicenseButton1Pressed")
    salvageTab:createButton(Rect(size.x - 210, 130, 200 + size.x - 210, 40 + 130), "Buy License"%_t, "onBuyLicenseButton2Pressed")
    salvageTab:createButton(Rect(size.x - 210, 180, 200 + size.x - 210, 40 + 180), "Buy License"%_t, "onBuyLicenseButton3Pressed")
    salvageTab:createButton(Rect(size.x - 210, 230, 200 + size.x - 210, 40 + 230), "Buy License"%_t, "onBuyLicenseButton4Pressed")

    local fontSize = 18
    salvageTab:createLabel(vec2(15, 85),  "60", fontSize)
    salvageTab:createLabel(vec2(15, 135), "120", fontSize)
    salvageTab:createLabel(vec2(15, 185), "240", fontSize)
    salvageTab:createLabel(vec2(15, 235), "480", fontSize)

    salvageTab:createLabel(vec2(60, 85),  "Minutes"%_t, fontSize)
    salvageTab:createLabel(vec2(60, 135), "Minutes"%_t, fontSize)
    salvageTab:createLabel(vec2(60, 185), "Minutes"%_t, fontSize)
    salvageTab:createLabel(vec2(60, 235), "Minutes"%_t, fontSize)

    priceLabel1 = salvageTab:createLabel(vec2(200, 85),  "", fontSize)
    priceLabel2 = salvageTab:createLabel(vec2(200, 135), "", fontSize)
    priceLabel3 = salvageTab:createLabel(vec2(200, 185), "", fontSize)
    priceLabel4 = salvageTab:createLabel(vec2(200, 235), "", fontSize)

    timeLabel = salvageTab:createLabel(vec2(10, 310), "", fontSize)

    -- create a tab for dismantling turrets
    local turretTab = tabbedWindow:createTab("Turret Dismantling /*UI Tab title*/"%_t, "data/textures/icons/recycle-turret.png", "Dismantle turrets into goods"%_t)

    local vsplit = UIHorizontalSplitter(Rect(turretTab.size), 10, 0, 0.17)
    inventory = turretTab:createInventorySelection(vsplit.bottom, 10)

    inventory.onSelectedFunction = "onTurretSelected"
    inventory.onDeselectedFunction = "onTurretDeselected"

    local lister = UIVerticalLister(vsplit.top, 10, 0)
    scrapButton = turretTab:createButton(Rect(), "Dismantle"%_t, "onDismantleTurretPressed")
    lister:placeElementTop(scrapButton)
    scrapButton.active = false
    scrapButton.width = 300

    turretTab:createFrame(lister.rect)

    lister:setMargin(10, 10, 10, 10)

    local hlister = UIHorizontalLister(lister.rect, 10, 10)

    for i = 1, 10 do
        local rect = hlister:nextRect(30)
        rect.height = rect.width

        local pic = turretTab:createPicture(rect, "data/textures/icons/rocket.png")
        pic:hide()
        pic.isIcon = true

        table.insert(goodsLabels, {icon = pic})

    end

end

function Scrapyard.onShowWindow()
    visible = true

    local ship = Player().craft
    if not ship then return end

    -- get the plan of the player's ship
    local plan = ship:getPlan()
    planDisplayer.plan = plan

    if ship.isDrone then
        sellButton.active = false
        sellWarningLabel:hide()
    else
        sellButton.active = true
        sellWarningLabel:show()
    end

    uiMoneyValue = Scrapyard.getShipValue(plan)

    -- licenses
    priceLabel1.caption = "$${money}"%_t % {money = Scrapyard.getLicensePrice(Player(), 60)}
    priceLabel2.caption = "$${money}"%_t % {money = Scrapyard.getLicensePrice(Player(), 120)}
    priceLabel3.caption = "$${money}"%_t % {money = Scrapyard.getLicensePrice(Player(), 240)}
    priceLabel4.caption = "$${money}"%_t % {money = Scrapyard.getLicensePrice(Player(), 480)}

    Scrapyard.getLicenseDuration()

    -- turrets
    inventory:fill(ship.factionIndex, InventoryItemType.Turret)

end

function Scrapyard.onBuyLicenseButton1Pressed()
    invokeServerFunction("buyLicense", 60 * 60)
end

function Scrapyard.onBuyLicenseButton2Pressed()
    invokeServerFunction("buyLicense", 60 * 120)
end

function Scrapyard.onBuyLicenseButton3Pressed()
    invokeServerFunction("buyLicense", 60 * 240)
end

function Scrapyard.onBuyLicenseButton4Pressed()
    invokeServerFunction("buyLicense", 60 * 480)
end

function Scrapyard.getLicensePrice(orderingFaction, minutes)

    local price = minutes * 150 * (1.0 + GetFee(Faction(), orderingFaction)) * Balancing_GetSectorRichnessFactor(Sector():getCoordinates())

    local discountFactor = 1.0
    if minutes > 60  then discountFactor = 0.93 end
    if minutes > 120 then discountFactor = 0.86 end
    if minutes > 240 then discountFactor = 0.80 end

    return round(price * discountFactor);

end
