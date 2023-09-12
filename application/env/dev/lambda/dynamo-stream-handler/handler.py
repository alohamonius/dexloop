import json
import logging
import os
import boto3
from botocore.exceptions import ClientError
import pickle
import base64

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# import concurrent.futures
# def send_message_to_connection(connection_id, message, apig_management_client):
#     try:
#         apig_management_client.post_to_connection(
#             ConnectionId=connection_id,
#             Data=message,
#         )
#         return None  # Success
#     except ClientError as e:
#         return e

# def send_data_to_all_connections(connections, message, apig_management_client):
#     with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
#         # Use ThreadPoolExecutor for concurrent execution of send_message_to_connection
#         futures = {executor.submit(send_message_to_connection, conn["connection_id"], message, apig_management_client): conn for conn in connections}
        
#         # Wait for all futures to complete
#         concurrent.futures.wait(futures)

def lambda_handler(event, context):
    with open('api_url', 'r') as file:
        api_url = file.read().strip()
    with open('connection_table', 'r') as file:
        table_name = file.read().strip()

    logger.info(event)  
    logger.info(event.items())
    records = event["Records"]
    recordsToPush = [item['dynamodb']['NewImage'] for item in records]

    apig_management_client = boto3.client(
        "apigatewaymanagementapi", endpoint_url=api_url
    )
    dynamoDb = boto3.client("dynamodb")
    all_connections = []
    scan_params = {
        'TableName': table_name,
    }
    response = dynamoDb.scan(**scan_params) #!!!!!! Scanning DynamoDB is not ideal in terms of cost or performance. I've learned this the hard way.
    while 'LastEvaluatedKey' in response:
        all_connections.extend(response['Items'])
        scan_params['ExclusiveStartKey'] = response['LastEvaluatedKey']
        response = dynamoDb.scan(**scan_params)

    all_connections.extend(response['Items'])
    connection_ids = [item['connection_id']['S'] for item in all_connections]
    #send_data_to_all_connections(connections, event.records, apig_management_client)
    logger.info(recordsToPush)
    for connection_id in connection_ids:
        try:
            # test ={"messages": ["a"]}   
            test = recordsToPush

            w =json.dumps(test).encode('utf-8')
            apig_management_client.post_to_connection(
                ConnectionId=connection_id,
                Data=w
            )
        except ClientError as e:    
            logger.error(e)
            return e

    return {"statusCode":200}