UniqueIDManager = {
    currentID = 1,
    usedIDs = { }
}

-- Метод для генерации уникального ID
function UniqueIDManager:generateUniqueID( )
    local uniqueID
    repeat
        uniqueID = self.currentID
        self.currentID = self.currentID + 1
    until not self.usedIDs[ uniqueID ]
    self.usedIDs[ uniqueID ] = true
    return uniqueID
end

-- Метод для назначения уникального ID игроку
function UniqueIDManager:assignUniqueID( player )
    self.currentID = 1
    local uniqueID = self:generateUniqueID( )
    setElementData( player, "playerID", uniqueID )
end

-- Метод для освобождения уникального ID при выходе игрока
function UniqueIDManager:onPlayerQuit( player )
    local playerID = getElementData( player, "playerID" )
    if playerID then
        self.usedIDs[ playerID ] = nil
    end
end

-- Создайте экземпляр класса
local uniqueIDManager = setmetatable( { }, {  __index = UniqueIDManager } )

addEventHandler( "onPlayerLogin", root, function( )
    uniqueIDManager:assignUniqueID( source )
end )

addEventHandler( "onPlayerQuit", root, function( )
    uniqueIDManager:onPlayerQuit( source )
end )
