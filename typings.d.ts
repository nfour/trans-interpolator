
interface IInterpOptions {
    open: string;
    close: string;
    depth: number;
    transform: (resolved: string, value?: any, expression?: string) => string
}

declare class TransInterpolator {
    data: { [k: string]: any };
    open: IInterpOptions['open'];
    close: IInterpOptions['close']
    depth: IInterpOptions['depth']
    transform: IInterpOptions['transform']

    constructor (data: TransInterpolator['data'], options?: Partial<IInterpOptions>)

    interpolate (
        expression: string,
        transform?: IInterpOptions['transform'],
        depth?: number
    ): string
}

declare namespace TransInterpolator {}

export = TransInterpolator;
