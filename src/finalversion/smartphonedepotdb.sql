-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 22, 2020 at 07:34 PM
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
 RETURN round(lv_sub_num,2);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tax_calc_sfuntion` (`f_id` INT(8), `f_subtotal` DOUBLE) RETURNS DOUBLE NO SQL
BEGIN
declare lv_tax_num double;
 SELECT f_subtotal*t.taxrate tax
  INTO lv_tax_num
  FROM sp_cart b, sp_tax t
  WHERE b.shipstate = t.state
   AND b.idCart = f_id;
  RETURN ROUND(lv_tax_num,2);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `colors`
--

CREATE TABLE `colors` (
  `C_ID` int(11) NOT NULL,
  `C_DESC` varchar(100) NOT NULL,
  `C_HEX` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `colors`
--

INSERT INTO `colors` (`C_ID`, `C_DESC`, `C_HEX`) VALUES
(1, 'Gold', '#E8D8C1'),
(2, 'Silver', '#DCDCDC'),
(3, 'Space Gray', '#C2C3C8'),
(4, 'Rose Gold', '#F1C8C2'),
(5, 'Black', '#000');

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
(29, 'user9', '25f9e794323b453885f5181f1b624d0b', 'admin'),
(31, 'smartphoneDepot', '25f9e794323b453885f5181f1b624d0b', 'admin'),
(32, 'timtran', '25f9e794323b453885f5181f1b624d0b', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `phones`
--

CREATE TABLE `phones` (
  `P_ID` int(11) NOT NULL,
  `P_SKU` int(4) DEFAULT NULL,
  `P_MODEL` varchar(100) NOT NULL,
  `P_DESC` varchar(500) NOT NULL,
  `P_IMG` varchar(100) NOT NULL,
  `P_STATUS` char(1) NOT NULL DEFAULT 'Y',
  `P_FEATURED_START` date DEFAULT NULL,
  `P_FEATURED_END` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phones`
--

