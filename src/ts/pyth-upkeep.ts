import { fetchPythData } from '@utils/pyth/hermes'
import { iPythABI } from '@utils/viem/abi/ipyth'
import { addr } from '@utils/viem/config'
import { walletKr } from '@utils/viem/wallets'

const pythPayload = await fetchPythData(['ARB', 'SOL', 'USDC', 'ETH', 'BTC', 'EUR', 'JPY'], 'ts')

while (true) {
  await walletKr.writeContract({
    abi: iPythABI,
    address: addr.pyth[42161],
    functionName: 'updatePriceFeeds',
    args: [pythPayload.payload],
    value: 7n,
  })
  console.log('updated price feeds')
  await new Promise(r => setTimeout(r, 25000))
}
