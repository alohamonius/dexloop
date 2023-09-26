import { DexChainData } from "./DexChainData";
import { toPairId } from "../utils/utils";
import { GraphDataId, GraphPoolId } from "./GraphId";
import { GraphPoolData } from "./GraphPool";

export function createGraphData(result: any): DexChainData[] {
  return Object.keys(result).map((key) => {
    const id: GraphDataId = GraphPoolId.Create(key);
    const data: any[] = result[key];

    const now = Date.now();
    data.map((d) => {
      d.id = id;
      d.pairId = toPairId(d);
      d.fee = d.feeTier ? parseFloat(d.feeTier) / 10000 : 0;
      d.pair = `${d.token0.symbol}/${d.token1.symbol}`;
      d.timestamp = d.syncAtTimestamp || now;
      delete d.feeTier;
    });
    return { graphDataId: id, data };
  });
}