INSERT INTO `phones` (`P_ID`, `P_SKU`, `P_MODEL`, `P_DESC`, `P_IMG`, `P_STATUS`, `P_FEATURED_START`, `P_FEATURED_END`) VALUES
(1, NULL, 'iPhone 6', 'Factory Unlocked\r\nApple A8 chip with M8 motion coprocessor\r\nSoftware version: iOS 12.4.4\r\n4G LTE speed\r\n4.7″ Retina touch screen with IPS technology\r\n8 MP rear-facing camera and front-facing 1.2 MP camera for self-portraits and video.\r\nCloud support lets you access your files anywhere\r\n\r\n', 'images/iPhone%206/space%20grey/front.jpg', 'Y', NULL, NULL),
(2, NULL, 'iPhone 6 Plus', 'Factory Unlocked\r\nApple A8 chip with M8 motion coprocessor\r\nSoftware version: iOS 12.4.4\r\n4G LTE speed\r\n5.5″ Retina touch screen with IPS technology\r\n8 MP rear-facing camera and front-facing 1.2 MP camera for self-portraits and video.\r\nCloud support lets you access your files anywhere\r\nTouch ID keeps your phone secure', 'images/iPhone%206%20Plus/gold/front.jpg', 'Y', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `phone_colors`
--

CREATE TABLE `phone_colors` (
  `PC_ID` int(11) NOT NULL,
  `PC_QUANTITY` int(11) NOT NULL,
  `P_OPT_ID` int(11) NOT NULL,
  `C_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phone_colors`
--

INSERT INTO `phone_colors` (`PC_ID`, `PC_QUANTITY`, `P_OPT_ID`, `C_ID`) VALUES
(1, 67, 1, 1),
(2, 66, 1, 2),
(3, 67, 1, 3),
(4, 67, 2, 1),
(5, 66, 2, 2),
(6, 67, 2, 3),
(7, 67, 3, 1),
(8, 66, 3, 2),
(9, 67, 2, 1),
(10, 66, 2, 2),
(11, 67, 2, 3),
(12, 67, 3, 1),
(13, 66, 3, 2),
(14, 67, 3, 3),
(15, 67, 4, 1),
(16, 66, 4, 2),
(17, 67, 4, 3),
(18, 67, 5, 1),
(19, 66, 5, 2),
(20, 67, 5, 3),
(21, 67, 6, 1),
(22, 66, 6, 2),
(23, 67, 6, 3),
(24, 67, 7, 1),
(25, 66, 7, 2),
(26, 67, 7, 3),
(27, 67, 8, 1),
(28, 66, 8, 2),
(29, 67, 8, 3);

-- --------------------------------------------------------

--
-- Table structure for table `phone_grades`
--

CREATE TABLE `phone_grades` (
  `P_GRADE_ID` int(11) NOT NULL,
  `P_GRADE` char(1) NOT NULL,
  `P_GRADE_DESC` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phone_grades`
--

INSERT INTO `phone_grades` (`P_GRADE_ID`, `P_GRADE`, `P_GRADE_DESC`) VALUES
(1, 'A', 'No Crack\r\nNo Chip\r\nNo Watermark\r\nNo Scratches\r\nNo Major Dent\r\nScratches Less Than 50%\r\nNo Engraving or Removed Engraving\r\nNo Visible Scratches on Screen\r\nVery Minimal Signs of Wear'),
(2, 'B', 'No Crack\r\nEdge Chip < 2.0mm Acceptable\r\nVisible Scratches Acceptable\r\nWatermark No Bigger Than a Dime Acceptable\r\nMinor Dent\r\nRemoved Engraving Acceptable\r\nSome Signs of Wear'),
(3, 'C', 'No Crack\r\nEdge Chip < 5.0mm Acceptable\r\nVisible Scratches\r\nPossible Dent\r\nHeavy Signs of Wear');

-- --------------------------------------------------------

--
-- Table structure for table `phone_options`
--

CREATE TABLE `phone_options` (
  `P_OPT_ID` int(11) NOT NULL,
  `P_PRICE` decimal(10,0) NOT NULL,
  `P_QUANTITY` int(11) NOT NULL,
  `P_OPT_SALE_ST` datetime DEFAULT NULL,
  `P_OPT_SALE_END` datetime DEFAULT NULL,
  `P_GRADE_ID` int(11) NOT NULL,
  `P_STG_ID` int(11) NOT NULL,
  `P_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phone_options`
--

INSERT INTO `phone_options` (`P_OPT_ID`, `P_PRICE`, `P_QUANTITY`, `P_OPT_SALE_ST`, `P_OPT_SALE_END`, `P_GRADE_ID`, `P_STG_ID`, `P_ID`) VALUES
(1, '125', 200, NULL, NULL, 1, 1, 1),
(2, '150', 143, NULL, NULL, 1, 3, 1),
(3, '120', 200, NULL, NULL, 2, 1, 1),
(4, '140', 200, NULL, NULL, 2, 3, 1),
(5, '175', 198, NULL, NULL, 1, 1, 2),
(6, '160', 200, NULL, NULL, 2, 1, 2),
(7, '200', 199, NULL, NULL, 1, 3, 2),
(8, '185', 200, NULL, NULL, 2, 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `phone_storage`
--

CREATE TABLE `phone_storage` (
  `P_STG_ID` int(11) NOT NULL,
  `P_STG_SIZE` int(11) NOT NULL,
  `P_STG_UNIT` char(2) NOT NULL DEFAULT 'GB'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phone_storage`
--

INSERT INTO `phone_storage` (`P_STG_ID`, `P_STG_SIZE`, `P_STG_UNIT`) VALUES
(1, 16, 'GB'),
(2, 32, 'GB'),
(3, 64, 'GB'),
(4, 128, 'GB'),
(5, 256, 'GB');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `idSmartPhones` int(16) NOT NULL,
  `productName` varchar(100) NOT NULL,
  `name` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `idSmartPhones`, `productName`, `name`) VALUES
(77, 16, 'iphone X', 'p11.jpg'),
(78, 17, 'iphone X', 'p12.jpg'),
(79, 15, 'iphone X', 'p21.jpg'),
(80, 14, 'iphone X', 'p22.jpg'),
(81, 13, 'iphone X', 'p31.jpg'),
(82, 12, 'iphone X', 'p32.jpg'),
(83, 11, 'iphone X', 'p41.jpg'),
(84, 18, 'iphone X', 'p51.jpg'),
(85, 19, 'iphone X', 'p52.jpg'),
(86, 20, 'iphone XS', 'p61.jpg'),
(87, 21, 'iphone XS', 'p62.jpg'),
(89, 22, 'iphone XS', 'p71.jpg'),
(90, 23, 'iphone XS', 'p72.jpg'),
(91, 24, 'iphone XS', 'p81.jpg'),
(92, 25, 'iphone XS', 'p82.jpg'),
(93, 26, 'iphone XS', 'p92.jpg'),
(94, 27, 'iphone XS', 'p91.jpg'),
(95, 28, 'iphone XS', 'p92.jpg'),
(96, 31, 'iphone XS', 'p101.jpg'),
(97, 15, 'iphone X', 'p102.jpg'),
(98, 16, 'iphone X', 'p103.jpg'),
(99, 17, 'iphone X', 'p111.jpg'),
(100, 18, 'iphone X', 'p112.jpg'),
(101, 19, 'iphone X', 'p113.jpg'),
(102, 20, 'iphone XS', 'p121.jpg'),
(103, 21, 'iphone XS', 'p122.jpg'),
(104, 22, 'iphone XS', 'p131.jpg'),
(134, 22, 'iphone XS', 'p51.jpg'),
(135, 22, 'iphone XS', 'p21.jpg'),
(137, 22, 'iphone XS', 'p31.jpg'),
(138, 22, 'iphone XS', 'p21.jpg'),
(139, 22, 'iphone XS', 'p21.jpg'),
(140, 11, 'iphone X', 'p21.jpg'),
(141, 11, 'iphone X', 'p21.jpg'),
(143, 19, 'iphone X', 'p21.jpg');

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
  `idCart` int(16) NOT NULL,
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
(1, 1, 100, 0, NULL, NULL, 20, NULL, '0000-00-00 00:00:00', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(9, 2, 100, 1, 1599.98, 5, 72, 1676.98, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(10, 1, 101, 1, 399.99, 5, 18, 422.99, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(11, 3, 101, 1, 2399.97, 5, 108, 2512.97, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(12, 1, 102, 0, NULL, NULL, 40, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(13, 4, 102, 1, 2799.96, 5, 126, 2930.96, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(14, 1, 103, 1, 799.99, 5, 36, 840.99, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(15, 2, 103, 0, NULL, NULL, 30, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-21 20:16:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(16, 1, 100, 1, 399.99, 5, 18, 422.99, '2020-03-20 10:36:11', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-20 10:36:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(26, 2, 101, 1, 1599.98, 5, NULL, NULL, '2020-03-20 12:48:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-20 12:48:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(41, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-03-25 17:55:05', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-25 17:55:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(42, NULL, 122, 0, NULL, NULL, NULL, NULL, '2020-03-25 19:03:05', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-25 19:03:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(43, NULL, 122, 0, NULL, NULL, NULL, NULL, '2020-03-25 19:03:41', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-25 19:03:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(44, 3, 122, 1, 1897, 5, 85.36, 1987.36, '2020-03-27 09:34:16', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-27 09:34:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(45, 2, 123, 1, 1398, 5, 62.91, 1465.91, '2020-03-27 13:03:36', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-27 13:03:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(46, 3, 123, 1, 1897, 5, 85.36, 1987.36, '2020-03-27 13:06:31', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-27 13:06:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(47, 2, 123, 1, 1398, 5, 62.91, 1465.91, '2020-03-27 13:08:22', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-27 13:08:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(48, 1, 123, 1, 599, 5, 26.96, 630.96, '2020-03-27 13:09:37', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-27 13:09:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(49, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-03-28 09:06:23', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:06:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(50, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-03-28 09:11:55', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:11:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(51, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-03-28 09:13:21', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:13:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(52, 2, 123, 1, 1398, 5, 62.91, 1465.91, '2020-03-28 09:16:18', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:16:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(53, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-03-28 09:20:16', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:20:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(54, 2, 122, 1, 1298, 5, 58.41, 1361.41, '2020-03-28 09:22:29', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:22:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(55, 3, 123, 1, 1897, 5, 85.36, 1987.36, '2020-03-28 09:33:09', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 09:33:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(56, 2, 123, 1, 1398, 5, 62.91, 1465.91, '2020-03-28 10:38:57', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-28 10:38:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(57, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-03-30 08:35:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-30 08:35:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(58, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-03-30 08:37:09', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-30 08:37:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(59, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-04-09 19:53:23', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-09 19:53:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(60, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-04-10 12:29:00', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-10 12:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(61, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-04-10 12:56:21', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-10 12:56:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(62, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-10 13:14:52', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-10 13:14:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(63, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-16 17:34:54', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 17:34:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(64, 1, 123, 1, 699, 5, 31.46, 735.46, '2020-04-16 19:02:34', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 19:02:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(65, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-16 19:28:49', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 19:28:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(66, 1, 123, 1, 799.99, 5, 36, 840.99, '2020-04-16 21:07:00', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 21:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(67, 3, 123, 1, 2199.97, 5, 99, 2303.97, '2020-04-16 21:08:13', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 21:08:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(68, 1, 123, 1, 799.99, 5, 36, 840.99, '2020-04-16 21:12:34', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 21:12:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(69, NULL, 123, 1, NULL, 5, NULL, NULL, '2020-04-16 21:15:07', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 21:15:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(70, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-16 21:20:53', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-16 21:20:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(71, 2, 123, 1, 1499.98, 5, 67.5, 1572.48, '2020-04-18 12:38:13', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-18 12:38:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(72, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-18 12:45:42', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-18 12:45:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(73, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-20 20:52:39', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 20:52:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(74, 2, 123, 1, 1399.98, 5, 63, 1467.98, '2020-04-20 20:53:09', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 20:53:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(75, 4, 123, 1, 3199.96, 5, 144, 3348.96, '2020-04-20 21:20:22', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 21:20:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(76, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-20 21:21:42', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 21:21:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(77, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-20 21:23:04', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 21:23:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(78, 2, 123, 1, 1399.98, 5, 63, 1467.98, '2020-04-20 23:26:09', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:26:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(79, 1, 123, 1, 799.99, 5, 36, 840.99, '2020-04-20 23:29:57', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:29:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(80, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-20 23:33:02', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:33:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(81, 2, 123, 1, 1399.98, 5, 63, 1467.98, '2020-04-20 23:37:47', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:37:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(82, 2, 123, 1, 1499.98, 5, 67.5, 1572.48, '2020-04-20 23:54:12', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:54:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(83, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-20 23:59:38', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-20 23:59:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(84, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-21 00:02:04', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 00:02:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(85, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-21 00:03:20', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 00:03:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(86, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-21 12:19:49', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 12:19:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(87, 2, 123, 1, 1399.98, 5, 63, 1467.98, '2020-04-21 12:48:05', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 12:48:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(88, 2, 123, 1, 1399.98, 5, 63, 1467.98, '2020-04-21 13:25:58', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 13:25:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(89, 9, 123, 1, 7099.91, 8, 319.5, 7427.41, '2020-04-21 14:23:04', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 14:23:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(90, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-21 20:32:45', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-21 20:32:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(91, NULL, 123, 1, NULL, 5, NULL, NULL, '2020-04-22 10:42:58', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 10:42:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(92, 10, 123, 1, 7399.9, 8, 333, 7740.9, '2020-04-22 12:43:16', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 12:43:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(93, 5, 123, 1, 3999.95, 5, 180, 4184.95, '2020-04-22 12:50:57', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 12:50:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(94, 2, 123, 1, 1699.98, 5, 76.5, 1781.48, '2020-04-22 13:00:09', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 13:00:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(95, 14, 123, 1, 10199.8, 15, 458.99, 10673.789999999999, '2020-04-22 13:04:32', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 13:04:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(96, 14, 123, 1, 10199.8, 15, 458.99, 10673.789999999999, '2020-04-22 13:18:20', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 13:18:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(97, 1, 123, 1, 699.99, 5, 31.5, 736.49, '2020-04-22 13:31:26', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 13:31:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N'),
(98, NULL, 123, 0, NULL, NULL, NULL, NULL, '2020-04-22 13:32:46', NULL, NULL, NULL, NULL, NULL, 'VA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-22 13:32:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N');

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
 declare lv_storageGB int(5);
  declare lv_color varchar(20);
 declare lv_grade VARCHAR(20);
declare lv_change_number DOUBLE; 
 declare lv_finished int(2);
 declare lv_idSmartPhones VARCHAR(16);
 declare lv_id_phoneoption int(11);
 declare lv_quantity int(8);
 declare lv_qyts int(8);
DECLARE cursor1 CURSOR FOR 
 SELECT idSmartPhones, quantity, P_OPT_ID 
 FROM sp_cartitem
 WHERE idCart = NEW.idCart;
 
 DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET lv_finished = 1;
  
 OPEN cursor1;
 getRedcord: LOOP
 FETCH cursor1 INTO lv_idSmartPhones, lv_quantity,lv_id_phoneoption;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord;
 END IF;
 if NEW.OrderPlaced = 1 then
 UPDATE sp_phones 
 SET stock = stock - lv_quantity 
 WHERE idSmartPhones = lv_idSmartPhones; 
  UPDATE phone_options 
 SET P_QUANTITY = P_QUANTITY - lv_quantity 
 WHERE P_OPT_ID = lv_id_phoneoption;
end if;
BEGIN

DECLARE cursor2 CURSOR FOR 
SELECT c.idcart, firstname, lastname, address, dtcreated, ci.quantity, productname, description, phonetype,ci.storageGB, ci.color, grade
FROM sp_shopper s, sp_cart c, sp_cartitem ci, sp_phones p
WHERE s.idshopper = c.idshopper and c.idcart = ci.idcart and ci.idsmartphones = p.idsmartphones and ci.idCart = NEW.idCart AND NEW.OrderPlaced = 1;

OPEN cursor2;
 getRedcord1: LOOP
 FETCH cursor2 INTO lv_idcart, lv_firstname,lv_lastname,lv_address,lv_dtcreated,lv_qty,lv_productname,lv_description,lv_phonetype,lv_storageGB, lv_color, lv_grade;
 IF lv_finished = 1 THEN 
     LEAVE getRedcord1;
 END IF;
 if NEW.OrderPlaced = 1 then
insert into SP_phone_onlinesell_record(idonlineSaleHistory,idBasket,CustomerFName,customerLName,address,dtcreated,qtys,
productname,description,phonetype,storageGB,color,grade,currentdate,actionTaken)
values(null, lv_idcart, lv_firstname, lv_lastname,lv_address,lv_dtcreated,lv_qty,
lv_productname,lv_description,lv_phonetype,lv_storageGB,lv_color,lv_grade,SYSDATE(), 'S-SOLD');
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
  `P_OPT_ID` int(11) NOT NULL,
  `idSmartPhones` int(8) DEFAULT NULL,
  `color` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `storageGB` int(5) NOT NULL,
  `Price` double DEFAULT NULL,
  `Quantity` int(5) DEFAULT NULL,
  `idCart` int(8) DEFAULT NULL,
  `option1` int(2) DEFAULT NULL,
  `option2` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_cartitem`
--

INSERT INTO `sp_cartitem` (`idCartItem`, `P_OPT_ID`, `idSmartPhones`, `color`, `storageGB`, `Price`, `Quantity`, `idCart`, `option1`, `option2`) VALUES
(127, 2, 20, '', 64, 799.99, 4, 96, NULL, NULL),
(128, 2, 21, '', 64, 699.99, 4, 96, NULL, NULL),
(129, 2, 31, '', 64, 799.98, 6, 96, NULL, NULL),
(130, 2, 13, '', 64, 499.99, 2, 96, NULL, NULL),
(131, 2, 21, '', 64, 699.99, 1, 97, NULL, NULL),
(132, 2, 20, '', 64, 799.99, 4, 98, NULL, NULL);

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
-- Table structure for table `sp_expense`
--

CREATE TABLE `sp_expense` (
  `idexpense` int(8) NOT NULL,
  `expensename` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `totalexpense` double DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_expense`
--

INSERT INTO `sp_expense` (`idexpense`, `expensename`, `description`, `totalexpense`, `currentdate`) VALUES
(1, 'ticket to texas', 'flight to texas to buy phone', 2000, '2020-03-07 00:05:03'),
(2, 'ticket to texas', 'flight to texas to buy phone', 2000, '2020-03-07 00:36:51'),
(3, 'ticket to texas', 'flight to texas to buy phone', 2000, '2020-03-07 10:44:01'),
(4, 'ticket to texas', 'flight to texas to buy phone', 2000, '2020-03-07 11:09:19'),
(5, 'travel', '43', 2222, '2020-04-10 12:50:20');

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
  `storageGB` int(5) NOT NULL,
  `color` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_online_orderprocess_record`
--

INSERT INTO `sp_online_orderprocess_record` (`idonlineProcess`, `idBasket`, `CustomerFName`, `customerLName`, `address`, `dtcreated`, `quantities`, `productname`, `description`, `phonetype`, `storageGB`, `color`, `grade`, `currentdate`, `actionTaken`) VALUES
(1, 83, 'Timothy', 'Tran', '1706 university', '2020-04-20', 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 0, '', 'B', '2020-04-21 14:22:27', 'S'),
(2, 84, 'Timothy', 'Tran', '1706 university', '2020-04-21', 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 0, '', 'B', '2020-04-21 14:22:27', 'S'),
(3, 86, 'Timothy', 'Tran', '1706 university', '2020-04-21', 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 0, '', 'C', '2020-04-21 14:22:27', 'S'),
(4, 87, 'Timothy', 'Tran', '1706 university', '2020-04-21', 2, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 0, '', 'B', '2020-04-21 14:22:27', 'S'),
(5, 88, 'Timothy', 'Tran', '1706 university', '2020-04-21', 2, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 0, '', 'B', '2020-04-21 14:22:27', 'S');

-- --------------------------------------------------------

--
-- Table structure for table `sp_phones`
--

CREATE TABLE `sp_phones` (
  `idSmartPhones` int(8) NOT NULL,
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
(11, 1, 'iphone X', 'iphone X, 64 GB', 'iphoneX', '', 64, 'A', 'iphoneXS.png', 699.99, 116, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(12, 1, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', '', 64, 'B', 'iphoneXS.png', 599.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(13, 1, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', '', 64, 'C', 'iphoneXS.png', 499.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(14, 1, 'iphone X', 'iphone X, 128 GB', 'iphoneX', '', 128, 'A', 'iphoneXS.png', 799.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(15, 1, 'iphone X', 'iphone X, 128 GB', 'iphoneX', '', 128, 'B', 'iphoneXS.png', 699.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(16, 1, 'iphone X', 'iphone X, 128 GB', 'iphoneX', '', 128, 'C', 'iphoneXS.png', 599.99, 98, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(17, 1, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', '', 256, 'A', 'iphoneXS.png', 899.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(18, 1, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', '', 256, 'B', 'iphoneXS.png', 799.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(19, 1, 'iphone X', 'iphone X, 256 GB', 'iphoneX', '', 256, 'C', 'iphoneXS.png', 699.99, 94, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(20, 1, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', '', 64, 'A', 'iphoneXS.png', 799.99, -4, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(21, 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', '', 64, 'B', 'iphoneXS.png', 699.99, 5, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(22, 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', '', 64, 'C', 'iphoneXS.png', 599.99, 10, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(23, 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', '', 128, 'A', 'iphoneXS.png', 899.99, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(24, 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', '', 128, 'B', 'iphoneXS.png', 799.99, 10, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(25, 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', '', 128, 'C', 'iphoneXS.png', 699.99, 99, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(26, 1, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', '', 256, 'A', 'iphoneXS.png', 999.99, 100, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(27, 1, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', '', 256, 'B', 'iphoneXS.png', 899.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(28, 1, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', '', 256, 'C', 'iphoneXS.png', 799.99, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'S', 1),
(31, 0, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', '', 64, 'A', NULL, 799.98, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL);

--
-- Triggers `sp_phones`
--
DELIMITER $$
CREATE TRIGGER `update_stock_logs_trigs` AFTER UPDATE ON `sp_phones` FOR EACH ROW BEGIN
INSERT INTO SP_updatePhoneStock(idforphone,PhoneName,Description,PhoneType,storageGB,grade,Price,PhoneSku,oldstock,dateChanged,type) 
VALUES (null, OLD.ProductName, OLD.Description, OLD.PhoneType, OLD.storageGB, OLD.grade, OLD.Price, old.idsmartphones, OLD.stock, SYSDATE(), 'UPDATE');
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
  `idSmartPhones` int(8) DEFAULT NULL
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
  `description` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `P_OPT_ID` int(8) DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storageGB` int(5) NOT NULL,
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

INSERT INTO `sp_phonespos` (`idphonepos`, `IMEI`, `PhoneName`, `description`, `P_OPT_ID`, `PhoneType`, `storageGB`, `color`, `grade`, `ProductImage`, `Price`, `SaleStart`, `SaleEnd`, `SalePrice`, `Active`, `idCustomer`, `FeatureStart`, `FeatureEnd`, `Type`) VALUES
(19, '123456789872', 'Iphone 6', '', NULL, 'iphoneX', 64, 'black', 'A', NULL, 699.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(23, '123456789875', 'Iphone XS', '', NULL, 'iphoneXS', 64, 'black', 'A', NULL, 799.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29, '123456789881', 'Iphone 12', '', NULL, 'iphone12', 64, 'black', 'A', NULL, 799.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30, '123456789871', 'Iphone X', '', NULL, 'iphoneX', 64, 'black', 'A', NULL, 699.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, '54353454353', 'iphone 6', '', NULL, 'iphone6s', 64, 'black', 'A', NULL, 699.98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Triggers `sp_phonespos`
--
DELIMITER $$
CREATE TRIGGER `ADD_NEW_INVENTORY` AFTER INSERT ON `sp_phonespos` FOR EACH ROW BEGIN
	IF NEW.PhoneType IS NOT NULL THEN 
	update phone_options
    SET p_quantity = p_quantity + 1
    WHERE P_OPT_ID = NEW.P_OPT_ID ;
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
 
  FETCH cursor1 INTO lv_quantity, lv_idonlineProcess;
 
     
 

 IF (lv_quantity > 1) then
 UPDATE SP_Online_orderprocess_record 
 SET quantities = quantities - 1
 WHERE idonlineProcess = lv_idonlineProcess; 
 
 INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType, storageGB, sphonecolor, grade,Price, currentdate,datesold, actionTaken)
	VALUES(null,OLD.IMEI,OLD.PhoneName,OLD.Description,OLD.PhoneType, old.storageGB, old.color, OLD.grade, OLD.Price, SYSDATE(),SYSDATE(), 'U-Sold');
 ELSEIF (lv_quantity = 1) THEN
 DELETE FROM SP_Online_orderprocess_record 
    WHERE OLD.PhoneType = Phonetype and OLD.color = color and old.grade = grade and OLD.storageGB = storageGB;
    
    INSERT INTO sp_phone_sales_history (idSaleHistory, idSmartPhones, ProductName, Description, PhoneType, storageGB,sphonecolor, grade,Price, currentdate,datesold, actionTaken)
	VALUES(null,OLD.IMEI,OLD.PhoneName,OLD.Description,OLD.PhoneType, old. storageGB, old.color, OLD.grade, OLD.Price,SYSDATE(),SYSDATE(), 'U-Sold');
end if;
 
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
  `idSmartPhones` int(8) DEFAULT NULL,
  `dtrequest` datetime DEFAULT CURRENT_TIMESTAMP,
  `dtrecd` date DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `qty` int(5) DEFAULT NULL,
  `idvender` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sp_phonetype`
--

CREATE TABLE `sp_phonetype` (
  `idphonetype` int(8) NOT NULL,
  `phonetype` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `PhonetypeName` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phonetype`
--

INSERT INTO `sp_phonetype` (`idphonetype`, `phonetype`, `PhonetypeName`) VALUES
(1, 'iphone11pro', 'Iphone 11 Pro'),
(2, 'iphone11', 'Iphone 11 '),
(5, 'iphoneX', 'Iphone X'),
(6, 'iphoneXS', 'Iphone XS'),
(7, 'iphone8plus', 'Iphone 8 Plus'),
(8, 'iphone8', 'IPhone 8'),
(9, 'iphone7plus', 'Iphone 7 Plus'),
(10, 'iphone7', 'Iphone 7'),
(11, 'iphone6s', 'Iphone 6s'),
(12, 'iphone11pro', 'Iphone 11 Pro'),
(13, 'iphone12', 'Iphone 12'),
(14, 'nokia', 'nokia 8898'),
(15, 'iphone12', 'iphone 12');

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
  `storageGB` int(5) NOT NULL,
  `color` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_phone_onlinesell_record`
--

INSERT INTO `sp_phone_onlinesell_record` (`idonlineSaleHistory`, `idBasket`, `CustomerFName`, `customerLName`, `address`, `dtcreated`, `qtys`, `productname`, `description`, `phonetype`, `storageGB`, `color`, `grade`, `currentdate`, `actionTaken`) VALUES
(63, 89, 'Timothy', 'Tran', '1706 university', '2020-04-21', 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-21 20:32:36', 'S'),
(64, 89, 'Timothy', 'Tran', '1706 university', '2020-04-21', 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, '', 'B', '2020-04-21 20:32:36', 'S'),
(65, 89, 'Timothy', 'Tran', '1706 university', '2020-04-21', 7, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-21 20:32:36', 'S'),
(66, 92, 'Timothy', 'Tran', '1706 university', '2020-04-22', 3, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 12:50:49', 'S'),
(67, 92, 'Timothy', 'Tran', '1706 university', '2020-04-22', 4, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-22 12:50:49', 'S'),
(68, 92, 'Timothy', 'Tran', '1706 university', '2020-04-22', 3, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 12:50:49', 'S'),
(69, 93, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-22 12:55:15', 'S'),
(70, 93, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 12:55:15', 'S'),
(71, 93, 'Timothy', 'Tran', '1706 university', '2020-04-22', 2, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, '', 'B', '2020-04-22 12:55:15', 'S'),
(72, 93, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, '', 'A', '2020-04-22 12:55:15', 'S'),
(73, 94, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-22 13:04:23', 'S'),
(74, 94, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, '', 'A', '2020-04-22 13:04:23', 'S'),
(75, 95, 'Timothy', 'Tran', '1706 university', '2020-04-22', 2, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-22 13:17:12', 'S'),
(76, 95, 'Timothy', 'Tran', '1706 university', '2020-04-22', 6, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', 64, '', 'A', '2020-04-22 13:17:12', 'S'),
(77, 95, 'Timothy', 'Tran', '1706 university', '2020-04-22', 2, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, '', 'C', '2020-04-22 13:17:12', 'S'),
(78, 95, 'Timothy', 'Tran', '1706 university', '2020-04-22', 4, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 13:17:12', 'S'),
(79, 96, 'Timothy', 'Tran', '1706 university', '2020-04-22', 2, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, '', 'A', '2020-04-22 13:29:55', 'S'),
(80, 96, 'Timothy', 'Tran', '1706 university', '2020-04-22', 4, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 13:29:55', 'S'),
(81, 96, 'Timothy', 'Tran', '1706 university', '2020-04-22', 6, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', 64, '', 'A', '2020-04-22 13:29:55', 'S'),
(82, 96, 'Timothy', 'Tran', '1706 university', '2020-04-22', 2, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, '', 'C', '2020-04-22 13:29:55', 'S'),
(83, 97, 'Timothy', 'Tran', '1706 university', '2020-04-22', 1, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, '', 'B', '2020-04-22 13:31:53', 'S');

--
-- Triggers `sp_phone_onlinesell_record`
--
DELIMITER $$
CREATE TRIGGER `addTo_process_order_TRg` AFTER DELETE ON `sp_phone_onlinesell_record` FOR EACH ROW BEGIN
	

insert into SP_Online_orderprocess_record(idonlineProcess,idBasket,CustomerFName,customerLName,address,dtcreated,quantities,
productname,description,phonetype,storageGB,color,grade,currentdate,actionTaken)
values(null, OLD.idBasket, OLD.CustomerFName, OLD.customerLName,OLD.address,OLD.dtcreated,OLD.qtys,
OLD.productname,OLD.description,OLD.phonetype,OLD.storageGB,OLD.color,OLD.grade,SYSDATE(), 'S-SOLD');


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
  `storageGB` int(6) NOT NULL,
  `sphonecolor` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `grade` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `datesold` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `actionTaken` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
-- Table structure for table `sp_purchasevendor`
--

CREATE TABLE `sp_purchasevendor` (
  `idpurchase` int(8) NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `invoice` int(20) NOT NULL,
  `description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `quantity` int(8) DEFAULT NULL,
  `totaldue` double DEFAULT NULL,
  `status` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_purchasevendor`
--

INSERT INTO `sp_purchasevendor` (`idpurchase`, `name`, `invoice`, `description`, `quantity`, `totaldue`, `status`, `currentdate`) VALUES
(1, 'primary one inc', 2147483647, '50 iphones X, 100 iphone 11, 10 samsung, ', 160, 50000, 'paid', '2020-03-07 00:45:58'),
(2, 'primary one inc', 2147483647, '50 iphones X, 100 iphone 11, 10 samsung, ', 100, 2000, 'paid', '2020-03-07 11:08:52');

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
(121, 'tim', 'tran', '1412 main st', 'fairfax', 'VA', '23423', NULL, NULL, NULL, 'tim', '$2y$10$Q/H5FgwzcWwWaQY7zoYgF.f4g3D8sLz10QpRFymh66lTryh/86guC', 0, '2020-02-01 10:19:27', NULL, NULL),
(122, 'tim', 'tran', '1412 main st', 'fairfax', 'VA', '54321', NULL, NULL, NULL, 'user9', '$2y$10$fV8aUM.vwq7uCaQWfvukO.I029HCbD5H5SEoJRdRMgUes/hnCkf1a', 0, '2020-02-22 13:36:53', NULL, NULL),
(123, 'Timothy', 'Tran', '1706 university', 'fairfax', 'VA', '22034', NULL, NULL, NULL, 'timtran', '$2y$10$gdmxQ2F.7G9lHYO1EH.zp.3MOScSvxOW/BQX7cgv8DwsHO88QQ3KG', 0, '2020-03-05 01:42:12', NULL, NULL);

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
  `idlog` int(8) NOT NULL,
  `name` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currentdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `errmsg` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_trans_log`
--

INSERT INTO `sp_trans_log` (`idlog`, `name`, `currentdate`, `errmsg`) VALUES
(1, 'smartphoneDepot', '2020-03-05 14:13:35', 'this user processed sale'),
(2, 'smartphoneDepot', '2020-03-05 14:23:55', 'this user manualy updated stock quantity of phones ID :11'),
(3, 'smartphoneDepot', '2020-03-06 11:48:07', 'this user manualy updated stock quantity of phones ID :11'),
(4, 'smartphoneDepot', '2020-03-06 11:50:15', 'this user manualy updated stock quantity of phones ID :12'),
(5, 'smartphoneDepot', '2020-03-06 12:08:36', 'this user processed sale'),
(6, 'smartphoneDepot', '2020-03-06 12:35:51', 'this user Add a new Phone: imei# : 123456789871'),
(7, 'smartphoneDepot', '2020-03-06 12:38:47', 'this user Add a new Phone: imei# : 123456789872'),
(8, 'smartphoneDepot', '2020-03-06 12:43:21', 'this user processed sale for Cart# : '),
(9, 'smartphoneDepot', '2020-03-06 13:14:13', 'this user manualy updated stock quantity of phones ID :13'),
(10, 'smartphoneDepot', '2020-03-06 23:52:27', 'this user Add a new Phone: imei# : '),
(11, 'smartphoneDepot', '2020-03-07 00:30:59', 'this user manualy updated stock quantity of phones ID :14'),
(12, 'smartphoneDepot', '2020-03-07 10:40:48', 'this user manualy updated stock quantity of phones ID :15'),
(13, 'smartphoneDepot', '2020-03-07 10:40:58', 'this user manualy updated stock quantity of phones ID :16'),
(14, 'smartphoneDepot', '2020-03-07 10:44:15', 'this user manualy updated stock quantity of phones ID :17'),
(15, 'smartphoneDepot', '2020-03-07 10:48:28', 'this user Add a new Phone: imei# : 123456789874'),
(16, 'user9', '2020-03-07 11:34:59', 'this user processed sale for Cart# : '),
(17, 'user9', '2020-03-07 11:39:53', 'this user manualy updated stock quantity of phones ID :11'),
(18, 'user9', '2020-03-07 11:42:23', 'this user Add a new Phone: imei# : 123456789871'),
(19, 'user9', '2020-03-07 11:42:38', 'this user Add a new Phone: imei# : 123456789872'),
(20, 'user9', '2020-03-07 11:43:21', 'This user process In-Store sale'),
(21, 'smartphoneDepot', '2020-03-10 20:18:41', 'this user Add a new Phone: imei# : 123456789871'),
(22, 'smartphoneDepot', '2020-03-10 20:19:01', 'this user Add a new Phone: imei# : 123456789873'),
(23, 'smartphoneDepot', '2020-03-10 20:19:22', 'this user Add a new Phone: imei# : 123456789874'),
(24, 'smartphoneDepot', '2020-03-10 20:19:39', 'this user Add a new Phone: imei# : 123456789875'),
(25, 'smartphoneDepot', '2020-03-10 21:04:10', 'this user Add a new Phone: imei# : 123456789876'),
(26, 'smartphoneDepot', '2020-03-10 21:04:25', 'this user Add a new Phone: imei# : 123456789878'),
(27, 'smartphoneDepot', '2020-03-10 21:04:38', 'this user Add a new Phone: imei# : 123456789877'),
(28, 'smartphoneDepot', '2020-03-10 21:04:53', 'this user Add a new Phone: imei# : 123456789879'),
(29, 'smartphoneDepot', '2020-03-10 21:38:15', 'this user Add a new Phone: imei# : '),
(30, 'smartphoneDepot', '2020-03-10 21:41:02', 'This user process In-Store sale'),
(31, 'smartphoneDepot', '2020-03-10 21:41:34', 'this user Add a new Phone: imei# : '),
(32, 'smartphoneDepot', '2020-03-10 21:42:54', 'this user Add a new Phone: imei# : '),
(33, 'smartphoneDepot', '2020-03-10 21:46:20', 'this user Add a new Phone: imei# : '),
(34, 'smartphoneDepot', '2020-03-10 21:48:26', 'this user Add a new Phone: imei# : '),
(35, 'smartphoneDepot', '2020-03-10 22:58:27', 'this user Add a new Phone: imei# : '),
(36, 'smartphoneDepot', '2020-03-10 23:00:44', 'this user Add a new Phone: imei# : '),
(37, 'smartphoneDepot', '2020-03-10 23:01:39', 'this user Add a new Phone: imei# : '),
(38, 'smartphoneDepot', '2020-03-10 23:02:18', 'this user Add a new Phone: imei# : 123456789881'),
(39, 'smartphoneDepot', '2020-03-10 23:07:27', 'this user processed sale for Cart# : '),
(40, 'smartphoneDepot', '2020-03-10 23:07:44', 'this user processed sale for Cart# : '),
(41, 'smartphoneDepot', '2020-03-10 23:15:51', 'this user processed sale for Cart# : '),
(42, 'smartphoneDepot', '2020-03-11 20:00:12', 'this user processed sale for Cart# : '),
(43, 'smartphoneDepot', '2020-03-11 20:15:01', 'this user Add a new Phone: imei# : 123456789871'),
(44, 'smartphoneDepot', '2020-03-11 20:29:21', 'this user manualy updated stock quantity of phones ID :11'),
(45, 'smartphoneDepot', '2020-03-25 18:26:45', 'this user Add a new Phone: imei# : 54353454353'),
(46, 'user9', '2020-04-10 12:51:12', 'this user manualy updated stock quantity of phones ID :11'),
(47, 'user9', '2020-04-10 16:41:31', 'this user processed sale for Cart# : '),
(48, 'user9', '2020-04-10 16:44:19', 'this user processed sale for Cart# : '),
(49, 'user9', '2020-04-10 16:49:27', 'this user processed sale for Cart# : '),
(50, 'user9', '2020-04-10 16:52:26', 'this user processed sale for Cart# : '),
(51, 'smartphoneDepot', '2020-04-20 21:13:35', 'this user manualy updated stock quantity of phones ID :19'),
(52, 'smartphoneDepot', '2020-04-20 21:13:52', 'this user manualy updated stock quantity of phones ID :22'),
(53, 'smartphoneDepot', '2020-04-20 21:14:04', 'this user manualy updated stock quantity of phones ID :24'),
(54, 'smartphoneDepot', '2020-04-20 21:14:10', 'this user manualy updated stock quantity of phones ID :18'),
(55, 'smartphoneDepot', '2020-04-20 21:14:20', 'this user manualy updated stock quantity of phones ID :25'),
(56, 'smartphoneDepot', '2020-04-20 21:14:27', 'this user manualy updated stock quantity of phones ID :26');

-- --------------------------------------------------------

--
-- Table structure for table `sp_updatephonestock`
--

CREATE TABLE `sp_updatephonestock` (
  `idforphone` int(16) NOT NULL,
  `PhoneName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneType` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storageGB` int(5) NOT NULL,
  `grade` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `PhoneSku` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `oldstock` int(8) DEFAULT NULL,
  `dateChanged` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Type` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sp_updatephonestock`
--

INSERT INTO `sp_updatephonestock` (`idforphone`, `PhoneName`, `Description`, `PhoneType`, `storageGB`, `grade`, `Price`, `PhoneSku`, `oldstock`, `dateChanged`, `Type`) VALUES
(1, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '', 96, '2020-03-06 11:49:12', 'U'),
(2, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, 'green', 599.99, '', 12, '2020-03-06 11:50:15', 'U'),
(3, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '', 100, '2020-03-06 12:07:43', 'UPDATE'),
(4, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '', 98, '2020-03-06 12:35:51', 'UPDATE'),
(5, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '', 99, '2020-03-06 12:38:47', 'UPDATE'),
(6, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, 'yellow', 499.99, '13', 15, '2020-03-06 13:14:13', 'UPDATE'),
(7, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'orange', 799.99, '14', 2, '2020-03-07 00:30:59', 'UPDATE'),
(8, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'green', 699.99, '15', 2, '2020-03-07 10:40:48', 'UPDATE'),
(9, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'yellow', 599.99, '16', 10, '2020-03-07 10:40:58', 'UPDATE'),
(10, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', 256, 'orange', 899.99, '17', 2, '2020-03-07 10:44:15', 'UPDATE'),
(11, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 100, '2020-03-07 10:48:07', 'UPDATE'),
(12, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 98, '2020-03-07 10:48:28', 'UPDATE'),
(13, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 99, '2020-03-07 11:39:53', 'UPDATE'),
(14, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 100, '2020-03-07 11:42:23', 'UPDATE'),
(15, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 101, '2020-03-07 11:42:38', 'UPDATE'),
(16, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 102, '2020-03-10 20:18:40', 'UPDATE'),
(17, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'orange', 799.99, '20', 1, '2020-03-10 20:19:01', 'UPDATE'),
(18, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 103, '2020-03-10 20:19:22', 'UPDATE'),
(19, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'orange', 799.99, '20', 2, '2020-03-10 20:19:39', 'UPDATE'),
(20, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 104, '2020-03-10 21:04:10', 'UPDATE'),
(21, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 105, '2020-03-10 21:04:25', 'UPDATE'),
(22, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 106, '2020-03-10 21:04:38', 'UPDATE'),
(23, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 107, '2020-03-10 21:04:53', 'UPDATE'),
(24, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', 64, 'orange', 799.98, '31', 0, '2020-03-10 23:02:18', 'UPDATE'),
(25, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 108, '2020-03-10 23:15:26', 'UPDATE'),
(26, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 106, '2020-03-11 20:15:01', 'UPDATE'),
(27, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 107, '2020-03-11 20:29:21', 'UPDATE'),
(28, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 123, '2020-03-18 19:46:04', 'UPDATE'),
(29, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'orange', 799.99, '20', 3, '2020-03-20 10:48:46', 'UPDATE'),
(30, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'yellow', 599.99, '16', 100, '2020-03-20 23:06:09', 'UPDATE'),
(31, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 121, '2020-03-25 17:56:45', 'UPDATE'),
(32, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 119, '2020-03-25 18:41:41', 'UPDATE'),
(33, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', 1, '2020-03-27 12:35:32', 'UPDATE'),
(34, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', 0, '2020-03-27 13:04:57', 'UPDATE'),
(35, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -1, '2020-03-27 13:07:01', 'UPDATE'),
(36, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -2, '2020-03-27 13:09:09', 'UPDATE'),
(37, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -3, '2020-03-27 13:10:00', 'UPDATE'),
(38, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -4, '2020-03-28 09:12:04', 'UPDATE'),
(39, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -5, '2020-03-28 09:18:47', 'UPDATE'),
(40, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -6, '2020-03-28 09:21:14', 'UPDATE'),
(41, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -7, '2020-03-28 09:23:31', 'UPDATE'),
(42, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -8, '2020-03-28 09:34:22', 'UPDATE'),
(43, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -9, '2020-03-28 09:36:45', 'UPDATE'),
(44, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -10, '2020-03-28 10:42:42', 'UPDATE'),
(45, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -11, '2020-03-30 08:37:31', 'UPDATE'),
(46, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -12, '2020-04-10 12:28:46', 'UPDATE'),
(47, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 117, '2020-04-10 12:51:12', 'UPDATE'),
(48, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -13, '2020-04-10 12:55:58', 'UPDATE'),
(49, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -14, '2020-04-10 12:56:35', 'UPDATE'),
(50, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -15, '2020-04-16 19:03:10', 'UPDATE'),
(51, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -16, '2020-04-16 21:06:50', 'UPDATE'),
(52, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -17, '2020-04-16 21:07:40', 'UPDATE'),
(53, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -18, '2020-04-16 21:12:25', 'UPDATE'),
(54, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -19, '2020-04-16 21:14:59', 'UPDATE'),
(55, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -20, '2020-04-18 12:41:09', 'UPDATE'),
(56, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -21, '2020-04-18 12:46:48', 'UPDATE'),
(57, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -22, '2020-04-20 20:52:55', 'UPDATE'),
(58, 'iphone X', 'iphone X, 64 GB', 'iphoneX', 64, 'orange', 699.99, '11', 116, '2020-04-20 20:55:46', 'UPDATE'),
(59, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, 'green', 599.99, '12', 100, '2020-04-20 20:55:53', 'UPDATE'),
(60, 'iphone X', 'iphone X, 64 GB ', 'iphoneX', 64, 'yellow', 499.99, '13', 100, '2020-04-20 20:56:03', 'UPDATE'),
(61, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'orange', 799.99, '14', 100, '2020-04-20 20:56:07', 'UPDATE'),
(62, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'green', 699.99, '15', 100, '2020-04-20 20:56:11', 'UPDATE'),
(63, 'iphone X', 'iphone X, 128 GB', 'iphoneX', 128, 'yellow', 599.99, '16', 98, '2020-04-20 20:56:15', 'UPDATE'),
(64, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', 256, 'orange', 899.99, '17', 100, '2020-04-20 20:56:18', 'UPDATE'),
(65, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', 256, 'green', 799.99, '18', 2, '2020-04-20 20:56:22', 'UPDATE'),
(66, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'yellow', 699.99, '19', -23, '2020-04-20 20:56:25', 'UPDATE'),
(67, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'orange', 799.99, '20', 2, '2020-04-20 20:56:33', 'UPDATE'),
(68, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'green', 699.99, '21', 2, '2020-04-20 20:56:36', 'UPDATE'),
(69, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'yellow', 599.99, '22', 0, '2020-04-20 20:56:41', 'UPDATE'),
(70, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'orange', 899.99, '23', 1, '2020-04-20 20:56:45', 'UPDATE'),
(71, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'green', 799.99, '24', 0, '2020-04-20 20:56:49', 'UPDATE'),
(72, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'yellow', 699.99, '25', 0, '2020-04-20 20:56:52', 'UPDATE'),
(73, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', 256, 'orange', 999.99, '26', 0, '2020-04-20 20:56:55', 'UPDATE'),
(74, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', 256, 'green', 899.99, '27', 0, '2020-04-20 20:57:00', 'UPDATE'),
(75, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', 256, 'yellow', 799.99, '28', 0, '2020-04-20 20:57:04', 'UPDATE'),
(76, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', 64, 'orange', 799.98, '31', 1, '2020-04-20 20:57:08', 'UPDATE'),
(77, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', -23, '2020-04-20 21:13:35', 'UPDATE'),
(78, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'C', 599.99, '22', 0, '2020-04-20 21:13:52', 'UPDATE'),
(79, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'B', 799.99, '24', 0, '2020-04-20 21:14:04', 'UPDATE'),
(80, 'iphone X', 'iphone X, 256 GB ', 'iphoneX', 256, 'B', 799.99, '18', 2, '2020-04-20 21:14:10', 'UPDATE'),
(81, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'C', 699.99, '25', 0, '2020-04-20 21:14:20', 'UPDATE'),
(82, 'iphone XS', 'iphone XS, 256 GB ', 'iphoneXS', 256, 'A', 999.99, '26', 0, '2020-04-20 21:14:27', 'UPDATE'),
(83, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 100, '2020-04-20 21:20:13', 'UPDATE'),
(84, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 99, '2020-04-20 21:21:32', 'UPDATE'),
(85, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 98, '2020-04-20 21:22:24', 'UPDATE'),
(86, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 97, '2020-04-20 23:25:33', 'UPDATE'),
(87, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 96, '2020-04-20 23:29:25', 'UPDATE'),
(88, 'iphone X', 'iphone X, 256 GB', 'iphoneX', 256, 'C', 699.99, '19', 95, '2020-04-20 23:30:08', 'UPDATE'),
(89, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 2, '2020-04-20 23:33:11', 'UPDATE'),
(90, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 1, '2020-04-20 23:53:31', 'UPDATE'),
(91, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 0, '2020-04-20 23:58:25', 'UPDATE'),
(92, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', -1, '2020-04-21 00:00:26', 'UPDATE'),
(93, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', -2, '2020-04-21 00:02:14', 'UPDATE'),
(94, 'iphone XS', 'iphone XS, 128 GB ', 'iphoneXS', 128, 'C', 699.99, '25', 100, '2020-04-21 12:20:00', 'UPDATE'),
(95, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', -3, '2020-04-21 13:25:50', 'UPDATE'),
(96, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', -5, '2020-04-21 14:21:40', 'UPDATE'),
(97, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', -7, '2020-04-21 17:12:02', 'UPDATE'),
(98, 'Iphone 12', 'Iphone 12 Midnight Green, 64 GB', 'iphone12', 64, 'A', 799.98, '31', 1, '2020-04-21 17:12:06', 'UPDATE'),
(99, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 10, '2020-04-21 20:32:36', 'UPDATE'),
(100, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 9, '2020-04-22 12:50:49', 'UPDATE'),
(101, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'A', 799.99, '20', 2, '2020-04-22 12:55:15', 'UPDATE'),
(102, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'A', 799.99, '20', 1, '2020-04-22 13:04:23', 'UPDATE'),
(103, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'A', 799.99, '20', 0, '2020-04-22 13:17:12', 'UPDATE'),
(104, 'iphone XS', 'iphone XS, 64 GB', 'iphoneXS', 64, 'A', 799.99, '20', -2, '2020-04-22 13:29:55', 'UPDATE'),
(105, 'iphone XS', 'iphone XS, 64 GB ', 'iphoneXS', 64, 'B', 699.99, '21', 6, '2020-04-22 13:31:53', 'UPDATE');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`C_ID`);

--
-- Indexes for table `loginadmin`
--
ALTER TABLE `loginadmin`
  ADD PRIMARY KEY (`idadmin`),
  ADD UNIQUE KEY `adminUsername` (`adminUsername`);

--
-- Indexes for table `phones`
--
ALTER TABLE `phones`
  ADD PRIMARY KEY (`P_ID`);

--
-- Indexes for table `phone_colors`
--
ALTER TABLE `phone_colors`
  ADD PRIMARY KEY (`PC_ID`),
  ADD KEY `C_ID` (`C_ID`),
  ADD KEY `P_OPT_ID` (`P_OPT_ID`);

--
-- Indexes for table `phone_grades`
--
ALTER TABLE `phone_grades`
  ADD PRIMARY KEY (`P_GRADE_ID`);

--
-- Indexes for table `phone_options`
--
ALTER TABLE `phone_options`
  ADD PRIMARY KEY (`P_OPT_ID`),
  ADD KEY `P_ID` (`P_ID`),
  ADD KEY `P_GRADE_ID` (`P_GRADE_ID`),
  ADD KEY `P_STG_ID` (`P_STG_ID`);

--
-- Indexes for table `phone_storage`
--
ALTER TABLE `phone_storage`
  ADD PRIMARY KEY (`P_STG_ID`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sp_for_smartphoneid` (`idSmartPhones`);

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
  ADD KEY `basktitems_idprod_fk` (`idSmartPhones`),
  ADD KEY `phone_option_idopt_fk` (`P_OPT_ID`);

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
-- Indexes for table `sp_expense`
--
ALTER TABLE `sp_expense`
  ADD PRIMARY KEY (`idexpense`);

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
-- Indexes for table `sp_phonetype`
--
ALTER TABLE `sp_phonetype`
  ADD PRIMARY KEY (`idphonetype`);

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
-- Indexes for table `sp_purchasevendor`
--
ALTER TABLE `sp_purchasevendor`
  ADD PRIMARY KEY (`idpurchase`);

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
-- Indexes for table `sp_trans_log`
--
ALTER TABLE `sp_trans_log`
  ADD PRIMARY KEY (`idlog`);

--
-- Indexes for table `sp_updatephonestock`
--
ALTER TABLE `sp_updatephonestock`
  ADD PRIMARY KEY (`idforphone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `colors`
--
ALTER TABLE `colors`
  MODIFY `C_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loginadmin`
--
ALTER TABLE `loginadmin`
  MODIFY `idadmin` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `phones`
--
ALTER TABLE `phones`
  MODIFY `P_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `phone_colors`
--
ALTER TABLE `phone_colors`
  MODIFY `PC_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `phone_grades`
--
ALTER TABLE `phone_grades`
  MODIFY `P_GRADE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `phone_options`
--
ALTER TABLE `phone_options`
  MODIFY `P_OPT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `phone_storage`
--
ALTER TABLE `phone_storage`
  MODIFY `P_STG_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;

--
-- AUTO_INCREMENT for table `sp_cart`
--
ALTER TABLE `sp_cart`
  MODIFY `idCart` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `sp_cartitem`
--
ALTER TABLE `sp_cartitem`
  MODIFY `idCartItem` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

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
-- AUTO_INCREMENT for table `sp_expense`
--
ALTER TABLE `sp_expense`
  MODIFY `idexpense` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `idonlineProcess` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sp_phones`
--
ALTER TABLE `sp_phones`
  MODIFY `idSmartPhones` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `sp_phonespos`
--
ALTER TABLE `sp_phonespos`
  MODIFY `idphonepos` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `sp_phonetype`
--
ALTER TABLE `sp_phonetype`
  MODIFY `idphonetype` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `sp_phone_onlinesell_record`
--
ALTER TABLE `sp_phone_onlinesell_record`
  MODIFY `idonlineSaleHistory` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `sp_phone_sales_history`
--
ALTER TABLE `sp_phone_sales_history`
  MODIFY `idSaleHistory` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_promolist`
--
ALTER TABLE `sp_promolist`
  MODIFY `idshopper` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sp_purchasevendor`
--
ALTER TABLE `sp_purchasevendor`
  MODIFY `idpurchase` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sp_shopper`
--
ALTER TABLE `sp_shopper`
  MODIFY `idShopper` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `sp_trans_log`
--
ALTER TABLE `sp_trans_log`
  MODIFY `idlog` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `sp_updatephonestock`
--
ALTER TABLE `sp_updatephonestock`
  MODIFY `idforphone` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `phone_colors`
--
ALTER TABLE `phone_colors`
  ADD CONSTRAINT `phone_colors_ibfk_1` FOREIGN KEY (`C_ID`) REFERENCES `colors` (`C_ID`),
  ADD CONSTRAINT `phone_colors_ibfk_2` FOREIGN KEY (`P_OPT_ID`) REFERENCES `phone_options` (`P_OPT_ID`);

--
-- Constraints for table `phone_options`
--
ALTER TABLE `phone_options`
  ADD CONSTRAINT `phone_options_ibfk_1` FOREIGN KEY (`P_ID`) REFERENCES `phones` (`P_ID`),
  ADD CONSTRAINT `phone_options_ibfk_2` FOREIGN KEY (`P_GRADE_ID`) REFERENCES `phone_grades` (`P_GRADE_ID`),
  ADD CONSTRAINT `phone_options_ibfk_3` FOREIGN KEY (`P_STG_ID`) REFERENCES `phone_storage` (`P_STG_ID`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `sp_for_smartphoneid` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`);

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
  ADD CONSTRAINT `basktitems_idprod_fk` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`),
  ADD CONSTRAINT `phone_option_idopt_fk` FOREIGN KEY (`P_OPT_ID`) REFERENCES `phone_options` (`P_OPT_ID`);

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
  ADD CONSTRAINT `smartphone_idphone_fk` FOREIGN KEY (`idSmartPhones`) REFERENCES `sp_phones` (`idSmartPhones`);

--
-- Constraints for table `sp_phonesoptiondetail`
--
ALTER TABLE `sp_phonesoptiondetail`
  ADD CONSTRAINT `prodoptdettail_idoptcat_fk` FOREIGN KEY (`idOptionCategory`) REFERENCES `sp_phonesoptioncategory` (`idOptionCategory`);

--
-- Constraints for table `sp_promolist`
--
ALTER TABLE `sp_promolist`
  ADD CONSTRAINT `promote_idshopper_fk` FOREIGN KEY (`idshopper`) REFERENCES `sp_shopper` (`idShopper`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
