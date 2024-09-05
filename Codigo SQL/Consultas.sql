/*
NIVEL BASICO

1-¿Cuántos clientes tenemos registrados en nuestra base de datos?
2-¿Cuántos pedidos se han realizado en total?
3-¿Cuál es el monto total de los pagos recibidos hasta ahora?
4-¿Cuántos productos diferentes tenemos en el inventario?
5-¿Cuáles son los nombres de los productos disponibles en la tienda?
6-¿Cuántos envíos están pendientes de entrega?
7-¿Cuántos métodos de pago diferentes se han utilizado?
8-¿Cuál es el nombre del cliente que realizó el pedido con ID 1?
9-¿Cuántos productos se incluyen en el pedido con ID 2?
10-¿Cuántos productos de la categoría 'Electrodomésticos' tenemos en inventario?


NIVEL INTERMEDIO

11-¿Cuál es el total de ventas generado por cada cliente?
12-¿Cuáles son los 5 productos más vendidos hasta la fecha?
13-¿Cuál es el promedio de ventas por pedido?
14-¿Cuáles son los ingresos totales generados en el último mes?
15-¿Cuáles son los estados de envío más comunes?
16-¿Qué porcentaje de los pedidos han sido pagados con tarjeta de crédito?
17-¿Cuáles son los clientes que han realizado más de 3 pedidos?
18-¿Cuáles son los productos que no se han vendido en absoluto?
19-¿Qué clientes han gastado más de $5000 en total?
20-¿Cuál es la cantidad promedio de productos por pedido?


NIVEL AVANZADO

21-¿Cuál es el producto que genera el mayor ingreso por ventas?
22-¿Cuál es la tasa de repetición de compra por parte de los clientes?
23-¿Cuál es el monto promedio de los pagos realizados según el método de pago?
24-¿Cuál es la tendencia de ingresos mensuales durante el último año?
25-¿Cuál es el tiempo promedio entre la realización de un pedido y su envío?
26-¿Qué cliente ha generado el mayor ingreso para la tienda y cuánto ha gastado en total?
27-¿Cuál es la relación entre el tipo de producto y la frecuencia de su venta?
28-¿Qué productos tienen un stock bajo en comparación con su tasa de ventas?
29-¿Cuál es el promedio de pagos pendientes por mes?
30-¿Cuál es el porcentaje de Cancelaciones por producto en relación a las unidades vendidas?
*/



-- 1
SELECT COUNT(*) FROM clientes; 

-- 2
SELECT count(*) FROM pedidos;

-- 3
SELECT SUM(monto_total) from pedidos;

-- 4
SELECT DISTINCT COUNT(*) FROM productos;

-- 5 
SELECT DISTINCT nombre  FROM productos;

-- 6
SELECT COUNT(estado_pedido) as Productos_Pendientes FROM Pedidos
WHERE estado_pedido = "Pendiente";

-- 7 
SELECT DISTINCT metodo FROM pagos;

-- 8 
SELECT c.nombre
FROM clientes as c
JOIN pedidos as p ON c.cliente_id = p.cliente_id
WHERE p.pedido_id = 1;

-- 9
SELECT COUNT(*) FROM detalle_pedidos
WHERE pedido_id = 2;

-- 10 
SELECT COUNT(*) 
FROM productos
WHERE categoria_id = (SELECT categoria_id FROM categorias WHERE nombre = "Electrodomesticos");


-- NIVEL INTERMEDIO

-- 11
SELECT c.nombre, c.apellido, p.monto_total
from clientes AS c
join pedidos AS p on c.cliente_id = p.cliente_id;

-- 12 
SELECT p.nombre, sum(dp.cantidad) AS Total_Ventas
FROM detalle_pedidos AS dp
JOIN productos AS p ON dp.producto_id = p.producto_id
GROUP BY p.nombre
ORDER BY Total_Ventas DESC
LIMIT 5;

-- 13
SELECT AVG(monto_total) AS 'Promedio de ventas' FROM pedidos;

-- 14
SELECT SUM(monto_total) AS Ingresos_Julio -- Nos encontramos en Agosto
FROM pedidos AS P
WHERE month(p.fecha_pedido) = MONTH (CURDATE()) -1 -- Obtengo el mes actual y le resto 1
AND
YEAR(p.fecha_pedido) = YEAR(CURDATE()); -- Obtengo los datos de este Año

-- 15
SELECT estado_pedido, COUNT(*) as envios_totales
FROM pedidos
GROUP BY estado_pedido
ORDER BY envios_totales DESC;

-- 16
-- La cantidad de pagos totales por 100, divididos por la cantidad de la condicion del WHERE (metodo = 'tarjeta_credito')
SELECT( Count(*) * 100 / (SELECT count(*) FROM pagos)) AS Porcentaje 
FROM pagos
WHERE metodo = 'tarjeta_credito';

-- 17 
SELECT c.nombre,c.apellido, COUNT(pedido_id) AS Pedidos_Totales
FROM clientes AS c
JOIN pedidos AS p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre, c.apellido
HAVING Pedidos_Totales > 3
ORDER BY Pedidos_Totales DESC;

-- 18 
SELECT nombre
FROM productos
WHERE producto_id NOT IN(SELECT producto_id FROM detalle_pedidos);

