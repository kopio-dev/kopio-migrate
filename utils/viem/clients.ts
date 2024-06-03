import { http, createPublicClient } from 'viem'
import { arbitrum, optimism } from 'viem/chains'
import { transports } from './config'

export const arb = createPublicClient({
  transport: transports[42161],
  batch: {
    multicall: true,
  },
  chain: arbitrum,
  cacheTime: 0,
})
export const opt = createPublicClient({
  transport: transports[10],
  batch: {
    multicall: true,
  },
  chain: optimism,
  cacheTime: 0,
})

export const arbPersonal = createPublicClient({
  transport: http(process.env.RPC_ARBITRUM_PERSONAL!),
  batch: {
    multicall: true,
  },
  chain: arbitrum,
  cacheTime: 0,
})
