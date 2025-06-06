-- Active: 1749038088780@@127.0.0.1@3320@mysql

CREATE DATABASE db;
SHOW DATABASES;

USE db;
-- 1. Tabla de tipos de usuarios
CREATE TABLE tipos_usuarios (
    tipo_id   INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(50)    NOT NULL
);

-- 2. Tabla de usuarios (clientes o empleados)
CREATE TABLE usuarios (
    usuario_id     INT AUTO_INCREMENT PRIMARY KEY,
    tipo_id        INT NOT NULL,
    nombre         VARCHAR(50)    NOT NULL,
    email          VARCHAR(50)    NOT NULL UNIQUE,
    telefono       VARCHAR(15),
    direccion      VARCHAR(100),
    ciudad         VARCHAR(50),
    pais           VARCHAR(50),
    fecha_registro DATE           NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_usuarios_tipos
        FOREIGN KEY (tipo_id)
        REFERENCES tipos_usuarios(tipo_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
-- 3. Tabla de productos
CREATE TABLE proveedores (
    proveedor_id   INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100)   NOT NULL,
    email          VARCHAR(100)   UNIQUE,
    telefono       VARCHAR(20),
    direccion      VARCHAR(150),
    ciudad         VARCHAR(50),
    pais           VARCHAR(50),
    fecha_registro DATE           NOT NULL DEFAULT (CURRENT_DATE)
);
-- 4. Tabla de productos
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(50)    NOT NULL,
    categoria   VARCHAR(50)    NOT NULL,
    precio      DECIMAL(10,2)  NOT NULL  DEFAULT 0.00,
    stock       INT            NOT NULL  DEFAULT 0,
    INDEX idx_productos_categoria (categoria)
);

