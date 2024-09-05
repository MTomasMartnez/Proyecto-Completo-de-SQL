-- STORED PROCEDURE

-- 1) Este procedimeinto almacenado me trae los clientes que la empresa considera como top ya que superan cierto ingreso de monto para la empresa

DELIMITER \\
CREATE PROCEDURE p_clientes_top()
BEGIN
	SELECT c.nombre, c.apellido, SUM(p.monto_total) AS Gastos 
	FROM clientes c 
	JOIN pedidos p ON c.cliente_id = p.cliente_id 
	GROUP BY c.nombre,c.apellido 
	HAVING Gastos > 5000 
	ORDER BY Gastos DESC;
END;
//
DELIMITER;

-- Llamada al Procedimiento
CALL tecnohogar.p_clientes_top();

-- Eliminacion 
DROP PROCEDURE p_clientes_top();


-- 2)
-- Mi idea fue crear un Stored Procedure que haga autoaticametne el descuento del IVA en los prodcutos 

DELIMITER //
CREATE PROCEDURE DescuentoIVA(IN pedidoID INT) -- Parametro que posteriormente se le pasa al procedimiento
BEGIN
    -- Verifica si el pedido existe
    IF EXISTS (SELECT 1 FROM pedidos WHERE pedido_id = pedidoID) THEN
        -- Actualiza el precios en la tabla detalle_pedidos descontando el IVA(21%)
        UPDATE detalle_pedidos
        SET precio = precio * (1 - 0.21) -- descuento del 21%
        WHERE pedido_id = pedidoID;

        -- Mensaje de confirmación
        SELECT CONCAT('Descuento del IVA aplicado al pedido ID: ', pedidoID) AS Mensaje;
    ELSE
        -- Mensaje de error, si el pedido no existe
        SELECT CONCAT('El pedido ID: ', pedidoID, ' no existe.') AS Mensaje;
    END IF;
END //
DELIMITER ;

CALL DescuentoIVA(655); -- Parametro en este caso el pedido con identificador 655

DROP PROCEDURE DescuentoIVA(); 



