USE ModaStore;

-- ----------------------------- Procedimiento de Actualización de Productos -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_Product(
    IN v_product_code INT,
    IN v_product_name VARCHAR(30),
    IN v_product_color VARCHAR(30),
    IN v_product_price DECIMAL(7, 2),
    IN v_product_stock_S INT,
    IN v_product_stock_M INT,
    IN v_product_stock_L INT,
    IN v_provider_id INT,
    IN v_category_id INT
)
BEGIN
    -- Actualizar los datos generales del producto (puede haber varias filas si el mismo producto tiene tallas diferentes)
    UPDATE Product
    SET
        product_name = v_product_name,
        product_color = v_product_color,
        product_price = v_product_price,
        provider_id = v_provider_id,
        category_id = v_category_id
    WHERE product_code = v_product_code;

    -- Actualizar el stock según la talla
    UPDATE Product
    SET product_stock = CASE product_size
        WHEN 'S' THEN v_product_stock_S
        WHEN 'M' THEN v_product_stock_M
        WHEN 'L' THEN v_product_stock_L
    END
    WHERE product_code = v_product_code AND product_size IN ('S', 'M', 'L');
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Actualización de Ventas -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_Sale(
    IN v_sale_id INT,
    IN v_sale_invoice_num INT,
    IN v_sale_date DATE,
    IN v_customer_id INT,
    IN v_products_sold JSON
)
BEGIN
    -- Actualizar la venta
    UPDATE Sale
    SET 
        sale_invoice_num = v_sale_invoice_num,
        sale_date = v_sale_date,
        customer_id = v_customer_id
    WHERE sale_id = v_sale_id;
    -- Eliminar los productos vendidos anteriores
    DELETE FROM Products_Sold WHERE sale_id = v_sale_id;
    -- Insertar los nuevos productos vendidos
    INSERT INTO Products_Sold (sale_id, product_id, quantity_sold)
    SELECT v_sale_id, product_id, product_quantity
    FROM JSON_TABLE(v_products_sold, '$[*]'
        COLUMNS (
            product_id INT PATH '$.product_id',
            product_quantity INT PATH '$.product_quantity'
        )
    ) AS jt;
END //
DELIMITER ;
