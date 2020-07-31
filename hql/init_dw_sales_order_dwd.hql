create database if not exists `sales_order_dwd`;
USE `sales_order_dwd`;

-- 创建dwd层产品表
CREATE TABLE IF NOT EXISTS `sales_order_dwd`.`dim_product` (
  `product_sk` int, 
  `product_code` int,
  `product_name` string,
  `product_category` string,
  `version` string,
  `effective_date` string,
  `expire_date` string 
)
CLUSTERED BY(product_sk) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC
;

-- 创建dwd层销售订单表
CREATE TABLE IF NOT EXISTS `sales_order_dwd`.`dim_date` (
  `date_sk` int,
  `date` string,
  `month` int,
  `monthname` string,
  `quarter` string,
  `year` int
)
CLUSTERED BY(date_sk) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
;

-- 创建dwd层客户表
CREATE TABLE IF NOT EXISTS `sales_order_dwd`.`dim_customer` (
  `customer_sk` int,
  `customer_number` int,
  `customer_name` string,
  `customer_street_address` string,
  `customer_zip_code` int,
  `customer_city` string,
  `customer_state` string,
  `version` string,
  `effective_date` string,
  `expire_date` string 
)
CLUSTERED BY(customer_sk) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC
;


-- 创建dwd层销售订单表
CREATE TABLE IF NOT EXISTS `sales_order_dwd`.`dim_order` (
  `order_sk` int,
  `order_number` int,
  `version` string,
  `effective_date` string,
  `expire_date` string 
)
CLUSTERED BY(order_sk) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC
;


-- 向dim_order中导入数据
INSERT OVERWRITE TABLE `sales_order_dwd`.`dim_order`
SELECT 
row_number() over(order by o.order_number) order_sk,
`order_number`,
'1',
from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss'),
'9999-12-31'
from 
`sales_order_ods`.`sales_order` o
;


-- 向dim_customer导入数据
INSERT OVERWRITE TABLE `sales_order_dwd`.`dim_customer`
SELECT 
  row_number() over(order by c.customer_number) customer_sk,
  `customer_number` ,
  `customer_name` ,
  `customer_street_address`,
  `customer_zip_code`,
  `customer_city` ,
  `customer_state` ,
  '1',
  from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss'),
  '9999-12-31'
from  `sales_order_ods`.`customer` c
;

-- 向dim_product导入数据
INSERT OVERWRITE TABLE `sales_order_dwd`.`dim_product`
SELECT 
  row_number() over(order by p.product_code) product_sk,
  `product_code`,
  `product_name`,
  `product_category`,
  '1',
  from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss'),
  '9999-12-31'
from  `sales_order_ods`.`product` p
;

-- 导入dim_date
LOAD DATA INPATH '/dw/date/dim_date.csv' INTO TABLE sales_order_dwd.dim_date;

