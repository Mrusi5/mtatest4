function joinHandler( )
	fadeCamera( source, true )
	setCameraMatrix( source, 1468.8785400391,  -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316 )
	outputChatBox( "Welcome to My Server", source )
end
addEventHandler( "onPlayerJoin", getRootElement( ), joinHandler )
addEvent( "registerRequest",true )
function registerRequest( player, email, password, password2 )
    local username = getPlayerName ( player )
    local account = getAccount( username )
    if account == false then
        local serial = getPlayerSerial( player )
        if password ~= password2 then
            outputChatBox( "Пароли не совпадают", player, 255, 0, 0 )
            return 
        end
        -- Проверяем, сколько аккаунтов связано с этим серийным номером
        local query = exports.db_connect:Query( "SELECT COUNT( * ) as count FROM users WHERE serial=?", serial )
        
        if query and query[ 1 ] and tonumber( query[ 1 ].count ) >= 3 then
            -- Оповещаем, что у игрока уже есть 3 или более аккаунтов
            outputChatBox( "У вас уже есть 3 или более аккаунтов.", player, 255,0,0 )
        else
            -- Регистрируем пользователя, если у него меньше 3 аккаунтов
            exports.db_connect:Exec( "INSERT INTO users( username, password, email, serial ) VALUES ( ?, ?, ?, ? )", username, password, email, serial )
            local addAccount = addAccount( tostring( username ), tostring( password ) )
            if addAccount then
                outputDebugString( "Пользователь зарегистрирован под именем " .. username )
                loginRequest( player, username, password )
            else
                outputDebugString( "Ошибка регистрации" )
            end
        end
    else
        outputChatBox( "Имя занято.", player, 255,0,0 )
    end
end

addEventHandler( "registerRequest", getRootElement( ), registerRequest )

addEvent( "loginRequest",true )
function loginRequest( player, email, password )
   local username = getPlayerName( player )
   local check = exports.db_connect:QuerySingle( "SELECT * FROM users WHERE username = ? ", username )
   if check then
       local checkPass = check.password
       if ( checkPass == password ) then
           logIn( player,getAccount( username ),tostring( password ) )
           triggerClientEvent( player,"showHide",getRootElement( ) )
           outputDebugString( "Пользователь авторизован" )
           spawnPlayer( source, 2000, 2000, 10 )
           setCameraTarget( source, source )
       end
    else
        outputChatBox( "Пользователь не найден", player, 255,0,0 )
   end
end
addEventHandler( "loginRequest",getRootElement( ),loginRequest )
