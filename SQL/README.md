# Consultas SQL sobre una base de datos de jardineria

## Consultas sobre una Tabla

1. **Listado de oficinas y ciudades:**
    ```sql
    SELECT codigo_oficina, ciudad AS ciudad_oficina FROM oficina;
    ```

2. **Listado de ciudades y teléfonos de oficinas en España:**
    ```sql
    SELECT ciudad AS ciudad_oficina, telefono AS telefono_oficina 
    FROM oficina 
    WHERE pais = "España";
    ```

3. **Listado de empleados cuyo jefe tiene el código 7:**
    ```sql
    SELECT nombre AS nombre_empleado, apellido1 AS apellido_1_empleado, apellido2 AS apellido2_empleado, email 
    FROM empleado 
    WHERE codigo_jefe = 7;
    ```

4. **Información del jefe de la empresa:**
    ```sql
    SELECT puesto, nombre, apellido1 AS apellido_1_empleado, apellido2 AS apellido_2_empleado, email 
    FROM empleado 
    WHERE codigo_jefe IS NULL;
    ```

5. **Empleados que no son representantes de ventas:**
    ```sql
    SELECT nombre AS nombre_empleado, apellido1 AS primer_apellido, apellido2 AS segundo_apellido, puesto 
    FROM empleado 
    WHERE puesto <> 'representante de ventas';
    ```

6. **Listado de clientes españoles:**
    ```sql
    SELECT nombre_cliente 
    FROM cliente 
    WHERE pais = "España";
    ```

7. **Distintos estados de los pedidos:**
    ```sql
    SELECT DISTINCT estado_pedido 
    FROM pedido;
    ```

8. **Clientes que realizaron algún pago en 2008:**
    - Utilizando la función YEAR de MySQL:
        ```sql
        SELECT DISTINCT cod_cliente 
        FROM transaccion 
        WHERE YEAR(fecha_transaccion) = 2008;
        ```
    - Utilizando la función DATE_FORMAT de MySQL:
        ```sql
        SELECT DISTINCT cod_cliente 
        FROM transaccion 
        WHERE DATE_FORMAT(fecha_transaccion, '%Y') = '2008';
        ```
    - Sin utilizar ninguna de las funciones anteriores:
        ```sql
        SELECT DISTINCT cod_cliente 
        FROM transaccion 
        WHERE fecha_transaccion >= '2008-01-01' 
        AND fecha_transaccion < '2009-01-01';
        ```

9. **Pedidos no entregados a tiempo:**
    ```sql
    SELECT codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega 
    FROM pedido 
    WHERE fecha_entrega > fecha_esperada AND estado_pedido != 'Entregado';
    ```

10. **Pedidos entregados al menos dos días antes de la fecha esperada:**
    ```sql
    SELECT codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega 
    FROM pedido 
    WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2;
    ```

11. **Pedidos rechazados en 2009:**
    ```sql
    SELECT codigo_pedido, fecha_pedido, estado_pedido 
    FROM pedido 
    WHERE estado_pedido = 'Rechazado' AND YEAR(fecha_pedido) = 2009;
    ```

12. **Pedidos entregados en enero de cualquier año:**
    ```sql
    SELECT codigo_pedido 
    FROM pedido 
    WHERE MONTH(fecha_entrega) = 1;
    ```

13. **Pagos realizados en 2008 mediante Paypal, ordenados de mayor a menor:**
    ```sql
    SELECT codigo_pedido, f.nombre_forma_pago AS forma_pago, fecha_pedido 
    FROM pedido p 
    JOIN forma_pago f ON f.id_forma_pago = p.tipo_pago 
    WHERE f.nombre_forma_pago = "Paypal" AND YEAR(fecha_pedido) = 2008 
    ORDER BY DATE(fecha_pedido) ASC;
    ```

14. **Formas de pago distintas:**
    ```sql
    SELECT DISTINCT nombre_forma_pago 
    FROM forma_pago;
    ```

15. **Productos de la gama Ornamentales con más de 100 unidades en stock, ordenados por precio:**
    ```sql
    SELECT * 
    FROM producto 
    WHERE gama_producto = 'Ornamentales' AND cantidad_stock > 100 
    ORDER BY precio_venta DESC;
    ```

