-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 29, 2020 at 06:26 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.2

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
(2, '150', 200, NULL, NULL, 1, 3, 1),
(3, '120', 200, NULL, NULL, 2, 1, 1),
(4, '140', 200, NULL, NULL, 2, 3, 1),
(5, '175', 200, NULL, NULL, 1, 1, 2),
(6, '160', 200, NULL, NULL, 2, 1, 2),
(7, '200', 200, NULL, NULL, 1, 3, 2),
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

--
-- Indexes for table `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`C_ID`);

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
-- AUTO_INCREMENT for table `colors`
--
ALTER TABLE `colors`
  MODIFY `C_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loginadmin`
--
ALTER TABLE `loginadmin`
  MODIFY `idadmin` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

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