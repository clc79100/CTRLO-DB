USE ModaStore;
-- ----------------------------- Procedures de Ventas -----------------------------
-- Filtro opcional por rango de fechas
DELIMITER //
CREATE PROCEDURE sp_Sales_Report(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT
        S.sale_id,
        S.sale_invoice_num,
        DATE_FORMAT(S.sale_date, '%d/%m/%Y') AS sale_date,
        SUM(P.product_price * PS.quantity_sold) AS total_sale
    FROM Sale S
    INNER JOIN Products_Sold PS
        ON S.sale_id = PS.sale_id
    INNER JOIN Product P
        ON PS.product_id = P.product_id
    WHERE 
        (start_date IS NULL OR S.sale_date >= start_date) AND
        (end_date IS NULL OR S.sale_date >= end_date) AND
        (S.sale_is_active = TRUE)
    GROUP BY
        S.sale_id,
        S.sale_date,
        S.sale_invoice_num
    ORDER BY S.sale_date;
END //
DELIMITER ;

-- Procedure para obtener los detalles de una venta específica
DELIMITER //
CREATE PROCEDURE sp_Sale_Detail(IN id_to_search INT)
BEGIN
    -- Datos de la Venta/Factura
   SELECT
        S.sale_id,
        DATE_FORMAT(S.sale_date, '%d/%m/%Y') AS sale_date,
        S.sale_invoice_num,
        SUM(P.product_price * PS.quantity_sold) AS total_sale
    FROM Sale S
    INNER JOIN Products_Sold PS
        ON S.sale_id = PS.sale_id
    INNER JOIN Product P
        ON PS.product_id = P.product_id
    WHERE 
        (S.sale_id = id_to_search) AND 
        (S.sale_is_active = TRUE)
    GROUP BY
        S.sale_id,
        S.sale_date,
        S.sale_invoice_num;

    -- Productos Vendidos
    SELECT
        P.product_code,
        P.product_name,
        P.product_color,
        P.product_size,
        P.product_price,
        PS.quantity_sold
    FROM Sale S
    INNER JOIN Products_Sold PS
        ON S.sale_id = PS.sale_id
    INNER JOIN Product P
        ON PS.product_id = P.product_id
    WHERE 
        (S.sale_id = id_to_search) AND 
        (S.sale_is_active = TRUE);
END //
DELIMITER ;

-- ----------------------------- Procedures de Productos -----------------------------
-- Filtro opcional por id de categoría y rango de stock
DELIMITER //
CREATE PROCEDURE sp_Stock_Report(IN id_to_search INT, IN min_stock INT, IN max_stock INT)
BEGIN
    SELECT
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name,
        SUM(P.product_stock) AS total_stock
    FROM Product P
    INNER JOIN Category CT
        ON P.category_id = CT.category_id
    WHERE 
        (id_to_search IS NULL OR CT.category_id = id_to_search) AND
        (P.product_is_active = TRUE)
    GROUP BY
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name
    HAVING
        (min_stock IS NULL OR total_stock >= min_stock) AND
        (max_stock IS NULL OR total_stock <= max_stock);
END //
DELIMITER ;

-- Procedure para obtener los detalles de un producto específico
DELIMITER //
CREATE PROCEDURE sp_Product_Detail(IN code_to_search INT)
BEGIN
    -- Datos del Producto
    SELECT
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name,
        PR.provider_name
    FROM Product P
    INNER JOIN Category CT
        ON P.category_id = CT.category_id
    INNER JOIN Provider PR
        ON P.provider_id = PR.provider_id
    WHERE 
        (P.product_code = code_to_search) AND
        (P.product_is_active = TRUE)
    GROUP BY
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name,
        PR.provider_name;

    -- Stock por tallas
    SELECT
        P.product_size,
        P.product_stock
    FROM Product P
    WHERE 
        (P.product_code = code_to_search) AND 
        (P.product_is_active = TRUE);
END //
DELIMITER ;

-- ----------------------------- Procedures de Proveedor -----------------------------

-- Lista de proveedores activos
DELIMITER //
CREATE PROCEDURE sp_Provider_List()
BEGIN
    SELECT
        PR.provider_id,
        PR.provider_name
    FROM Provider PR
    WHERE
        (PR.provider_is_active = TRUE)
    ORDER BY PR.provider_id;
END //
DELIMITER ;

-- Procedure para obtener los detalles de un proveedor específico
DELIMITER //
CREATE PROCEDURE sp_Provider_Products(IN id_to_search INT)
BEGIN
    SELECT
        PR.provider_id,
        PR.provider_name,
        PR.provider_mail,
        PR.provider_phone
    FROM Provider PR
    WHERE 
        (PR.provider_id = id_to_search) AND
        (PR.provider_is_active = TRUE);

    SELECT
        P.product_code,
        P.product_name
    FROM Product P
    JOIN Provider PR
        ON P.provider_id = PR.provider_id
    WHERE 
        (PR.provider_id = id_to_search) AND
        (P.product_is_active = TRUE) AND
        (PR.provider_is_active = TRUE)
    GROUP BY
        P.product_code,
        P.product_name
    ORDER BY product_code;
END //
DELIMITER ;

-- ----------------------------- Procedures de Cliente -----------------------------

-- Lista de clientes activos
DELIMITER //
CREATE PROCEDURE sp_Customer_List()
BEGIN
    SELECT
        C.customer_id,
        C.customer_name
    FROM Customer C
    WHERE
        (C.customer_is_active = TRUE)
    ORDER BY C.customer_id;
    END //
    DELIMITER ;

-- Se muestra todos los productos sin importar la baja logica
DELIMITER //
CREATE PROCEDURE sp_Customer_Detail(IN search_id INT)
BEGIN
    SELECT
        C.customer_id,
        C.customer_name
    FROM Customer C
    WHERE 
        (C.customer_id = search_id) AND
        (C.customer_is_active = TRUE);

    SELECT
        P.product_id,
        P.product_name,
        P.product_size,
        P.product_color,
        S.sale_invoice_num,
        DATE_FORMAT(S.sale_date, '%d/%m/%Y') AS sale_date
        FROM Product P
        INNER JOIN Products_Sold PS
            ON P.product_id = PS.product_id
        INNER JOIN Sale S
            ON PS.sale_id = S.sale_id
        WHERE 
            (S.customer_id = search_id) AND
            (S.sale_is_active = TRUE)
        ORDER BY S.sale_date;
END //
DELIMITER ;

