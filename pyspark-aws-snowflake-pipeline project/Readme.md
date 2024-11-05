# Spotify End-To-End Data Pyspark Engineering project

### Introduction 
In this project, we will build an ETL [Extract ,Transform, Load] Pipeline using Spotify API on AWS. The Pipeline will retrive the data from the Spotify API, transform it to a desired format, and load it into an AWS data store.

### Architecture
![Architecture Diagram](https://github.com/DineshchandraRS/RealTime-Pipelines-AWS-Snowflake/blob/main/pyspark-aws-snowflake-pipeline%20project/Screenshot%202024-10-31%20000138.png)

### About Dataset/API
This API contains information aboy music artist, albums and songs - [Spotify API](https://developer.spotify.com/documentation/)

### Services Used
1. **S3(Simple Storage Service):** Amazon S3(Simple Storage Service) is a highly scalable object storage service that can store and retrieve any amount of data from anywhere on the web. It is commonly used to store and distribute large media files, data backups, and static website files.

2. **AWS Lambda:** AWS Lambda is as serverless computing service that lets you run your code without managing servers. You can use Lambda to run code and to get response to events like changes in S3, DynamoDB, or other AWS services.

3. **Cloud Watch:** Amazon Cloudwatch is a monitoring service for AWS resources and the applications you run on them. YOu can use CloudWatch Trigger to track metrics,  collect and monitor log files, and set alarms.

4. **AWS Glue:** AWS Glue is a serverless data integration service that helps users discover, prepare, and move data for analytics, machine learning, and application development. In Glue i used data transformations using Pyspark.
   
6. **Snowpipe:** Snowpipe is a serverless data ingestion service from Snowflake that loads data into Snowflake data warehouses from files or other sources

7. **Snowflake:**Snowflake enables data storage, processing, and analytic solutions that are faster, easier to use, and far more flexible than traditional offerings.  It is OLAP database that i stored the data from AWS.


### Install Packages
```
pip install pandas
pip install numpy
pip install spotify
```

### Project Execution Flow
Extract data from API -> Lambda Trigger (every 1 hour) -> Run Extract code -> Store raw Data -> Trigger Transform Function in Glue -> Transform Data and Load It using snowpipe -> Query using Snowflake
