-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2020 at 06:33 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smartphonedepotdb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BASKET_ADDSMP_SP` (IN `p_basketitemid` INT(8), IN `p_producid` VARCHAR(16), IN `p_basketid` INT(8), IN `p_price` DOUBLE, IN `p_quantity` INT(5), IN `p_sizecode` INT(2), IN `p_fromcode` INT(2))  NO SQL
BEGIN
INSERT INTO sp_cartItem (idCartItem,idSmartPhones,price,Quantity,idCart,option1,option2)
VALUES (p_basketitemid, p_producid, p_price, p_quantity, p_basketid,p_sizecode,p_fromcode);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `basket_calc_sp` (IN `p_idCart` INT(8))  NO SQL
BEGIN
 declare lv_sub_num double;
 declare lv_tax_num double ;
 declare lv_ship_num double;
 declare lv_total_num double;
 declare lv_quantity_item int(5);
set lv_sub_num  = subtotal_calc_sf(p_idCart);
set lv_tax_num = tax_calc_sfuntion(p_idCart, subtotal_calc_sf(p_idCart));
set lv_ship_num = shipping_calc_sf(p_idCart);
set lv_total_num = (lv_sub_num + lv_tax_num + lv_ship_num);
select SUM(quantity)
into lv_quantity_item
 from sp_cartItem
 where idCart = p_idCart;
 UPDATE sp_cart
  SET orderplaced = 1,
      subtotal = lv_sub_num,
      Tax = lv_tax_num,
      shipping = lv_ship_num,
      quantity = lv_quantity_item,
      total = lv_total_num
  WHERE idCart = p_idCart;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cal_total_before_orderPlace_sp` (IN `p_idCart` INT(8))  NO SQL
BEGIN
 declare lv_sub_num double;
 declare lv_tax_num double ;
 declare lv_ship_num double;
 declare lv_total_num double;
 declare lv_quantity_item int(5);
set lv_sub_num  = subtotal_calc_sf(p_idCart);
set lv_tax_num = tax_calc_sfuntion(p_idCart, subtotal_calc_sf(p_idCart));
set lv_ship_num = shipping_calc_sf(p_idCart);
set lv_total_num = (lv_sub_num + lv_tax_num + lv_ship_num);
select SUM(quantity)
into lv_quantity_item
 from sp_cartItem
 where idCart = p_idCart;
 UPDATE sp_cart
  SET subtotal = lv_sub_num,
      Tax = lv_tax_num,
      shipping = lv_ship_num,
      quantity = lv_quantity_item,
      total = lv_total_num
  WHERE idCart = p_idCart;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Userlogin_sp` (IN `p_username` VARCHAR(25), IN `p_password` VARCHAR(100), OUT `username` VARCHAR(25), OUT `password` VARCHAR(100), OUT `shopperid` INT(8), OUT `firstname` VARCHAR(30))  NO SQL
BEGIN
DECLARE lv_firstName_txt VARCHAR(30);
DECLARE lv_lastName_txt VARCHAR(30);
DECLARE LV_RowNotFound INT(2) DEFAULT 0;
DECLARE lv_idshoper INT(8);
DECLARE CONTINUE HANDLER FOR NOT FOUND
set LV_RowNotFound = 1;
 SELECT idShopper, username, password, firstname
 INTO shopperid, username, password, firstname
 FROM sp_shopper
 WHERE username = p_username;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `shipping_calc_sf` (`f_idCart` INT(8)) RETURNS DOUBLE NO SQL
BEGIN
declare lv_qty_num int(5);
 declare lv_ship_cost double;
  SELECT SUM(quantity)
   INTO lv_qty_num
   FROM sp_cartitem
   WHERE idCart = f_idCart;
  IF lv_qty_num > 10 THEN
     set lv_ship_cost = 15.00;
  ELSEIF lv_qty_num > 5 THEN
     set lv_ship_cost = 8.00;
  ELSE
    set lv_ship_cost = 5.00;
  END IF;
  RETURN lv_ship_cost;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `subtotal_calc_sf` (`f_idcal` INT(8)) RETURNS DOUBLE NO SQL
BEGIN
 declare lv_sub_num double;
 SELECT SUM(quantity*price)
  INTO lv_sub_num
  FROM sp_cartitem
  WHERE idCart = f_idcal;
 RETURN lv_sub_num;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tax_calc_sfuntion` (`f_id` INT(8), `f_subtotal` DOUBLE) RETURNS DOUBLE NO SQL
BEGIN
declare lv_tax_num double;
 SELECT f_subtotal*t.taxrate tax
  INTO lv_tax_num
  FROM sp_cart b, sp_tax t
  WHERE b.shipstate = t.state
   AND b.idCart = f_id;
  RETURN lv_tax_num;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loginadmin`
--

CREATE TABLE `loginadmin` (
  `idadmin` int(8) NOT NULL,
  `adminUsername` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adminPassword` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adminLevel` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `loginadmin`
--

INSERT INTO `loginadmin` (`idadmin`, `adminUsername`, `adminPassword`, `adminLevel`) VALUES
(29, 'user9', '25f9e794323b453885f5181f1b624d0b', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `sp_audit_logon`
--

CREATE TABLE `sp_audit_logon` (
  `userid` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_cart`
