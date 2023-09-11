import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(event)
    with open('connection_table', 'r') as file:
        table_name = file.read().strip()
    connection_id = event.get("requestContext", {}).get("connectionId")
    table = boto3.resource("dynamodb").Table(table_name)
    body = json.loads(event.get('body'))
    logger.info(body)
    table.put_item(Item={"connection_id": connection_id, "on":body.on})
    return '1'