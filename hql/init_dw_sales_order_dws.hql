-- 创建销售订单主题的dws层
CREATE DATABASE IF NOT EXISTS `sales_order_dws`;
USE `sales_order_dws`;

-- 创建dws层销售订单表
CREATE TABLE IF NOT EXISTS `sales_order_dws`.`fact_sales_order` (
  `order_sk` int,
  `customer_sk` int,
  `product_sk` int,
  `order_date_sk` int,
  `order_amount` decimal(18,2)
)
CLUSTERED BY(order_sk) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC
;

-- 导入事实表数据
INSERT OVERWRITE TABLE `sales_order_dws`.`fact_sales_order`
SELECT
do.order_sk order_sk,
dc.customer_sk customer_sk,
dp.product_sk product_sk,
dd.date_sk order_date_sk,
so.order_amount order_amount
FROM
sales_order_ods.sales_order so
JOIN
sales_order_dwd.dim_order do
ON
so.order_number = do.order_number
JOIN
sales_order_dwd.dim_product dp
ON
so.product_code = dp.product_code 
JOIN
sales_order_dwd.dim_customer dc
ON
so.customer_number = dc.customer_number
JOIN
sales_order_dwd.dim_date dd
ON
to_date(so.order_date) = dd.date
;