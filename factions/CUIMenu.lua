----------------------------------------------Отрисовка панели------------------------------------------------------

local screenWidth, screenHeight = guiGetScreenSize( )
local panelWidth = screenWidth * 0.6
local panelHeight = screenHeight * 0.6
local x = ( screenWidth - panelWidth ) / 2
local y = ( screenHeight - panelHeight ) / 2

local isOrgPanelVisible = false
local playerFactionData = nil
local accessLevelplayer = nil


local orgPanel = nil
----------------------------------------Получение данных фракции-----------------------------------------------------
addEvent( "factionDataReceived", true )
addEventHandler( "factionDataReceived", root, function( factionData )
    playerFactionData = factionData
end )
--------------------------------------------Видимость панели---------------------------------------------------------
function toggleOrgPanel( )
    requestPlayerFaction( )
    triggerServerEvent( "requestFactionData", localPlayer, localPlayer )
    setTimer( function( )
        if accessLevelplayer then
            if not orgPanel then
                orgPanel = guiCreateWindow( x, y, panelWidth, panelHeight, "Панель организации", false )
                guiSetVisible( orgPanel, true )
                showCursor( true )
                
                orgName = "Название организации" 
        
        
                tabPanel = guiCreateTabPanel( 0.05, 0.1, 0.9, 0.8, true, orgPanel )
                tabMembers = guiCreateTab( "Список участников", tabPanel )
        
                gridlist = guiCreateGridList( 0.05, 0.05, 0.9, 0.8, true, tabMembers )
                guiGridListAddColumn( gridlist, "ID", 0.2 )
                guiGridListAddColumn( gridlist, "Имя", 0.5 )
    
                if accessLevelplayer == "leader" then
                    CityTableReceive = 0
                    TaxTableReceive = 0
                    triggerServerEvent( "CityTableCall", root, localPlayer )
                    triggerServerEvent( "TaxTableCall", root, localPlayer )
                    setTimer( function( )
                        tabCity = guiCreateTab( "Управление городом", tabPanel )
                        local cityName = CityTableReceive[ 1 ].cityName
                        beforPoint = CityTableReceive[ 1 ].availablePoints
                        point = beforPoint
    
    
                        -- Добавляем поле ввода для изменения названия города
                        local cityNameLabel = guiCreateLabel( 10, 30, 150, 20, "Название города:", false, tabCity )
                        local cityNameEdit = guiCreateEdit( 160, 30, 200, 20, cityName, false, tabCity )
                        local changeCityNameButton = guiCreateButton( 365, 25, 150, 30, "Изменить название", false, tabCity )
    
                        local taxPointlabel = guiCreateLabel( 0.05, 0.91, 0.2, 0.05, "Свободные очки:", true, tabCity )
                        -- Создаем раздел управления налогами
                        local taxesLabel = guiCreateLabel( 10, 90, 150, 20, "Управление налогами:", false, tabCity )
                        taxPointValue = guiCreateLabel( 0.15, 0.91, 0.2, 0.05, tostring( point ), true, tabCity )
                                                
                        -- Пример создания элементов управления налогами ( можно добавить остальные )
                        local bustax = TaxElement.new( 130, "Налог на прибыль с бизнесов", 'bustax' )
                        local workertax = TaxElement.new( 160, "Налог на доход рабочих", 'workertax' )  
                        local factiontax = TaxElement.new( 190, "Налог на доход фракций", 'factiontax' )
                        local sellcartax = TaxElement.new( 220, "Налог на продажу ТС", 'sellcartax' )
                        local buycartax = TaxElement.new( 250, "Налог на покупку ТС", 'buycartax' )

                        -- Кнопка применения изменений
                        applyButton = guiCreateButton( 0.55, 0.9, 0.2, 0.05, "Применить", true, tabCity )
                        
                        -- Кнопка сброса налогов
                        resetButton = guiCreateButton( 0.75, 0.9, 0.2, 0.05, "Сбросить", true, tabCity )
                        --Обработка кнопки "Применить"
                        addEventHandler( "onClientGUIClick", applyButton, function( )
                            if point == beforPoint then
                                return 
                            end
                            if point == 0 then
                            local taxValues = {
                                bustax = bustax.currentRate,
                                workertax = workertax.currentRate,
                                factiontax = factiontax.currentRate,
                                sellcartax = sellcartax.currentRate,
                                buycartax = buycartax.currentRate
                            }
                            setTimer( function( )
                                triggerServerEvent( "ApplyTaxValues", root, localPlayer, taxValues )
                            end, 100, 1 )

                            else
                                outputChatBox( "Нужно потратить все доступные свободные очки", 255,0,0 )
                            end
                        end, false )

                        addEventHandler( "onClientGUIClick", resetButton, function( )
                            triggerServerEvent( "ResetTaxValues", root, localPlayer, taxValues )
                        end, false )
                        
                        addEventHandler( "onClientGUIClick", changeCityNameButton, function( )
                            local newName = guiGetText( cityNameEdit )
                            if newName then
                            triggerServerEvent( "ChangeCityName", root, localPlayer, newName )
                            end
                        end, false )
    
                    end, 100, 1 )
                    
                    fireButton = guiCreateButton( 0.05, 0.9, 0.2, 0.05, "Уволить", true, tabMembers )
                    invButton = guiCreateButton( 0.75, 0.9, 0.2, 0.05, "Пригласить", true, tabMembers )
                    inviteEdit = guiCreateEdit( 0.64, 0.9, 0.1, 0.05, "", true, tabMembers )
--------------------------------------------Кнопка "Уволить"--------------------------------------------------------
                    addEventHandler( "onClientGUIClick", fireButton, function( )
                        local selectedRow, selectedCol = guiGridListGetSelectedItem( gridlist )
                        
                        if selectedRow and selectedCol then
                            local playerID = guiGridListGetItemText( gridlist, selectedRow, 1 )
                            if playerID ~= "" then
                                triggerServerEvent( "firePlayerFromFaction", root, localPlayer, playerID )
                            else
                                outputChatBox( "Выберите игрока из списка, чтобы уволить его.", 255, 0, 0 )
                            end
                    
                        end
                    end, false )
                    -----------------------------------------Кнопка "Пригласить"--------------------------------------------------------
                    function sendInvite( )
                        local playerID = guiGetText( inviteEdit )
                        local factionName = playerFactionData.name
                        triggerServerEvent( "checkID", root, localPlayer, playerID, factionName )
                    end
                    
                    addEventHandler( "onClientGUIClick", invButton, sendInvite, false )
                    updateGridList( )
                end
            else
                orgPanel = nil
                showCursor( false )
            end
        end
    end, 100, 1 )
