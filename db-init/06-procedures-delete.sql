USE ModaStore;

-- ----------------------------- Procedimiento de Eliminación de Productos -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Product(IN v_product_code INT)
BEGIN
    UPDATE Product
    SET is_active = 0
    WHERE product_code = v_product_code;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Ventas -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Sale(IN v_sale_id INT)
BEGIN
    UPDATE Sale
    SET sale_is_active = 0
    WHERE sale_id = v_sale_id;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Clientes -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Customer(IN v_customer_id INT)
BEGIN
    UPDATE Customer
    SET customer_is_active = 0
    WHERE customer_id = v_customer_id;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Proveedores -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Provider(IN v_provider_id INT)
BEGIN
    UPDATE Provider
    SET provider_is_active = 0
    WHERE provider_id = v_provider_id;
END //
DELIMITER ;     

-- ----------------------------- Procedimiento de Eliminación de Usuarios -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_User(IN v_user_id INT)
BEGIN
    UPDATE User
    SET user_is_active = 0
    WHERE user_id = v_user_id;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Categorías -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Category(IN v_category_id INT)
BEGIN
    UPDATE Category
    SET category_is_active = 0
    WHERE category_id = v_category_id;
END //
DELIMITER ;