-- 19 
SELECT c.nombre, SUM(p.monto_total) AS Gastos
FROM clientes c 
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
HAVING Gastos > 5000
ORDER BY Gastos DESC;

-- 20

SELECT AVG(cantidad) AS Promedio
FROM detalle_pedidos;

-- NIVEL AVANZADO

-- 21
-- El ingreso por ventas de cada producto se calcula multiplicando la cantidad vendida por el precio del producto
SELECT p.nombre, SUM(dp.producto_id * dp.precio) AS Ingreso -- cantidad de productos vendidos en la tabla dp por su precio 
FROM detalle_pedidos AS dp
JOIN productos AS p ON dp.producto_id = p.producto_id -- Relaciono los campos para conocer el nombre del Producto
GROUP BY p.nombre
ORDER BY Ingreso DESC
LIMIT 1;

-- 22
SELECT (COUNT(DISTINCT cliente_id) * 100 / (SELECT COUNT(*) FROM clientes)) as "Tasa de Repeticion"
FROM pedidos
GROUP BY cliente_id;
-- HAVING  COUNT(pedido_id) > 1;

-- 23
SELECT metodo, AVG(importe) as Promedio
FROM pagos
GROUP BY metodo;

-- 24 
SELECT MONTH(fecha_pedido) AS Mes, SUM(monto_total) Ingresos
FROM pedidos
WHERE YEAR(curdate()) -- CURDATE() me devuelve la fecha completa actual(YEAR-MONTH-DAY), con YEAR() extraigo el año en el que me encuentro actualmente 
GROUP BY Mes
ORDER BY Mes; 

-- 25
SELECT AVG(DATEDIFF(p.fecha_pedido, e.fecha_envio) * 24) AS "Tiempo de Diferencia(Hrs)" -- LO multiplico por 24 ya que al hacer AVG me devuelve en fraccion, al hacer esto lo paso a una medida de Horas
FROM envios AS e
JOIN pedidos AS p on e.pedido_id = p.pedido_id;


-- 26
SELECT CONCAT ( 'Nombre: ' , c.nombre , ' Apellido: ' , c.apellido) as Nombre_Completo, SUM(p.monto_total) AS Ingreso_Total
FROM clientes AS c
JOIN pedidos AS p ON c.cliente_id = p.cliente_id
GROUP BY Nombre_Completo
ORDER BY Ingreso_Total DESC
LIMIT 5;

SELECT  c.nombre, SUM(p.monto_total) AS Ingreso_Total
FROM clientes AS c
JOIN pedidos AS p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
ORDER BY Ingreso_Total DESC
LIMIT 5;

-- Este es el codigo correcto ya que el identificador unico del cliente es la columna indicada que me muestra el cliente que más ingresos genero, 
-- ya que por otro lado, si agrupo los datos por nombre o apellido, se suman todas las Personas con los mismos nombres y los mismos apellidos
SELECT   c.nombre, c.apellido, c.cliente_id, SUM(p.monto_total) AS Ingreso_Total
FROM clientes AS c
JOIN pedidos AS p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id
ORDER BY Ingreso_Total DESC
LIMIT 1;

-- 27 
-- Hago un 1er Join para relacionar Productos y Detalles, luego otro para relacionar Productos y Categorias
SELECT  c.nombre AS Categoria, COUNT(*) AS Cantidad
FROM productos AS p
JOIN detalle_pedidos AS d ON p.producto_id = d.producto_id
JOIN categorias AS c ON p.categoria_id = c.categoria_id
GROUP BY Categoria -- Nombre de las categoria_id
ORDER BY Cantidad DESC;

-- 28 
-- La tasa de ventas de un producto puede calcularse como la cantidad total vendida en un período de tiempo específico
SELECT p.nombre, p.stock, SUM(d.cantidad) as cantidad
FROM productos AS p
JOIN detalle_pedidos AS d ON p.producto_id = d.producto_id
GROUP BY p.nombre, p.stock
HAVING p.stock < SUM(d.cantidad) * 0.2 -- El 0.2 hace referencia al 20% es decir cuando un producto tenga stock actual inferior al 20% de su cantidad total se lo considera bajo en Stock
-- En este caso no se lo realiza en base al tiempo sino que a un porcentaje de la cantidad del producto
ORDER BY p.stock ASC;

-- 29 
SELECT AVG(monto_total) Promedio, MONTH(fecha_pedido) AS Mes from pedidos
WHERE estado_pedido = 'Pendiente'
GROUP BY Mes
ORDER BY Mes;

-- 30
SELECT p.pedido_id,
    COUNT(d.detalle_id) AS total_vendido,
    COUNT(CASE WHEN p.estado_pedido = 'cancelado' THEN 1 END) AS total_cancelado, -- CASE WHEN verifica si el estado del pedido es 'cancelado', si es así, asigna un 1, y si no, un valor nulo que no se cuenta
    (COUNT(CASE WHEN p.estado_pedido = 'cancelado' THEN 1 END) / COUNT(p.pedido_id)) * 100 AS porcentaje_cancelaciones -- Calculamos el porcentaje 
FROM pedidos p
JOIN detalle_pedidos AS d ON p.pedido_id = d.pedido_id
GROUP BY p.pedido_id
ORDER BY porcentaje_cancelaciones DESC;



