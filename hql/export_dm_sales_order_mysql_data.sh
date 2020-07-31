#!/bin/bash
SQOOP_HOME=/opt/apps/sqoop-1.4.6-cdh5.7.6
$SQOOP_HOME/bin/sqoop export \
--connect jdbc:mysql://2002slave1:3306/sales_order_res \
--username root \
--password-file hdfs://2002master:9000/sqoop/password.txt \
--export-dir /user/root/warehouse/sales_order_dm.db/sales_order_cnt \
--columns date,customer_number,customer_name,order_cnt1,order_amt1,order_cnt2,order_amt2 \
--input-fields-terminated-by '\001' \
--table sales_order_cnt \
--num-mappers 1