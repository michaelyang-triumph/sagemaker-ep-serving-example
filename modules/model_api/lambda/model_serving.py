import os
import io
import boto3
import json
import csv
import logging

# grab environment variables
ENDPOINT_NAME = os.environ['ENDPOINT_NAME']
LOG_LEVEL     = os.environ['LOG_LEVEL']

# set logger
logger = logging.getLogger()
logger.setLevel(LOG_LEVEL)

runtime= boto3.client('runtime.sagemaker')

def lambda_handler(event, context):

    try:

        logger.info("Received event: " + json.dumps(event, indent=2))
        
        data = json.loads(json.dumps(event))
        payload = json.loads(data['body'])['data']
        logger.info(payload)
        
        response = runtime.invoke_endpoint(EndpointName=ENDPOINT_NAME,
                                        ContentType='text/csv',
                                        Body=payload)
        logger.info(f"Response: {response}")
        result = json.loads(response['Body'].read().decode())
        logger.info(f"Results: {result}")

    except Exception as e:

        result = {"error": str(e)}
    
    return {
    "statusCode": 200,
    "body": str(result)
    }