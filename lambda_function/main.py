import boto3
import requests
import csv

def lambda_handler(event, context):
    response = requests.get('') 
    
    
    data = response.json()
    processed_data = extract_data(data) 
    
   
    csv_data = convert_to_csv(processed_data)
    

    bucket_name = 'surfline-data-bucket'
    file_name = 'surfline_data.csv' 
    
    s3 = boto3.client('s3')
    s3.put_object(Body=csv_data, Bucket=bucket_name, Key=file_name)
    
    return {
        'statusCode': 200,
        'body': 'Data successfully collected and exported to S3 bucket.'
    }

def extract_data(data):
    return extract_data

def convert_to_csv(data):
    csv_data = ''
    csv_writer = csv.writer(csv_data)
    for row in data:
        csv_writer.writerow(row)
    return csv_data
