import { getBuiltGraphSDK, execute } from "./.graphclient";

(async () => {
  // const data = await getBuiltGraphSDK().GetPoolsByIdsEth({
  //   first: 100,
  //   skip: 0,
  //   tokenOut: ["0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"],
  //   tokenIn: ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"],
  //   totalLocked: 1_000_000,
  // });
  const w = await getBuiltGraphSDK().GetPoolsEth({ first: 20000, skip: 0 });
  console.log(Object.keys(w).map((key) => w[key].length));
  debugger;
})();
