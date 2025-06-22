USE ModaStore;

-- ----------------------------- Procedimiento de Eliminación de Productos -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Product(IN id_to_seatch INT)
BEGIN
    UPDATE Product
    SET product_is_active = 0
    WHERE product_code = id_to_seatch;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Ventas -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Sale(IN id_to_seatch INT)
BEGIN
    DELETE FROM Products_Sold
    WHERE sale_id = id_to_search;

    UPDATE Sale
    SET sale_is_active = 0
    WHERE sale_id = id_to_seatch;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Clientes -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Customer(IN id_to_search INT)
BEGIN
    UPDATE Customer
    SET customer_is_active = 0
    WHERE customer_id = id_to_search;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Proveedores -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Provider(IN id_to_search INT)
BEGIN
    UPDATE Provider
    SET provider_is_active = 0
    WHERE provider_id = id_to_search;
END //
DELIMITER ;     

-- ----------------------------- Procedimiento de Eliminación de Usuarios -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_User(IN id_to_search INT)
BEGIN
    UPDATE User
    SET user_is_active = 0
    WHERE user_id = id_to_search;
END //
DELIMITER ;

-- ----------------------------- Procedimiento de Eliminación de Categorías -----------------------------
DELIMITER //
CREATE PROCEDURE sp_Delete_Category(IN id_to_search INT)
BEGIN
    UPDATE Category
    SET category_is_active = 0
    WHERE category_id = id_to_search;
END //
DELIMITER ;
