## Proyecto 3: Tienda de Ropa - Claudio Castro

Nombre del proyecto: ModaStore

**Módulos**:
- Control de acceso (roles: administrador, vendedor)
- Productos (ropa, tallas, colores, precios, stock)
- Clientes (registro de compradores, historial de compras)
- Ventas (factura, fecha, productos vendidos)
- Inventario (stock por categoría, alertas de bajo stock)
- Proveedores (contacto, productos ofrecidos)
- Reportes (ventas, productos más vendidos, inventario)

**TODO**
- Update individual al stock de un prodcuto por tallas a Product
- Update general a Product
- Trigger para actualizar el stock después de una venta
- Trigger para sumar piezas vendidas del stock, al cancelar una venta


## Temporal
- Array de JSON para inserciòn de productos vendidos
```json
[
  { "product_id": 1, "quantity": 2 },
  { "product_id": 3, "quantity": 1 }
]
```