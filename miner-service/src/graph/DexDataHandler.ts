import { singleton } from "tsyringe";
import { AppLogger } from "../utils/App.logger";
import { DexChainData } from "../models/DexChainData";
import { createOrUpdate } from "../dynamo";

@singleton()
export class DexDataHandler {
  constructor() {
    AppLogger.info("DexDataHandler ctor");
  }
  public async handle(graphData: DexChainData[]) {
    const dynamoTasks = graphData.map(async (data) => {
      const graphDataId = data.graphDataId.id();
      return data.data.map((item) => createOrUpdate(item, graphDataId));
    });
    await Promise.all(dynamoTasks.slice(0, 3));
  }
}
