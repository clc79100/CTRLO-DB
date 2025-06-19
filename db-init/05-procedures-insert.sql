USE ModaStore;
-- ----------------------------- Procedures de Inserción de Categorías -----------------------------
-- Inserción de un producto con 3 diferentes stock(L, M, S)
DELIMITER //
CREATE PROCEDURE sp_Insert_Product(
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
    DECLARE new_code INT;
    
    -- nuevo codigo 
    SELECT IFNULL(MAX(product_code), 0) + 1 INTO new_code
    FROM Product;

    INSERT INTO Product (product_code, product_name, product_size, product_color, 
                         product_price, product_stock, provider_id, category_id)
    VALUES
    (new_code, v_product_name, 'S', v_product_color, v_product_price, v_product_stock_S, v_provider_id, v_category_id),
    (new_code, v_product_name, 'M', v_product_color, v_product_price, v_product_stock_M, v_provider_id, v_category_id),
    (new_code, v_product_name, 'L', v_product_color, v_product_price, v_product_stock_L, v_provider_id, v_category_id);
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Inserción de Ventas -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Insert_Sale(
    IN v_sale_invoice_num INT,
    IN v_sale_date DATE,
    IN v_customer_id INT,
    IN v_products_sold JSON
)
BEGIN
    DECLARE new_sale_id INT;
    -- Insertar la venta
    INSERT INTO Sale (sale_invoice_num, sale_date, customer_id)
    VALUES (v_sale_invoice_num, v_sale_date, v_customer_id);
    
    -- Obtener el ID de la nueva venta
    SET new_sale_id = LAST_INSERT_ID();
    
    -- Insertar los productos vendidos
    INSERT INTO Products_Sold (sale_id, product_id, quantity_sold)
    SELECT new_sale_id, product_id, product_quantity
    -- Se insertan los productos vendidos desde el Array JSON
    FROM JSON_TABLE(products_sold, '$[*]'
        COLUMNS (
            product_id INT PATH '$.product_id',
            product_quantity INT PATH '$.product_quantity'
        )
    ) AS jt;
END //
DELIMITER ;