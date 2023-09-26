import { getBuiltGraphSDK as ethSdk } from "../clients/eth_rc/.graphclient";
import {
  GetPoolsByIdsBscQueryVariables,
  getBuiltGraphSDK as bscSdk,
} from "../clients/bsc_rc/.graphclient";
import { getBuiltGraphSDK as maticSdk } from "../clients/matic_rc/.graphclient";
import { Chain, ChainType } from "../../models/ChainType";
import { AppLogger } from "../../utils/App.logger";
import { GraphApiResponse } from "./GraphApiResponse";
import { GraphPairId } from "../../models/GraphId";

const ChaintToFirstLimit = {
  [Chain.bsc]: 20000,
  [Chain.eth]: 20000,
  [Chain.matic]: 5000,
};

export class ChainGraphClient {
  chainToApi = new Map<Chain, any>();

  constructor() {
    this.chainToApi.set(Chain.eth, {
      id: (filter) => ethSdk().GetPoolsByIdsEth(filter),
      all: (filter) => ethSdk().GetPoolsEth(filter),
    });

    this.chainToApi.set(Chain.bsc, {
      id: (filter) => bscSdk().GetPoolsByIdsBsc(filter),
      all: (filter) => bscSdk().GetPoolsBsc(filter),
    });

    this.chainToApi.set(Chain.matic, {
      id: (filter) => maticSdk().GetPoolsByIdsMatic(filter),
      all: (filter) => maticSdk().GetPoolsMatic(filter),
    });
  }

  public getChains(): Chain[] {
    return [Chain.bsc, Chain.eth, Chain.matic];
  }

  public getByIds(
    chain: Chain,
    pairIds: GraphPairId[],
    totalLocked: number = 1_000_000
  ): Promise<GraphApiResponse> {
    const api = this.chainToApi.get(chain);

    return this.apiCall(chain, () =>
      api.id({
        skip: 0,
        totalLocked: totalLocked,
        tokenIn: pairIds.map((c) => c.left),
        tokenOut: pairIds.map((c) => c.right),
      })
    );
  }

  //TODO: getAll -> HELL.
  public getMaximumChainData(
    chain: Chain,
    totalLocked: number = 1_000_000
  ): Promise<GraphApiResponse> {
    const api = this.chainToApi.get(chain);
    const first = ChaintToFirstLimit[chain];
    return this.apiCall(chain, () =>
      api.all({
        first: first,
        skip: 0,
        totalLocked: totalLocked,
      })
    );
  }

  public getAllChainsData(): Promise<GraphApiResponse[]> {
    const chains = Array.from(this.chainToApi.keys());
    const chainTasks = chains.map((chain) => {
      return this.getMaximumChainData(chain);
    });
    return Promise.all(chainTasks);
  }

  private async apiCall(
    chain: Chain,
    apiMethod: () => Promise<any[]>
  ): Promise<GraphApiResponse> {
    try {
      const response = await apiMethod();
      return {
        chain: chain,
        data: response || [],
        error: null,
      };
    } catch (error) {
      return {
        chain: chain,
        data: null,
        error: error.errors,
      };
    }
  }
}