-- 5. Tabla de proveedores de productos
CREATE TABLE proveedores_productos (
    proveedor_id INT NOT NULL,
    producto_id  INT NOT NULL,
    PRIMARY KEY (proveedor_id, producto_id),
    INDEX idx_pp_proveedor   (proveedor_id),
    INDEX idx_pp_producto    (producto_id),
    CONSTRAINT fk_pp_proveedor
        FOREIGN KEY (proveedor_id) 
        REFERENCES proveedores(proveedor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pp_producto
        FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 6. Tabla de empleados, Un empleado está asociado a un registro en 'usuarios'
CREATE TABLE empleados (
    empleado_id       INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id        INT NOT NULL,
    puesto            VARCHAR(50)     NOT NULL,
    fecha_contratacion DATE           NOT NULL,
    salario           DECIMAL(10,2)   NOT NULL  DEFAULT 0.00,
    CONSTRAINT fk_empleados_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(usuario_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7. Tabla de pedidos
CREATE TABLE pedidos (
    pedido_id     INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id    INT NOT NULL,      -- FK a 'usuarios'
    empleado_id   INT NOT NULL,      -- FK a 'empleados' (quién atendió el pedido)
    fecha_pedido  DATE NOT NULL      DEFAULT (CURRENT_DATE),
    estado        ENUM('Pendiente','Procesando','Enviado','Entregado','Cancelado') NOT NULL DEFAULT 'Pendiente',
    INDEX idx_pedidos_fecha (fecha_pedido),
    CONSTRAINT fk_pedidos_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES usuarios(usuario_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_empleado
        FOREIGN KEY (empleado_id)
        REFERENCES empleados(empleado_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 8. Tabla de detalles_pedidos
CREATE TABLE detalles_pedidos (
    detalle_id      INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id       INT NOT NULL,
    producto_id     INT NOT NULL,
    cantidad        INT NOT NULL     DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    --
    CONSTRAINT fk_detalles_ped_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedidos(pedido_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalles_ped_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    INDEX idx_detalles_pedido (pedido_id),
    INDEX idx_detalles_producto (producto_id)
);

  INSERT INTO tipos_usuarios(nombre) VALUES ('Cliente'), ('Empleado');
  INSERT INTO usuarios (
    tipo_id,
    nombre,
    email,
    telefono,
    direccion,
    ciudad,
    pais,
    fecha_registro
) VALUES
    (1, 'Ana Pérez',         'ana.perez@gmail.com',      '555-1234',   'Calle 123',           'Madrid',    'España', '2022-01-15'),
    (1, 'Juan García',       'juan.garcia@hotmail.com',  '555-5678',   'Avenida 45',          'Barcelona', 'España', '2021-11-22'),
    (1, 'María López',       'maria.lopez@gmail.com',    '555-7890',   'Calle Falsa 123',     'Sevilla',   'España', '2023-02-03'),
    (1, 'Carlos Sánchez',    'carlos.sanchez@yahoo.com', '555-4321',   'Av. Libertad 90',     'Valencia',  'España', '2023-05-17'),
    (1, 'Lucía Fernández',   'lucia.fernandez@gmail.com','555-8765',   'Plaza Mayor 12',      'Zaragoza',  'España', '2022-08-21'),
    (1, 'Pablo Martínez',    'pablo.martinez@gmail.com', '555-2345',   'Calle Nueva 45',      'Bilbao',    'España', '2021-09-15'),
    (1, 'Raúl Torres',       'raul.torres@hotmail.com',  '555-6789',   'Av. Central 120',     'Málaga',    'España', '2022-04-01'),
    (1, 'Elena Ramírez',     'elena.ramirez@gmail.com',  '555-1234',   'Paseo del Prado 5',   'Madrid',    'España', '2021-12-20'),
    (1, 'Sofía Gómez',       'sofia.gomez@gmail.com',    '555-5432',   'Calle Sol 18',        'Córdoba',   'España', '2022-11-30'),
    (1, 'Andrés Ortega',     'andres.ortega@hotmail.com','555-9876',   'Av. Buenavista 67',   'Murcia',    'España', '2022-07-14'),
    (1, 'Laura Morales',     'laura.morales@hotmail.com','555-3333',   'Calle Luna 8',        'Pamplona',  'España', '2023-01-11'),
    (1, 'Iván Navarro',      'ivan.navarro@gmail.com',   '555-2222',   'Av. del Rey 21',      'Santander', 'España', '2022-02-05'),
    (1, 'Daniel Ruiz',       'daniel.ruiz@yahoo.com',    '555-4444',   'Calle Grande 99',     'Valencia',  'España', '2023-02-17'),
    (1, 'Esther Blanco',     'esther.blanco@gmail.com',  '555-1111',   'Av. Colón 3',         'Valladolid','España', '2022-10-20'),
    (1, 'Nuria Gil',         'nuria.gil@gmail.com',      '555-5555',   'Calle Olmo 30',       'Madrid',    'España', '2021-06-30'),
    (1, 'Miguel Torres',     'miguel.torres@hotmail.com','555-6666',   'Paseo Marítimo 12',   'Cádiz',     'España', '2023-04-05'),
    (1, 'Paula Castro',      'paula.castro@gmail.com',   '555-7777',   'Plaza Carmen 8',      'Granada',   'España', '2021-12-05'),
    (1, 'Sergio Márquez',    'sergio.marquez@hotmail.com','555-8888',  'Av. Sol 45',          'Málaga',    'España', '2022-05-22'),
    (1, 'Beatriz Vega',      'beatriz.vega@gmail.com',   '555-9999',   'Calle Verde 67',      'Alicante',  'España', '2023-03-30'),
    (1, 'Álvaro Ramos',      'alvaro.ramos@gmail.com',   '555-0000',   'Av. Central 55',      'Logroño',   'España', '2022-09-10'),
     (
    1, 'Juan Quiroga', 'juan.quiroga@gmail.com', '+57 3001234567', 'Cra 10 #45-20', 'Bogotá', 'Colombia', '2025-06-01'
);

INSERT INTO usuarios (
    tipo_id,
    nombre,
    email,
    telefono,
    direccion,
    ciudad,
    pais,
    fecha_registro
) VALUES
    (2, 'Carlos López',     'carlos.lopez@empresa.com',      NULL, NULL, NULL, NULL, '2020-05-10'),
    (2, 'Marta Fernández',  'marta.fernandez@empresa.com',   NULL, NULL, NULL, NULL, '2021-08-20'),
    (2, 'Sergio Molina',    'sergio.molina@empresa.com',     NULL, NULL, NULL, NULL, '2022-01-11'),
    (2, 'Teresa Ortega',    'teresa.ortega@empresa.com',     NULL, NULL, NULL, NULL, '2021-04-15'),
    (2, 'Rafael Castro',    'rafael.castro@empresa.com',     NULL, NULL, NULL, NULL, '2020-12-05'),
    (2, 'Gloria Morales',   'gloria.morales@empresa.com',    NULL, NULL, NULL, NULL, '2023-02-10'),
    (2, 'Pablo Vega',       'pablo.vega@empresa.com',        NULL, NULL, NULL, NULL, '2022-10-23'),
    (2, 'Raquel Sánchez',   'raquel.sanchez@empresa.com',    NULL, NULL, NULL, NULL, '2019-11-07'),
    (2, 'Luis Ramos',       'luis.ramos@empresa.com',        NULL, NULL, NULL, NULL, '2021-03-18'),
    (2, 'Natalia Ruiz',     'natalia.ruiz@empresa.com',      NULL, NULL, NULL, NULL, '2022-07-30'),
    (2, 'Daniel Lara',      'daniel.lara@empresa.com',       NULL, NULL, NULL, NULL, '2020-11-15'),
    (2, 'Manuel García',    'manuel.garcia@empresa.com',     NULL, NULL, NULL, NULL, '2021-01-18'),
    (2, 'José Martínez',    'jose.martinez@empresa.com',     NULL, NULL, NULL, NULL, '2022-06-25'),
    (2, 'Patricia León',    'patricia.leon@empresa.com',     NULL, NULL, NULL, NULL, '2018-10-05'),
    (2, 'Lola Díaz',        'lola.diaz@empresa.com',         NULL, NULL, NULL, NULL, '2019-08-19'),
    (2, 'Juan Cruz',        'juan.cruz@empresa.com',         NULL, NULL, NULL, NULL, '2020-12-01'),
    (2, 'Paula Rueda',      'paula.rueda@empresa.com',       NULL, NULL, NULL, NULL, '2018-05-10'),
    (2, 'Miguel Gil',       'miguel.gil@empresa.com',        NULL, NULL, NULL, NULL, '2021-04-12'),
    (2, 'Rocío López',      'rocio.lopez@empresa.com',       NULL, NULL, NULL, NULL, '2022-02-20'),
    (2, 'Andrés Navas',     'andres.navas@empresa.com',      NULL, NULL, NULL, NULL, '2021-12-13');
    
    INSERT INTO empleados (
    usuario_id,
    puesto,
    fecha_contratacion,
    salario
) VALUES
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'carlos.lopez@empresa.com'),
      'Gerente de Ventas',    '2020-05-10', 3500000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'marta.fernandez@empresa.com'),
      'Asistente de Ventas',  '2021-08-20', 2200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'sergio.molina@empresa.com'),
      'Representante de Ventas','2022-01-11',2500000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'teresa.ortega@empresa.com'),
      'Asistente de Marketing','2021-04-15',2100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'rafael.castro@empresa.com'),
      'Analista de Datos',     '2020-12-05',2800000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'gloria.morales@empresa.com'),
      'Ejecutiva de Cuentas',  '2023-02-10',2400000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'pablo.vega@empresa.com'),
      'Supervisor de Ventas',  '2022-10-23',2600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'raquel.sanchez@empresa.com'),
      'Gerente de Finanzas',   '2019-11-07',4000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'luis.ramos@empresa.com'),
      'Auxiliar Administrativo','2021-03-18',2000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'natalia.ruiz@empresa.com'),
      'Desarrolladora',        '2022-07-30',3000000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'daniel.lara@empresa.com'),
      'Representante de Ventas','2020-11-15',2600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'manuel.garcia@empresa.com'),
      'Encargado de Almacén',  '2021-01-18',2200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'jose.martinez@empresa.com'),
      'Especialista de Soporte','2022-06-25',2100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'patricia.leon@empresa.com'),
      'Gerente de Proyectos',  '2018-10-05',4200000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'lola.diaz@empresa.com'),
      'Coordinadora de Logística','2019-08-19',3100000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'juan.cruz@empresa.com'),
      'Asistente Administrativo','2020-12-01',1900000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'paula.rueda@empresa.com'),
      'Jefe de Compras',       '2018-05-10',3600000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'miguel.gil@empresa.com'),
      'Consultor de Negocios', '2021-04-12',2900000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'rocio.lopez@empresa.com'),
      'Especialista en Ventas','2022-02-20',2300000.00
    ),
    (
      (SELECT usuario_id FROM usuarios WHERE email = 'andres.navas@empresa.com'),
      'Desarrollador',         '2021-12-13',3100000.00
    );
    SELECT * FROM usuarios;
