import { GraphDataId } from "./GraphId";
import { GraphPoolData } from "./GraphPool";

export interface DexChainData {
  graphDataId: GraphDataId;
  data: GraphPoolData[];
}
