import { divider, formatAmount, formatPosition, formatPrice } from '@utils/logging'
import { fetchPythData } from '@utils/pyth/hermes'
import { iDataV1ABI } from '@utils/viem/abi/datav1'
import { arb } from '@utils/viem/clients'
import { addr } from '@utils/viem/config'
import { formatUnits } from 'viem'

const pythPayload = await fetchPythData(['ARB', 'SOL', 'USDC', 'ETH', 'BTC', 'EUR', 'JPY'], 'ts')

const result = [
  await arb.readContract({
    address: addr.datav1[42161],
    abi: iDataV1ABI,
    functionName: 'getAccount',
    args: [pythPayload.view, '0x299776620339EA8d5a4aAA2597Fcf75481ADA0Af'],
  }),
]

result
  .filter(r => r?.protocol)
  .map(r => {
    const info = r!.protocol!
    divider('*')
    console.log('Address', info.addr)
    divider('-')
    for (const bal of info.bals) {
      console.log(`Balance ${bal.symbol}: ${formatAmount(bal.amount, bal.decimals)} - $${formatPrice(bal.val)}`)
    }
    divider('-')
    for (const pos of info.minter.deposits) {
      console.log(formatPosition('Minter Deposit', pos))
    }
    divider('-')
    for (const pos of info.minter.debts) {
      console.log(formatPosition('Minter Borrow', pos))
    }

    divider('-')
    console.log(
      `Minter totals > CR: ${formatUnits(info.minter.totals.cr, 2)}% | Collateral $${formatPrice(
        info.minter.totals.valColl,
      )} | Debt $${formatPrice(info.minter.totals.valDebt)}`,
    )
    divider('*')
    return r.protocol!
  })
