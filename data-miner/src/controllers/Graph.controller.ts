import { Request, Response, Router, NextFunction } from "express";
import { DexPairsRepositoryInMemory } from "../graph/DexPairsRepositoryMemory";
import AppRoute from "./AppRoute";
import { Lifecycle, autoInjectable, container, scoped } from "tsyringe";
import { query, body, matchedData, validationResult } from "express-validator";
import { AppLogger } from "../utils/App.logger";
import { ChainGraphClient } from "../graph/api/ChainGraphClient";
import { GraphPairId } from "../models/GraphId";

@autoInjectable()
export default class GraphController implements AppRoute {
  route: string = "/graph";
  router: Router = Router();
  repository: DexPairsRepositoryInMemory;
  api = new ChainGraphClient();
  constructor(repository: DexPairsRepositoryInMemory) {
    this.repository = repository;

    this.router.post(
      "/apiByIds",
      query("chain").exists().withMessage("required"),
      body("pairs").exists().withMessage("required"),
      (req, res, next) => this.getApiPairsData(req, res, next)
    );

    this.router.post(
      "/cachePairToPools",
      body("pairs").exists().withMessage("required"),
      (req, res, next) => this.getPairsToPools(req, res, next)
    );

    this.router.post(
      "/cachePairsData",
      query("chain").exists().withMessage("required"),
      body("pairs").exists().withMessage("required"),
      (req, res, next) => this.getPairsToPools(req, res, next)
    );
    this.router.get("/cacheStats", (req, res, next) =>
      this.getCacheStats(req, res, next)
    );
    this.router.get(
      "/cacheChainToPairs",
      query("chain").exists().withMessage("required"),
      (req, res, next) => this.getCachePairIds(req, res, next)
    );
  }

  getPairsToPools(request: Request, response: Response, next: NextFunction) {
    const result = validationResult(request);
    if (!result.isEmpty()) response.send(result.array());
    const tokenIds: any = request.body;

    const data = this.repository.getPairToPools(tokenIds.pairs);
    response.json(Array.from(data.entries()));
  }

  getCachePairIds(request: Request, response: Response, next: NextFunction) {
    const chain: any = request.query.chain;
    const chainPairs = this.repository.getPairs(chain);
    response.json(chainPairs);
  }

  async getApiPairsData(
    request: Request,
    response: Response,
    next: NextFunction
  ) {
    const result = validationResult(request);
    if (!result.isEmpty()) response.send(result.array());
    const chain: any = request.query.chain;
    const tokenIds: GraphPairId[] = request.body.pairs;
    const data = await this.api.getByIds(chain, tokenIds);
    response.json(data);
  }

  getCacheStats(request: Request, response: Response, next: NextFunction) {
    const data = this.repository.getStats();
    response.json(data);
  }
}