INSERT INTO proveedores (
    nombre, email, telefono, direccion, ciudad, pais, fecha_registro
) VALUES
    ('Tech Supplies S.A.',           'contacto@techsupplies.com',  '0341-5551234', 'Calle Industria 45', 'Bogotá',   'Colombia', '2023-01-10'),
    ('Global Components Ltda.',       'ventas@globalcomp.com',      '0341-5555678', 'Av. Comercio 123',   'Medellín', 'Colombia', '2022-09-15'),
    ('Electrodomésticos del Norte',   'info@electronorte.com',      '0346-5557890', 'Calle Norte 8',      'Cali',     'Colombia', '2023-03-05'),
    ('Accesorios y Más S.A.S.',       'accesorios@ymas.com',        '0342-5554321', 'Av. Central 67',     'Barranquilla','Colombia','2022-11-20'),
    ('Muebles & Diseño S.A.',         'contacto@mueblesydiseno.com','0345-5558765', 'Calle Muebles 12',   'Cartagena','Colombia','2023-02-25'), ('Proveedor XYZ S.A.S.','contacto@provedorxyz.com', '+57 3107654321','Av. Comercio 123', 'Medellín', 'Colombia','2025-05-20'
);
    INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Laptop',           'Electrónica',  4148678.51, 50),
