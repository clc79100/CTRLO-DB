USE ModaStore;
INSERT INTO User (user_mail, user_password, user_role) VALUES
  ('big@negroides.world', 'Adm1nPass', 'admin'),
  ('bob@modastore.com', 'Vend3rPass', 'vendedor');

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

(8, 'Playera Bob Esponja', 'S', 'amarilla', 120.00, 30, 2, 3),
(8, 'Playera Bob Esponja', 'M', 'amarilla', 120.00, 30, 2, 3),
(8, 'Playera Bob Esponja', 'L', 'amarilla', 120.00, 30, 2, 3),

(9, 'Pantalón de Mezclilla', 'S', 'azul', 220.00, 20, 3, 3),
(9, 'Pantalón de Mezclilla', 'M', 'azul', 220.00, 20, 3, 3),
(9, 'Pantalón de Mezclilla', 'L', 'azul', 220.00, 20, 3, 3);


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