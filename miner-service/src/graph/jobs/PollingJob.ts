import { autoInjectable, singleton } from "tsyringe";
import { DexDataHandler } from "../DexDataHandler";
import { AppLogger } from "../../utils/App.logger";
import cron from "node-cron";
import { DexChainData } from "../../models/DexChainData";
import { ChainGraphClient } from "../api/ChainGraphClient";
import { GraphApiResponse } from "../api/GraphApiResponse";
import { createGraphData } from "../../models/domain";
import { Chain } from "../../models/ChainType";

@singleton()
@autoInjectable()
export default class PollingJob {
  handler: DexDataHandler;
  executor = new ChainGraphClient();
  jobs: cron.ScheduledTask[] = [];
  lock: Map<string, boolean> = new Map<string, boolean>();

  constructor(handler_: DexDataHandler) {
    this.handler = handler_;
    AppLogger.info(`PollingJob ctor`);
  }

  async StartPollingAsync(chains: Chain[], seconds: number) {
    chains.map(async (chain) => {
      const task = cron.schedule(`*/${seconds} * * * * *`, async () => {
        const data = await this.loadChain(chain);
        const parsedData: DexChainData[] = createGraphData(data.data);
        this.handler.handle(parsedData);
      });
      this.jobs.push(task);
    });
    this.jobs.forEach((task) => {
      task.start();
    });
  }

  async PreloadAll(chains: Chain[]): Promise<GraphApiResponse[]> {
    const all = await Promise.all(
      chains.map(async (chain) => {
        return this.loadChain(chain);
      })
    );

    return all;
  }

  private async loadChain(chain: Chain): Promise<GraphApiResponse> {
    if (this.lock.get(chain)) return;
    const start = Date.now();
    const data = await this.executor.getMaximumChainData(chain);
    const end = Date.now();

    AppLogger.info(`${chain} executed: ${end - start} ms`);
    this.lock.set(chain, false);
    if (data.error !== null) {
      AppLogger.error(data.error);
    }
    return data;
  }

  async StopAsync() {
    this.jobs.forEach((job) => {
      job.stop();
    });
    this.jobs = [];
  }
}
