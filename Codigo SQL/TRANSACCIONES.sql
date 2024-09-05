-- TRANSACCIONES

-- 1 Realizar una Venta Completa:

START TRANSACTION; -- inicio la transaccion 
	
    -- Mi primer objetivo es insertar el nuevo pedido en la tabla pedido
 	INSERT INTO pedidos(cliente_id,direccion_pedido, monto_total,estado_pedido,fecha_pedido)
  VALUES(1,'916 David Corner Apt. 331 North Patrick, OR 50039', 700,'Enviado', '2024-09-03');

-- Luego inserto los valores nuevos en detalle_pedidos 
	INSERT INTO detalle_pedidos(pedido_id,cantidad,precio,descuento,producto_id)
	VALUES (2001,5,700,4,51);

-- Actualizo el stock en la tabla productos 
	UPDATE productos SET stock = stock - 5 WHERE producto_id = 51;

-- Inserto los datos del pago
    INSERT INTO pagos (pedido_id,metodo,importe)
    VALUES(2001,'efectivo',700);
    
-- ROLLBACK; -- Antes del commit verifico si los datos se encuentra corectos en la base de datos y si es asi confirmo con commit sino doy ROLLBACK

-- Es Correcto (SELECT * FROM pedidos WHERE pedido_id = 2001;)

-- Confirmo la transaccion
COMMIT;
    

