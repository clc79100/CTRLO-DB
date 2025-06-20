# Lo que pidio el Control O
### Proyecto 3: Tienda de Ropa - Claudio Castro

### Nombre del proyecto: ModaStore

**Módulos**:
- Control de acceso (roles: administrador, vendedor)
- Productos (ropa, tallas, colores, precios, stock)
- Clientes (registro de compradores, historial de compras)
- Ventas (factura, fecha, productos vendidos)
- Inventario (stock por categoría, alertas de bajo stock)
- Proveedores (contacto, productos ofrecidos)
- Reportes (ventas, productos más vendidos, inventario)

**TODO**
- Ventas no afectadas por cambio de precio en producto
- Trigger para actualizar stock en cada venta

# Explicación
## Diagrama Entidad Relación
![Diagrama de la base de datos](resources/E-R.png)

## Procedures
1. **[Ventas](/docs/ventas.md)**
2. **[Productos](/docs/productos.md)**
3. **[Proveedores](/docs/proveedores.md)**
4. **[Clientes](/docs/clientes.md)**
5. **[Usuarios](/docs/usuarios.md)**
6. **[Categorías](/docs/categorias.md)**

**Nota**
- Los parametros nulos se envian de la siguiente manera: 
  - `sp_Ejemplo(NULL)`
- Todos los deletes son bajas lógicas

## Formato:

### sp_Nombre_del_Procedure
#### Parametros:
- Nombre_de_parametro:
  - tipo de dato
  - **`NOT NULL`**/**`NULL`**
#### Ejemplo:
- ```sql
  CALL sp_Ejemplo(1);
  ```
- imagen de resultado ( solo para procedures de tipo SELECT )
