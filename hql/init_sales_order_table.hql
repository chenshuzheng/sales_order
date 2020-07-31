-- 创建销售订单主题的ods层
create database if not exists `sales_order_ods`;
USE `sales_order_ods`;

-- 创建ods层销售订单表
CREATE TABLE IF NOT EXISTS `sales_order_ods`.`sales_order` (
  `order_number` int,
  `customer_number` int,
  `product_code` int,
  `order_date` string,
  `entry_date` string,
  `order_amount` decimal(18,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
;

-- 创建ods层客户表
CREATE TABLE IF NOT EXISTS `sales_order_ods`.`customer` (
  `customer_number` int,
  `customer_name` string,
  `customer_street_address` string,
  `customer_zip_code` int,
  `customer_city` string,
  `customer_state` string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
;

-- 创建ods层产品表
CREATE TABLE IF NOT EXISTS `sales_order_ods`.`product` (
  `product_code` int,
  `product_name` string,
  `product_category` string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
;

