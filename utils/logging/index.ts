import { formatUnits } from 'viem'

export function formatPosition(prefix: string, pos: any) {
  return `${prefix}: ${formatAmount(pos.amount, pos.config.decimals)} ${pos.symbol} | $${formatPrice(
    pos.val,
  )} / $${formatPrice(pos.valAdj)}`
}

export function divider(type = '-') {
  console.log(type.repeat(60))
}
export function formatAmount(amt: bigint, decimals: number) {
  return Number(formatUnits(amt, decimals)).toFixed(8)
}
export function formatPrice(price: bigint) {
  return Number(formatUnits(price, 8)).toFixed(4)
}
