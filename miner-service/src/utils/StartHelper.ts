import { Chain } from "../models/ChainType";

export function parseArguments(): IStartConfig {
  const defaultPollingMode = true;
  const defaultDebugMode = false;

  const port = parseInt(process.env.PORT, 10) || 3000;
  const chainsArg = process.argv[2];
  const dynamoTable = process.argv[3];
  const pollingArg = process.argv[4];
  const debugArg = process.argv[5];

  if (!chainsArg) {
    throw new Error("Chains argument is missing.");
  }

  const chains = chainsArg.split(",").map((c) => Chain[c.trim()]);

  if (!pollingArg) {
    console.warn("Polling argument is missing. Defaulting to true.");
  }

  const polling = pollingArg ? parseBool(pollingArg) : defaultPollingMode;

  if (!debugArg) {
    console.warn("Debug argument is missing. Defaulting to false.");
  }

  const debug = debugArg ? parseBool(debugArg) : defaultDebugMode;

  return { chains, dynamoTable, polling, debug, port };
}

function parseBool(str: string): boolean {
  const normalizedStr = str.toLowerCase();
  return normalizedStr === "true";
}

interface IStartConfig {
  chains: Chain[];
  dynamoTable: string;
  port: number;
  debug: boolean;
  polling: boolean;
}
