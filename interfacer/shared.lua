function extend( name )
    local file_name = table.concat( { "Extend/", name, ".lua" }, '' )

    if not fileExists( file_name ) then
        return false, "Расширение " .. file_name .. " не существует"
    end

    local file = fileOpen( file_name, true )
    local size = fileGetSize( file )
    if size <= 0 then
        fileClose( file )
        return false, "Модуль " .. file_name .. " пустой"
    end

    local chunk = fileRead( file, size )
    fileClose( file )

    return chunk
end