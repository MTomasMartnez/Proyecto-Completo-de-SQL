-- VIEW

CREATE VIEW vw_Top_50_productos  AS
SELECT nombre, precio
FROM productos
ORDER BY precio DESC
LIMIT 50;

CREATE VIEW vw_clientes_brasilenios AS
SELECT *
FROM clientes
WHERE pais = 'Brasil';


SELECT nombre,apellido FROM vw_clientes_brasilenios;

SELECT cb.nombre,cb.apellido,p.fecha_pedido,p.monto_total,p.estado_pedido
FROM vw_clientes_brasilenios AS cb
LEFT JOIN pedidos AS p ON cb.cliente_id = p.cliente_id
WHERE estado_pedido = 'Entregado';

-- ELIMINACION DE LAS VISTAS
-- DROP VIEW IF EXIST vw_Top_50_productos (Pongo la condicion IF EXIST para mayor seguridad a la hora de eliminar la vista, ya que previo a la eliminacion tiene que pasar por una condicion("si existe la vista"))
-- DROP VIEW IF EXIST vw_clientes_brasilenios

