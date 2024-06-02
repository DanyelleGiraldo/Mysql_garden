# Consultas BD Jardineria

# Consultas SQL sobre una Base de Datos Empresarial

Este archivo contiene una serie de consultas SQL diseñadas para interactuar con una base de datos empresarial. Las consultas están organizadas en diferentes categorías para facilitar su comprensión y uso.

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

1. **Nombre de cada cliente y su representante de ventas:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1 
    FROM cliente c, empleado e 
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado;
    ```

2. **Clientes que hayan realizado pagos y sus representantes de ventas:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1 
    FROM cliente c, empleado e, pago p 
    WHERE c.id_cliente = p.id_cliente AND c.codigo_empleado_rep_ventas = e.id_empleado;
    ```

3. **Clientes que no hayan realizado pagos y sus representantes de ventas:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1 
    FROM cliente c, empleado e 
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);
    ```

4. **Clientes que han hecho pagos, sus representantes y la ciudad de la oficina del representante:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
    FROM cliente c, empleado e, pago p, oficina o 
    WHERE c.id_cliente = p.id_cliente AND c.codigo_empleado_rep_ventas = e.id_empleado AND e.codigo_oficina = o.codigo_oficina;
    ```

5. **Clientes que no han hecho pagos, sus representantes y la ciudad de la oficina del representante:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
    FROM cliente c, empleado e, oficina o 
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado AND e.codigo_oficina = o.codigo_oficina AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);
    ```

6. **Dirección de oficinas con clientes en Fuenlabrada:**
    ```sql
    SELECT DISTINCT o.direccion 
    FROM oficina o, cliente c 
    WHERE c.codigo_oficina = o.codigo_oficina AND c.ciudad = 'Fuenlabrada';
    ```

7. **Clientes, sus representantes y la ciudad de la oficina del representante:**
    ```sql
    SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
    FROM cliente c, empleado e, oficina o 
    WHERE c.codigo_empleado_rep_ventas = e.id_empleado AND e.codigo_oficina = o.codigo_oficina;
    ```

8. **Empleados y sus jefes:**
    ```sql
    SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre 
    FROM empleado e1, empleado e2 
    WHERE e1.id_jefe = e2.id_empleado;
    ```

9. **Empleados, sus jefes y los jefes de sus jefes:**
    ```sql
    SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre, e3.nombre AS jefe_de_jefe_nombre 
    FROM empleado e1 
    JOIN empleado e2 ON e1.id_jefe = e2.id_empleado 
    JOIN empleado e3 ON e2.id_jefe = e3.id_empleado;
    ```

10. **Clientes que no recibieron pedidos a tiempo:**
    ```sql
    SELECT DISTINCT c.nombre_cliente 
    FROM cliente c, pedido p 
    WHERE c.id_cliente = p.id_cliente AND p.fecha_entrega > p.fecha_estimada_entrega;
    ```

11. **Gamas de producto compradas por cada cliente:**
    ```sql
    SELECT DISTINCT c.nombre_cliente, gp.nombre_gama 
    FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto gp 
    WHERE c.id_cliente = p.id_cliente AND p.numero_pedido = dp.numero_pedido AND dp.codigo_producto = pr.codigo_producto AND pr.codigo_gama = gp.codigo_gama;
    ```

## Consultas Multitabla (Composición Externa)

1. **Clientes que no han realizado ningún pago:**
    ```sql
    SELECT c.* 
    FROM cliente c 
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    WHERE t.cod_cliente IS NULL;
    ```

2. **Clientes que no han realizado ningún pedido:**
    ```sql
    SELECT c.* 
    FROM cliente c 
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    WHERE t.cod_cliente IS NULL;
    ```

3. **Clientes que no han realizado ningún pago ni pedido:**
    ```sql
    SELECT c.* 
    FROM cliente c 
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    WHERE t.cod_cliente IS NULL AND p.codigo_cliente_pedido IS NULL;
    ```

4. **Clientes que no han realizado ningún pago ni pedido, y su representante de ventas:**
    ```sql
    SELECT c.*, e.nombre 
    FROM cliente c 
    LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    LEFT JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado 
    WHERE t.cod_cliente IS NULL AND p.codigo_cliente_pedido IS NULL;
    ```

## Consultas con Agrupamiento y Agregación

1. **Cantidad de oficinas por ciudad:**
    ```sql
    SELECT ciudad, COUNT(*) AS cantidad_oficinas 
    FROM oficina 
    GROUP BY ciudad;
    ```

2. **Clientes por país:**
    ```sql
    SELECT pais, COUNT(*) AS cantidad_clientes 
    FROM cliente 
    GROUP BY pais;
    ```

3. **Pedidos por estado:**
    ```sql
    SELECT estado_pedido, COUNT(*) AS cantidad_pedidos 
    FROM pedido 
    GROUP BY estado_pedido;
    ```

4. **Pedidos por país de cliente:**
    ```sql
    SELECT c.pais, COUNT(p.codigo_pedido) AS cantidad_pedidos 
    FROM pedido p 
    JOIN cliente c ON p.codigo_cliente_pedido = c.id_cliente 
    GROUP BY c.pais;
    ```

5. **Total pagado por cliente en 2008:**
    ```sql
    SELECT t.cod_cliente, SUM(t.importe) AS total_pagado 
    FROM transaccion t 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY t.cod_cliente;
    ```

6. **Total pagado por cliente en 2008 ordenado por total pagado:**
    ```sql
    SELECT t.cod_cliente, SUM(t.importe) AS total_pagado 
    FROM transaccion t 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY t.cod_cliente 
    ORDER BY total_pagado DESC;
    ```

7. **Ingresos mensuales de la empresa en 2008:**
    ```sql
    SELECT MONTH(t.fecha_transaccion) AS mes, SUM(t.importe) AS ingresos_mensuales 
    FROM transaccion t 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY mes 
    ORDER BY mes;
    ```

8. **Ingresos mensuales de la empresa por país en 2008:**
    ```sql
    SELECT c.pais, MONTH(t.fecha_transaccion) AS mes, SUM(t.importe) AS ingresos_mensuales 
    FROM transaccion t 
    JOIN cliente c ON t.cod_cliente = c.id_cliente 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY c.pais, mes 
    ORDER BY c.pais, mes;
    ```

9. **Pedidos no entregados a tiempo por país de cliente:**
    ```sql
    SELECT c.pais, COUNT(p.codigo_pedido) AS cantidad_pedidos_no_a_tiempo 
    FROM pedido p 
    JOIN cliente c ON p.codigo_cliente_pedido = c.id_cliente 
    WHERE p.fecha_entrega > p.fecha_esperada 
    GROUP BY c.pais;
    ```

10. **Cantidad de productos comprados por cliente:**
    ```sql
    SELECT c.nombre_cliente, COUNT(dp.codigo_producto) AS cantidad_productos 
    FROM cliente c 
    JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.numero_pedido 
    GROUP BY c.nombre_cliente;
    ```

11. **Cantidad de productos comprados por cliente ordenado por cantidad:**
    ```sql
    SELECT c.nombre_cliente, COUNT(dp.codigo_producto) AS cantidad_productos 
    FROM cliente c 
    JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.numero_pedido 
    GROUP BY c.nombre_cliente 
    ORDER BY cantidad_productos DESC;
    ```

12. **Total de ingresos por cliente:**
    ```sql
    SELECT c.nombre_cliente, SUM(t.importe) AS total_ingresos 
    FROM cliente c 
    JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    GROUP BY c.nombre_cliente;
    ```

13. **Clientes con más de 5 productos comprados:**
    ```sql
    SELECT c.nombre_cliente, COUNT(dp.codigo_producto) AS cantidad_productos 
    FROM cliente c 
    JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido 
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.numero_pedido 
    GROUP BY c.nombre_cliente 
    HAVING cantidad_productos > 5;
    ```

14. **Clientes con más de 1000 euros en pagos realizados en 2008:**
    ```sql
    SELECT t.cod_cliente, SUM(t.importe) AS total_pagado 
    FROM transaccion t 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY t.cod_cliente 
    HAVING total_pagado > 1000;
    ```

15. **Empleados con al menos 5 clientes representados:**
    ```sql
    SELECT e.nombre, COUNT(c.id_cliente) AS cantidad_clientes 
    FROM empleado e 
    JOIN cliente c ON e.id_empleado = c.codigo_empleado_rep_ventas 
    GROUP BY e.nombre 
    HAVING cantidad_clientes >= 5;
    ```

16. **Empleados con al menos 1000 euros en pagos realizados por sus clientes en 2008:**
    ```sql
    SELECT e.nombre, SUM(t.importe) AS total_pagado 
    FROM empleado e 
    JOIN cliente c ON e.id_empleado = c.codigo_empleado_rep_ventas 
    JOIN transaccion t ON c.id_cliente = t.cod_cliente 
    WHERE YEAR(t.fecha_transaccion) = 2008 
    GROUP BY e.nombre 
    HAVING total_pagado > 1000;
    ```
