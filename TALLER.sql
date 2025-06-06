-- MySQL dump 10.13  Distrib 9.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `detalles_pedidos`
--

DROP TABLE IF EXISTS `detalles_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalles_pedidos` (
  `detalle_id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  `precio_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`detalle_id`),
  KEY `idx_detalles_pedido` (`pedido_id`),
  KEY `idx_detalles_producto` (`producto_id`),
  CONSTRAINT `fk_detalles_ped_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`pedido_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detalles_ped_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`producto_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalles_pedidos`
--

LOCK TABLES `detalles_pedidos` WRITE;
/*!40000 ALTER TABLE `detalles_pedidos` DISABLE KEYS */;
INSERT INTO `detalles_pedidos` VALUES (1,1,1,2,4148678.51),(2,2,2,1,2074318.51),(3,3,3,3,1244616.00),(4,4,4,1,103718.00),(5,5,5,5,186692.40),(6,6,6,4,82974.40),(7,7,7,2,622308.00),(8,8,8,1,829744.00),(9,9,9,8,497846.40),(10,10,10,3,1037180.00),(11,11,11,6,145205.20),(12,12,12,7,248923.20),(13,13,13,4,331897.60),(14,14,14,5,186692.40),(15,15,15,9,2074360.00),(16,16,16,10,311154.00),(17,17,17,5,228179.60),(18,18,18,4,746769.60),(19,19,19,11,1244616.00),(20,20,20,12,622308.00);
/*!40000 ALTER TABLE `detalles_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `empleado_id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `puesto` varchar(50) NOT NULL,
  `fecha_contratacion` date NOT NULL,
  `salario` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`empleado_id`),
  KEY `fk_empleados_usuarios` (`usuario_id`),
  CONSTRAINT `fk_empleados_usuarios` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,43,'Gerente de Ventas','2020-05-10',3500000.00),(2,44,'Asistente de Ventas','2021-08-20',2200000.00),(3,45,'Representante de Ventas','2022-01-11',2500000.00),(4,46,'Asistente de Marketing','2021-04-15',2100000.00),(5,47,'Analista de Datos','2020-12-05',2800000.00),(6,48,'Ejecutiva de Cuentas','2023-02-10',2400000.00),(7,49,'Supervisor de Ventas','2022-10-23',2600000.00),(8,50,'Gerente de Finanzas','2019-11-07',4000000.00),(9,51,'Auxiliar Administrativo','2021-03-18',2000000.00),(10,52,'Desarrolladora','2022-07-30',3000000.00),(11,53,'Representante de Ventas','2020-11-15',2600000.00),(12,54,'Encargado de Almacén','2021-01-18',2200000.00),(13,55,'Especialista de Soporte','2022-06-25',2100000.00),(14,56,'Gerente de Proyectos','2018-10-05',4200000.00),(15,57,'Coordinadora de Logística','2019-08-19',3100000.00),(16,58,'Asistente Administrativo','2020-12-01',1900000.00),(17,59,'Jefe de Compras','2018-05-10',3600000.00),(18,60,'Consultor de Negocios','2021-04-12',2900000.00),(19,61,'Especialista en Ventas','2022-02-20',2300000.00),(20,62,'Desarrollador','2021-12-13',3100000.00);
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `pedido_id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `empleado_id` int NOT NULL,
  `fecha_pedido` date NOT NULL DEFAULT (curdate()),
  `estado` enum('Pendiente','Procesando','Enviado','Entregado','Cancelado') NOT NULL DEFAULT 'Pendiente',
  PRIMARY KEY (`pedido_id`),
  KEY `idx_pedidos_fecha` (`fecha_pedido`),
  KEY `fk_pedidos_cliente` (`cliente_id`),
  KEY `fk_pedidos_empleado` (`empleado_id`),
  CONSTRAINT `fk_pedidos_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `usuarios` (`usuario_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_empleado` FOREIGN KEY (`empleado_id`) REFERENCES `empleados` (`empleado_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,1,1,'2023-02-10','Entregado'),(2,2,2,'2023-02-12','Pendiente'),(3,3,3,'2023-03-15','Cancelado'),(4,4,4,'2023-03-16','Enviado'),(5,5,5,'2023-04-10','Pendiente'),(6,6,6,'2023-04-12','Entregado'),(7,7,7,'2023-05-05','Pendiente'),(8,8,8,'2023-05-07','Pendiente'),(9,9,9,'2023-05-10','Entregado'),(10,10,10,'2023-06-01','Entregado'),(11,11,11,'2023-06-02','Cancelado'),(12,12,12,'2023-06-03','Entregado'),(13,13,13,'2023-07-12','Pendiente'),(14,14,14,'2023-07-20','Cancelado'),(15,15,15,'2023-08-15','Entregado'),(16,16,16,'2023-08-30','Procesando'),(17,17,17,'2023-09-10','Pendiente'),(18,18,18,'2023-09-25','Enviado'),(19,19,19,'2023-10-05','Cancelado'),(20,20,20,'2023-10-18','Entregado'),(21,21,1,'2025-06-02','Pendiente'),(22,21,1,'2025-06-05','Entregado'),(23,21,1,'2025-06-10','Pendiente'),(24,21,1,'2025-06-12','Cancelado'),(25,21,1,'2025-06-15','Entregado'),(26,21,1,'2025-06-18','Pendiente'),(27,21,1,'2025-06-20','Entregado');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `producto_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`producto_id`),
  KEY `idx_productos_categoria` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Laptop','Electrónica',4148678.51,50),(2,'Smartphone','Electrónica',2074318.51,150),(3,'Televisor','Electrónica',1244616.00,40),(4,'Auriculares','Accesorios',103718.00,200),(5,'Teclado','Accesorios',186692.40,120),(6,'Ratón','Accesorios',82974.40,180),(7,'Impresora','Oficina',622308.00,60),(8,'Escritorio','Muebles',829744.00,25),(9,'Silla','Muebles',497846.40,80),(10,'Tableta','Electrónica',1037180.00,90),(11,'Lámpara','Hogar',145205.20,100),(12,'Ventilador','Hogar',248923.20,50),(13,'Microondas','Hogar',331897.60,30),(14,'Licuadora','Hogar',186692.40,70),(15,'Refrigerador','Electrodomésticos',2074360.00,20),(16,'Cafetera','Electrodomésticos',311154.00,60),(17,'Altavoces','Audio',228179.60,90),(18,'Monitor','Electrónica',746769.60,40),(19,'Bicicleta','Deporte',1244616.00,15),(20,'Reloj Inteligente','Electrónica',622308.00,100),(21,'Auricular Bluetooth Pro','Accesorios',259900.00,75);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `proveedor_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `fecha_registro` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`proveedor_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Tech Supplies S.A.','contacto@techsupplies.com','0341-5551234','Calle Industria 45','Bogotá','Colombia','2023-01-10'),(2,'Global Components Ltda.','ventas@globalcomp.com','0341-5555678','Av. Comercio 123','Medellín','Colombia','2022-09-15'),(3,'Electrodomésticos del Norte','info@electronorte.com','0346-5557890','Calle Norte 8','Cali','Colombia','2023-03-05'),(4,'Accesorios y Más S.A.S.','accesorios@ymas.com','0342-5554321','Av. Central 67','Barranquilla','Colombia','2022-11-20'),(5,'Muebles & Diseño S.A.','contacto@mueblesydiseno.com','0345-5558765','Calle Muebles 12','Cartagena','Colombia','2023-02-25'),(6,'Proveedor XYZ S.A.S.','contacto@provedorxyz.com','+57 3107654321','Av. Comercio 123','Medellín','Colombia','2025-05-20');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores_productos`
--

DROP TABLE IF EXISTS `proveedores_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores_productos` (
  `proveedor_id` int NOT NULL,
  `producto_id` int NOT NULL,
  PRIMARY KEY (`proveedor_id`,`producto_id`),
  KEY `idx_pp_proveedor` (`proveedor_id`),
  KEY `idx_pp_producto` (`producto_id`),
  CONSTRAINT `fk_pp_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`producto_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pp_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`proveedor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores_productos`
--

LOCK TABLES `proveedores_productos` WRITE;
/*!40000 ALTER TABLE `proveedores_productos` DISABLE KEYS */;
INSERT INTO `proveedores_productos` VALUES (1,1),(1,3),(1,4),(1,17),(1,18),(2,1),(2,7),(2,15),(2,16),(2,20),(3,2),(3,3),(3,11),(3,12),(3,13),(4,4),(4,5),(4,6),(4,14),(5,8),(5,9),(5,10),(5,19);
/*!40000 ALTER TABLE `proveedores_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_usuarios`
--

DROP TABLE IF EXISTS `tipos_usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_usuarios` (
  `tipo_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`tipo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_usuarios`
--

LOCK TABLES `tipos_usuarios` WRITE;
/*!40000 ALTER TABLE `tipos_usuarios` DISABLE KEYS */;
INSERT INTO `tipos_usuarios` VALUES (1,'Cliente'),(2,'Empleado');
/*!40000 ALTER TABLE `tipos_usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `usuario_id` int NOT NULL AUTO_INCREMENT,
  `tipo_id` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `fecha_registro` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`usuario_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_usuarios_tipos` (`tipo_id`),
  CONSTRAINT `fk_usuarios_tipos` FOREIGN KEY (`tipo_id`) REFERENCES `tipos_usuarios` (`tipo_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,1,'Ana Pérez','ana.perez@gmail.com','555-1234','Calle 123','Madrid','España','2022-01-15'),(2,1,'Juan García','juan.garcia@hotmail.com','555-5678','Avenida 45','Barcelona','España','2021-11-22'),(3,1,'María López','maria.lopez@gmail.com','555-7890','Calle Falsa 123','Sevilla','España','2023-02-03'),(4,1,'Carlos Sánchez','carlos.sanchez@yahoo.com','555-4321','Av. Libertad 90','Valencia','España','2023-05-17'),(5,1,'Lucía Fernández','lucia.fernandez@gmail.com','555-8765','Plaza Mayor 12','Zaragoza','España','2022-08-21'),(6,1,'Pablo Martínez','pablo.martinez@gmail.com','555-2345','Calle Nueva 45','Bilbao','España','2021-09-15'),(7,1,'Raúl Torres','raul.torres@hotmail.com','555-6789','Av. Central 120','Málaga','España','2022-04-01'),(8,1,'Elena Ramírez','elena.ramirez@gmail.com','555-1234','Paseo del Prado 5','Madrid','España','2021-12-20'),(9,1,'Sofía Gómez','sofia.gomez@gmail.com','555-5432','Calle Sol 18','Córdoba','España','2022-11-30'),(10,1,'Andrés Ortega','andres.ortega@hotmail.com','555-9876','Av. Buenavista 67','Murcia','España','2022-07-14'),(11,1,'Laura Morales','laura.morales@hotmail.com','555-3333','Calle Luna 8','Pamplona','España','2023-01-11'),(12,1,'Iván Navarro','ivan.navarro@gmail.com','555-2222','Av. del Rey 21','Santander','España','2022-02-05'),(13,1,'Daniel Ruiz','daniel.ruiz@yahoo.com','555-4444','Calle Grande 99','Valencia','España','2023-02-17'),(14,1,'Esther Blanco','esther.blanco@gmail.com','555-1111','Av. Colón 3','Valladolid','España','2022-10-20'),(15,1,'Nuria Gil','nuria.gil@gmail.com','555-5555','Calle Olmo 30','Madrid','España','2021-06-30'),(16,1,'Miguel Torres','miguel.torres@hotmail.com','555-6666','Paseo Marítimo 12','Cádiz','España','2023-04-05'),(17,1,'Paula Castro','paula.castro@gmail.com','555-7777','Plaza Carmen 8','Granada','España','2021-12-05'),(18,1,'Sergio Márquez','sergio.marquez@hotmail.com','555-8888','Av. Sol 45','Málaga','España','2022-05-22'),(19,1,'Beatriz Vega','beatriz.vega@gmail.com','555-9999','Calle Verde 67','Alicante','España','2023-03-30'),(20,1,'Álvaro Ramos','alvaro.ramos@gmail.com','555-0000','Av. Central 55','Logroño','España','2022-09-10'),(21,1,'Juan Quiroga','juan.quiroga@gmail.com','+57 3001234567','Cra 10 #45-20','Bogotá','Colombia','2025-06-01'),(43,2,'Carlos López','carlos.lopez@empresa.com',NULL,NULL,NULL,NULL,'2020-05-10'),(44,2,'Marta Fernández','marta.fernandez@empresa.com',NULL,NULL,NULL,NULL,'2021-08-20'),(45,2,'Sergio Molina','sergio.molina@empresa.com',NULL,NULL,NULL,NULL,'2022-01-11'),(46,2,'Teresa Ortega','teresa.ortega@empresa.com',NULL,NULL,NULL,NULL,'2021-04-15'),(47,2,'Rafael Castro','rafael.castro@empresa.com',NULL,NULL,NULL,NULL,'2020-12-05'),(48,2,'Gloria Morales','gloria.morales@empresa.com',NULL,NULL,NULL,NULL,'2023-02-10'),(49,2,'Pablo Vega','pablo.vega@empresa.com',NULL,NULL,NULL,NULL,'2022-10-23'),(50,2,'Raquel Sánchez','raquel.sanchez@empresa.com',NULL,NULL,NULL,NULL,'2019-11-07'),(51,2,'Luis Ramos','luis.ramos@empresa.com',NULL,NULL,NULL,NULL,'2021-03-18'),(52,2,'Natalia Ruiz','natalia.ruiz@empresa.com',NULL,NULL,NULL,NULL,'2022-07-30'),(53,2,'Daniel Lara','daniel.lara@empresa.com',NULL,NULL,NULL,NULL,'2020-11-15'),(54,2,'Manuel García','manuel.garcia@empresa.com',NULL,NULL,NULL,NULL,'2021-01-18'),(55,2,'José Martínez','jose.martinez@empresa.com',NULL,NULL,NULL,NULL,'2022-06-25'),(56,2,'Patricia León','patricia.leon@empresa.com',NULL,NULL,NULL,NULL,'2018-10-05'),(57,2,'Lola Díaz','lola.diaz@empresa.com',NULL,NULL,NULL,NULL,'2019-08-19'),(58,2,'Juan Cruz','juan.cruz@empresa.com',NULL,NULL,NULL,NULL,'2020-12-01'),(59,2,'Paula Rueda','paula.rueda@empresa.com',NULL,NULL,NULL,NULL,'2018-05-10'),(60,2,'Miguel Gil','miguel.gil@empresa.com',NULL,NULL,NULL,NULL,'2021-04-12'),(61,2,'Rocío López','rocio.lopez@empresa.com',NULL,NULL,NULL,NULL,'2022-02-20'),(62,2,'Andrés Navas','andres.navas@empresa.com',NULL,NULL,NULL,NULL,'2021-12-13');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-06  1:31:56
