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
(1, 'Pants', 'S', 'gris', 400.00, 60, 1, 1),
(1, 'Pants', 'M', 'gris', 400.00, 60, 1, 1),
(1, 'Pants', 'L', 'gris', 400.00, 60, 1, 1),

(2, 'Playera Básica', 'S', 'negro', 150.00, 60, 2, 1),
(2, 'Playera Básica', 'M', 'negro', 150.00, 60, 2, 1),
(2, 'Playera Básica', 'L', 'negro', 150.00, 60, 2, 1),

(3, 'Shorts Denim', 'S', 'azul', 320.00, 60, 3, 1),
(3, 'Shorts Denim', 'M', 'azul', 320.00, 60, 3, 1),
(3, 'Shorts Denim', 'L', 'azul', 320.00, 60, 3, 1),

-- Dama
(4, 'Falda Midi',    'S',  'negro', 422.00, 60, 1, 2),
(4, 'Falda Midi',    'M',  'negro', 422.00, 60, 1, 2),
(4, 'Falda Midi',    'L',  'negro', 422.00, 60, 1, 2),

(5, 'Top Encaje',    'S',  'rojo',  250.00, 60, 2, 2),
(5, 'Top Encaje',    'M',  'rojo',  250.00, 60, 2, 2),
(5, 'Top Encaje',    'L',  'rojo',  250.00, 60, 2, 2),

(6, 'Playera Crop',  'S',  'rosa',  369.00, 60, 3, 2),
(6, 'Playera Crop',  'M',  'rosa',  369.00, 60, 3, 2),
(6, 'Playera Crop',  'L',  'rosa',  369.00, 60, 3, 2),

-- Niños
(7, 'Shorts Algodón','S',  'verde', 185.00, 60, 1, 3),
(7, 'Shorts Algodón','M',  'verde', 185.00, 60, 1, 3),
(7, 'Shorts Algodón','L',  'verde', 185.00, 60, 1, 3),

(8, 'Playera Bob Esponja','S','amarilla',120.00,60, 2, 3),
(8, 'Playera Bob Esponja','M','amarilla',120.00,60, 2, 3),
(8, 'Playera Bob Esponja','L','amarilla',120.00,60, 2, 3),

(9, 'Pantalón de Mezclilla','S','azul',220.00,60,3, 3),
(9, 'Pantalón de Mezclilla','M','azul',220.00,60,3, 3),
(9, 'Pantalón de Mezclilla','L','azul',220.00,60,3, 3);


-- Sale 1 – Juan Perez
CALL sp_Insert_Sale(
  '2023-10-01',
  1,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 2,  'product_quantity', 2, 'product_price', 400.00),
    JSON_OBJECT('product_id', 20, 'product_quantity', 1, 'product_price', 185.00)
  )
);

-- Sale 2 – Maria Lopez
CALL sp_Insert_Sale(
  '2023-10-02',
  2,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 14, 'product_quantity', 3, 'product_price', 250.00),
    JSON_OBJECT('product_id', 23, 'product_quantity', 2, 'product_price', 120.00)
  )
);

-- Sale 3 – Ana Torres
CALL sp_Insert_Sale(
  '2023-10-03',
  3,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 13, 'product_quantity', 1, 'product_price', 150.00),
    JSON_OBJECT('product_id', 27, 'product_quantity', 3, 'product_price', 220.00)
  )
);

-- Sale 4 – Carlos Sanchez
CALL sp_Insert_Sale(
  '2023-10-04',
  4,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 17, 'product_quantity', 2, 'product_price', 369.00),
    JSON_OBJECT('product_id', 20, 'product_quantity', 1, 'product_price', 185.00)
  )
);

-- Sale 5 – Luis Ramirez
CALL sp_Insert_Sale(
  '2023-10-05',
  5,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 8,  'product_quantity', 2, 'product_price', 320.00),
    JSON_OBJECT('product_id', 23, 'product_quantity', 1, 'product_price', 120.00)
  )
);

-- Sale 6 – Juan Perez
CALL sp_Insert_Sale(
  '2023-10-06',
  1,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 11, 'product_quantity', 1, 'product_price', 422.00),
    JSON_OBJECT('product_id', 27, 'product_quantity', 2, 'product_price', 220.00)
  )
);

-- Sale 7 – Maria Lopez
CALL sp_Insert_Sale(
  '2023-10-07',
  2,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 5,  'product_quantity', 3, 'product_price', 150.00),
    JSON_OBJECT('product_id', 20, 'product_quantity', 1, 'product_price', 185.00)
  )
);

-- Sale 8 – Ana Torres
CALL sp_Insert_Sale(
  '2023-10-08',
  3,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 14, 'product_quantity', 2, 'product_price', 250.00),
    JSON_OBJECT('product_id', 23, 'product_quantity', 2, 'product_price', 120.00)
  )
);

-- Sale 9 – Carlos Sanchez
CALL sp_Insert_Sale(
  '2023-10-09',
  4,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 2,  'product_quantity', 2, 'product_price', 400.00),
    JSON_OBJECT('product_id', 27, 'product_quantity', 1, 'product_price', 220.00)
  )
);

-- Sale 10 – Luis Ramirez
CALL sp_Insert_Sale(
  '2023-10-10',
  5,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 17, 'product_quantity', 1, 'product_price', 369.00),
    JSON_OBJECT('product_id', 20, 'product_quantity', 3, 'product_price', 185.00)
  )
);

-- Sale 11 – Juan Perez
CALL sp_Insert_Sale(
  '2023-10-11',
  1,
  JSON_ARRAY(
    JSON_OBJECT('product_id', 8,  'product_quantity', 2, 'product_price', 320.00),
    JSON_OBJECT('product_id', 23, 'product_quantity', 2, 'product_price', 120.00)
  )
);
