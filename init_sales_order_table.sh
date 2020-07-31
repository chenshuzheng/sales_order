#!bin/bash
HIVE_HOME=/opt/apps/hive-1.1.0-cdh5.7.6
function main() {
    sql='
        create database if not exists `sales_order_ods`;
        USE `sales_order_ods`;
        CREATE TABLE IF NOT EXISTS `sales_order_ods`.`sales_order` (
          `order_number` int,
          `product_code` int,
            `customer_number` int,
        `order_date` string,
          `entry_date` string,
          `order_amount` decimal(18,2)
        )
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        ;

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

        CREATE TABLE IF NOT EXISTS `sales_order_ods`.`product` (
          `product_code` int,
          `product_name` string,
          `product_category` string
        )
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        ;
    '
	${HIVE_HOME}/bin/hive -e "$sql"
}
main