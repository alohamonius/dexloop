import { Chain } from "../../models/ChainType";

export interface GraphApiResponse {
  chain: Chain;
  data: any[];
  error: any[];
}
