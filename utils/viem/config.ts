import { http } from 'viem'

const alchemy = (key: 'arb-mainnet' | 'opt-mainnet' | 'arb-sepolia', checkFork = false) => {
  if (checkFork && process.env.VIEM_FORK) {
    return http(process.env.VIEM_FORK)
  }
  return http(`https://${key}.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`)
}

const localhost = http('http://localhost:8545')

export const transports = {
  1: http(),
  1337: localhost,
  421614: alchemy('arb-sepolia'),
  10: alchemy('opt-mainnet'),
  41337: localhost,
  42161: alchemy('arb-mainnet', false),
} as const

export const addr = {
  qfk: { 42161: '0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6' },
  kreskian: { 42161: '0xAbDb949a18d27367118573A217E5353EDe5A0f1E' },
  marketStatus: {
    42161: '0xf6188e085ebEB716a730F8ecd342513e72C8AD04',
  },
  multicall: {
    42161: '0xC35A7648B434f0A161c12BD144866bdf93c4a4FC',
  },
  datav1: {
    42161: '0xF21De5aBac99514610F33Ca15113Bb6bCfCD476d',
  },
  kresko: {
    42161: '0x0000000000177abD99485DCaea3eFaa91db3fe72',
  },
  pyth: {
    42161: '0xff1a0f4744e8582DF1aE09D5611b887B6a12925C',
  },
  vault: {
    42161: '0x2dF01c1e472eaF880e3520C456b9078A5658b04c',
  },
  kiss: {
    42161: '0x6A1D6D2f4aF6915e6bBa8F2db46F442d18dB5C9b',
  },
} as const
