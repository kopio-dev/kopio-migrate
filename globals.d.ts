export declare global {
  type Maybe<T> = T | null | undefined
  type Opt<T> = T | undefined
  type Bool<T> = T extends Falsy ? false : true

  type ReadAny<T> = T extends [...any[]] ? readonly [...T] | [...T] : never

  type NumVal = string | number | bigint

  type Result<T, TActual = T extends TFunc ? ReturnType<T> : T> = TActual extends PromiseLike<infer U>
    ? Awaited<U>
    : TActual

  type Sure<T> = T extends Falsy ? never : T

  type Falsy = undefined | null | false

  type If<T, R1, R2 = never> = T extends Falsy ? R2 : R1
  type Is<T, What, R1, R2 = never> = T extends What ? R1 : R2
}
