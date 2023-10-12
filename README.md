Изменения в id_players /Sid_issuance.lua - Id с помощью ООП
<br>
Управление городом в файлах factions/CUIMenu.lua, factions/Scity_managment.lua
<br>
UPDATE:
<br>
Удалены папки db_connect и admin_level.
<br>
Добавленна проверка email при авторизации в файле Slogin_system.lua
<br>
Изменена функция регистрации. Теперь при регистрации присваевается уровень доступа 1(стандарт).
<br>
Изменён доступ к командам set_player_faction и set_player_faction_leader. Теперь проверяет  не таблицу acl, а уровень доступа в таблице БД.
<br>
Добавлен Интерфейсер.
