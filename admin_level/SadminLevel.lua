
function setAdminLevelCommand( player, command, targetPlayerName )
    local accountName = getAccountName( getPlayerAccount( player ) )
    if isObjectInACLGroup( "user."..accountName, aclGetGroup( "Admin" ) ) then
        local targetPlayer = getPlayerFromName( targetPlayerName )
        if targetPlayer then
            aclGroupAddObject( aclGetGroup( "Admin" ), "user."..targetPlayerName )
            outputChatBox( "Игрок " .. targetPlayerName .. " получил статус администратора", player, 0, 255, 0 )
        else
            outputChatBox( "Игрок с именем " .. targetPlayerName .. " не найден.", player, 255, 0, 0)
        end
    else
        outputChatBox( "У вас нет прав для выполнения этой команды.", player, 255, 0, 0 )
    end
end
addCommandHandler( "setadminlevel", setAdminLevelCommand )