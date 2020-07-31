#!/bin/bash
SQOOP_HOME=/opt/apps/sqoop-1.4.6-cdh5.7.6
$SQOOP_HOME/bin/sqoop import \
--connect jdbc:mysql://2002slave1/sales_source \
--username root \
--password-file hdfs://2002master:9000/sqoop/password.txt \
--table customer \
--hive-import \
--hive-table sales_order_ods.customer \
--fields-terminated-by ',' \
--delete-target-dir \
--num-mappers 1 \
--as-textfile

$SQOOP_HOME/bin/sqoop import \
--connect jdbc:mysql://2002slave1/sales_source \
--username root \
--password-file hdfs://2002master:9000/sqoop/password.txt \
--table product \
--hive-import \
--hive-table sales_order_ods.product \
--fields-terminated-by ',' \
--delete-target-dir \
--num-mappers 1 \
--as-textfile

$SQOOP_HOME/bin/sqoop import \
--connect jdbc:mysql://2002slave1/sales_source \
--username root \
--password-file hdfs://2002master:9000/sqoop/password.txt \
--table sales_order \
--hive-import \
--hive-table sales_order_ods.sales_order \
--fields-terminated-by ',' \
--delete-target-dir \
--num-mappers 1 \
--as-textfile