import { singleton } from "tsyringe";
import { distinctKey, getPairIds, toDictinary } from "../utils/utils";
import { DexPairsRepositoryInMemory } from "./DexPairsRepositoryMemory";
import { AppLogger } from "../utils/App.logger";
import { DexChainData } from "../models/DexChainData";
import { GraphId, PairId } from "../models/GraphId";
import { GraphPoolData } from "../models/GraphPool";
import { createOrUpdate } from "../db";

@singleton()
export class DexDataHandler {
  private _repository: DexPairsRepositoryInMemory;
  private _db = new Map<GraphId, Map<PairId, GraphPoolData[]>>();

  constructor(repository: DexPairsRepositoryInMemory) {
    AppLogger.info("DexDataHandler ctor");
    this._repository = repository;
  }
  public async handle(graphData: DexChainData[]) {
    const w = graphData.map(async (data) => {
      const dataId = data.graphDataId.id();

      const pools = distinctKey<GraphPoolData>(data.data, "pairId");
      const d = data.data[0];
      return createOrUpdate(d, dataId);
      return;

      const pairIds: PairId[] = pools.map((c) => c.pairId);

      this._repository.setChainPairs(data.graphDataId.chain, pairIds);
      const dexСhainVData = toDictinary(pools);

      AppLogger.info(`${dataId} has pairs:${pairIds.length}`);

      this._db.set(dataId, dexСhainVData);
      //
      //I want store _db value to dynamoDB
      //
    });
    await Promise.all(w.slice(0, 3));

    // this._repository.setChainPairPools(Array.from(this._db.entries()));
  }
}
