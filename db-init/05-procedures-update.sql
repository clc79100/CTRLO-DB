USE ModaStore;

-- ----------------------------- Procedure de Actualización de Productos -----------------------------
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
    -- Actualizar los datos generales del producto
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

-- ----------------------------- Procedure de Actualización de Ventas -----------------------------
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

-- ----------------------------- Procedure de Actualización de Usuarios -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_User(
    IN v_user_id INT,
    IN v_user_mail VARCHAR(50),
    IN v_user_password VARCHAR(10),
    IN v_user_role VARCHAR(30)
)
BEGIN
    UPDATE User
    SET
        user_mail = v_user_mail,
        user_password = v_user_password,
        user_role = v_user_role
    WHERE user_id = v_user_id;
END //
DELIMITER ;
-- ----------------------------- Procedure de Actualización de Clientes -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_Customer(
    IN v_customer_id INT,
    IN v_customer_name VARCHAR(30)
)
BEGIN
    UPDATE Customer
    SET
        customer_name = v_customer_name
    WHERE customer_id = v_customer_id;
END //
DELIMITER ;

-- ----------------------------- Procedure de Actualización de Proovedores -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_Provider(
    IN v_provider_id INT,
    IN v_provider_name VARCHAR(30),
    IN v_provider_mail VARCHAR(30),
    IN v_provider_phone VARCHAR(10)
)
BEGIN
    UPDATE Provider
    SET
        provider_name = v_provider_name,
        provider_mail = v_provider_mail,
        provider_phone = v_provider_phone
    WHERE provider_id = v_provider_id;
END //
DELIMITER ;

-- ----------------------------- Procedure de Actualización de Categorias -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Update_Category(
    IN v_category_id INT,
    IN v_category_name VARCHAR(30)
)
BEGIN
    UPDATE Category
    SET
        category_name = v_category_name
    WHERE category_id = v_category_id;
END //
DELIMITER ;