end

bindKey( "p", "down", toggleOrgPanel )

function requestPlayerFaction( )
    triggerServerEvent( "checkPlayerFaction", localPlayer, localPlayer )
end 
-- Проверка доступа панели
addEvent( "receiveFactionForAccessLevel", true )
addEventHandler( "receiveFactionForAccessLevel", root, function( accessLevel )
    if accessLevel then
        if accessLevel == "member" then
            if orgPanel then
                destroyElement( orgPanel )
                showCursor( false )
            end
            accessLevelplayer = "member"
        elseif accessLevel == "leader" then
            if orgPanel then
                destroyElement( orgPanel )
                showCursor( false )
            end
            accessLevelplayer = "leader"
        end
    else
        accessLevelplayer = nil
        if orgPanel then
            destroyElement( orgPanel )
            showCursor( false )
            orgPanel = nil
        end
        outputChatBox( "Вы не состоите в фракции." )
    end
end )

----------------------------------------Заполнение списка участников------------------------------------------------
function updateGridList( )
    guiGridListClear( gridlist )


    local members = playerFactionData.members

    for i, memberID in pairs( members ) do
        local memberName = getPlayerName( memberID ) or "N/A"
        local memberID = getElementData( memberID, "playerID" ) or "N/A"

        local row = guiGridListAddRow( gridlist )
        guiGridListSetItemText( gridlist, row, 1, memberID, false, false )
        guiGridListSetItemText( gridlist, row, 2, memberName, false, false )

    end
