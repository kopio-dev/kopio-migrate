import { parseAbiParameters } from 'viem/utils'

export const pythPayloads = parseAbiParameters([
  'bytes32[] ids, bytes[] updatedatas, Price[] prices',
  'struct Price { int64 price; uint64 conf; int32 exp; uint256 timestamp; }',
])
