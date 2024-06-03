import { tickers } from '@utils/pyth/config'
import { hermes } from '@utils/pyth/hermes'

const response = await fetch(hermes.sse([tickers.ETH, tickers.BTC]))

if (!response.body) throw new Error('No reader')

const reader = response.body.getReader()
const decoder = new TextDecoder()
while (true) {
  const { done, value } = await reader.read()
  if (done) break
  console.log(decoder.decode(value))
}
