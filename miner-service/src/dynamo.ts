import { GraphPoolData } from "./models/GraphPool";
import { PromiseResult } from "aws-sdk/lib/request";
import { AppLogger } from "./utils/App.logger";
import AWS from "aws-sdk";

//export type PutItemInputAttributeMap = {[key: string]: AttributeValue}; - DICTIONARY
export function createOrUpdate(poolData: GraphPoolData, dataId: string) {
  const t0 = poolData.token0;
  const t1 = poolData.token1;
  const item = {
    GraphId: { S: dataId },
    PairId: { S: poolData.pairId },
    dexPoolId: { S: poolData.dexPoolId ?? "N/A" },
    pair: { S: poolData.pair ?? "N/A" },
    token0Price: { S: poolData.token0Price },
    token1Price: { S: poolData.token1Price },
    token0: { S: `${t0.id}___${t0.symbol}___${t0.name}___${t0.decimals}` },
    token1: { S: `${t1.id}___${t1.symbol}___${t1.name}___${t1.decimals}` },
    volumeUSD: { S: poolData.totalVolumeUSD ?? "0" },
    // timestamp: { N: 1 },
    // fee: { N: poolData.fee },
  };
  const dynamodb = new AWS.DynamoDB();
  const tableName = process.env.DYNAMO_TABLE;

  const putItemParams: AWS.DynamoDB.PutItemInput = {
    TableName: tableName,
    Item: item,
  };

  return awsCall(dynamodb.putItem(putItemParams).promise());
  // return dynamodb.putItem(putItemParams).promise();
}

async function awsCall(
  func: Promise<PromiseResult<AWS.DynamoDB.PutItemOutput, AWS.AWSError>>
) {
  try {
    const result = await func;
    return result;
  } catch (e) {
    AppLogger.error(e.message);
  }
}
