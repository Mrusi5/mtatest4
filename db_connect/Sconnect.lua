local connection = nil
addEventHandler( "onResourceStart",resourceRoot,function( resource )
       connection = dbConnect( "mysql","dbname=mta;host=127.0.0.1;port=3306;","root","" )

       if connection then
           outputDebugString( getResourceName( resource ) .. " : Подключено к базе данных" )
           return true
       else
           outputDebugString( getResourceName( resource ) .. " : Неудалось подключиться к базе данных" )
           return false
       end
   end
)

function Query( ... )
   if connection then
       local query = dbQuery( connection, ... )
       local result = dbPoll( query,-1 )
       return result
   else
       return false
   end
end

function QuerySingle( str,... )
   if connection then
       local result = Query( str,... )
       if type( result ) == 'table' then
           return result[ 1 ]
       end
   else
       return false
   end
end

function Exec( str,... )
   if connection then
       local query = dbExec( connection,str,... )
       return query
   else
       return false
   end
end
