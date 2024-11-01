create database if not exists scd_demo;
use database scd_demo;
create schema if not exists scd2;
use schema scd2;
show tables;

create or replace table customer (
     customer_id number,
     first_name varchar,
     last_name varchar,
     email varchar,
     street varchar,
     city varchar,
     state varchar,
     country varchar,
     update_timestamp timestamp_ntz default current_timestamp());

create or replace table customer_history (
     customer_id number,
     first_name varchar,
     last_name varchar,
     email varchar,
     street varchar,
     city varchar,
     state varchar,
     country varchar,
     start_time timestamp_ntz default current_timestamp(),
     end_time timestamp_ntz default current_timestamp(),
     is_current boolean
     );
     
create or replace table customer_raw (
     customer_id number,
     first_name varchar,
     last_name varchar,
     email varchar,
     street varchar,
     city varchar,
     state varchar,
     country varchar);
     
create or replace stream customer_table_changes on table customer;

create or replace storage integration scd_snowflake
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::982534387834:role/snowflake-s3-connection'
    STORAGE_ALLOWED_LOCATIONS = ('s3://dw-snowflake-course-dinesh')
    COMMENT = 'Creating connection between snowflake and AWS s3'


desc integration scd_snowflake
list @customer_ext_stage;

CREATE OR REPLACE STAGE SCD_DEMO.SCD2.customer_ext_stage
    url='s3://dw-snowflake-course-dinesh/stream_data'
    credentials = (AWS_KEY_ID = 'AKIA6JQ447B5FAJLG7JZ' AWS_SECRET_KEY = 'hTw9/EQc/0Vc1ZpOtGvZ5gQRrdqeG8+Pn9/aoA9N
');

CREATE OR REPLACE FILE FORMAT SCD_DEMO.SCD2.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @customer_ext_stage
  FILE_FORMAT = CSV
  ;

-- show pipes;

select SYSTEM$PIPE_STATUS('customer_s3_pipe');

SELECT count(*) FROM customer_raw;

truncate customer_raw;
