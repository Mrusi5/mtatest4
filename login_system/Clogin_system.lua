local sx, sy = guiGetScreenSize ( )
function centerGUI ( guiElement )
   local width, height = guiGetSize ( guiElement, false )
   local x, y = ( sx / 2 - width / 2 ), ( sy / 2 - height / 2 )
   guiSetPosition ( guiElement, x, y, false )
end

GUIEditor = {
   tab = { },
   staticimage = { },
   tabpanel = { },
   edit = { },
   button = { },
   window = { },
   label = { }
}

       GUIEditor.window[ 1 ] = guiCreateWindow( 423, 331, 523, 367, "", false )
       guiWindowSetSizable( GUIEditor.window[ 1 ], false )
       centerGUI( GUIEditor.window[ 1 ] )
       guiSetVisible( GUIEditor.window[ 1 ],false )
       GUIEditor.tabpanel[ 1 ] = guiCreateTabPanel( 11, 109, 502, 241, false, GUIEditor.window[ 1 ] )

       GUIEditor.tab[ 1 ] = guiCreateTab( "Логин", GUIEditor.tabpanel[ 1 ] )

       GUIEditor.label[ 1 ] = guiCreateLabel( 27, 32, 63, 15, "Email", false, GUIEditor.tab[ 1 ] )
       GUIEditor.edit[ 1 ] = guiCreateEdit( 100, 30, 352, 26, "", false, GUIEditor.tab[ 1 ] )
       GUIEditor.edit[ 2 ] = guiCreateEdit( 100, 74, 352, 26, "", false, GUIEditor.tab[ 1 ] )
       GUIEditor.button[ 1 ] = guiCreateButton( 314, 152, 153, 42, "Логин", false, GUIEditor.tab[ 1 ] )
       GUIEditor.label[ 2 ] = guiCreateLabel( 27, 75, 42, 15, "Пароль", false, GUIEditor.tab[ 1 ] )

       GUIEditor.tab[ 2 ] = guiCreateTab( "Регистрация", GUIEditor.tabpanel[ 1 ] )

       GUIEditor.label[ 3 ] = guiCreateLabel( 27, 32, 63, 15, "Email", false, GUIEditor.tab[ 2 ] )

       GUIEditor.label[ 4 ] = guiCreateLabel( 27, 75, 42, 15, "Пароль", false, GUIEditor.tab[ 2 ] )
       GUIEditor.label[ 5 ] = guiCreateLabel( 27, 119, 60, 15, "Проверка", false, GUIEditor.tab[ 2 ] )
       GUIEditor.button[ 2 ] = guiCreateButton( 314, 152, 153, 42, "Регистрация", false, GUIEditor.tab[ 2 ] )
       GUIEditor.edit[ 4 ] = guiCreateEdit( 100, 118, 352, 26, "", false, GUIEditor.tab[ 2 ] )
       GUIEditor.edit[ 5 ] = guiCreateEdit( 100, 30, 352, 26, "", false, GUIEditor.tab[ 2 ] )
       GUIEditor.edit[ 6 ] = guiCreateEdit( 100, 74, 352, 26, "", false, GUIEditor.tab[ 2 ] )


addEvent( "showHide",true )
function showHide( )
   if guiGetVisible( GUIEditor.window[ 1 ] ) == true then
       guiSetVisible( GUIEditor.window[ 1 ],false )
       showCursor( false )
   elseif guiGetVisible( GUIEditor.window[ 1 ] ) == false then
       guiSetVisible( GUIEditor.window[ 1 ],true )
       showCursor( true )
   end
end
addEventHandler( "showHide",getLocalPlayer( ),showHide )

showHide( )

function buttonClick( )
   if source == GUIEditor.button[ 2 ] then
       local password = guiGetText( GUIEditor.edit[ 6 ] )
       local password2 = guiGetText( GUIEditor.edit[ 4 ] )
       local email = guiGetText( GUIEditor.edit[ 5 ] )
       triggerServerEvent( "registerRequest",getLocalPlayer( ),getLocalPlayer( ),email, password, password2 )
   elseif source == GUIEditor.button[ 1 ] then
       local email = guiGetText( GUIEditor.edit[ 1 ] )
       local password = guiGetText( GUIEditor.edit[ 2 ] )
       triggerServerEvent( "loginRequest",getLocalPlayer( ),getLocalPlayer( ),email,password )
   end
end
addEventHandler( "onClientGUIClick",GUIEditor.window[ 1 ],buttonClick )
