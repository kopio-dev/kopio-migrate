import { http, createWalletClient } from 'viem'
import { mnemonicToAccount } from 'viem/accounts'
import { arbitrum } from 'viem/chains'
import { transports } from './config'

const arbArgs = { transport: transports[42161], chain: arbitrum } as const

export const walletPersonal = createWalletClient({
  ...arbArgs,
  account: mnemonicToAccount(process.env.PERSONAL_MNEMONIC!),
  name: 'arb-personal',
})

export const walletKr = createWalletClient({
  ...arbArgs,
  account: mnemonicToAccount(process.env.MNEMONIC!),
  name: 'arb-personal',
})
