-- TRIGGER

DELIMITER //
CREATE TRIGGER tg_Act_Stock 
AFTER UPDATE 
ON detalle_pedidos -- En que tabla lo voy a ejecutar 
FOR EACH ROW -- Quiero que se ejecute en todas las filas

BEGIN -- inicio del trigger
	UPDATE productos
    SET stock = stock - NEW.cantidad -- la logica es que el stock nuevo es stock menos cantidad  
    WHERE producto_id = NEW.producto.id;
    
    -- Alerta de productos bajos en stock en este caso menos de 3 productos
    IF( SELECT stock FROM productos WHERE producto_id = NEW.producto_id) < 10 THEN -- THEN(si la condicion es verdadera)
    INSERT INTO Alerta_de_Stock (producto_id,mensaje,fecha_alerta)
    VALUES (NEW.producto_id,'Este Producto se encunetra bajo en Stock, se requiere Reabastecimiento',NOW());
    END IF;


END; -- fin del trigger
DELIMITER; 

-- se crea la tabla de alarma 
CREATE TABLE alertas_stock (
    alerta_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    mensaje VARCHAR(255),
    fecha_alerta DATETIME,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);



-- Cambiar los datos de Stock y verificar 
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio, descuento)
VALUES (150, 38, 5, 120, 2.12);  

SELECT stock FROM productos WHERE producto_id = 38;

SELECT * FROM alertas_stock WHERE producto_id = 38;


-- TRIGGER NUEVO EMAIL

-- 1ERO Creo la nueva tabla 
CREATE TABLE Email_historial (
    email_H_id INT NOT NULL AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (email_H_id),
    UNIQUE INDEX email_UNIQUE (email),
    CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Creo el Trigger
DELIMITER //
CREATE TRIGGER tg_New_Email
AFTER UPDATE
ON clientes
FOR EACH ROW 
BEGIN
	IF OLD.email <> NEW.email THEN
    INSERT INTO Email_historial (cliente_id,email)
    VALUES (OLD.cliente_id, OLD.email);
    END IF;

END;


-- Compruebo su uso

UPDATE clientes 
SET email = 'ProbandoTrigger@gmail.com'
WHERE cliente_id = 10;

SELECT * FROM email_historial;