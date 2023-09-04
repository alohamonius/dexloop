import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handle_not_found(table, connection_id):
    """
    Handle the case when the action is not found.
    """
    return 404

def handle_connect(table, connection_id):
    status_code = 200
    try:
        table.put_item(Item={"connection_id": connection_id})
        logger.info("Added connection %s", connection_id)
    except ClientError:
        logger.exception("Couldn't add connection %s", connection_id)
        status_code = 503
    return status_code

def handle_disconnect(table, connection_id):
    status_code = 200
    try:
        table.delete_item(Key={"connection_id": connection_id})
        logger.info("Disconnected connection %s.", connection_id)
    except ClientError:
        logger.exception("Couldn't disconnect connection %s.", connection_id)
        status_code = 503
    return status_code

def handle_default(event, connection_id):
    logger.info('onDefault')
    # body = json.loads(event.get('body'))
    # logger.info(body)
    
    
    return 400

action_handlers = {
        "$connect": handle_connect,
        "$disconnect": handle_disconnect,
        "$default": handle_default,
    }

def lambda_handler(event, context):
    logger.info(event)
    with open('connection_table', 'r') as file:
        table_name = file.read().strip()
    connection_id = event.get("requestContext", {}).get("connectionId")
    table = boto3.resource("dynamodb").Table(table_name)
    routeKey = event.get('requestContext',{}).get('routeKey')
    response_handler = action_handlers.get(routeKey, handle_not_found)
    response = {
        "statusCode": response_handler(table, connection_id),
        "body":json.dumps("HELLo")
        }
    
    return response