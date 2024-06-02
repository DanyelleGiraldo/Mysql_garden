CREATE DATABASE Jardineria;
use Jardineria;

CREATE TABLE gama_producto(
  id_gama VARCHAR(50) PRIMARY KEY,
  descripcion_texto TEXT,
  descripcion_html TEXT,
  imagen VARCHAR(256)
  );

CREATE TABLE proveedor(
  id_proveedor INT(10) PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50)NOT NULL,
  apellido2 VARCHAR(50),
  telefono INT(10)
  );

  
CREATE TABLE producto(
  codigo_producto INT(10) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  gama_producto VARCHAR(50) NOT NULL,
  dimensiones_producto varchar(25),
  descripcion text,
  id_proveedor_producto INT(10), 
  cantidad_stock smallint(6) NOT NULL,
  precio_venta DECIMAL(15,2) NOT NULL,
  precio_proveedor DECIMAL(15,2),
  CONSTRAINT FK_gama_producto FOREIGN KEY (gama_producto) REFERENCES gama_producto(id_gama),
  CONSTRAINT FK_proveedor FOREIGN KEY (id_proveedor_producto) REFERENCES  proveedor(id_proveedor)
  );
  
CREATE TABLE tipo_tel(
  id_tipo_tel INT(10) PRIMARY KEY,
  nombre_tipo_tel VARCHAR(50) NOT NULL,
  descripcion_tipo_tel TEXT
  );
  
CREATE TABLE contacto(
  id_contacto INT(10) PRIMARY KEY,
  nombre_contacto VARCHAR(50) NOT NULL,
  apellido1_contacto VARCHAR(50) NOT NULL,
  apellido2_contacto VARCHAR(50),
  telefono_contacto INT(10) NOT NULL,
  tipo_telefono int(10),
  Foreign Key (tipo_telefono) REFERENCES tipo_tel(id_tipo_tel)
  );
  
CREATE TABLE forma_pago(
  id_forma_pago INT(10) PRIMARY KEY,
  nombre_forma_pago VARCHAR(50) NOT NULL,
  descripcion_forma_pago TEXT
  );
  
CREATE TABLE transaccion(
  id_transaccion VARCHAR(50),
  cod_cliente INT(10) NOT NULL,
  forma_pago_trasaccion INT(10) NOT NULL,
  fecha_transaccion DATE,
  total_transaccion DECIMAL (15,2),
  CONSTRAINT FK_forma_pago FOREIGN KEY (forma_pago_trasaccion) REFERENCES forma_pago(id_forma_pago)
  );

CREATE TABLE oficina(
  codigo_oficina VARCHAR(10) PRIMARY KEY,
  ciudad varchar(30) NOT NULL,
  region varchar(50),
  pais varchar(50),
  codigo_postal VARCHAR(10) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50)
  );
 
CREATE TABLE empleado(
  id_empleado INT(11) PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50),
  extension_empleado VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  codigo_oficina_empleado VARCHAR(10) NOT NULL,
  codigo_jefe INT(11),
  puesto VARCHAR(50),
  CONSTRAINT FK_jefe_empleado foreign key (codigo_jefe) REFERENCES empleado(id_empleado),
  CONSTRAINT FK_oficina_empleado FOREIGN KEY (codigo_oficina_empleado) REFERENCES oficina(codigo_oficina)
  );

  CREATE TABLE cliente(
  id_cliente INT(10) PRIMARY KEY,
  nombre_cliente VARCHAR(50) NOT NULL,
  apellido1_cliente VARCHAR(50) NOT NULL,
  apellido2_cliente VARCHAR(50),
  id_contacto_cliente INT(10),
  telefono_cliente varchar(15) NOT NULL,
  fax VARCHAR(15) NOT NULL,
  linea_direccion1 varchar(50) NOT NULL,
  linea_direccion2 VARCHAR(50),
  region VARCHAR(50) NOT NULL,
  ciudad VARCHAR(50) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  codigo_postal_cliente varchar(10),
  codigo_empleado_rep_ventas INT(10),
  limite_credito DECIMAL(15,2),
  CONSTRAINT FK_contacto FOREIGN KEY (id_contacto_cliente) REFERENCES contacto(id_contacto),
  CONSTRAINT FK_representante_ventas FOREIGN KEY (codigo_empleado_rep_ventas) REFERENCES empleado(id_empleado)
);

CREATE TABLE pedido(
  codigo_pedido INT(11) PRIMARY KEY,
  fecha_pedido DATE NOT NULL,
  fecha_esperada DATE NOT NULL,
  fecha_entrega DATE, 
  estado_pedido ENUM('Pendiente', 'Entregado', 'Enviado', 'Rechazado') NOT NULL,
  comentarios TEXT,
  tipo_pago int(10),
  constraint fk_tipo_pago foreign key (tipo_pago) references forma_pago(id_forma_pago),
  codigo_cliente_pedido INT(10) NOT NULL,
  CONSTRAINT FK_cliente_pedido FOREIGN KEY (codigo_cliente_pedido) REFERENCES cliente(id_cliente)
  );

CREATE TABLE detalle_pedido(
  codigo_pedido_detalle INT(10) NOT NULL,
  codigo_producto_pedido INT(10) NOT NULL,
  cantidad INT(11) NOT NULL,
  precio_unidad DECIMAL(15,2) NOT NULL,
  numero_linea SMALLINT(6) NOT NULL,
  PRIMARY KEY (codigo_pedido_detalle, codigo_producto_pedido),
  CONSTRAINT FK_producto_pedido FOREIGN KEY (codigo_producto_pedido) REFERENCES producto(codigo_producto),
  CONSTRAINT FK_codigo_pedido FOREIGN KEY (codigo_pedido_detalle) REFERENCES pedido(codigo_pedido)
  );
 