--

CREATE TABLE `sp_cart` (
  `idCart` int(8) NOT NULL,
  `Quantity` int(5) DEFAULT NULL,
  `idShopper` int(8) DEFAULT NULL,
  `OrderPlaced` int(1) DEFAULT NULL,
  `SubTotal` double DEFAULT NULL,
  `Shipping` double DEFAULT NULL,
  `Tax` double DEFAULT NULL,
  `Total` double DEFAULT NULL,
  `dtCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `Promo` int(2) DEFAULT NULL,
  `ShipFirstName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipLastName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipAddress` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipCity` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipState` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipZipCode` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipPhone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipFax` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillFirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillLastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillAddress` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillCity` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillState` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillZipCode` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillPhone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillFax` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dtOrdered` datetime DEFAULT CURRENT_TIMESTAMP,
  `ShipProvince` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShipCountry` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillProvince` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillCountry` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CardType` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CardNumber` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ExpMonth` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ExpYear` char(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CardName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipbill` char(1) COLLATE utf8_unicode_ci DEFAULT 'N',
  `ShipFlag` char(1) COLLATE utf8_unicode_ci DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_cart`
--

INSERT INTO `sp_cart` (`idCart`, `Quantity`, `idShopper`, `OrderPlaced`, `SubTotal`, `Shipping`, `Tax`, `Total`, `dtCreated`, `Promo`, `ShipFirstName`, `ShipLastName`, `ShipAddress`, `ShipCity`, `ShipState`, `ShipZipCode`, `ShipPhone`, `ShipFax`, `ShipEmail`, `BillFirstName`, `BillLastName`, `BillAddress`, `BillCity`, `BillState`, `BillZipCode`, `BillPhone`, `BillFax`, `BillEmail`, `dtOrdered`, `ShipProvince`, `ShipCountry`, `BillProvince`, `BillCountry`, `CardType`, `CardNumber`, `ExpMonth`, `ExpYear`, `CardName`, `shipbill`, `ShipFlag`) VALUES
(1, 1, 100, NULL, NULL, NULL, 20, NULL, '0000-00-00 00:00:00', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(9, 1, 100, NULL, NULL, NULL, 20, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(10, 1, 101, 1, 399.99, 5, 17.99955, 422.98955, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(11, 1, 101, NULL, NULL, NULL, 30, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(12, 1, 102, NULL, NULL, NULL, 40, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(13, 2, 102, NULL, NULL, NULL, 40, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(14, 1, 103, NULL, NULL, NULL, 50, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(15, 2, 103, NULL, NULL, NULL, 30, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N');

--
-- Triggers `sp_cart`
--
DELIMITER $$
CREATE TRIGGER `product_inventory_trgs` AFTER UPDATE ON `sp_cart` FOR EACH ROW BEGIN
declare lv_idcart int(8); 
 declare lv_firstname varchar(30);
 declare lv_lastname VARCHAR(30);
  declare lv_address varchar(100);
 declare lv_dtcreated date;
  declare lv_qty int(5);
 declare lv_productname VARCHAR(50);
  declare lv_description varchar(80);
 declare lv_phonetype VARCHAR(20);
  declare lv_color varchar(20);
 declare lv_grade VARCHAR(20);
declare lv_change_number DOUBLE; 
 declare lv_finished int(2);
 declare lv_idSmartPhones VARCHAR(16);
 declare lv_quantity int(8);
DECLARE cursor1 CURSOR FOR 
 SELECT idSmartPhones, quantity 
 FROM sp_cartitem
 WHERE idCart = NEW.idCart;
 
 DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET lv_finished = 1;
  
 OPEN cursor1;
 getRedcord: LOOP
 FETCH cursor1 INTO lv_idSmartPhones, lv_quantity;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord;
 END IF;
 if NEW.OrderPlaced = 1 then
 UPDATE sp_phones 
 SET stock = stock - lv_quantity 
 WHERE idSmartPhones = lv_idSmartPhones; 
end if;
BEGIN

DECLARE cursor2 CURSOR FOR 
SELECT c.idcart, firstname, lastname, address, dtcreated, ci.quantity, productname, description, phonetype, color, grade
FROM sp_shopper s, sp_cart c, sp_cartitem ci, sp_phones p
WHERE s.idshopper = c.idshopper and c.idcart = ci.idcart and ci.idsmartphones = p.idsmartphones and ci.idCart = NEW.idCart AND NEW.OrderPlaced = 1;

OPEN cursor2;
 getRedcord1: LOOP
 FETCH cursor2 INTO lv_idcart, lv_firstname,lv_lastname,lv_address,lv_dtcreated,lv_qty,lv_productname,lv_description,lv_phonetype, lv_color, lv_grade;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord1;
 END IF;
 if NEW.OrderPlaced = 1 then
insert into SP_phone_onlinesell_record(idonlineSaleHistory,idBasket,CustomerFName,customerLName,address,dtcreated,qtys,
productname,description,phonetype,color,grade,currentdate,actionTaken)
values(null, lv_idcart, lv_firstname, lv_lastname,lv_address,lv_dtcreated,lv_qty,
lv_productname,lv_description,lv_phonetype,lv_color,lv_grade,SYSDATE(), 'S-SOLD');
END IF;
 END LOOP getRedcord1;
 CLOSE cursor2; 

END;
 END LOOP getRedcord;
 CLOSE cursor1; 
 
 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sp_cartitem`
--

CREATE TABLE `sp_cartitem` (
  `idCartItem` int(8) NOT NULL,
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `Quantity` int(5) DEFAULT NULL,
  `idCart` int(8) DEFAULT NULL,
  `option1` int(2) DEFAULT NULL,
  `option2` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_cartitem`
--

INSERT INTO `sp_cartitem` (`idCartItem`, `idSmartPhones`, `Price`, `Quantity`, `idCart`, `option1`, `option2`) VALUES
(1, '11', 399.99, 1, 1, 1, 4),
(17, '11', 399.99, 1, 1, 1, 4),
(18, '11', 799.99, 2, 9, 2, 3),
(19, '12', 399.99, 1, 10, 3, 2),
(20, '13', 799.99, 2, 11, 2, 4),
(21, '14', 799.99, 1, 11, 1, 4),
(22, '15', 399.99, 1, 12, 1, 2),
(23, '16', 799.99, 2, 13, 2, 3),
(24, '17', 399.99, 1, 13, 1, 4),
(25, '18', 799.99, 1, 14, 1, 3),
(26, '19', 799.99, 2, 15, 1, 3),
(27, '20', 399.99, 1, 15, 2, 4),
(28, '21', 799.99, 1, 13, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sp_cartstatus`
--

CREATE TABLE `sp_cartstatus` (
  `idStatus` int(8) NOT NULL,
  `idCart` int(8) DEFAULT NULL,
  `idStage` int(1) DEFAULT NULL,
  `dtStage` date DEFAULT NULL,
  `Notes` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipper` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ShippingNum` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_companycustomer`
--

CREATE TABLE `sp_companycustomer` (
  `idCustomer` int(8) NOT NULL,
  `CCustomerName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CCustomerAddress` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CCustomercity` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CCustomerState` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CCustomerZip` char(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CCcustomerPhone` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_department`
--

CREATE TABLE `sp_department` (
  `idDepartment` int(3) NOT NULL,
  `DeptName` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `DeptDesc` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `DeptImage` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_department`
--

INSERT INTO `sp_department` (`idDepartment`, `DeptName`, `DeptDesc`, `DeptImage`) VALUES
(1, 'Whole Sale', 'sells all type of unlocked pho', 'office.png'),
(2, 'Retail', 'instore sells all type of unlo', 'store.png');

-- --------------------------------------------------------

--
-- Table structure for table `sp_invoiceitems`
--

CREATE TABLE `sp_invoiceitems` (
  `idInvoice` int(8) NOT NULL,
  `iditems` int(8) NOT NULL,
  `invoiceQuantity` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_invoicephone`
--

CREATE TABLE `sp_invoicephone` (
  `idInvoice` int(8) NOT NULL,
  `idCustomer` int(8) DEFAULT NULL,
  `InvoiceDate` date DEFAULT NULL,
  `invoiceTotal` double DEFAULT NULL,
  `invoiceQuantity` int(5) DEFAULT NULL,
  `PayStatus` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_items`
--

CREATE TABLE `sp_items` (
  `iditems` int(8) NOT NULL,
  `IMEI` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_online_orderprocess_record`
--

CREATE TABLE `sp_online_orderprocess_record` (
  `idonlineProcess` int(8) NOT NULL,
  `idBasket` int(8) DEFAULT NULL,
  `CustomerFName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customerLName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dtcreated` date DEFAULT NULL,
  `quantities` int(6) DEFAULT NULL,
  `productname` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonetype` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phones`
--

CREATE TABLE `sp_phones` (
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `sku` int(8) NOT NULL,
  `ProductName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `storageGB` int(5) NOT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `ProductImage` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `stock` int(8) NOT NULL,
  `SaleStart` date DEFAULT NULL,
  `SaleEnd` date DEFAULT NULL,
  `SalePrice` double DEFAULT NULL,
  `Active` int(1) DEFAULT NULL,
  `Featured` int(1) DEFAULT NULL,
  `FeatureStart` date DEFAULT NULL,
  `FeatureEnd` date DEFAULT NULL,
  `Type` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `idDepartment` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phones`
--

INSERT INTO `sp_phones` (`idSmartPhones`, `sku`, `ProductName`, `Description`, `PhoneType`, `color`, `storageGB`, `grade`, `ProductImage`, `Price`, `stock`, `SaleStart`, `SaleEnd`, `SalePrice`, `Active`, `Featured`, `FeatureStart`, `FeatureEnd`, `Type`, `idDepartment`) VALUES
('11', 1, 'iphone X', 'iphone X, 64 GB - Gold', 'iphoneX64orange', '', 64, 'orange', 'iphoneXS.png', 699.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('12', 1, 'iphone X', 'iphone X, 64 GB - Gold', 'iphoneX64green', '', 64, 'green', 'iphoneXS.png', 599.99, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('13', 1, 'iphone X', 'iphone X, 64 GB - Gold', 'iphoneX64yellow', '', 64, 'yellow', 'iphoneXS.png', 499.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('14', 1, 'iphone X', 'iphone X, 128 GB - Gold', 'iphoneX128orange', '', 128, 'orange', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('15', 1, 'iphone X', 'iphone X, 128 GB - Gold', 'iphoneX128green', '', 128, 'green', 'iphoneXS.png', 699.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('16', 1, 'iphone X', 'iphone X, 128 GB - Gold', 'iphoneX128yellow', '', 128, 'yellow', 'iphoneXS.png', 599.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('17', 1, 'iphone X', 'iphone X, 256 GB - Gold', 'iphoneX256orange', '', 256, 'orange', 'iphoneXS.png', 899.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('18', 1, 'iphone X', 'iphone X, 256 GB - Gold', 'iphoneX256green', '', 256, 'green', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('19', 1, 'iphone X', 'iphone X, 256 GB - Gold', 'iphoneX256yellow', '', 256, 'yellow', 'iphoneXS.png', 699.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('20', 1, 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS64orange', '', 64, 'orange', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('21', 1, 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS64green', '', 64, 'green', 'iphoneXS.png', 699.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('22', 1, 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS64yellow', '', 64, 'yellow', 'iphoneXS.png', 599.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('23', 1, 'iphone XS', 'iphone XS, 128 GB - Gold', 'iphoneXS128orange', '', 128, 'orange', 'iphoneXS.png', 899.99, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('24', 1, 'iphone XS', 'iphone XS, 128 GB - Gold', 'iphoneXS128green', '', 128, 'green', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('25', 1, 'iphone XS', 'iphone XS, 128 GB - Gold', 'iphoneXS128yellow', '', 128, 'yellow', 'iphoneXS.png', 699.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('26', 1, 'iphone XS', 'iphone XS, 256 GB - Gold', 'iphoneXS256orange', '', 256, 'orange', 'iphoneXS.png', 999.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('27', 1, 'iphone XS', 'iphone XS, 256 GB - Gold', 'iphoneXS256green', '', 256, 'green', 'iphoneXS.png', 899.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('28', 1, 'iphone XS', 'iphone XS, 256 GB - Gold', 'iphoneXS256yellow', '', 256, 'yellow', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sp_phonesoption`
--

CREATE TABLE `sp_phonesoption` (
  `idSmartPhonesoption` int(3) NOT NULL,
  `idoption` int(2) DEFAULT NULL,
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phonesoptioncategory`
--

CREATE TABLE `sp_phonesoptioncategory` (
  `idOptionCategory` int(5) NOT NULL,
  `CategoryName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phonesoptiondetail`
--

CREATE TABLE `sp_phonesoptiondetail` (
  `idoption` int(2) NOT NULL,
  `OptionName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `idOptionCategory` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phonespos`
--

CREATE TABLE `sp_phonespos` (
  `idphonepos` int(16) NOT NULL,
  `IMEI` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `PhoneName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProductImage` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `SaleStart` date DEFAULT NULL,
  `SaleEnd` date DEFAULT NULL,
  `SalePrice` double DEFAULT NULL,
  `Active` int(1) DEFAULT NULL,
  `idCustomer` varchar(9) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FeatureStart` date DEFAULT NULL,
  `FeatureEnd` date DEFAULT NULL,
  `Type` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phonespos`
--

INSERT INTO `sp_phonespos` (`idphonepos`, `IMEI`, `PhoneName`, `Description`, `PhoneType`, `color`, `grade`, `ProductImage`, `Price`, `SaleStart`, `SaleEnd`, `SalePrice`, `Active`, `idCustomer`, `FeatureStart`, `FeatureEnd`, `Type`) VALUES
(18, '12345678955433', 'iphone XS', 'iphone Xs, 128 GB - Gold', 'iphoneXS128orange', 'gold', 'orange', 'iphoneXS.png', 499.99, NULL, NULL, NULL, 1, NULL, NULL, NULL, '1'),
(19, '12345678955431', 'iphone X', 'iphone X, 64 GB - Gold', 'iphoneX64green', 'gold', 'green', 'iphoneXS.png', 499.99, NULL, NULL, NULL, 1, NULL, NULL, NULL, '1');

--
-- Triggers `sp_phonespos`
--
DELIMITER $$
CREATE TRIGGER `ADD_NEW_INVENTORY` AFTER INSERT ON `sp_phonespos` FOR EACH ROW BEGIN
	IF NEW.PhoneType IS NOT NULL THEN 
	update sp_phones
    SET STOCK = STOCK + 1
    WHERE PhoneType = NEW.PhoneType;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `phoneSale_history_trigs` AFTER DELETE ON `sp_phonespos` FOR EACH ROW BEGIN
	declare lv_idonlineProcess int(8);
	declare lv_finished int(2);
    declare lv_quantity int(6);
    DECLARE cursor1 CURSOR FOR 
 SELECT quantities, idonlineProcess
 FROM SP_Online_orderprocess_record
 WHERE idonlineProcess = idonlineProcess;
  DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET lv_finished = 1;
  OPEN cursor1;
 getRedcord: LOOP
 FETCH cursor1 INTO lv_quantity, lv_idonlineProcess;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord;
 END IF;
 if (lv_quantity > 1) then
 UPDATE SP_Online_orderprocess_record 
 SET quantities = quantities - 1
 WHERE idonlineProcess = lv_idonlineProcess; 
 
 INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType,sphonecolor, grade,Price, currentdate, actionTaken)
	VALUES(null,OLD.IMEI,OLD.PhoneName,OLD.Description,OLD.PhoneType, old.color, OLD.grade, OLD.Price, SYSDATE(), 'U-Sold');
 ELSE
 DELETE FROM SP_Online_orderprocess_record 
    WHERE OLD.PhoneType = Phonetype;
    
    INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType,sphonecolor, grade,Price, currentdate, actionTaken)
	VALUES(null,OLD.IMEI,OLD.PhoneName,OLD.Description,OLD.PhoneType, old.color, OLD.grade, OLD.Price, SYSDATE(), 'U-Sold');
end if;
 END LOOP getRedcord;
 CLOSE cursor1;
 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phones_request`
--

CREATE TABLE `sp_phones_request` (
  `idRequest` int(4) NOT NULL,
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dtrequest` datetime DEFAULT CURRENT_TIMESTAMP,
  `dtrecd` date DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `qty` int(5) DEFAULT NULL,
  `idvender` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phone_onlinesell_record`
--

CREATE TABLE `sp_phone_onlinesell_record` (
  `idonlineSaleHistory` int(8) NOT NULL,
  `idBasket` int(8) DEFAULT NULL,
  `CustomerFName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customerLName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dtcreated` date DEFAULT NULL,
  `qtys` int(6) NOT NULL,
  `productname` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonetype` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `sp_phone_onlinesell_record`
--
DELIMITER $$
CREATE TRIGGER `addTo_process_order_TRg` AFTER DELETE ON `sp_phone_onlinesell_record` FOR EACH ROW BEGIN
	

insert into SP_Online_orderprocess_record(idonlineProcess,idBasket,CustomerFName,customerLName,address,dtcreated,quantities,
productname,description,phonetype,color,grade,currentdate,actionTaken)
values(null, OLD.idBasket, OLD.CustomerFName, OLD.customerLName,OLD.address,OLD.dtcreated,OLD.qtys,
OLD.productname,OLD.description,OLD.phonetype,OLD.color,OLD.grade,SYSDATE(), 'S-SOLD');


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phone_sales_history`
--

CREATE TABLE `sp_phone_sales_history` (
  `idSaleHistory` int(8) NOT NULL,
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProductName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sphonecolor` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phone_sales_history`
--

INSERT INTO `sp_phone_sales_history` (`idSaleHistory`, `idSmartPhones`, `ProductName`, `Description`, `PhoneType`, `sphonecolor`, `grade`, `Price`, `currentdate`, `actionTaken`) VALUES
(4, '12345678955435', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-20 19:39:15', 'U-Sold'),
(5, '12345778905430', 'iphone8', 'iphone 8, 64 GB - Gold', 'iphone8', 'gold', 'orange', 799.99, '2020-02-20 19:50:07', 'U-Sold'),
(6, '12345678955435', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-20 19:53:56', 'U-Sold'),
(7, '12345678955431', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-20 20:48:04', 'U-Sold'),
(8, '12345678955432', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-20 20:49:12', 'U-Sold'),
(9, '12345778905437', 'iphone8', 'iphone 8, 64 GB - Gold', 'iphone8', 'gold', 'orange', 799.99, '2020-02-20 21:03:51', 'U-Sold'),
(10, '12345778905437', 'iphone8', 'iphone 8, 64 GB - Gold', 'iphone8', 'gold', 'orange', 799.99, '2020-02-20 21:03:51', 'U-Sold'),
(11, '12345678955434', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-21 22:34:56', 'U-Sold'),
(12, '12345678955434', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'orange', 799.99, '2020-02-21 22:34:56', 'U-Sold'),
(13, '12345778905438', 'iphone8', 'iphone 8, 64 GB - Gold', 'iphone8', 'gold', 'orange', 799.99, '2020-02-21 23:29:03', 'U-Sold'),
(14, '12345778905439', 'iphone8', 'iphone 8, 64 GB - Gold', 'iphone8', 'gold', 'orange', 799.99, '2020-02-21 23:29:58', 'U-Sold'),
(15, '12345678955431', 'iphone X', 'iphone X, 64 GB - Gold', 'iphoneX64green', 'gold', 'green', 499.99, '2020-02-21 23:41:28', 'U-Sold');

-- --------------------------------------------------------

--
-- Table structure for table `sp_promolist`
--

CREATE TABLE `sp_promolist` (
  `idshopper` int(8) NOT NULL,
  `month` char(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `year` char(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `promo_flag` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Used` char(1) COLLATE utf8_unicode_ci DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_shipping`
--

CREATE TABLE `sp_shipping` (
  `idRange` int(5) NOT NULL,
  `Low` int(3) DEFAULT NULL,
  `High` int(3) DEFAULT NULL,
  `Fee` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_shipping`
--

INSERT INTO `sp_shipping` (`idRange`, `Low`, `High`, `Fee`) VALUES
(1, 1, 1, 5),
(2, 6, 20, 10),
(3, 21, 999, 15);

--
-- Triggers `sp_shipping`
--
DELIMITER $$
CREATE TRIGGER `online_sale_history_trig` AFTER UPDATE ON `sp_shipping` FOR EACH ROW BEGIN
declare lv_finished int(2);
declare lv_idcart int(8); 
 declare lv_firstname varchar(30);
 declare lv_lastname VARCHAR(30);
  declare lv_address varchar(100);
 declare lv_dtcreated date;
  declare lv_qty int(5);
 declare lv_productname VARCHAR(50);
  declare lv_description varchar(80);
 declare lv_phonetype VARCHAR(20);
  declare lv_color varchar(20);
 declare lv_grade VARCHAR(20);
 
DECLARE cursor1 CURSOR FOR 

SELECT c.idcart, firstname, lastname, address, dtcreated, ci.quantity, productname, description, phonetype, color, grade
FROM sp_shopper s, sp_cart c, sp_cartitem ci, sp_phones p
WHERE s.idshopper = c.idshopper and c.idcart = ci.idcart and ci.idsmartphones = p.idsmartphones and c.orderplaced = 1;
 
 DECLARE CONTINUE HANDLER 
 FOR NOT FOUND SET lv_finished = 1;
 OPEN cursor1;
 getRedcord: LOOP
 FETCH cursor1 INTO lv_idcart, lv_firstname,lv_lastname,lv_address,lv_dtcreated,lv_qty,lv_productname,lv_description,lv_phonetype, lv_color, lv_grade;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord;
 END IF;
 if NEW.high = 1 then
insert into SP_phone_onlinesell_record(idonlineSaleHistory,idBasket,CustomerFName,customerLName,address,dtcreated,qtys,
productname,description,phonetype,color,grade,currentdate,actionTaken)
values(null, lv_idcart, lv_firstname, lv_lastname,lv_address,lv_dtcreated,lv_qty,
lv_productname,lv_description,lv_phonetype,lv_color,lv_grade,SYSDATE(), 'S-SOLD');
end if;
 END LOOP getRedcord;
 CLOSE cursor1; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sp_shopper`
--

CREATE TABLE `sp_shopper` (
  `idShopper` int(8) NOT NULL,
  `FirstName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `City` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `State` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ZipCode` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fax` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UserName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Password` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Cookie` int(4) DEFAULT '0',
  `dtEntered` datetime DEFAULT CURRENT_TIMESTAMP,
  `Province` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_shopper`
--

INSERT INTO `sp_shopper` (`idShopper`, `FirstName`, `LastName`, `Address`, `City`, `State`, `ZipCode`, `Phone`, `Fax`, `Email`, `UserName`, `Password`, `Cookie`, `dtEntered`, `Province`, `Country`) VALUES
(100, 'Tim', 'Tran', '1400 University St.', 'Fairfax', 'VA', '22033', '7031234567', NULL, 'smartphonedepot@gmail.com', 'user1', '123456', 1, '0000-00-00 00:00:00', NULL, 'USA'),
(101, 'Alana', 'Young', '1401 University St.', 'Fairfax', 'VA', '22033', '7031234576', NULL, 'smartphonedepot@gmail.com', 'user2', '123456', 1, '0000-00-00 00:00:00', NULL, 'USA'),
(102, 'Heiwad', '', '1402 University St.', 'Fairfax', 'VA', '22033', '7031234576', NULL, 'smartphonedepot@gmail.com', 'user3', '12345678', 1, '0000-00-00 00:00:00', NULL, 'USA'),
(103, 'Harman', 'Waraich', '1403 University St.', 'Fairfax', 'VA', '22033', '7031234578', NULL, 'smartphonedepot@gmail.com', 'user4', '123456', 1, '0000-00-00 00:00:00', NULL, 'USA'),
(118, 'Enujin', 'Song', '4400 university', 'fairfax', 'VA', '22033', NULL, NULL, NULL, 'user5', '$2y$10$.bpgYrPCXGNepL.aPGHAMeM5cPS/xWL7MtN/9T12gnXaLfqxdSeia', 0, '2020-01-13 00:11:18', NULL, NULL),
(119, 'ti', 'tei', '123 fairfax', 'woodbridge', '- ', '22191', NULL, NULL, NULL, 'harman', '$2y$10$tmxKb386mwwPIxdO10R4.eoRK6WykGdhFH9J.h4wYdTARXb11tQZa', 0, '2020-01-17 18:55:07', NULL, NULL),
(120, 'arian', 'arabshahi', '123 test street', 'sterling', 'VA', '20166', NULL, NULL, NULL, 'arian.arabshahi123', '$2y$10$yh44X2JePJfRp/FeBl.IM.TfSDx/uPAyrCSSbbLS0qx7/lvhjdHsW', 0, '2020-01-17 19:31:36', NULL, NULL),
(121, 'tim', 'tran', '1412 main st', 'fairfax', 'VA', '23423', NULL, NULL, NULL, 'tim', '$2y$10$Q/H5FgwzcWwWaQY7zoYgF.f4g3D8sLz10QpRFymh66lTryh/86guC', 0, '2020-02-01 10:19:27', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sp_shop_sales`
--

CREATE TABLE `sp_shop_sales` (
  `idshopper` int(8) DEFAULT NULL,
  `total` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_tax`
--

CREATE TABLE `sp_tax` (
  `idState` int(2) NOT NULL,
  `State` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaxRate` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_tax`
--

INSERT INTO `sp_tax` (`idState`, `State`, `TaxRate`) VALUES
(1, 'VA', 0.045),
(2, 'NC', 0.03),
(3, 'DC', 0.06);

-- --------------------------------------------------------

--
-- Table structure for table `sp_trans_log`
--

CREATE TABLE `sp_trans_log` (
  `shopper` int(8) DEFAULT NULL,
  `appaction` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `errcode` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `errmsg` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `loginadmin`
--
ALTER TABLE `loginadmin`
  ADD PRIMARY KEY (`idadmin`),
  ADD UNIQUE KEY `adminUsername` (`adminUsername`);

--
-- Indexes for table `sp_cart`
--
ALTER TABLE `sp_cart`
  ADD PRIMARY KEY (`idCart`),
  ADD KEY `basket_idshopper_fk` (`idShopper`);

--
-- Indexes for table `sp_cartitem`
--
ALTER TABLE `sp_cartitem`
  ADD PRIMARY KEY (`idCartItem`),
  ADD KEY `basktitems_bsktid_fk` (`idCart`),
  ADD KEY `basktitems_idprod_fk` (`idSmartPhones`);

--
-- Indexes for table `sp_cartstatus`
--
ALTER TABLE `sp_cartstatus`
  ADD PRIMARY KEY (`idStatus`),
  ADD KEY `BasketStatuses_idCart_fk` (`idCart`);

--
-- Indexes for table `sp_companycustomer`
--
ALTER TABLE `sp_companycustomer`
  ADD PRIMARY KEY (`idCustomer`);

--
-- Indexes for table `sp_department`
--
ALTER TABLE `sp_department`
  ADD PRIMARY KEY (`idDepartment`);

--
-- Indexes for table `sp_invoiceitems`
--
ALTER TABLE `sp_invoiceitems`
  ADD PRIMARY KEY (`idInvoice`,`iditems`),
  ADD KEY `idinvoice_items_fk` (`iditems`);

--
-- Indexes for table `sp_invoicephone`
--
ALTER TABLE `sp_invoicephone`
  ADD PRIMARY KEY (`idInvoice`),
  ADD KEY `idinvoice_idcustomer_fk` (`idCustomer`);

--
-- Indexes for table `sp_items`
--
ALTER TABLE `sp_items`
  ADD PRIMARY KEY (`iditems`);

--
-- Indexes for table `sp_online_orderprocess_record`
--
ALTER TABLE `sp_online_orderprocess_record`
  ADD PRIMARY KEY (`idonlineProcess`);

--
-- Indexes for table `sp_phones`
--
ALTER TABLE `sp_phones`
  ADD PRIMARY KEY (`idSmartPhones`),
  ADD KEY `prodduct_idDept_fk` (`idDepartment`);

--
-- Indexes for table `sp_phonesoption`
--
ALTER TABLE `sp_phonesoption`
  ADD PRIMARY KEY (`idSmartPhonesoption`),
  ADD KEY `prodoption_prodid_fk` (`idSmartPhones`);

--
-- Indexes for table `sp_phonesoptioncategory`
--
ALTER TABLE `sp_phonesoptioncategory`
  ADD PRIMARY KEY (`idOptionCategory`);

--
-- Indexes for table `sp_phonesoptiondetail`
--
ALTER TABLE `sp_phonesoptiondetail`
  ADD PRIMARY KEY (`idoption`),
  ADD KEY `prodoptdettail_idoptcat_fk` (`idOptionCategory`);

--
-- Indexes for table `sp_phonespos`
--
ALTER TABLE `sp_phonespos`
  ADD PRIMARY KEY (`idphonepos`);

--
-- Indexes for table `sp_phones_request`
--
ALTER TABLE `sp_phones_request`
  ADD PRIMARY KEY (`idRequest`),
  ADD KEY `prodrequest_idprod_fk` (`idSmartPhones`);

--
-- Indexes for table `sp_phone_onlinesell_record`
--
ALTER TABLE `sp_phone_onlinesell_record`
  ADD PRIMARY KEY (`idonlineSaleHistory`);

--
-- Indexes for table `sp_phone_sales_history`
--
ALTER TABLE `sp_phone_sales_history`
  ADD PRIMARY KEY (`idSaleHistory`);

--
-- Indexes for table `sp_promolist`
--
ALTER TABLE `sp_promolist`
  ADD UNIQUE KEY `promote_uk` (`idshopper`,`month`,`year`);

--
-- Indexes for table `sp_shipping`
--
ALTER TABLE `sp_shipping`
  ADD PRIMARY KEY (`idRange`);

--
-- Indexes for table `sp_shopper`
--
ALTER TABLE `sp_shopper`
  ADD PRIMARY KEY (`idShopper`);

--
-- Indexes for table `sp_tax`
--
ALTER TABLE `sp_tax`
  ADD PRIMARY KEY (`idState`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `loginadmin`
--
ALTER TABLE `loginadmin`
  MODIFY `idadmin` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `sp_cart`
--
ALTER TABLE `sp_cart`
  MODIFY `idCart` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `sp_cartitem`
--
ALTER TABLE `sp_cartitem`
  MODIFY `idCartItem` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `sp_cartstatus`
--
ALTER TABLE `sp_cartstatus`
  MODIFY `idStatus` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_companycustomer`
--
ALTER TABLE `sp_companycustomer`
  MODIFY `idCustomer` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_department`
--
ALTER TABLE `sp_department`
  MODIFY `idDepartment` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sp_invoicephone`
--
ALTER TABLE `sp_invoicephone`
  MODIFY `idInvoice` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_items`
--
ALTER TABLE `sp_items`
  MODIFY `iditems` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_online_orderprocess_record`
--
ALTER TABLE `sp_online_orderprocess_record`
  MODIFY `idonlineProcess` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_phonespos`
--
ALTER TABLE `sp_phonespos`
  MODIFY `idphonepos` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `sp_phone_onlinesell_record`
--
ALTER TABLE `sp_phone_onlinesell_record`
  MODIFY `idonlineSaleHistory` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_phone_sales_history`
--
ALTER TABLE `sp_phone_sales_history`
  MODIFY `idSaleHistory` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `sp_promolist`
--
ALTER TABLE `sp_promolist`
  MODIFY `idshopper` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_shopper`
--
ALTER TABLE `sp_shopper`
  MODIFY `idShopper` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `sp_cart`
--
ALTER TABLE `sp_cart`
  ADD CONSTRAINT `basket_idshopper_fk` FOREIGN KEY (`idShopper`) REFERENCES `sp_shopper` (`idShopper`);

--
-- Constraints for table `sp_cartitem`
--
ALTER TABLE `sp_cartitem`
  ADD CONSTRAINT `basktitems_bsktid_fk` FOREIGN KEY (`idCart`) REFERENCES `sp_cart` (`idCart`),
  ADD CONSTRAINT `basktitems_idprod_fk` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`);

--
-- Constraints for table `sp_cartstatus`
--
ALTER TABLE `sp_cartstatus`
  ADD CONSTRAINT `BasketStatuses_idCart_fk` FOREIGN KEY (`idCart`) REFERENCES `sp_cart` (`idCart`);

--
-- Constraints for table `sp_invoiceitems`
--
ALTER TABLE `sp_invoiceitems`
  ADD CONSTRAINT `idinvoice_invoiceitems_fk` FOREIGN KEY (`idInvoice`) REFERENCES `sp_invoicephone` (`idInvoice`),
  ADD CONSTRAINT `idinvoice_items_fk` FOREIGN KEY (`iditems`) REFERENCES `sp_items` (`iditems`);

--
-- Constraints for table `sp_invoicephone`
--
ALTER TABLE `sp_invoicephone`
  ADD CONSTRAINT `idinvoice_idcustomer_fk` FOREIGN KEY (`idCustomer`) REFERENCES `sp_companycustomer` (`idCustomer`);

--
-- Constraints for table `sp_phones`
--
ALTER TABLE `sp_phones`
  ADD CONSTRAINT `prodduct_idDept_fk` FOREIGN KEY (`idDepartment`) REFERENCES `sp_department` (`idDepartment`);

--
-- Constraints for table `sp_phonesoption`
--
ALTER TABLE `sp_phonesoption`
  ADD CONSTRAINT `prodoption_prodid_fk` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`);

--
-- Constraints for table `sp_phonesoptiondetail`
--
ALTER TABLE `sp_phonesoptiondetail`
  ADD CONSTRAINT `prodoptdettail_idoptcat_fk` FOREIGN KEY (`idOptionCategory`) REFERENCES `sp_phonesoptioncategory` (`idOptionCategory`);

--
-- Constraints for table `sp_phones_request`
--
ALTER TABLE `sp_phones_request`
  ADD CONSTRAINT `prodrequest_idprod_fk` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`);

--
-- Constraints for table `sp_promolist`
--
ALTER TABLE `sp_promolist`
  ADD CONSTRAINT `promote_idshopper_fk` FOREIGN KEY (`idshopper`) REFERENCES `sp_shopper` (`idShopper`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
