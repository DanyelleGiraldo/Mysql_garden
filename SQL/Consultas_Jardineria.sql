-- Consultas sobre una tabla

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

select codigo_oficina, ciudad as ciudad_oficina from oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

select ciudad as ciudad_oficina , telefono as telefono_oficina from oficina where pais= "España";

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo
-- jefe tiene un código de jefe igual a 7.

select nombre as nombre_empleado, apellido1 as apellido_1_empleado, apellido2 as apellido2_empleado, email from empleado where codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la
-- empresa.

select puesto, nombre, apellido1 as apellido_1_empleado, apellido2 as apellido_2_empleado, email from empleado where codigo_jefe is null;

 -- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos
-- empleados que no sean representantes de ventas.

SELECT nombre AS nombre_empleado, apellido1 AS primer_apellido, apellido2 AS segundo_apellido, puesto 
FROM empleado 
WHERE puesto <> 'representante de ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente from cliente where pais = "España";

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un
-- pedido.

select distinct estado_pedido from pedido;

/* 8. Devuelve un listado con el código de cliente de aquellos clientes que
realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
• Utilizando la función YEAR de MySQL.
• Utilizando la función DATE_FORMAT de MySQL.
• Sin utilizar ninguna de las funciones anteriores */

SELECT DISTINCT cod_cliente
FROM transaccion
WHERE YEAR(fecha_transaccion) = 2008;

SELECT DISTINCT cod_cliente
FROM transaccion
WHERE DATE_FORMAT(fecha_transaccion, '%Y') = '2008';

SELECT DISTINCT cod_cliente
FROM transaccion
WHERE fecha_transaccion >= '2008-01-01'
AND fecha_transaccion < '2009-01-01';

/* 9. Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos que no han sido entregados a
tiempo*/

SELECT codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega 
FROM pedido 
WHERE fecha_entrega > fecha_esperada AND estado_pedido != 'Entregado';

/*
10. Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al
menos dos días antes de la fecha esperada.
*/

SELECT codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega 
FROM pedido 
WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2; 

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

SELECT codigo_pedido, fecha_pedido, estado_pedido
FROM pedido
WHERE estado_pedido = 'Rechazado' AND YEAR(fecha_pedido) = 2009;

/*
12. Devuelve un listado de todos los pedidos que han sido entregados en el
mes de enero de cualquier año.
*/

select codigo_pedido from pedido where month(fecha_entrega) = 1;

/*
13. Devuelve un listado con todos los pagos que se realizaron en el
año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
*/

select codigo_pedido, f.nombre_forma_pago as forma_pago, fecha_pedido 
from pedido p 
join forma_pago f 
on f.id_forma_pago = p.tipo_pago 
where f.nombre_forma_pago = "Paypal" 
and year(fecha_pedido) = 2008 order by date(fecha_pedido) asc;

/* 14. Devuelve un listado con todas las formas de pago que aparecen en la
tabla pago. Tenga en cuenta que no deben aparecer formas de pago
repetidas.*/

SELECT DISTINCT nombre_forma_pago
FROM forma_pago;


/*
15. Devuelve un listado con todos los productos que pertenecen a la
gama Ornamentales y que tienen más de 100 unidades en stock. El listado
deberá estar ordenado por su precio de venta, mostrando en primer lugar
los de mayor precio.
*/
SELECT *
FROM producto
WHERE gama_producto = 'Ornamentales' AND cantidad_stock > 100
ORDER BY precio_venta DESC;


-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y
-- cuyo representante de ventas tenga el código de empleado 11 o 30.

SELECT *
FROM cliente
WHERE ciudad = 'Madrid' AND codigo_empleado_rep_ventas IN (11, 30);


-- Consultas multitabla (Composición interna)
-- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c, empleado e
WHERE c.codigo_empleado_rep_ventas = e.id_empleado;

-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c, empleado e, pago p
WHERE c.id_cliente = p.id_cliente
AND c.codigo_empleado_rep_ventas = e.id_empleado;

-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.

SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente c, empleado e
WHERE c.codigo_empleado_rep_ventas = e.id_empleado
AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);

