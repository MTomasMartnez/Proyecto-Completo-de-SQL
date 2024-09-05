-- 1. Crear un Rol
-- Para crear un rol en MySQL, usa el comando CREATE ROLE. Por ejemplo, si quieres crear un rol llamado developer, puedes hacerlo así:
CREATE ROLE 'Desarrollador';
CREATE ROLE 'Usuario';
CREATE ROLE 'Lector';

-- 2. Asignar Permisos a un Rol
 
GRANT ALL PRIVILEGES ON tecnohogar.* TO 'Desarrollador';
GRANT SELECT, INSERT, UPDATE   ON tecnohogar.productos TO 'Usuario';
GRANT SELECT ON tecnohogar.productos TO 'Lector';

-- 3. Asignar un Rol a un Usuario

GRANT 'Desarrollador' TO 'Carlos'@'localhost';
GRANT 'Usuario' TO 'Luis'@'localhost';
GRANT 'Lector' TO 'Alberto'@'localhost';


-- 4. Activar los Roles para un Usuario
-- Para que un usuario active los roles asignados, debe ejecutar el comando SET ROLE

SET ROLE 'Desarrollador';
-- O
SET ROLE ALL; -- para todos los roles

-- 5. Revocar Permisos o Roles
-- Si necesitas revocar permisos de un rol o revocar un rol de un usuario, usa el comando REVOKE

REVOKE INSERT ON tecnohogar.productos FROM 'Desarrollador';

REVOKE 'Desarrollador' FROM 'Carlos'@'localhost';


--  Ver Roles y Permisos

SHOW GRANTS FOR 'Desarrollador';


-- Para ver permisos de un usuario:

SHOW GRANTS FOR 'Carlos'@'localhost';

-- Si necesitas eliminar un rol completamente

DROP ROLE 'developer';