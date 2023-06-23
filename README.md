# airflow-with-mysql-and-postgres
Creation of infrastructure using terraform in aws and use docker compose for apache airflow, mySQL and Postgres

# Terraform 

- The terraform create s3 bucket, lambda function and IAM roles then terraform is planned and applied .

# Docker :

- Here the main image is apache airflow .
- The sql acts backend server for airflow

- Then in postgres the data is stored and analysed

# AWS Lambda :

- A cron Job is done every one hr the data is fetched from api and stored as csv file in s3 .