-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c, empleado e, pago p, oficina o
WHERE c.id_cliente = p.id_cliente
AND c.codigo_empleado_rep_ventas = e.id_empleado
AND e.codigo_oficina = o.codigo_oficina;

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c, empleado e, oficina o
WHERE c.codigo_empleado_rep_ventas = e.id_empleado
AND e.codigo_oficina = o.codigo_oficina
AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

SELECT DISTINCT o.direccion
FROM oficina o, cliente c
WHERE c.codigo_oficina = o.codigo_oficina
AND c.ciudad = 'Fuenlabrada';

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente c, empleado e, oficina o
WHERE c.codigo_empleado_rep_ventas = e.id_empleado
AND e.codigo_oficina = o.codigo_oficina;

-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.

SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre
FROM empleado e1, empleado e2
WHERE e1.id_jefe = e2.id_empleado;

-- 9. Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.

SELECT e1.nombre AS empleado_nombre, e2.nombre AS jefe_nombre, e3.nombre AS jefe_de_jefe_nombre
FROM empleado e1
JOIN empleado e2 ON e1.id_jefe = e2.id_empleado
JOIN empleado e3 ON e2.id_jefe = e3.id_empleado;

-- 10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.

SELECT DISTINCT c.nombre_cliente
FROM cliente c, pedido p
WHERE c.id_cliente = p.id_cliente
AND p.fecha_entrega > p.fecha_estimada_entrega;

-- 11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.

SELECT DISTINCT c.nombre_cliente, gp.nombre_gama
FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto gp
WHERE c.id_cliente = p.id_cliente
AND p.numero_pedido = dp.numero_pedido
AND dp.codigo_producto = pr.codigo_producto
AND pr.codigo_gama = gp.codigo_gama;

-- Consultas multitabla (Composición externa)

-- 1. Devuelve un listado que muestre solamente los clientes que no han
-- realizado ningún pago.
SELECT c.*
FROM cliente c
LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
WHERE t.cod_cliente IS NULL;

-- 2. Devuelve un listado que muestre solamente los clientes que no han
-- realizado ningún pedido.
SELECT c.*
FROM cliente c
LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
WHERE t.cod_cliente IS NULL;

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún
-- pago y los que no han realizado ningún pedido.

SELECT c.*
FROM cliente c
LEFT JOIN transaccion t ON c.id_cliente = t.cod_cliente
LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
WHERE t.cod_cliente IS NULL AND p.codigo_pedido IS NULL;


-- 4. Devuelve un listado que muestre solamente los empleados que no tienen
-- una oficina asociada.

SELECT e.*
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
WHERE e.codigo_oficina_empleado IS NULL;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un
-- cliente asociado.

SELECT e.*
FROM empleado e
LEFT JOIN cliente c ON e.id_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_empleado_rep_ventas IS NULL;

/*6. Devuelve un listado que muestre solamente los empleados que no tienen un
cliente asociado junto con los datos de la oficina donde trabajan.*/

select e.nombre, e.apellido1, o.*
from empleado e 
left join cliente c on c.codigo_empleado_rep_ventas = e.id_empleado 
left join oficina o on o.codigo_oficina = e.id_empleado 
where c.codigo_empleado_rep_ventas is null ;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina
-- asociada y los que no tienen un cliente asociado.

SELECT e.nombre, e.apellido1 
FROM empleado e 
LEFT JOIN oficina o ON o.codigo_oficina = e.codigo_oficina_empleado 
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.id_empleado
WHERE e.codigo_oficina_empleado IS NULL AND c.codigo_empleado_rep_ventas IS NULL;


-- 8. Devuelve un listado de los productos que nunca han aparecido en un
-- pedido.

SELECT *
FROM producto
WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto_pedido FROM detalle_pedido);


-- 9. Devuelve un listado de los productos que nunca han aparecido en un
-- pedido. El resultado debe mostrar el nombre, la descripción y la imagen del
-- producto.

SELECT p.nombre, p.descripcion, g.imagen
FROM producto p join gama_producto g on p.gama_producto = g.id_gama
WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto_pedido FROM detalle_pedido);


-- 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que
-- hayan sido los representantes de ventas de algún cliente que haya realizado
-- la compra de algún producto de la gama Frutales.

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


-- 11. Devuelve un listado con los clientes que han realizado algún pedido pero no
-- han realizado ningún pago.

