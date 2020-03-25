-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 11, 2020 at 02:26 AM
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
(7, 'user3', 'fcea920f7412b5da7be0cf42b8c93759', 'level2'),
(8, 'user9', '25f9e794323b453885f5181f1b624d0b', 'admin'),
(10, 'tim', 'c20ad4d76fe97759aa27a0c99bff6710', 'level2'),
(24, 'user4', '25f9e794323b453885f5181f1b624d0b', 'user'),
(25, 'user6', '25f9e794323b453885f5181f1b624d0b', 'user');

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
(1, 1, 100, 0, 399.99, 5, 20, 419.99, '2020-01-02 02:12:06', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:14:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(2, 1, 100, 0, 799.99, 6, 20, 819.99, '2020-01-01 08:34:17', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:16:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(3, 1, 101, 0, 799.99, 7, 30, 829.99, '2020-01-01 13:06:19', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:17:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(4, 1, 101, 0, 399.99, 8, 30, 429.99, '2020-01-01 17:10:38', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(5, 4, 102, 1, 2100.96, 5, 94.5432, 2200.5032, '2020-01-01 06:36:07', 0, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(6, 2, 102, 0, 799.99, 8, 40, 829.99, '2020-01-01 19:08:40', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(7, 1, 103, 0, 399.99, 5, 17.99955, 422.98955, '2020-01-01 05:26:43', 0, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(8, 2, 103, 0, 799.99, 7, 30, 829.99, '2020-01-01 09:35:03', 0, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 22:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N');

--
-- Triggers `sp_cart`
--
DELIMITER $$
CREATE TRIGGER `product_inventory_trgs` AFTER UPDATE ON `sp_cart` FOR EACH ROW BEGIN
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
(1, '123456789123456', 399.99, 1, 1, 1, 4),
(2, '987654321234567', 799.99, 2, 2, 2, 3),
(3, '123456789123456', 399.99, 1, 2, 3, 2),
(4, '987654321234567', 799.99, 2, 3, 2, 4),
(5, '987654321234567', 799.99, 1, 1, 1, 4),
(6, '123456789123456', 399.99, 1, 3, 1, 2),
(7, '987654321234567', 799.99, 2, 4, 2, 3),
(8, '123456789123456', 399.99, 1, 5, 1, 4),
(9, '987654321234567', 799.99, 1, 4, 1, 3),
(10, '987654321234567', 799.99, 2, 6, 1, 3),
(11, '123456789123456', 399.99, 1, 7, 2, 4),
(12, '987654321234567', 799.99, 1, 8, 1, 1),
(14, '987654321234567', 500.99, 1, 5, 2, 4),
(15, '987654321234567', 599.99, 2, 5, 2, 4);

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

--
-- Dumping data for table `sp_cartstatus`
--

INSERT INTO `sp_cartstatus` (`idStatus`, `idCart`, `idStage`, `dtStage`, `Notes`, `shipper`, `ShippingNum`) VALUES
(1, 1, 1, '2020-01-10', NULL, NULL, NULL),
(2, 1, 5, '2020-01-11', NULL, NULL, NULL),
(3, 2, 1, '2020-01-12', NULL, NULL, NULL),
(4, 2, 5, '2020-01-13', NULL, NULL, NULL),
(5, 3, 1, '2020-01-14', NULL, NULL, NULL);

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
-- Table structure for table `sp_phones`
--

CREATE TABLE `sp_phones` (
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `sku` int(8) NOT NULL,
  `ProductName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
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

INSERT INTO `sp_phones` (`idSmartPhones`, `sku`, `ProductName`, `Description`, `PhoneType`, `color`, `grade`, `ProductImage`, `Price`, `stock`, `SaleStart`, `SaleEnd`, `SalePrice`, `Active`, `Featured`, `FeatureStart`, `FeatureEnd`, `Type`, `idDepartment`) VALUES
('123456789123456', 14, 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'silver', 'orange', 'iphone8.png', 399.99, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
('987654321234567', 14, 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'gold', 'green', 'iphoneXS.png', 799.99, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1);

--
-- Triggers `sp_phones`
--
DELIMITER $$
CREATE TRIGGER `phoneSale_history_trigs` AFTER UPDATE ON `sp_phones` FOR EACH ROW BEGIN
	
IF OLD.stock <> NEW.stock THEN
	INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType,grade,Price, currentdate, actionTaken)
	VALUES(null,OLD.idSmartPhones,OLD.ProductName,OLD.Description,OLD.PhoneType, OLD.grade, OLD.Price, SYSDATE(), 'U-Sold');
ELSE
	INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType,grade,Price, currentdate, actionTaken)
	VALUES(null,OLD.idSmartPhones,OLD.ProductName,OLD.Description,OLD.PhoneType, OLD.grade, OLD.Price, SYSDATE(), 'D-delete');
END IF;
END
$$
DELIMITER ;

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
  `IMEI` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `PhoneName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProductImage` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `SaleStart` date DEFAULT NULL,
  `SaleEnd` date DEFAULT NULL,
  `SalePrice` double DEFAULT NULL,
  `Active` int(1) DEFAULT NULL,
  `Featured` int(1) DEFAULT NULL,
  `FeatureStart` date DEFAULT NULL,
  `FeatureEnd` date DEFAULT NULL,
  `Type` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
-- Table structure for table `sp_phone_sales_history`
--

CREATE TABLE `sp_phone_sales_history` (
  `idSaleHistory` int(8) NOT NULL,
  `idSmartPhones` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProductName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phone_sales_history`
--

INSERT INTO `sp_phone_sales_history` (`idSaleHistory`, `idSmartPhones`, `ProductName`, `Description`, `PhoneType`, `grade`, `Price`, `currentdate`, `actionTaken`) VALUES
(77, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-08 12:10:41', 'U-Sold'),
(78, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-08 12:11:24', 'U-Sold'),
(79, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-08 12:11:24', 'U-Sold'),
(80, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-08 12:11:24', 'U-Sold'),
(81, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-17 18:40:26', 'U-Sold'),
(82, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 18:40:38', 'U-Sold'),
(83, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-17 19:14:11', 'U-Sold'),
(84, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 19:14:11', 'U-Sold'),
(85, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 19:14:11', 'U-Sold'),
(86, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 19:34:31', 'U-Sold'),
(87, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-17 19:34:44', 'U-Sold'),
(88, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-01-17 19:37:52', 'U-Sold'),
(89, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 19:37:52', 'U-Sold'),
(90, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-01-17 19:37:52', 'U-Sold'),
(91, '123456789123456', 'iphone 8', 'iphone 8, 64 GB - silver', 'iphone8', 'orange', 399.99, '2020-02-01 12:26:23', 'U-Sold'),
(92, '987654321234567', 'iphone XS', 'iphone XS, 64 GB - Gold', 'iphoneXS', 'green', 799.99, '2020-02-01 12:26:37', 'U-Sold');

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
(1, 1, 5, 5),
(2, 6, 20, 10),
(3, 21, 999, 15);

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
  ADD PRIMARY KEY (`IMEI`);

--
-- Indexes for table `sp_phones_request`
--
ALTER TABLE `sp_phones_request`
  ADD PRIMARY KEY (`idRequest`),
  ADD KEY `prodrequest_idprod_fk` (`idSmartPhones`);

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
  MODIFY `idadmin` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `sp_cart`
--
ALTER TABLE `sp_cart`
  MODIFY `idCart` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sp_cartitem`
--
ALTER TABLE `sp_cartitem`
  MODIFY `idCartItem` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `sp_cartstatus`
--
ALTER TABLE `sp_cartstatus`
  MODIFY `idStatus` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- AUTO_INCREMENT for table `sp_phone_sales_history`
--
ALTER TABLE `sp_phone_sales_history`
  MODIFY `idSaleHistory` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

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
