import { getBuiltGraphSDK, execute } from "./.graphclient";

(async () => {
  const w = await getBuiltGraphSDK().GetPoolsBsc({ first: 20000, skip: 0 });
  debugger;
})();