('Smartphone',       'Electrónica',  2074318.51, 150),
('Televisor',        'Electrónica',  1244616.00, 40),
('Auriculares',      'Accesorios',    103718.00, 200),
('Teclado',          'Accesorios',    186692.40, 120),
('Ratón',            'Accesorios',     82974.40, 180),
('Impresora',        'Oficina',       622308.00, 60),
('Escritorio',       'Muebles',       829744.00, 25),
('Silla',            'Muebles',       497846.40, 80),
('Tableta',          'Electrónica',  1037180.00, 90),
('Lámpara',          'Hogar',         145205.20, 100),
('Ventilador',       'Hogar',         248923.20, 50),
('Microondas',       'Hogar',         331897.60, 30),
('Licuadora',        'Hogar',         186692.40, 70),
('Refrigerador',     'Electrodomésticos', 2074360.00, 20),
('Cafetera',         'Electrodomésticos', 311154.00, 60),
('Altavoces',        'Audio',         228179.60, 90),
('Monitor',          'Electrónica',   746769.60, 40),
('Bicicleta',        'Deporte',      1244616.00, 15),
('Reloj Inteligente','Electrónica',   622308.00, 100),
('Auricular Bluetooth Pro','Accesorios',259900.00,75);
INSERT INTO proveedores_productos (proveedor_id, producto_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (1, 4),
    (4, 4),
    (5, 8),
    (1, 3),
    (3, 3),
    (4, 6),
    (4, 5),
    (2, 7),
    (2, 15),
    (5, 9),
    (5, 10),
    (3, 11),
    (3, 12),
    (3, 13),
    (4, 14),
    (2, 16),
    (1, 17),
    (1, 18),
    (5, 19),
    (2, 20);
    INSERT INTO pedidos (cliente_id, empleado_id, fecha_pedido, estado) VALUES
(1, 1, '2023-02-10', 'Entregado'),
(2, 2, '2023-02-12', 'Pendiente'),
(3, 3, '2023-03-15', 'Cancelado'),
(4, 4, '2023-03-16', 'Enviado'),
(5, 5, '2023-04-10', 'Pendiente'),
(6, 6, '2023-04-12', 'Entregado'),
(7, 7, '2023-05-05', 'Pendiente'),
(8, 8, '2023-05-07', 'Pendiente'),
(9, 9, '2023-05-10', 'Entregado'),
(10, 10, '2023-06-01', 'Entregado'),
(11, 11, '2023-06-02', 'Cancelado'),
(12, 12, '2023-06-03', 'Entregado'),
(13, 13, '2023-07-12', 'Pendiente'),
(14, 14, '2023-07-20', 'Cancelado'),
(15, 15, '2023-08-15', 'Entregado'),
(16, 16, '2023-08-30', 'Procesando'),
(17, 17, '2023-09-10', 'Pendiente'),
(18, 18, '2023-09-25', 'Enviado'),
(19, 19, '2023-10-05', 'Cancelado'),
(20, 20, '2023-10-18', 'Entregado'),
(21,1,'2025-06-02','Pendiente'),
(21,1,'2025-06-05','Entregado'),
(21,1,'2025-06-10','Pendiente'),
(21,1,'2025-06-12','Cancelado'),
(21,1,'2025-06-15','Entregado'),
(21,1,'2025-06-18','Pendiente'),
(21,1,'2025-06-20','Entregado');

INSERT INTO detalles_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1,  1,  2,  4148678.51),
(2,  2,  1,  2074318.51),
(3,  3,  3,  1244616.00),
(4,  4,  1,   103718.00),
(5,  5,  5,   186692.40),
(6,  6,  4,    82974.40),
(7,  7,  2,   622308.00),
(8,  8,  1,   829744.00),
(9,  9,  8,   497846.40),
(10, 10, 3,  1037180.00),
(11, 11, 6,   145205.20),
(12, 12, 7,   248923.20),
(13, 13, 4,   331897.60),
(14, 14, 5,   186692.40),
(15, 15, 9,  2074360.00),
(16, 16, 10,  311154.00),
(17, 17, 5,   228179.60),
(18, 18, 4,   746769.60),
(19, 19, 11, 1244616.00),
(20, 20, 12,  622308.00);


