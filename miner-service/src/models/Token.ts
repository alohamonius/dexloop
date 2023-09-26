export interface IToken {
  id: string;
  symbol: string;
  name: string;
  decimals: string;
  getId(): string;
}

export class Token implements IToken {
  id: string;
  symbol: string;
  name: string;
  decimals: string;
  public getId = () =>
    `${this.id}_${this.symbol}_${this.name}_${this.decimals}`;
}
