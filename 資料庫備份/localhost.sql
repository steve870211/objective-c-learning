-- phpMyAdmin SQL Dump
-- version 4.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost:8889
-- Generation Time: Apr 12, 2016 at 03:58 PM
-- Server version: 5.5.38
-- PHP Version: 5.5.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `OrderEasy`
--

-- --------------------------------------------------------

--
-- Table structure for table `Menus`
--

CREATE TABLE `Menus` (
`foodID` int(11) NOT NULL,
  `shopID` int(11) NOT NULL,
  `shopName` varchar(25) NOT NULL,
  `foodName` varchar(25) NOT NULL,
  `price` int(11) NOT NULL,
  `foodPhoto` varchar(25) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=43 ;

--
-- Dumping data for table `Menus`
--

INSERT INTO `Menus` (`foodID`, `shopID`, `shopName`, `foodName`, `price`, `foodPhoto`) VALUES
(1, 1, '四海遊龍', '招牌鍋貼', 6, '招牌鍋貼.jpg'),
(2, 1, '四海遊龍', '韭菜鍋貼', 6, '韭菜鍋貼.jpg'),
(3, 1, '四海遊龍', '辣味鍋貼', 7, '辣味鍋貼.jpg'),
(4, 1, '四海遊龍', '招牌水餃', 7, '招牌水餃.jpg'),
(5, 1, '四海遊龍', '綠皮韭菜水餃', 7, '綠皮韭菜水餃.jpg'),
(6, 1, '四海遊龍', '辣味水餃', 8, '辣味水餃.jpg'),
(7, 1, '四海遊龍', '紅油抄手', 8, '紅油抄手.jpg'),
(8, 1, '四海遊龍', '鮮蝦水餃', 10, '鮮蝦水餃.jpg'),
(9, 1, '四海遊龍', '玉米水餃', 9, '玉米水餃.jpg'),
(10, 1, '四海遊龍', '生水餃', 10, '生水餃.jpg'),
(11, 1, '四海遊龍', '鮮蝦生水餃', 12, '鮮蝦生水餃.jpg'),
(12, 1, '四海遊龍', '牛肉湯餃', 60, '牛肉湯餃.jpg'),
(13, 1, '四海遊龍', '酸辣湯餃', 60, '酸辣湯餃.jpg'),
(14, 1, '四海遊龍', '牛肉麵', 100, '牛肉麵.jpg'),
(15, 1, '四海遊龍', '牛肉乾拌麵', 85, '牛肉乾拌麵.jpg'),
(16, 1, '四海遊龍', '牛肉醬拌麵', 90, '牛肉醬拌麵.jpg'),
(17, 1, '四海遊龍', '餛飩麵', 95, '餛飩麵.jpg'),
(18, 2, '丸龜製麵', '湯烏龍麵', 99, '湯烏龍麵.jpg'),
(19, 2, '丸龜製麵', '溫玉濃湯烏龍麵', 99, '溫玉濃湯烏龍麵.jpg'),
(20, 2, '丸龜製麵', '釜揚烏龍麵', 99, '釜揚烏龍麵.jpg'),
(21, 2, '丸龜製麵', '豆皮烏龍麵', 109, '豆皮烏龍麵.jpg'),
(22, 2, '丸龜製麵', '明太蛋拌烏龍麵', 109, '明太蛋拌烏龍麵.jpg'),
(23, 2, '丸龜製麵', '豚骨烏龍麵', 109, '豚骨烏龍麵.jpg'),
(24, 2, '丸龜製麵', '香辣豚骨烏龍麵', 119, '香辣豚骨烏龍麵.jpg'),
(25, 2, '丸龜製麵', '牛肉牛蒡烏龍麵', 109, '牛肉牛蒡烏龍麵.jpg'),
(26, 2, '丸龜製麵', '牛肉牛蒡溫玉濃湯烏龍麵', 119, '牛肉牛蒡溫玉濃湯烏龍麵.jpg'),
(27, 2, '丸龜製麵', '牛肉牛蒡蛋拌烏龍麵', 129, '牛肉牛蒡蛋拌烏龍麵.jpg'),
(28, 2, '丸龜製麵', '咖哩烏龍麵', 109, '咖哩烏龍麵.jpg'),
(29, 2, '丸龜製麵', '炸蓮藕', 40, '炸蓮藕.jpg'),
(30, 2, '丸龜製麵', '咖哩可樂餅', 35, '咖哩可樂餅.jpg'),
(31, 2, '丸龜製麵', '炸地瓜', 35, '炸地瓜.jpg'),
(32, 2, '丸龜製麵', '炸白身魚', 40, '炸白身魚.jpg'),
(33, 2, '丸龜製麵', '炸什錦', 40, '炸什錦.jpg'),
(34, 2, '丸龜製麵', '炸蝦', 35, '炸蝦.jpg'),
(35, 2, '丸龜製麵', '炸雞', 35, '炸雞.jpg'),
(36, 2, '丸龜製麵', '炸茄子', 30, '炸茄子.jpg'),
(37, 2, '丸龜製麵', '炸竹輪', 30, '炸竹輪.jpg'),
(38, 2, '丸龜製麵', '炸青椒', 30, '炸青椒.jpg'),
(39, 2, '丸龜製麵', '明太子飯糰', 35, '明太子飯糰.jpg'),
(40, 2, '丸龜製麵', '牛肉飯糰', 35, '牛肉飯糰.jpg'),
(41, 2, '丸龜製麵', '鮭魚飯糰', 40, '鮭魚飯糰.jpg'),
(42, 2, '丸龜製麵', '豆皮壽司', 25, '豆皮壽司.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--

CREATE TABLE `Orders` (
`ID` int(11) NOT NULL,
  `orderID` varchar(100) NOT NULL,
  `shopID` int(11) NOT NULL,
  `foodID` int(11) NOT NULL,
  `orderNumber` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `customerName` varchar(25) NOT NULL,
  `cellphoneNumber` varchar(10) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `Orders`
--

INSERT INTO `Orders` (`ID`, `orderID`, `shopID`, `foodID`, `orderNumber`, `total`, `customerName`, `cellphoneNumber`) VALUES
(3, '20160410339138678442127', 2, 18, 2, 2, 'Steve', '0956111120'),
(4, '20160410339138678442127', 2, 28, 2, 2, 'Steve', '0956111120'),
(5, '2016041033929353849291', 2, 18, 10, 990, 'sass', '0222552522'),
(7, '20160410341857530272949', 1, 1, 2, 12, 'Hogg', '0955522212'),
(8, '20160410342091501665996', 2, 18, 25, 2475, 'Steve ', '0925677252'),
(9, '20160410342542165557308', 1, 6, 5, 40, 'Teague ', '0922365589');

-- --------------------------------------------------------

--
-- Table structure for table `Shops`
--

CREATE TABLE `Shops` (
`shopID` int(11) NOT NULL,
  `shopName` varchar(25) NOT NULL,
  `shopLogo` varchar(25) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `Shops`
--

INSERT INTO `Shops` (`shopID`, `shopName`, `shopLogo`) VALUES
(1, '四海遊龍', '四海遊龍.jpg'),
(2, '丸龜製麵', '丸龜製麵.jpg'),
(3, '蒲家廚房', 'null.jpg'),
(4, '洪媽媽', 'null.jpg'),
(5, '三顧茅廬', '三顧茅廬.jpg'),
(6, '海音咖啡', 'null.jpg'),
(7, '廣東鴨庄', 'null.jpg'),
(8, '吉利素食', 'null.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Menus`
--
ALTER TABLE `Menus`
 ADD PRIMARY KEY (`foodID`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Shops`
--
ALTER TABLE `Shops`
 ADD PRIMARY KEY (`shopID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Menus`
--
ALTER TABLE `Menus`
MODIFY `foodID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=43;
--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `Shops`
--
ALTER TABLE `Shops`
MODIFY `shopID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