/* 
CONSULTAS BASICAS
1. Consulta todos los datos de la tabla `usuarios` para ver la lista completa de clientes.
2. Muestra los nombres y correos electrónicos de todos los clientes que residen en la ciudad de Madrid.
3. Obtén una lista de productos con un precio mayor a $100.000, mostrando solo el nombre y el precio.
4. Encuentra todos los empleados que tienen un salario superior a $2.500.000, mostrando su nombre, puesto y salario.
5. Lista los nombres de los productos en la categoría "Electrónica", ordenados alfabéticamente.
6. Muestra los detalles de los pedidos que están en estado "Pendiente", incluyendo el ID del pedido, el ID del cliente y la fecha del pedido.
7. Encuentra el nombre y el precio del producto más caro en la base de datos.
8. Obtén el total de pedidos realizados por cada cliente, mostrando el ID del cliente y el total de pedidos.
9. Calcula el promedio de salario de todos los empleados en la empresa.
10. Encuentra el número de productos en cada categoría, mostrando la categoría y el número de productos.
11. Obtén una lista de productos con un precio mayor a $75 USD, mostrando solo el nombre, el precio y su respectivo precio en USD.
12. Lista todos los proveedores registrados. */

--1 
SELECT * FROM usuarios WHERE tipo_id = 1;

--2
SELECT nombre,email FROM usuarios WHERE ciudad = "Madrid";

--3
SELECT nombre,precio FROM productos WHERE precio > 100000;

--4
SELECT empleados.puesto,empleados.salario,usuarios.nombre
FROM empleados
JOIN usuarios ON empleados.usuario_id = usuarios.usuario_id
WHERE salario > 2500000

--5
SELECT nombre 
FROM productos
WHERE categoria = "Electrónica"
ORDER BY nombre ASC;

--6
SELECT detalles_pedidos.* , pedidos.pedido_id, pedidos.cliente_id, pedidos.fecha_pedido
FROM pedidos
JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
WHERE estado = 'Pendiente'

--7
SELECT precio,nombre
FROM productos
ORDER BY precio DESC
LIMIT 1;

--8
SELECT usuarios.nombre,COUNT(pedidos.pedido_id) AS total_pedidos
FROM pedidos
JOIN usuarios ON pedidos.cliente_id = usuarios.usuario_id
GROUP BY usuarios.nombre;

--9
SELECT AVG(salario) AS promedio_salario_empresa
FROM empleados;

--10
SELECT categoria,COUNT(nombre) AS cantidad
FROM productos
GROUP BY categoria;

--11
SELECT nombre,precio/4000 AS precio_dolares
FROM productos
WHERE precio/4000 > 75
ORDER BY precio_dolares DESC;

--12
SELECT * FROM proveedores;


/* 
CONSULTAS MULTITABLA JOINS
1. Encuentra los nombres de los clientes y los detalles de sus pedidos.
2. Lista todos los productos pedidos junto con el precio unitario de cada pedido
3. Encuentra los nombres de los clientes y los nombres de los empleados que gestionaron sus pedidos
4. Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`
5. Encuentra los productos y, si existen, los detalles de pedidos en los que no se ha incluido el producto usando `RIGHT JOIN`.
6. Lista todos los empleados junto con los pedidos que han gestionado, si existen, usando `LEFT JOIN` para ver los empleados sin pedidos.
7. Encuentra los empleados que no han gestionado ningún pedido usando un `LEFT JOIN` combinado con `WHERE`.
8. Calcula el total gastado en cada pedido, mostrando el ID del pedido y el total, usando `JOIN`.
9. Realiza un `CROSS JOIN` entre clientes y productos para mostrar todas las combinaciones posibles de clientes y productos.
10. Encuentra los nombres de los clientes y los productos que han comprado, si existen, incluyendo los clientes que no han realizado pedidos usando `LEFT JOIN`.
11. Listar todos los proveedores que suministran un determinado producto.
12. Obtener todos los productos que ofrece un proveedor específico.
13. Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).
14. Contar cuántos proveedores tiene cada producto.
15. Para un proveedor determinado (p. ej. `proveedor_id = 3`), muestra el nombre de todos los productos que suministra.
16. Para un producto específico (p. ej. `producto_id = 1`), muestra todos los proveedores que lo distribuyen, con sus datos de contacto.
17. Cuenta cuántos proveedores tiene cada producto, listando `producto_id`, `nombre` y `cantidad_proveedores`.
18. Cuenta cuántos productos suministra cada proveedor, mostrando `proveedor_id`, `nombre_proveedor` y `total_productos`.
 */