end

local inviteWindow = nil
--Окно приглашения

function receiveInvite( inviteMessage, factionIdforInvite )
    if not isElement( inviteWindow ) then
        inviteWindow = guiCreateWindow( 0.3, 0.3, 0.4, 0.2, "Приглашение", true )
        local inviteLabel = guiCreateLabel( 0.1, 0.2, 0.8, 0.3, inviteMessage, true, inviteWindow )
        local acceptButton = guiCreateButton( 0.2, 0.7, 0.3, 0.2, "Принять", true, inviteWindow )
        local declineButton = guiCreateButton( 0.5, 0.7, 0.3, 0.2, "Отказаться", true, inviteWindow )

        guiSetInputEnabled( true )
---------Обработка нажатия кнопки "Принять"
        addEventHandler( "onClientGUIClick", acceptButton, function( )

            local playerID = getElementData( localPlayer, "playerID" )

            triggerServerEvent( "acceptInvite", localPlayer, localPlayer, playerID, factionIdforInvite )

            destroyElement( inviteWindow )

            guiSetInputEnabled( false )
        end, false )
---------Обработка нажатия кнопки "Отказаться"
        addEventHandler( "onClientGUIClick", declineButton, function( )
            destroyElement( inviteWindow )

            guiSetInputEnabled( false )
        end, false )
    end
end

addEvent( "onReceiveInvite", true )
addEventHandler( "onReceiveInvite", resourceRoot, receiveInvite )

--------Класс налогов
TaxElement = { }
TaxElement.__index = TaxElement

-- Конструктор класса налогов
function TaxElement.new( yPos, taxName, taxTableName )
    local self = setmetatable( { }, TaxElement )
    local currentRate = taxValue( taxTableName )
    self.beforecurrentRate = currentRate
    self.label = guiCreateLabel( 10, yPos, 200, 20, taxName, false, tabCity )
    self.rateLabel = guiCreateLabel( 276, yPos, 50, 20, self.beforecurrentRate .. "%", false, tabCity )
    self.decreaseButton = guiCreateButton( 220, yPos, 30, 20, "-", false, tabCity )
    self.increaseButton = guiCreateButton( 320, yPos, 30, 20, "+", false, tabCity )
    self.currentRate = currentRate

    -- Привязываем обработчики событий к кнопкам
    addEventHandler( "onClientGUIClick", self.decreaseButton, function( )
        self:decreaseRate( )
        guiSetText( taxPointValue, point )
    end, false )

    addEventHandler( "onClientGUIClick", self.increaseButton, function( )
        self:increaseRate( )
        guiSetText( taxPointValue, point )
    end, false )

    return self
end

-- Методы для увеличения и уменьшения значения currentRate
function TaxElement:decreaseRate( )
    if point <= 0 and self.currentRate <= self.beforecurrentRate then
        return
    end
    if self.currentRate > 0 then
        self.currentRate = self.currentRate - 1
        if self.currentRate >= self.beforecurrentRate then
            point = point + 1
        else
            point = point - 1
        end
        self:updateRateLabel( )
    end
end

function TaxElement:increaseRate( )
    if point <= 0 and self.currentRate >= self.beforecurrentRate then
        return
    end
    if self.currentRate < 100 then
        self.currentRate = self.currentRate + 1
        if self.currentRate <= self.beforecurrentRate then
            point = point + 1
        else
            point = point - 1
        end
    self:updateRateLabel( )
    end 
end

-- Метод для обновления текста в rateLabel
function TaxElement:updateRateLabel( )
    guiSetText( self.rateLabel, self.currentRate .. "%" )
end

addEvent( "receiveCityTable", true )
addEventHandler( "receiveCityTable", resourceRoot, function( CityTable )
    CityTableReceive = CityTable
end )

addEvent( "receiveTaxTable", true )
addEventHandler( "receiveTaxTable", resourceRoot, function( TaxTable )
    TaxTableReceive = TaxTable
end )

function taxValue( taxTableName )
    for _, line in pairs( TaxTableReceive ) do
        if line.taxName == taxTableName then
            return line.value
        end
    end
end