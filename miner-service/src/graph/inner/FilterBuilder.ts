import { Chain, PairId } from "../../models/GraphId";

//TODO:WORKS ONLY FOR MATIC, TEST
const ChainToWhere = {
  [Chain.matic]: {
    or: [
      {
        token0_in: [],
        totalValueLockedUSD_gt: 123332,
      },
      {
        token1_in: [],
        totalValueLockedUSD_gt: 123332,
      },
    ],
  },
};

const ChaintToFirstLimit = {
  [Chain.bsc]: 20000,
  [Chain.eth]: 20000,
  [Chain.matic]: 5000,
};

function createFilter(chain: Chain, pairIds: PairId[]) {
  const filter = ChaintToFirstLimit[chain];
  const o = ChainToWhere[chain];
}
