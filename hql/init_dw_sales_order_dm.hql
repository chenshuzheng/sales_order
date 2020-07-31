-- 创建销售订单主题的dws层
CREATE DATABASE IF NOT EXISTS `sales_order_dm`;
USE `sales_order_dm`;

-- 创建dm层销售订单表
CREATE TABLE IF NOT EXISTS `sales_order_dm`.`sales_order_cnt` (
  `date` string,
  `customer_number` int,
  `customer_name` string,
  `order_cnt1` int,
  `order_amt1` decimal(18,2),
  `order_cnt2` int,
  `order_amt2` decimal(18,2)
)
CLUSTERED BY(customer_number) INTO 8 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
STORED AS textfile
;


-- 将dw层的数据分析导入到dm层
FROM (
select 
nvl(tmp1.date, tmp2.date) date,
nvl(tmp1.customer_number, tmp2.customer_number) customer_number,
nvl(tmp1.customer_name, tmp2.customer_name) customer_name,
nvl(tmp1.cnt1, 0),
nvl(tmp1.amt1, 0),
nvl(tmp2.cnt2, 0) + nvl(tmp1.cnt1, 0),
nvl(tmp2.amt2, 0) + nvl(tmp1.amt1, 0)
from
(
 select
 dd.date date,
 dc.customer_number customer_number,
 dc.customer_name customer_name,
 count(customer_number) cnt1,
 sum(order_amount) amt1
 from `sales_order_dws`.`fact_sales_order` fso
 join
 sales_order_dwd.dim_date dd
 on fso.order_date_sk = dd.date_sk
 join
 sales_order_dwd.dim_customer dc
 on fso.customer_sk = dc.customer_sk
 where dd.date = '2018-10-01'
 group by 
 date,
 customer_number,
 customer_name
)tmp1
full join 
(
 select
 dd.date date,
 dc.customer_number customer_number,
 dc.customer_name customer_name,
 count(customer_number) cnt2,
 sum(order_amount) amt2
 from `sales_order_dws`.`fact_sales_order` fso
 join
 sales_order_dwd.dim_date dd
 on fso.order_date_sk = dd.date_sk
 join
 sales_order_dwd.dim_customer dc
 on fso.customer_sk = dc.customer_sk
 where dd.date = date_sub('2018-10-01',1)
 group by 
 date,
 customer_number,
 customer_name
)tmp2
on tmp1.customer_number = tmp2.customer_number
)tmp3
INSERT OVERWRITE TABLE `sales_order_dm`.`sales_order_cnt`
SELECT *
;
