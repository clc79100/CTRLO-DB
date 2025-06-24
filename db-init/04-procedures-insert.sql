USE ModaStore;
-- ----------------------------- Procedures de Inserción de Productos -----------------------------
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
    IN v_sale_date DATE,
    IN v_customer_id INT,
    IN v_products_sold JSON
)
BEGIN
    DECLARE new_sale_id INT;
    DECLARE v_total_sale DECIMAL(10,2);
    DECLARE generated_invoice VARCHAR(20);

    -- Calcular el total de la venta
    SELECT SUM(product_quantity * product_price)
    INTO v_total_sale
    FROM JSON_TABLE(v_products_sold, '$[*]'
        COLUMNS (
            product_id INT PATH '$.product_id',
            product_quantity INT PATH '$.product_quantity',
            product_price DECIMAL(10,2) PATH '$.product_price'
        )
    ) AS jt_total;

    -- Insertar la venta SIN el invoice_num por ahora
    INSERT INTO Sale (sale_invoice_num, sale_date, customer_id, total_sale)
    VALUES ('TEMP', v_sale_date, v_customer_id, v_total_sale);

    -- Obtener el ID autogenerado
    SET new_sale_id = LAST_INSERT_ID();

    -- Generar el invoice_num basado en el ID
    SET generated_invoice = CONCAT('MS-', new_sale_id);

    -- Actualizar el invoice_num
    UPDATE Sale
    SET sale_invoice_num = generated_invoice
    WHERE sale_id = new_sale_id;

    -- Insertar los productos vendidos
    INSERT INTO Products_Sold (sale_id, product_id, quantity_sold)
    SELECT new_sale_id, product_id, product_quantity
    FROM JSON_TABLE(v_products_sold, '$[*]'
        COLUMNS (
            product_id INT PATH '$.product_id',
            product_quantity INT PATH '$.product_quantity'
        )
    ) AS jt_insert;
END //
DELIMITER ;
-- ----------------------------- Procedure de Insercion de Usuarios -----------------------------

DELIMITER //
CREATE PROCEDURE sp_Insert_User(
    IN v_user_mail VARCHAR(50),
    IN v_user_password VARCHAR(20),
    IN v_user_role VARCHAR(30)
)
BEGIN
    INSERT INTO User (user_mail, user_password, user_role)
    VALUES (v_user_mail, v_user_password, v_user_role);
END //
DELIMITER ;

-- ----------------------------- Procedure de Insercion de Clientes -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Insert_Customer(
    IN v_customer_name VARCHAR(30)
)
BEGIN
    INSERT INTO Customer (customer_name)
    VALUES (v_customer_name);
END //
DELIMITER ;

-- ----------------------------- Procedure de Insercion de Proveedores -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Insert_Provider(
    IN v_provider_name VARCHAR(30),
    IN v_provider_mail VARCHAR(30),
    IN v_provider_phone VARCHAR(10)
)
BEGIN
    INSERT INTO Provider (provider_name, provider_mail, provider_phone)
    VALUES (v_provider_name, v_provider_mail, v_provider_phone);
END //
DELIMITER ;

-- ----------------------------- Procedure de Insercion de Categorias -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Insert_Category(
    IN v_category_name VARCHAR(30)
)
BEGIN
    INSERT INTO Category (category_name)
    VALUES (v_category_name);
END //
DELIMITER ;
