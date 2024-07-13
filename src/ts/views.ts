import { fetchPythData } from '@kr/pyth/pyth-hermes'
import { arb } from '@kr/viem/clients'
import { iDataConfig } from '@kr/viem/contracts/iData'
import { divider, formatAmount, formatPosition, formatPrice } from '@kr/viem/logging'
import { formatUnits } from 'viem/utils'

const pythPayload = await fetchPythData(
	['ARB', 'SOL', 'USDC', 'ETH', 'BTC', 'EUR', 'JPY', 'GBP', 'XAU', 'XAG', 'USDT'],
	'ts',
)

const result = [
	await arb.readContract({
		...iDataConfig,
		functionName: 'getAccount',
		args: [pythPayload.view, '0x299776620339EA8d5a4aAA2597Fcf75481ADA0Af', []],
	}),
]

result.map(r => {
	divider('*')
	console.log('Address', r.addr)
	divider('-')
	for (const tkn of r.tokens) {
		console.log(`Balance ${tkn.symbol}: ${formatAmount(tkn.amount, tkn.decimals)} - $${formatPrice(tkn.val)}`)
	}
	divider('-')
	for (const pos of r.minter.deposits) {
		console.log(formatPosition('Minter Deposit', pos))
	}
	divider('-')
	for (const pos of r.minter.debts) {
		console.log(formatPosition('Minter Borrow', pos))
	}

	divider('-')
	console.log(
		`Minter totals > CR: ${formatUnits(r.minter.totals.cr, 2)}% | Collateral $${formatPrice(
			r.minter.totals.valColl,
		)} | Debt $${formatPrice(r.minter.totals.valDebt)}`,
	)
	divider('*')
	return r
})
