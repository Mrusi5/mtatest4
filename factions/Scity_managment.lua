-- Определяем класс CityManagement
CityManagement = { }
CityManagement.__index = CityManagement

-- Конструктор класса
function CityManagement:new( cityName )
    local self = setmetatable( { }, CityManagement )
    local realTime = getRealTime(  ).timestamp
    local formattedTime = os.date( "%Y-%m-%d %H:%M:%S", realTime )
    self.cityName = cityName
    self.lastNameChangeTime = formattedTime
    self.taxRates = {
        [ 'bustax' ] = 5,
        [ "workertax" ] = 5,
        [ "factiontax" ] = 5,
        [ "sellcartax" ] = 5,
        [ "buycartax" ] = 5
    }
    self.availablePoints = 10
    self.lastTaxChangeTime = formattedTime
    
    local check = exports.db_connect:Query( "SELECT * FROM city WHERE cityName=?", cityName )
    if check[ 1 ] then
        return
    end

    local query = exports.db_connect:Exec( "INSERT INTO city ( cityName, lastNameChangeTime, availablePoints, lastTaxChangeTime ) VALUES ( ?, ?, ?, ? )", self.cityName, self.lastNameChangeTime, self.availablePoints, self.lastTaxChangeTime )

    if query then
        result = exports.db_connect:Query( "SELECT * FROM city WHERE cityName=?", cityName )
        if result then
            self.id = result[ 1 ].id

            for taxName, value in pairs( self.taxRates ) do
            local taxQuery = exports.db_connect:Exec( "INSERT INTO tax ( taxName, value, city_id ) VALUES ( ?, ?, ? )", taxName, value, self.id )
            end
        end
    end
    
    return self
end

function CityManagement:addEventHandlers(  )
    addEvent( "CityTableCall", true )
    addEventHandler( "CityTableCall", root, function(  )
        self:getCityTable(  )
    end )

    addEvent( "TaxTableCall", true )
    addEventHandler( "TaxTableCall", root, function(  )
        self:getTaxTable(  )
    end )

    addEvent( "ApplyTaxValues", true )
    addEventHandler( "ApplyTaxValues", root, function( player, taxValues )
        self:applyTaxValues( player, taxValues )
    end )

    addEvent( 'ChangeCityName', true )
    addEventHandler( 'ChangeCityName', root, function( player, cityName )
        self:changeCityName( player, cityName )
    end, false )

    addEvent( "ResetTaxValues", true )
    addEventHandler( "ResetTaxValues", root, function( player )
        self:resetTaxValues( player )
    end )
end

function CityManagement:getCityTable(  )
    local CityTable = exports.db_connect:Query( "SELECT * FROM city" )
    triggerClientEvent( client, "receiveCityTable", resourceRoot, CityTable )
end

function CityManagement:getTaxTable(  )
    local TaxTable = exports.db_connect:Query( "SELECT * FROM tax" )
    triggerClientEvent( client, "receiveTaxTable", resourceRoot, TaxTable )
end
-- Принятие налогов
function CityManagement:applyTaxValues( player, taxValues )
    local lastChange = exports.db_connect:QuerySingle( "SELECT * FROM city" ).lastTaxChangeTime
    local realTime = getRealTime(  ).timestamp
    local formattedTime = os.date( "%Y-%m-%d %H:%M:%S", realTime )
    if parseTimestamp( formattedTime ) - parseTimestamp( lastChange ) < 86400 then
        outputChatBox( "Изменения налогов можно вносить раз в день", player, 255,0,0 )
        return
    end
    for taxName, value in pairs( taxValues ) do
        local query = "UPDATE tax SET value = ? WHERE taxName = ?"
        local result = exports.db_connect:Exec( query, value, taxName )

        if result then
            outputDebugString( "Обновлен налог: " .. taxName .. " со ставкой " .. value .. "%" )
        else
            outputDebugString( "Не удалось обновить налог: " .. taxName )
        end
    end
    outputChatBox( "Изменения приняты", player, 0,255,0 )
    local query = exports.db_connect:Exec( "UPDATE city SET availablePoints = ?, lastTaxChangeTime = ?", 0, formattedTime )
end
-- Изменение имени города
function CityManagement:changeCityName( player, cityName )
    local lastChange = exports.db_connect:QuerySingle( "SELECT * FROM city" ).lastNameChangeTime
    local realTime = getRealTime(  ).timestamp
    local formattedTime = os.date( "%Y-%m-%d %H:%M:%S", realTime )
    if parseTimestamp( formattedTime ) - parseTimestamp( lastChange ) < 86400 then
        outputChatBox( "Измененить название города можно раз в день", player, 255,0,0 )
        return
    end
    local result = exports.db_connect:Exec( "UPDATE city SET cityName = ?, lastNameChangeTime = ?" , cityName, formattedTime )
    outputChatBox( "Изменения приняты", player, 0,255,0 )
end
-- Сброс налогов
function CityManagement:resetTaxValues( player )
    local lastChange = exports.db_connect:QuerySingle( "SELECT * FROM city" ).lastTaxChangeTime
    local realTime = getRealTime(  ).timestamp
    local formattedTime = os.date( "%Y-%m-%d %H:%M:%S", realTime )
    if parseTimestamp( formattedTime ) - parseTimestamp( lastChange ) < 86400 then
        outputChatBox( "Изменения налогов можно вносить раз в день", player, 255,0,0 )
        return
    end
    local taxTable = exports.db_connect:Query( "SELECT * FROM tax" )

    for i, row in pairs( taxTable ) do
        local query = "UPDATE tax SET value = ?"
        local result = exports.db_connect:Exec( query, 5 )
    end
    outputChatBox( "Налоги сброшенны", player, 0,255,0 )

    local query = exports.db_connect:Exec( "UPDATE city SET availablePoints = ?, lastTaxChangeTime = ?", 0, formattedTime )
end

CheckTable = exports.db_connect:Query( "SELECT * FROM city" )
if not CheckTable[ 1 ] then
CityManagement:new( 'Saratov' )
end
CityManagement:addEventHandlers(  )

function parseTimestamp( str )
    local year, month, day, hour, min, sec = str:match( "( %d+ )-( %d+ )-( %d+ ) ( %d+ ):( %d+ ):( %d+ )" )
    return os.time( { year=year, month=month, day=day, hour=hour, min=min, sec=sec } )
end