--1
SELECT detalles_pedidos.*, usuarios.nombre
FROM usuarios
JOIN pedidos ON  pedidos.cliente_id = usuarios.usuario_id
JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
WHERE usuarios.tipo_id = 1;

--2
SELECT productos.nombre AS nombre_producto, detalles_pedidos.precio_unitario 
FROM detalles_pedidos
JOIN productos ON detalles_pedidos.producto_id = productos.producto_id;

--3
USE db;
SELECT usuario_pedido.nombre AS nombre_cliente, usuario_empleado.nombre AS nombre_empleado
FROM pedidos
JOIN usuarios AS usuario_pedido ON pedidos.cliente_id = usuario_pedido.usuario_id
JOIN empleados ON pedidos.empleado_id = empleados.empleado_id
JOIN usuarios AS usuario_empleado ON empleados.usuario_id = usuario_empleado.usuario_id;


--4 
SELECT pedidos.pedido_id,productos.nombre
FROM pedidos
LEFT JOIN  detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
LEFT JOIN productos ON detalles_pedidos.producto_id = productos.producto_id;

--5
USE db;
SELECT productos.*,detalles_pedidos.*
FROM detalles_pedidos
RIGHT JOIN productos ON detalles_pedidos.producto_id = productos.producto_id;

--6
USE db;
SELECT empleados.empleado_id,pedidos.pedido_id
FROM empleados
LEFT JOIN pedidos ON empleados.empleado_id = pedidos.empleado_id;

--7
SELECT empleados.empleado_id,pedidos.pedido_id
FROM empleados
LEFT JOIN pedidos ON empleados.empleado_id = pedidos.empleado_id
WHERE pedidos.empleado_id IS NULL;

--8
USE db;
SELECT detalles_pedidos.pedido_id,(productos.precio * detalles_pedidos.cantidad) AS precio_total
FROM productos
JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id;
--9
SELECT productos.*,usuarios.*
FROM usuarios
CROSS JOIN productos
WHERE tipo_id = 1;

--10
SELECT usuarios.nombre,productos.nombre
FROM usuarios
LEFT JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
LEFT JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
LEFT JOIN productos ON detalles_pedidos.producto_id = productos.producto_id
WHERE tipo_id = 1 ;

--11
SELECT productos.nombre, GROUP_CONCAT(proveedores_productos.proveedor_id SEPARATOR ', ') AS proveedor_id
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
GROUP BY productos.nombre;

--12
USE db;
SELECT proveedores_productos.proveedor_id,GROUP_CONCAT(productos.nombre SEPARATOR ', ') AS productos_manejados
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
GROUP BY proveedor_id;

--13
SELECT proveedores.nombre,productos.nombre
FROM proveedores
LEFT JOIN proveedores_productos ON proveedores.proveedor_id = proveedores_productos.proveedor_id
LEFT JOIN productos ON proveedores_productos.producto_id = productos.producto_id
WHERE productos.nombre IS NULL;

--14
USE db;
SELECT productos.nombre, COUNT(proveedores_productos.proveedor_id) AS cantidad_proveedores
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
GROUP BY productos.nombre;

--15
USE db;
SELECT proveedores.nombre,productos.nombre
FROM proveedores
JOIN proveedores_productos ON proveedores.proveedor_id = proveedores_productos.proveedor_id
JOIN productos ON proveedores_productos.producto_id = productos.producto_id
WHERE proveedores.proveedor_id = 1;

--16
SELECT productos.nombre AS nombre_producto,proveedores.nombre AS nombre_proveedor, proveedores.*
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
JOIN proveedores ON proveedores_productos.proveedor_id = proveedores.proveedor_id
WHERE productos.producto_id = 1;

--17
SELECT productos.producto_id,productos.nombre AS producto_nombre, COUNT(proveedores_productos.proveedor_id) AS cantidad_proveedores
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
GROUP BY productos.producto_id
ORDER BY productos.producto_id ASC;

