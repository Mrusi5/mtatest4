function getPlayerID( player )
    return getElementData( player, "playerID" )
end

function displayPlayerID( )
    local localPlayer = getLocalPlayer( )
    local localX, localY, localZ = getElementPosition( localPlayer )
    local localPlayerID = getPlayerID( localPlayer )
    local localText = "ID: " .. tostring( localPlayerID )
    local screenX, screenY = getScreenFromWorldPosition( localX, localY, localZ + 1 )
    
    if screenX and screenY then
        dxDrawText( localText, 10, 10, 200, 50, tocolor( 255, 0, 0 ), 1.0, "default-bold" )
    end
    
    local maxDistance = 50
    local playersInRange = getElementsWithinRange( localX, localY, localZ, maxDistance, "player" )

    for _, player in pairs( playersInRange ) do
        if player ~= localPlayer then
            local x, y, z = getElementPosition( player )
            local playerID = getPlayerID( player )
            local text = "ID: " .. playerID
            local screenX, screenY = getScreenFromWorldPosition( x, y, z + 1 )

            if screenX and screenY then
                dxDrawText( text, screenX - 20, screenY - 20, screenX, screenY, tocolor( 255, 255, 255 ), 1.0, "default-bold" )
            end
        end
    end
end

addEventHandler( "onClientRender", root, displayPlayerID )
