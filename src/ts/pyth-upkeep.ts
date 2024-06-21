import { fetchPythData } from '@kr/pyth/pyth-hermes'
import { iPythConfig } from '@kr/viem/contracts/iPyth'
import { walletKr } from '@kr/viem/wallets'

const pythPayload = await fetchPythData(['ARB', 'SOL', 'USDC', 'ETH', 'BTC', 'EUR', 'JPY'], 'ts')

while (true) {
  await walletKr.writeContract({
    ...iPythConfig,
    functionName: 'updatePriceFeeds',
    args: [pythPayload.payload],
    value: 7n,
  })
  console.log('updated price feeds')
  await new Promise(r => setTimeout(r, 25000))
}