--18
SELECT proveedores_productos.proveedor_id,proveedores.nombre,COUNT(productos.producto_id) AS total_productos
FROM productos
JOIN proveedores_productos ON productos.producto_id = proveedores_productos.producto_id
JOIN proveedores ON proveedores_productos.proveedor_id = proveedores.proveedor_id
GROUP BY proveedor_id;
/*
SUBCONSULTAS
1. Encuentra los nombres de los clientes que han realizado al menos un pedido de más de $500.000.
2. Muestra los productos que nunca han sido pedidos.
3. Lista los empleados que han gestionado pedidos en los últimos 6 meses.
4. Encuentra el pedido con el total de ventas más alto.
5. Muestra los nombres de los clientes que han realizado más pedidos que el promedio de pedidos de todos los clientes.
6. Obtén los productos cuyo precio es superior al precio promedio de todos los productos.
7. Lista los clientes que han gastado más de $1.000.000 en total.
8. Encuentra los empleados que ganan un salario mayor al promedio de la empresa.
9. Obtén los productos que generaron ingresos mayores al ingreso promedio por producto.
10. Encuentra el nombre del cliente que realizó el pedido más reciente.
11. Muestra los productos pedidos al menos una vez en los últimos 3 meses.
12. Lista los empleados que no han gestionado ningún pedido.
13. Encuentra los clientes que han comprado más de tres tipos distintos de productos.
14. Muestra el nombre del producto más caro que se ha pedido al menos cinco veces.
15. Lista los clientes cuyo primer pedido fue un año después de su registro.

16. Encuentra los nombres de los productos que tienen un stock inferior al promedio del stock de todos los productos.
17. Lista los clientes que han realizado menos de tres pedidos.
18. Encuentra los nombres de los productos que fueron pedidos por los clientes que registraron en el último año.
19. Obtén el nombre del empleado que gestionó el mayor número de pedidos.
20. Lista los productos que han sido comprados en cantidades mayores que el promedio de cantidad de compra de todos los productos.
21. Proveedores que suministran más productos que el promedio de productos por proveedor.
22. Proveedores que solo suministran productos de la categoría "Electrónica".
23. Productos que solo tienen proveedores registrados hace más de un año. */

--1
USE db;
SELECT usuarios.usuario_id, usuarios.nombre
FROM usuarios
JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
WHERE usuarios.usuario_id IN(
  SELECT pedidos.cliente_id
  FROM pedidos
  JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
  GROUP BY pedidos.pedido_id,pedidos.cliente_id
  HAVING SUM(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) > 500000
);

--2
SELECT jamas_pedidos.*
FROM (SELECT productos.producto_id,productos.nombre,detalles_pedidos.pedido_id 
FROM productos
LEFT JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
WHERE pedido_id IS NULL) AS jamas_pedidos;

--3
USE db;
SELECT *
FROM(SELECT pedidos.pedido_id,usuarios.nombre,pedidos.fecha_pedido
FROM pedidos
JOIN empleados ON pedidos.empleado_id = empleados.empleado_id
JOIN usuarios ON empleados.usuario_id = usuarios.usuario_id
WHERE usuarios.tipo_id = 2
) AS seleccionar_empleados
WHERE fecha_pedido >= NOW() - INTERVAL 6 MONTH;

--4
USE db;
SELECT nombre,total_vendido
FROM(SELECT productos.nombre,SUM(detalles_pedidos.cantidad) AS total_vendido
FROM productos
JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
GROUP BY productos.nombre
) AS contador_maxVentas
ORDER BY total_vendido DESC
LIMIT 1
;

--5

SELECT usuarios.nombre,(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) AS gasto_persona,gasto_promedio
FROM usuarios
JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
CROSS JOIN(
  SELECT AVG(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) AS gasto_promedio
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
  JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
  WHERE usuarios.tipo_id = 1
) AS gasto_promedio
WHERE (detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) > gasto_promedio
ORDER BY gasto_persona;

--6
USE db;
SELECT nombre,precio,precio_promedio
FROM productos
CROSS JOIN(
  SELECT  AVG(precio) AS precio_promedio
  FROM productos
) AS productos_promedio
GROUP BY nombre,precio,precio_promedio
HAVING precio > precio_promedio;

--7
SELECT nombre,gasto
FROM(
  SELECT usuarios.nombre,(detalles_pedidos.precio_unitario * detalles_pedidos.cantidad) AS gasto
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
  JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
) AS select_gasto
WHERE gasto > 1000000;

--8
USE db;
SELECT usuarios.nombre,empleados.salario,salario_promedio
FROM usuarios
JOIN empleados ON usuarios.usuario_id = empleados.usuario_id
CROSS JOIN(
  SELECT AVG(salario) AS salario_promedio
  FROM empleados
) AS salarios_promedio
WHERE salario > 1000000 AND usuarios.tipo_id = 2;


--9
USE db;
SELECT productos.nombre,(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) AS ingresos, ingreso_promedio
FROM productos
JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id 
CROSS JOIN(
  SELECT AVG(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) AS ingreso_promedio
  FROM productos
  JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
) AS promedio_productos
WHERE ingreso_promedio < (detalles_pedidos.cantidad * detalles_pedidos.precio_unitario);

--10
USE db;
SELECT *
FROM(
  SELECT usuarios.nombre,pedidos.fecha_pedido
  FROM pedidos
  JOIN usuarios ON pedidos.cliente_id = usuarios.usuario_id
  WHERE usuarios.tipo_id = 1 
) AS fechas_pedidos
ORDER BY fecha_pedido DESC
LIMIT 1;

