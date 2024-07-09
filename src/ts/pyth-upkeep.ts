import { fetchPythData } from '@kr/pyth/pyth-hermes'
import { iPythConfig } from '@kr/viem/contracts/iPyth'
import { wallet } from '@kr/viem/clients'

const pythPayload = await fetchPythData(['ARB', 'SOL', 'USDC', 'ETH', 'BTC', 'EUR', 'JPY', 'XAG', 'XAU'], 'ts')

while (true) {
	await wallet.writeContract({
		...iPythConfig,
		functionName: 'updatePriceFeeds',
		args: [pythPayload.payload],
		value: 10n,
	})
	console.log('updated price feeds')
	await new Promise(r => setTimeout(r, 25000))
}
