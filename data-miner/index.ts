import "reflect-metadata";
import { container } from "tsyringe";
import { AppLogger } from "./src/utils/App.logger";
import ExpressApi from "./Api";
import { getMemoryUsage } from "./src/utils/utils";
import LiveJob from "./src/graph/jobs/LiveJob";
import PollingJob from "./src/graph/jobs/PollingJob";
import { parseArguments } from "./src/utils/StartHelper";
import AWS from "aws-sdk";

const envFile = process.env.CODEBUCKET_ENV
  ? `.env.${process.env.CODEBUCKET_ENV}`
  : ".env.example";
require("dotenv").config({ path: envFile });

const MEMORY_LIMIT_TO_RESTART_SUBSCRIPTIONS_MB = 1800;
const DEFAULT_POLLING_INTERVAL_SECONDS = 15;

const liveJob = container.resolve(LiveJob);
const pollingJob = container.resolve(PollingJob);

(async () => {
  AWS.config.update({
    region: process.env.REGION,
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  });
  const { polling, debug, port, chains } = parseArguments();
  const api = new ExpressApi();

  getMemoryUsage();

  if (polling) {
    await pollingJob.StartPollingAsync(
      chains,
      DEFAULT_POLLING_INTERVAL_SECONDS
    );
  } else {
    await pollingJob.PreloadAll(chains);
  }

  api.run(port, () => {
    AppLogger.info(`API started on port:${port}`);
  });

  if (debug) {
    setInterval(async () => {
      AppLogger.info(`Memory usage checker`);
      const { heapUsed } = getMemoryUsage();

      AppLogger.info(`Memory is okay Heap: ${heapUsed}MB`);
    }, 10000);
  }
})();