select c.nombre_cliente from cliente c 
left join pedido p on c.id_cliente = p.codigo_cliente_pedido 
where tipo_pago is null;

-- 12. Devuelve un listado con los datos de los empleados que no tienen clientes
-- asociados y el nombre de su jefe asociado.

SELECT e.*, jefe.nombre AS nombre_jefe, jefe.apellido1 AS apellido1_jefe
FROM empleado e
LEFT JOIN empleado jefe ON e.codigo_jefe = jefe.id_empleado
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.id_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;


-- Consultas resumen

-- 1. ¿Cuántos empleados hay en la compañía?

SELECT COUNT(*) AS total_empleados FROM empleado;

-- 2. ¿Cuántos clientes tiene cada país?

SELECT pais, COUNT(*) AS total_clientes 
FROM cliente 
GROUP BY pais;

-- 3. ¿Cuál fue el pago medio en 2009?

SELECT AVG(total_transaccion) AS pago_medio 
FROM transaccion 					
WHERE YEAR(fecha_transaccion) = 2009;


-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

SELECT estado_pedido, COUNT(*) AS total_pedidos 
FROM pedido 
GROUP BY estado_pedido 
ORDER BY total_pedidos DESC;

-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.

SELECT 
  MAX(precio_venta) AS precio_mas_caro,
  MIN(precio_venta) AS precio_mas_barato 
FROM producto;

-- 6. Calcula el número de clientes que tiene la empresa.

SELECT COUNT(*) AS total_clientes FROM cliente;

-- 7. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

SELECT COUNT(*) AS total_clientes_madrid 
FROM cliente 
WHERE ciudad = 'Madrid';

-- 8. ¿Cuántos clientes tiene cada una de las ciudades que empiezan por M?

SELECT ciudad, COUNT(*) AS total_clientes 
FROM cliente 
WHERE ciudad LIKE 'M%' 
GROUP BY ciudad;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

SELECT e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, COUNT(c.id_cliente) AS total_clientes 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado 
GROUP BY e.id_empleado, e.nombre, e.apellido1;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.

SELECT COUNT(*) AS clientes_sin_representante 
FROM cliente 
WHERE codigo_empleado_rep_ventas IS NULL;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

SELECT 
  c.nombre_cliente, 
  c.apellido1_cliente, 
  c.apellido2_cliente, 
  MIN(t.fecha_transaccion) AS primer_pago, 
  MAX(t.fecha_transaccion) AS ultimo_pago 
FROM cliente c 
JOIN transaccion t ON c.id_cliente = t.cod_cliente 
GROUP BY c.id_cliente, c.nombre_cliente, c.apellido1_cliente, c.apellido2_cliente;

-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.

SELECT 
  codigo_pedido_detalle, 
  COUNT(DISTINCT codigo_producto_pedido) AS productos_diferentes 
FROM detalle_pedido 
GROUP BY codigo_pedido_detalle;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

SELECT 
  codigo_pedido_detalle, 
  SUM(cantidad) AS cantidad_total_productos 
FROM detalle_pedido 
GROUP BY codigo_pedido_detalle;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido.

SELECT 
  p.nombre, 
  SUM(dp.cantidad) AS total_unidades_vendidas 
FROM detalle_pedido dp 
JOIN producto p ON dp.codigo_producto_pedido = p.codigo_producto 
GROUP BY p.codigo_producto 
ORDER BY total_unidades_vendidas DESC 
LIMIT 20;

-- 15. Facturación total de la empresa (base imponible, IVA y total facturado)

SELECT 
    SUM(dp.cantidad * p.precio_venta) AS base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
    SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado
FROM 
    detalle_pedido dp
JOIN 
    producto p ON dp.codigo_producto_pedido = p.codigo_producto;


-- 16. Facturación total de la empresa agrupada por código de producto

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

-- 17. Facturación total de la empresa agrupada por código de producto, filtrada por códigos que empiecen por "OR"

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

-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 
-- euros. Se mostrará el nombre, unidades vendidas, total facturado y total 
-- facturado con impuestos (21% IVA).

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

-- 19. Muestre la suma total de todos los pagos que se realizaron para cada uno 
-- de los años que aparecen en la tabla pagos.

SELECT 
    YEAR(fecha_pedido) AS ano,
    SUM(cantidad * precio_unidad) AS total_pago_anual
