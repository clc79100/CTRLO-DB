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
    product_
    product_name VARCHAR(30) NOT NULL,
    product_size VARCHAR(30) NOT NULL,
    product_color VARCHAR(30) NOT NULL,
    product_price DOUBLE NOT NULL,
    product_stock INT NOT NULL,
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY(product_id),
    CONSTRAINT fk_category_id FOREIGN KEY(category_id) REFERENCES Category(category_id),
    CONSTRAINT fk_provider_id FOREIGN KEY(provider_id) REFERENCES Provider(provider_id)
);

CREATE TABLE Sale(
    sale_id INT NOT NULL AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    sale_invoice_num INT,
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

-- Procedure de Reporte de Ventas
DELIMITER //
CREATE PROCEDURE sp_Sales_Report(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT
        S.sale_id,
        S.sale_date,
        S.sale_invoice_num,
        SUM(PS.quantity_sold) AS total_quantity,
        SUM(P.product_price * PS.quantity_sold) AS total_sales
    FROM Sale S
    INNER JOIN Products_Sold PS
        ON S.sale_id = PS.sale_id
    INNER JOIN Product P
        ON PS.product_id = P.product_id
    GROUP BY
        S.sale_id,
        S.sale_date,
        S.sale_invoice_num
    ORDER BY S.sale_date;
    WHERE S.sale_date BETWEEN start_date AND end_date;
END //
DELIMITER ;


USE ModaStore;
DELIMITER //
CREATE PROCEDURE sp_Stock_Report(IN id_to_search INT)
BEGIN
    SELECT 
        P.product_name,
        P.product_price,
        CT.category_name,
        SUM(P.product_stock) total_stock
        FROM Product P
        INNER JOIN Category CT
            ON P.category_id = CT.category_id
        WHERE (id_to_search IS NULL OR CT.category_id = id_to_search)
        GROUP BY
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
        P.product_id,
        P.product_name
    FROM Product P
    JOIN Provider PR
        ON P.provider_id = PR.provider_id
    WHERE P.provider_id = id_to_search;
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

INSERT INTO Product
    (product_name, product_size, product_color, product_price, product_stock, provider_id, category_id)
VALUES
  -- Caballero
  ('Pants', 'M',   'Caqui',   400.00, 10, 1, 1),
  ('Playera Básica',  'L',   'negro',  150.00, 20, 2, 1),
  ('Shorts Denim',    'M',   'azul',    320.00, 15, 3, 1),

  -- Dama
  ('Falda Midi',      'S',   'negro',   422.00, 12, 1, 2),
  ('Top Encaje',      'M',   'rojo',    250.00, 18, 2, 2),
  ('Playera Crop',    'L',   'rosa',    369.00, 22, 3, 2),

  -- Niños
  ('Shorts Algodón',  '10',  'verde',   185.00, 25, 1, 3),
  ('Playera Bob Esponja','8',  'amarilla',120.00, 30, 2, 3),
  ('Pantalón de Mezclilla',  '12',  'gris',    220.00, 20, 3, 3);

INSERT INTO Sale(sale_date, sale_invoice_num, customer_id) VALUES
    ('2023-10-01', 1, 1),
    ('2023-10-02', 2, 2),
    ('2023-10-03', 3, 1),
    ('2023-10-04', 4, 2),
    ('2023-10-05', 5, 1),
    ('2023-10-06', 6, 2),
    ('2023-10-07', 7, 1),
    ('2023-10-08', 8, 2),
    ('2023-10-09', 9, 1),
    ('2023-10-10', 10, 2),
    ('2023-10-11', 11, 1);

-- Sale 1 - Juan Perez (Hombre)
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(1, 1, 2),
(1, 7, 1);

-- Sale 2 - Maria Lopez (Mujer)
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(2, 5, 3),
(2, 8, 2);

-- Sale 3 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(3, 2, 1),
(3, 9, 3);

-- Sale 4 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(4, 6, 2),
(4, 7, 1);

-- Sale 5 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(5, 3, 2),
(5, 8, 1);

-- Sale 6 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(6, 4, 1),
(6, 9, 2);

-- Sale 7 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(7, 2, 3), 
(7, 7, 1); 

-- Sale 8 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(8, 5, 2), 
(8, 8, 2); 

-- Sale 9 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(9, 1, 2),
(9, 9, 1);

-- Sale 10 - Maria Lopez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(10, 6, 1), 
(10, 7, 3);

-- Sale 11 - Juan Perez
INSERT INTO Products_Sold (sale_id, product_id, quantity_sold) VALUES
(11, 3, 2),
(11, 8, 2);

