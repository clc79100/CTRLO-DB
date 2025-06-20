## Productos
### sp_Stock_Report
#### Parametros:
- category_id_to_search
  - INT
  - **`NOT NULL`**
- min_stock
  - INT
  - **`NULL`**
- max_stock
  - INT
  - **`NULL`**
#### Ejemplo:
- ```sql
  CALL sp_Stock_Report(1, 20, 30)
  ```
- ![sp_Stock_Report](../resources/sp_Stock_Report.jpg)

---

### sp_Product_Detail
#### Parametros:
- id_to_search:
  - INT
  - **`NOT NULL`**
#### Ejemplo:
- ```sql
  CALL sp_Product_Detail(1);
    ```
1. Datos del Producto
- ![sp_Stock_Report](../resources/sp_Product_Detail_1.jpg)
2. Stock por tallas del Producto
- ![sp_Stock_Report](../resources/sp_Product_Detail_2.jpg)

---

### sp_Insert_Product
#### Parametros:
- v_product_name
  - VARCHAR(30)
  - **`NOT NULL`**
- v_product_color 
  - VARCHAR(30)
  - **`NOT NULL`**
- v_product_price 
  - DECIMAL(7, 2) //Máximo de 7 caracteres y 2 decimas
  - **`NOT NULL`**
- v_product_stock_S 
  - INT
  - **`NULL`**
- v_product_stock_M 
  - INT
  - **`NULL`**
- v_product_stock_L 
  - INT
  - **`NULL`**
- v_provider_id 
  - INT
  - **`NOT NULL`**
- v_category_id
  - INT
  - **`NOT NULL`**
#### Ejemplo:
  ```sql
    CALL sp_Insert_Product(
      'Camisa',
      'Azul',
      19.99,
      10,
      5,
      8,
      1,
      1
    );
  ```

---

### sp_Update_Product
#### Parametros:

- v_product_code
  - INT
  - **`NOT NULL`**
- v_product_name
  - VARCHAR(30)
  - **`NOT NULL`**
- v_product_color
  - VARCHAR(30)
  - **`NOT NULL`**
- v_product_price
  - DECIMAL(7, 2)
  - **`NOT NULL`**
- v_product_stock_S
  - INT
  - **`NULL`**
- v_product_stock_M
  - INT
  - **`NULL`**
- v_product_stock_L
  - INT
  - **`NULL`**
- v_provider_id
  - INT
  - **`NOT NULL`**
- v_category_id
  - INT
  - **`NOT NULL`**

#### Ejemplo:

  ```sql
    CALL sp_Update_Product(
      5,
      'Camisa Actualizada',
      'Rojo',
      24.99,
      12,
      6,
      10,
      1,
      1
    );
  ```

---

### sp_Delete_Product
#### Parametros:
- id_to_search:
  - INT
  - **`NOT NULL`**
#### Ejemplo:
- ```sql
  CALL sp_Delete_Product(1);
  ```