FROM 
    pedido p
join 
    detalle_pedido dp on dp.codigo_pedido_detalle = p.codigo_pedido
GROUP BY 
    YEAR(fecha_pedido);

-- Subconsultas

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.

SELECT nombre_cliente
FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);

-- 2.  Devuelve el nombre del producto que tenga el precio de venta más caro.


SELECT nombre
FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

-- 3. Devuelve el nombre del producto del que se han vendido más unidades. 
-- (Tenga en cuenta que tendrá que calcular cuál es el número total de 
-- unidades que se han vendido de cada producto a partir de los datos de la 
-- tabla detalle_pedido)

SELECT p.nombre
FROM producto p
JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto_pedido
GROUP BY p.nombre
ORDER BY SUM(dp.cantidad) DESC
LIMIT 1;

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya 
-- realizado. (Sin utilizar INNER JOIN).

SELECT c.nombre_cliente
FROM cliente c
WHERE limite_credito > (SELECT SUM(dp.cantidad * dp.precio_unidad) FROM pedido p  
JOIN detalle_pedido dp on dp.codigo_pedido_detalle = p.codigo_pedido 
WHERE p.codigo_cliente_pedido = c.id_cliente );

-- 5. Devuelve el producto que más unidades tiene en stock

SELECT nombre
FROM producto
WHERE cantidad_stock = (SELECT MAX(cantidad_stock) FROM producto);

-- 6. Devuelve el producto que menos unidades tiene en stock.

SELECT nombre
FROM producto
WHERE cantidad_stock = (SELECT MIN(cantidad_stock) FROM producto);

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a 
-- cargo de Alberto Soria.
 
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = (SELECT id_empleado FROM empleado WHERE nombre = 'Alberto' AND apellido1 = 'Soria');

-- Consultas variadas
-- 1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos 
-- pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no 
-- han realizado ningún pedido.

SELECT c.nombre_cliente AS nombre_cliente, 
       COUNT(dp.codigo_pedido_detalle) AS numero_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido_detalle
GROUP BY c.nombre_cliente;

-- 2. Devuelve un listado con los nombres de los clientes y el total pagado por 
-- cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han 
-- realizado ningún pago.

SELECT c.nombre_cliente, 
       COALESCE(SUM(dp.precio_unidad * dp.cantidad), 0) AS total_pagado
FROM cliente c
LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
join detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido_detalle 
GROUP BY c.nombre_cliente;

-- 3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 
-- ordenados alfabéticamente de menor a mayor.

SELECT DISTINCT c.nombre_cliente
FROM cliente c
JOIN pedido p ON c.id_cliente = p.codigo_cliente_pedido
WHERE YEAR(p.fecha_pedido) = 2008
ORDER BY c.nombre_cliente;

-- 4. Devuelve el nombre del cliente, el nombre y primer apellido de su 
-- representante de ventas y el número de teléfono de la oficina del 
-- representante de ventas, de aquellos clientes que no hayan realizado ningún 
-- pago.

SELECT c.nombre_cliente, 
       e.nombre AS nombre_representante, 
       e.apellido1 AS apellido_representante, 
       o.telefono AS telefono_oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado
JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
WHERE NOT EXISTS (SELECT 1 FROM pedido p WHERE c.id_cliente = p.codigo_cliente_pedido);

-- 5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el 
-- nombre y primer apellido de su representante de ventas y la ciudad donde 
-- está su oficina.

SELECT c.nombre_cliente AS nombre_cliente, 
       e.nombre AS nombre_representante, 
       e.apellido1 AS apellido_representante, 
       o.ciudad AS ciudad_oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.id_empleado
JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina;

-- 6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos 
-- empleados que no sean representante de ventas de ningún cliente.

SELECT e.nombre, 
       e.apellido1, 
       e.apellido2, 
       e.puesto, 
       o.telefono
FROM empleado e
JOIN oficina o ON e.codigo_oficina_empleado = o.codigo_oficina
WHERE e.id_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- 7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el 
-- número de empleados que tiene.

SELECT o.ciudad, 
       COUNT(e.id_empleado) AS numero_empleados
FROM oficina o
JOIN empleado e ON o.codigo_oficina = e.codigo_oficina_empleado
GROUP BY o.ciudad;