16. **Clientes de Madrid con representantes de ventas con código 11 o 30:**
    ```sql
    SELECT * 
    FROM cliente 
    WHERE ciudad = 'Madrid' AND codigo_empleado_rep_ventas IN (11, 30);
    ```

## Consultas Multitabla (Composición Interna)

1. **Listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1
    FROM cliente c, empleado e
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado;
    ```

2. **Nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1
    FROM cliente c, empleado e, pago p
    WHERE c.id_cliente = p.id_cliente
    AND c.codigo_empleado_rep_ventas = e.id_empleado;
    ```

3. **Nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1
    FROM cliente c, empleado e
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado
    AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);
    ```

4. **Nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
    FROM cliente c, empleado e, pago p, oficina o
    WHERE c.id_cliente = p.id_cliente
    AND c.codigo_empleado_rep_ventas = e.id_empleado
    AND e.codigo_oficina = o.codigo_oficina;
    ```

5. **Nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
    FROM cliente c, empleado e, oficina o
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado
    AND e.codigo_oficina = o.codigo_oficina
    AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);
    ```

6. **Dirección de las oficinas que tengan clientes en Fuenlabrada:**
    ```sql
    SELECT DISTINCT o.direccion
    FROM oficina o, cliente c
    WHERE c.codigo_oficina = o.codigo_oficina
    AND c.ciudad = 'Fuenlabrada';
    ```

7. **Nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
    FROM cliente c, empleado e, oficina o
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado
    AND e.codigo_oficina = o.codigo_oficina;
    ```

8. **Listado con el nombre de los empleados junto con el nombre de sus jefes:**
    ```sql
    SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre
    FROM empleado e1, empleado e2
    WHERE e1.id_jefe = e2.id_empleado;
    ```

9. **Listado que muestre el nombre de cada empleado, el nombre de su jefe y el nombre del jefe de su jefe:**
    ```sql
    SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre, e3.nombre AS jefe_de_jefe_nombre
    FROM empleado e1
    JOIN empleado e2 ON e1.id_jefe = e2.id_empleado
    JOIN empleado e3 ON e2.id_jefe = e3.id_empleado;
    ```

10. **Nombre de los clientes a los que no se les ha entregado a tiempo un pedido:**
    ```sql
    SELECT DISTINCT c.nombre_cliente
    FROM cliente c, pedido p
    WHERE c.id_cliente = p.id_cliente
    AND p.fecha_entrega > p.fecha_estimada_entrega;
    ```

