CREATE USER 'api-user'@'%' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON *.* TO 'api-user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE USER 'test-user'@'%' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON *.* TO 'api-user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS ModaStore;
CREATE DATABASE ModaStore;
USE ModaStore;

CREATE TABLE Category(
    category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(30),
    PRIMARY KEY(category_id)
);

CREATE TABLE Provider(
    provider_id INT NOT NULL AUTO_INCREMENT,
    provider_name VARCHAR(30) NOT NULL,
    provider_mail VARCHAR(30),
    provider_phone VARCHAR(10),
    PRIMARY KEY(provider_id)
);

CREATE TABLE Customer(
    customer_id INT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(30),
    PRIMARY KEY(customer_id)
);

CREATE TABLE User(
    user_id INT NOT NULL AUTO_INCREMENT,
    user_name VARCHAR(30),
    user_role VARCHAR(30) NOT NULL,
    user_mail VARCHAR(50) NOT NULL,
    user_password VARCHAR(10) NOT NULL,
    PRIMARY KEY(user_id)
);

CREATE TABLE Product(
    product_id INT NOT NULL AUTO_INCREMENT,
    product_code INT NOT NULL,
    product_name VARCHAR(30) NOT NULL,
    product_size VARCHAR(30) NOT NULL,
    product_color VARCHAR(30) NOT NULL,
    product_price DECIMAL(7, 2) NOT NULL,
    product_stock INT NOT NULL,
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY(product_id),
    CONSTRAINT fk_category_id FOREIGN KEY(category_id) REFERENCES Category(category_id),
    CONSTRAINT fk_provider_id FOREIGN KEY(provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE Sale(
    sale_id INT NOT NULL AUTO_INCREMENT,
    sale_invoice_num INT NOT NULL UNIQUE,
    sale_date DATE NOT NULL,
    customer_id INT NOT NULL,
    PRIMARY KEY(sale_id),
    CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Products_Sold(
    products_sold_id INT NOT NULL AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_sold INT NOT NULL,
    PRIMARY KEY(products_sold_id),
    CONSTRAINT fk_sale_id FOREIGN KEY(sale_id) REFERENCES Sale(sale_id),
    CONSTRAINT fk_product_id FOREIGN KEY(product_id) REFERENCES Product(product_id)
);

-- Procedures de Ventas
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
        (end_date IS NULL OR S.sale_date <= end_date)
    GROUP BY
        S.sale_id,
        S.sale_date,
        S.sale_invoice_num
    ORDER BY S.sale_date;
END //
DELIMITER ;

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
    WHERE S.sale_id = id_to_search
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
    WHERE S.sale_id = id_to_search;
END //
DELIMITER ;


-- Procedure de Reporte de Productos 
DELIMITER //
CREATE PROCEDURE sp_Stock_Report(IN id_to_search INT)
BEGIN
    SELECT
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name,
        SUM(P.product_stock) total_stock
    FROM Product P
    INNER JOIN Category CT
        ON P.category_id = CT.category_id
    WHERE (id_to_search IS NULL OR CT.category_id = id_to_search)
    GROUP BY
        P.product_code,
        P.product_name,
        P.product_price,
        CT.category_name;
END //
DELIMITER ;

-- Procedure de Productos por Proveedor
DELIMITER //
CREATE PROCEDURE sp_Provider_Products(IN id_to_search INT)
BEGIN
    SELECT
        P.product_code,
        P.product_name
    FROM Product P
    JOIN Provider PR
        ON P.provider_id = PR.provider_id
    WHERE P.provider_id = id_to_search
    GROUP BY
        P.product_code,
        P.product_name
    ORDER BY product_code;
END //
DELIMITER ;

-- Procedure de Historial de Compras de Cliente
DELIMITER //
CREATE PROCEDURE sp_Customer_History(IN search_id INT)
BEGIN
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
        WHERE S.customer_id = search_id
        ORDER BY S.sale_date;
END //
DELIMITER ;

-- Procedure de Inserción de Productos para los tres tamaños de ropa
DELIMITER //
CREATE PROCEDURE sp_Insert_Product(
    IN product_name VARCHAR(30),
    IN product_color VARCHAR(30), 
    IN product_price DECIMAL(7, 2), 
    IN product_stock_S INT,
    IN product_stock_M INT,
    IN product_stock_L INT, 
    IN provider_id INT, 
    IN category_id INT
)
BEGIN
    DECLARE new_code INT;
    
    -- nuevo codigo 
    SELECT IFNULL(MAX(product_code), 0) + 1 INTO new_code
    FROM Product;

    INSERT INTO Product (product_code, product_name, product_size, product_color, 
                         product_price, product_stock, provider_id, category_id)
    VALUES
    (new_code, product_name, 'S', product_color, product_price, product_stock_S, provider_id, category_id),
    (new_code, product_name, 'M', product_color, product_price, product_stock_M, provider_id, category_id),
    (new_code, product_name, 'L', product_color, product_price, product_stock_L, provider_id, category_id);
END //
DELIMITER ;



INSERT INTO User (user_name, user_role, user_mail, user_password) VALUES
  ('Big Negroide',  'admin',    'big@negroides.world',    'Adm1nPass'),
  ('Bob Vendedor','vendedor', 'bob@modastore.com',      'Vend3rPass');

INSERT INTO Category (category_name) VALUES
  ('Caballero'),
  ('Dama'),
  ('Niños');

INSERT INTO Customer(customer_name) VALUES
    ('Juan Perez'),
    ('Maria Lopez'),
    ('Ana Torres'),
    ('Carlos Sanchez'),
    ('Luis Ramirez');

INSERT INTO Provider (provider_name, provider_mail, provider_phone) VALUES
    ('ModaGlobal', 'contacto@modaglobal.com', '477123456'),
    ('ProovedorNegroide', 'proovedor@negroides.world', '477654321'),
    ('Calvin Klein', 'calvin@klein.com', '477987654');

INSERT INTO Product (product_code, product_name, product_size, product_color, product_price, product_stock, provider_id, category_id) 
VALUES
-- Caballero
(1, 'Pants', 'S', 'gris', 400.00, 10, 1, 1),
(1, 'Pants', 'M', 'gris', 400.00, 10, 1, 1),
(1, 'Pants', 'L', 'gris', 400.00, 10, 1, 1),

(2, 'Playera Básica', 'S', 'negro', 150.00, 20, 2, 1),
(2, 'Playera Básica', 'M', 'negro', 150.00, 20, 2, 1),
(2, 'Playera Básica', 'L', 'negro', 150.00, 20, 2, 1),

(3, 'Shorts Denim', 'S', 'azul', 320.00, 15, 3, 1),
(3, 'Shorts Denim', 'M', 'azul', 320.00, 15, 3, 1),
(3, 'Shorts Denim', 'L', 'azul', 320.00, 15, 3, 1),

-- Dama
(4, 'Falda Midi', 'S', 'negro', 422.00, 12, 1, 2),
(4, 'Falda Midi', 'M', 'negro', 422.00, 12, 1, 2),
(4, 'Falda Midi', 'L', 'negro', 422.00, 12, 1, 2),

(5, 'Top Encaje', 'S', 'rojo', 250.00, 18, 2, 2),
(5, 'Top Encaje', 'M', 'rojo', 250.00, 18, 2, 2),
(5, 'Top Encaje', 'L', 'rojo', 250.00, 18, 2, 2),

(6, 'Playera Crop', 'S', 'rosa', 369.00, 22, 3, 2),
(6, 'Playera Crop', 'M', 'rosa', 369.00, 22, 3, 2),
(6, 'Playera Crop', 'L', 'rosa', 369.00, 22, 3, 2),

-- Niños
(7, 'Shorts Algodón', 's', 'verde', 185.00, 25, 1, 3),
(7, 'Shorts Algodón', 'M', 'verde', 185.00, 25, 1, 3),
(7, 'Shorts Algodón', 'L', 'verde', 185.00, 25, 1, 3),

(7, 'Playera Bob Esponja', 'S', 'amarilla', 120.00, 30, 2, 3),
(7, 'Playera Bob Esponja', 'M', 'amarilla', 120.00, 30, 2, 3),
(7, 'Playera Bob Esponja', 'L', 'amarilla', 120.00, 30, 2, 3),

(7, 'Pantalón de Mezclilla', 'S', 'azul', 220.00, 20, 3, 3),
(7, 'Pantalón de Mezclilla', 'M', 'azul', 220.00, 20, 3, 3),
(7, 'Pantalón de Mezclilla', 'L', 'azul', 220.00, 20, 3, 3);


INSERT INTO Sale(sale_date, sale_invoice_num, customer_id) VALUES
    ('2023-10-01', 1, 1),
    ('2023-10-02', 2, 2),
    ('2023-10-03', 3, 3),
    ('2023-10-04', 4, 4),
    ('2023-10-05', 5, 5),
    ('2023-10-06', 6, 1),
    ('2023-10-07', 7, 2),
    ('2023-10-08', 8, 3),
    ('2023-10-09', 9, 4),
    ('2023-10-10', 10, 5),
    ('2023-10-11', 11, 1);

-- Sale 1 - Juan Perez (Hombre)
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(1, 2, 2),   -- Pants M (Caballero)
(1, 20, 1);  -- Shorts Algodón 10 (Niños)

-- Sale 2 - Maria Lopez (Mujer)
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(2, 14, 3),  -- Top Encaje M (Dama)
(2, 23, 2);  -- Playera Bob Esponja 10 (Niños)

-- Sale 3 - Ana Torres
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(3, 13, 1),   -- Playera Básica M (Caballero)
(3, 27, 3);  -- Pantalón Mezclilla 12 (Niños)

-- Sale 4 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(4, 17, 2),  -- Playera Crop M (Dama)
(4, 20, 1);  -- Shorts Algodón 10 (Niños)

-- Sale 5 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(5, 8, 2),   -- Shorts Denim M (Caballero)
(5, 23, 1);  -- Playera Bob Esponja 10 (Niños)

-- Sale 6 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(6, 11, 1),  -- Falda Midi M (Dama)
(6, 27, 2);  -- Pantalón Mezclilla 12 (Niños)

-- Sale 7 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(7, 5, 3),   -- Playera Básica M (Caballero)
(7, 20, 1);  -- Shorts Algodón 10 (Niños)

-- Sale 8 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(8, 14, 2),  -- Top Encaje M (Dama)
(8, 23, 2);  -- Playera Bob Esponja 10 (Niños)

-- Sale 9 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(9, 2, 2),   -- Pants M (Caballero)
(9, 27, 1);  -- Pantalón Mezclilla 12 (Niños)

-- Sale 10 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(10, 17, 1),  -- Playera Crop M (Dama)
(10, 20, 3);  -- Shorts Algodón 10 (Niños)

-- Sale 11 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(11, 8, 2),   -- Shorts Denim M (Caballero)
(11, 23, 2);  -- Playera Bob Esponja 10 (Niños)
