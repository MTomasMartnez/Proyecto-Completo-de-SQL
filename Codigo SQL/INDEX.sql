-- INDEX

-- INDEX(si acepta valores duplcados y nulos)
CREATE INDEX idx_detalle_pedidos_precio ON detalle_pedidos(precio);


-- INDEX UNICO (no acepta valores duplicados ni nulos)
-- Optimizar la búsqueda de clientes por su email, para la gestión de usuarios y validaciones de duplicados
CREATE UNIQUE INDEX idx_clientes_email ON clientes(email);
-- EJEMPLO -> Buscar un cliente por su correo para verificar si ya está registrado


-- INDEX COMPUESTO (las columnas son unicas)
-- Mejorar el rendimiento de las consultas que cruzan productos y pedidos, especialmente útil para analizar qué productos se venden más en ciertos pedidos
CREATE UNIQUE INDEX idx_detalle_pedidos_proid_pedid ON detalle_pedidos(producto_id,pedido_id);
-- EJEMPLO ->  Consultar la cantidad vendida de un producto específico en un pedido.


-- ELIMINACION DE LOS INDEX	
DROP INDEX idx_detalle_pedidos_precio;
DROP INDEX idx_clientes_email;
DROP INDEX idx_detalle_pedidos_proid_pedid;