11. **Listado de las diferentes gamas de producto que ha comprado cada cliente:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, gp.nombre_gama
    FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto gp
    WHERE c.id_cliente = p.id_cliente
    AND p.numero_pedido = dp.numero_pedido
    AND dp.codigo_producto = pr.codigo_producto
    AND pr.codigo_gama = gp.codigo_gama;
    ```

## Consultas Multitabla (Composición Externa)

1. **Listado de clientes que no han realizado ningún pago:**
    ```sql
    SELECT c.*
    FROM cliente c
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
    WHERE t.cod_cliente IS NULL;
    ```

2. **Listado de clientes que no han realizado ningún pedido:**
    ```sql
    SELECT c.*
    FROM cliente c
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
    WHERE t.cod_cliente IS NULL;
    ```

3. **Listado de clientes que no han realizado ningún pago ni pedido:**
    ```sql
    SELECT c.*
    FROM cliente c
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
    WHERE t.cod_cliente IS NULL AND p.codigo_pedido IS NULL;
    ```

4. **Listado de empleados que no tienen una oficina asociada:**
    ```sql
    SELECT e.*
    FROM empleado e
    LEFT JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
    WHERE e.codigo_oficina_empleado IS NULL;
    ```

5. **Listado de empleados que no tienen un cliente asociado:**
    ```sql
    SELECT e.*
    FROM empleado e
    LEFT JOIN cliente c ON e.id_empleado = c.codigo_empleado_rep_ventas
    WHERE c.codigo_empleado_rep_ventas IS NULL;
    ```

6. **Listado de empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan:**
    ```sql
    SELECT e.nombre, e.apellido1, o.*
    FROM empleado e 
    LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.id_empleado 
    LEFT JOIN oficina o ON o.codigo_oficina = e.id_empleado 
    WHERE c.codigo_empleado_rep_ventas IS NULL;
    ```

7. **Listado de empleados que no tienen una oficina asociada y no tienen un cliente asociado:**
    ```sql
    SELECT e.nombre, e.apellido1 
    FROM empleado e 
    LEFT JOIN oficina o ON o.codigo_oficina = e.codigo_oficina_empleado 
    LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.id_empleado
    WHERE e.codigo_oficina_empleado IS NULL AND c.codigo_empleado_rep_ventas IS NULL;
    ```

8. **Listado de productos que nunca han aparecido en un pedido:**
    ```sql
    SELECT *
    FROM producto
    WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto_pedido FROM detalle_pedido);
    ```

9. **Listado de productos que nunca han aparecido en un pedido con nombre, descripción y imagen:**
    ```sql
    SELECT p.nombre, p.descripcion, g.imagen
    FROM producto p join gama_producto g on p.gama_producto = g.id_gama
    WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto_pedido FROM detalle_pedido);
    ```

10. **Oficinas donde no trabajan empleados que hayan sido representantes de ventas para clientes que hayan comprado productos de la gama Frutales:**
    ```sql
    SELECT *
    FROM oficina o
    WHERE codigo_oficina NOT IN (
        SELECT DISTINCT codigo_oficina_empleado
        FROM empleado
        WHERE id_empleado IN (
            SELECT DISTINCT codigo_empleado_rep_ventas
            FROM cliente
            JOIN transaccion ON cliente.id_cliente = transaccion.cod_cliente
            JOIN detalle_pedido ON transaccion.id_transaccion = detalle_pedido.codigo_pedido_detalle
            JOIN producto ON detalle_pedido.codigo_producto_pedido = producto.codigo_producto
            WHERE producto.gama_producto = 'Frutales'
        )
    );
    ```

11. **Listado de clientes que han realizado pedidos pero no han realizado pagos:**
    ```sql
    SELECT c.nombre_cliente
    FROM cliente c 
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    WHERE tipo_pago IS NULL;
    ```

12. **Listado de empleados sin clientes asociados y nombre de su jefe asociado:**
    ```sql
    SELECT e.*, jefe.nombre AS nombre_jefe, jefe.apellido1 AS apellido1_jefe
    FROM empleado e
    LEFT JOIN empleado jefe ON e.codigo_jefe = jefe.id_empleado
    LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.id_empleado
    WHERE c.codigo_empleado_rep_ventas IS NULL;
    ```

## Consultas Resumen

1. **Número total de empleados en la compañía:**
    ```sql
    SELECT COUNT(*) AS total_empleados FROM empleado;
    ```

2. **Número de clientes por país:**
    ```sql
    SELECT pais, COUNT(*) AS total_clientes 
    FROM cliente 
    GROUP BY pais;
    ```

3. **Pago promedio en 2009:**
    ```sql
    SELECT AVG(total_transaccion) AS pago_medio 
    FROM transaccion 
    WHERE YEAR(fecha_transaccion) = 2009;
    ```

4. **Número de pedidos por estado en orden descendente:**
    ```sql
    SELECT estado_pedido, COUNT(*) AS total_pedidos 
    FROM pedido 
    GROUP BY estado_pedido 
    ORDER BY total_pedidos DESC;
    ```

5. **Precio de venta del producto más caro y más barato:**
    ```sql
    SELECT 
      MAX(precio_venta) AS precio_mas_caro,
      MIN(precio_venta) AS precio_mas_barato 
    FROM producto;
    ```

6. **Número total de clientes en la empresa:**
    ```sql
    SELECT COUNT(*) AS total_clientes FROM cliente;
    ```

7. **Número de clientes en Madrid:**
    ```sql
    SELECT COUNT(*) AS total_clientes_madrid 
    FROM cliente 
    WHERE ciudad = 'Madrid';
    ```

8. **Número de clientes por ciudad que comienza con M:**
    ```sql
    SELECT ciudad, COUNT(*) AS total_clientes 
    FROM cliente 
    WHERE ciudad LIKE 'M%' 
    GROUP BY ciudad;
    ```

9. **Representantes de ventas y número de clientes que atienden:**
    ```sql
    SELECT e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, COUNT(c.id_cliente) AS total_clientes 
    FROM cliente c 
    JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado 
    GROUP BY e.id_empleado, e.nombre, e.apellido1;
    ```

10. **Número de clientes sin representante de ventas:**
    ```sql
    SELECT COUNT(*) AS clientes_sin_representante 
    FROM cliente 
    WHERE codigo_empleado_rep_ventas IS NULL;
    ```

11. **Fecha del primer y último pago por cliente:**
    ```sql
    SELECT 
      c.nombre_cliente, 
      c.apellido1_cliente, 
      c.apellido2_cliente, 
      MIN(t.fecha_transaccion) AS primer_pago, 
      MAX(t.fecha_transaccion) AS ultimo_pago 
    FROM cliente c 
    JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    GROUP BY c.id_cliente, c.nombre_cliente, c.apellido1_cliente, c.apellido2_cliente;
    ```

12. **Número de productos diferentes en cada pedido:**
    ```sql
    SELECT 
      codigo_pedido_detalle, 
      COUNT(DISTINCT codigo_producto_pedido) AS productos_diferentes 
    FROM detalle_pedido 
    GROUP BY codigo_pedido_detalle;
    ```

13. **Suma de la cantidad total de productos en cada pedido:**
    ```sql
    SELECT 
      codigo_pedido_detalle, 
      SUM(cantidad) AS cantidad_total_productos 
    FROM detalle_pedido 
    GROUP BY codigo_pedido_detalle;
    ```

14. **Top 20 productos más vendidos y número total de unidades vendidas:**
    ```sql
    SELECT 
      p.nombre, 
      SUM(dp.cantidad) AS total_unidades_vendidas 
    FROM detalle_pedido dp 
    JOIN producto p ON dp.codigo_producto_pedido = p.codigo_producto 
    GROUP BY p.codigo_producto 
    ORDER BY total_unidades_vendidas DESC 
    LIMIT 20;
    ```

15. **Facturación total de la empresa (base imponible, IVA y total facturado):**
    ```sql
    SELECT 
        SUM(dp.cantidad * p.precio_venta) AS base_imponible,
        SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
        SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado
    FROM 
        detalle_pedido dp
    JOIN 
        producto p ON dp.codigo_producto_pedido = p.codigo_producto;
    ```

16. **Facturación total de la empresa agrupada por código de producto:**
    ```sql
    SELECT 
        dp.codigo_producto_pedido,
        SUM(dp.cantidad * p.precio_venta) AS base_imponible,
        SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
        SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado
    FROM 
        detalle_pedido dp
    JOIN 
        producto p ON dp.codigo_producto_pedido = p.codigo_producto
    GROUP BY 
        dp.codigo_producto_pedido;
    ```

17. **Facturación total de la empresa por código de producto filtrada por códigos que empiecen por "OR":**
    ```sql
    SELECT 
        dp.codigo_producto_pedido,
        SUM(dp.cantidad * p.precio_venta) AS base_imponible,
        SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
        SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado
    FROM 
        detalle_pedido dp
    JOIN 
        producto p ON dp.codigo_producto_pedido = p.codigo_producto
    WHERE 
        dp.codigo_producto_pedido LIKE 'OR%'
    GROUP BY 
        dp.codigo_producto_pedido;
    ```

18. **Ventas totales de productos facturados más de 3000 euros:**
    ```sql
    SELECT 
        p.nombre,
        SUM(dp.cantidad) AS unidades_vendidas,
        SUM(dp.cantidad * p.precio_venta) AS total_facturado,
        SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado_con_iva
    FROM 
        detalle_pedido dp
    JOIN 
        producto p ON dp.codigo_producto_pedido = p.codigo_producto
    GROUP BY 
        p.codigo_producto, p.nombre
    HAVING 
        total_facturado > 3000;
    ```

19. **Suma total de todos los pagos por año:**
    ```sql
    SELECT 
        YEAR(fecha_pedido) AS ano,
        SUM(cantidad * precio_unidad) AS total_pago_anual
    FROM 
        pedido p
    JOIN 
        detalle_pedido dp ON dp.codigo_pedido_detalle = p.codigo_pedido
    GROUP BY 
        YEAR(fecha_pedido);
    ```

## Subconsultas

1. **Nombre del cliente con mayor límite de crédito:**
    ```sql
    SELECT nombre_cliente
    FROM cliente
    WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);
    ```

2. **Nombre del producto con precio de venta más caro:**
    ```sql
    SELECT nombre
    FROM producto
    WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);
    ```

3. **Nombre del producto más vendido por unidades:**
    ```sql
    SELECT p.nombre
    FROM producto p
    JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto_pedido
    GROUP BY p.nombre
    ORDER BY SUM(dp.cantidad) DESC
    LIMIT 1;
    ```

4. **Clientes cuyo límite de crédito es mayor que los pagos realizados:**
    ```sql
    SELECT c.nombre_cliente
    FROM cliente c
    WHERE limite_credito > (SELECT SUM(dp.cantidad * dp.precio_unidad) FROM pedido p  
    JOIN detalle_pedido dp on dp.codigo_pedido_detalle = p.codigo_pedido 
    WHERE p.codigo_cliente_pedido = c.id_cliente );
    ```

5. **Producto con más unidades en stock:**
    ```sql
    SELECT nombre
    FROM producto
    WHERE cantidad_stock = (SELECT MAX(cantidad_stock) FROM producto);
    ```

6. **Producto con menos unidades en stock:**
    ```sql
    SELECT nombre
    FROM producto
    WHERE cantidad_stock = (SELECT MIN(cantidad_stock) FROM producto);
    ```

7. **Nombre, apellidos y email de los empleados a cargo de Alberto Soria:**
    ```sql
    SELECT nombre, apellido1, apellido2, email
    FROM empleado
    WHERE codigo_jefe = (SELECT id_empleado FROM empleado WHERE nombre = 'Alberto' AND apellido1 = 'Soria');
    ```

## Consultas variadas

1. **Listado de clientes con cantidad de pedidos realizados:**
    ```sql
    SELECT c.nombre_cliente AS nombre_cliente, 
           COUNT(dp.codigo_pedido_detalle) AS numero_pedidos
    FROM cliente c
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
    LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido_detalle
    GROUP BY c.nombre_cliente;
    ```

2. **Listado de clientes con total pagado por cada uno:**
    ```sql
    SELECT c.nombre_cliente, 
           COALESCE(SUM(dp.precio_unidad * dp.cantidad), 0) AS total_pagado
    FROM cliente c
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido_detalle 
    GROUP BY c.nombre_cliente;
    ```

3. **Clientes que hicieron pedidos en 2008, ordenados alfabéticamente:**
    ```sql
    SELECT DISTINCT c.nombre_cliente
    FROM cliente c
    JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
    WHERE YEAR(p.fecha_pedido) = 2008
    ORDER BY c.nombre_cliente;
    ```

4. **Nombre de cliente, representante de ventas y teléfono de la oficina:**
    ```sql
    SELECT c.nombre_cliente, 
           e.nombre AS nombre_representante, 
           e.apellido1 AS apellido_representante, 
           o.telefono AS telefono_oficina
    FROM cliente c
    JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado
    JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
    WHERE NOT EXISTS (SELECT 1 FROM pedido p WHERE c.id_cliente = p.codigo_cliente_pedido);
    ```

5. **Listado de clientes con nombre del representante de ventas y ciudad de la oficina:**
    ```sql
    SELECT c.nombre_cliente AS nombre_cliente, 
           e.nombre AS nombre_representante, 
           e.apellido1 AS apellido_representante, 
           o.ciudad AS ciudad_oficina
    FROM cliente c
    JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado
    JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina;
    ```

6. **Empleados de oficinas que no son representantes de ventas:**
    ```sql
    SELECT e.nombre, 
           e.apellido1, 
           e.apellido2, 
           e.puesto, 
           o.telefono
    FROM empleado e
    JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
    WHERE e.id_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);
    ```

7. **Ciudades con número de empleados en las oficinas:**
    ```sql
    SELECT o.ciudad, 
           COUNT(e.id_empleado) AS numero_empleados
    FROM oficina o
    JOIN empleado e ON o.codigo_oficina = e.codigo_oficina_empleado
    GROUP BY o.ciudad;
    ```