--11
SELECT nombre,ultima_fecha
FROM(
  SELECT productos.nombre,MAX(pedidos.fecha_pedido) AS ultima_fecha
  FROM productos
  JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
  JOIN pedidos ON detalles_pedidos.pedido_id = pedidos.pedido_id
  WHERE pedidos.fecha_pedido >= NOW() - INTERVAL 3 MONTH
  GROUP BY productos.nombre
) AS pedidos;

--12
USE db;
SELECT *
FROM (
  SELECT usuarios.nombre, pedidos.pedido_id
  FROM empleados
  JOIN usuarios ON empleados.usuario_id = usuarios.usuario_id
  LEFT JOIN pedidos ON pedidos.empleado_id = empleados.empleado_id
  WHERE usuarios.tipo_id = 2
) AS empleados
WHERE pedido_id IS NULL;

--13
USE db;
SELECT *
FROM(
  SELECT usuarios.nombre,pedidos.pedido_id,COUNT( DISTINCT detalles_pedidos.producto_id) AS productos_distintos
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
  JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
  GROUP BY usuarios.nombre,pedidos.pedido_id
) AS productos_conteo
WHERE productos_distintos > 3
;

--14
USE db;
SELECT nombre,cantidad,precio_unitario
FROM(
  SELECT productos.nombre,detalles_pedidos.cantidad,precio_unitario 
  FROM productos
  JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
  WHERE detalles_pedidos.cantidad >= 5
) AS producto_minimo
ORDER BY precio_unitario DESC
LIMIT 1;

--15
SELECT nombre,fecha_registro,fecha_pedido
FROM(
  SELECT usuarios.nombre,usuarios.fecha_registro,pedidos.fecha_pedido
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
) AS pedidos_fecha
WHERE fecha_pedido >= fecha_registro + INTERVAL 1 YEAR;

--16
SELECT productos.nombre,productos.stock, promedio_stock
FROM productos
CROSS JOIN(
  SELECT AVG(productos.stock) AS promedio_stock
  FROM productos
) AS promediaje
WHERE productos.stock > promedio_stock;

--17
SELECT nombre, cantidad_pedidos
FROM(
  SELECT usuarios.nombre,COUNT(pedidos.cliente_id) AS cantidad_pedidos
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
  WHERE usuarios.tipo_id = 1
  GROUP BY usuarios.nombre
) AS cantidad_pedidos
WHERE cantidad_pedidos < 3;

--18
USE db;
SELECT  nombre_producto,nombre_user,fecha_registro
FROM(
  SELECT productos.nombre AS nombre_producto,usuarios.nombre AS nombre_user,usuarios.fecha_registro
  FROM usuarios
  JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
  JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
  JOIN productos ON detalles_pedidos.producto_id = productos.producto_id
  WHERE usuarios.tipo_id = 1
) AS usuarios
WHERE fecha_registro > NOW() - INTERVAL 1 YEAR;

--19
SELECT *
FROM(
  SELECT usuarios.nombre AS nombre_empleado,COUNT(pedidos.pedido_id) AS cantidad_pedidos_gestionados
  FROM usuarios
  JOIN empleados ON usuarios.usuario_id = empleados.empleado_id
  JOIN pedidos ON empleados.empleado_id = pedidos.empleado_id
  GROUP BY nombre_empleado
) AS empleados
ORDER BY cantidad_pedidos_gestionados DESC
LIMIT 1;

--20
SELECT productos.nombre, detalles_pedidos.cantidad, promedio_compra
FROM detalles_pedidos
JOIN productos ON  detalles_pedidos.producto_id = productos.producto_id
CROSS JOIN(
  SELECT AVG(cantidad) AS promedio_compra
  FROM detalles_pedidos
) AS promedio_compra
WHERE detalles_pedidos.cantidad > promedio_compra
ORDER BY cantidad DESC
;

--21
SELECT proveedores.nombre,COUNT(proveedores_productos.producto_id) AS cantidad,promedio
FROM proveedores
JOIN proveedores_productos ON proveedores.proveedor_id = proveedores_productos.proveedor_id
CROSS JOIN(
  SELECT AVG(cantidad_productos) AS promedio
  FROM(
    SELECT proveedor_id, COUNT(producto_id) AS cantidad_productos
    FROM proveedores_productos
    GROUP BY proveedor_id
  ) AS contador_proveedor
) AS promedio_por_proveedor
GROUP BY proveedores.nombre,promedio
HAVING cantidad > promedio;

--22
