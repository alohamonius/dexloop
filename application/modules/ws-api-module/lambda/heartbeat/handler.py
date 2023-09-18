import json
import logging
import os
import boto3
from botocore.exceptions import ClientError
    
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    return {"statusCode":200}