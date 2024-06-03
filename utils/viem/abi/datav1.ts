export const iMarketStatus = [
  {
    type: 'function',
    name: 'allowed',
    inputs: [
      {
        name: '',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'exchanges',
    inputs: [
      {
        name: '',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getExchange',
    inputs: [
      {
        name: '',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getExchangeStatus',
    inputs: [
      {
        name: '_exchange',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getExchangeStatuses',
    inputs: [
      {
        name: '_exchanges',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bool[]',
        internalType: 'bool[]',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTickerExchange',
    inputs: [
      {
        name: '_ticker',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'exchange',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTickerStatus',
    inputs: [
      {
        name: '_ticker',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'status',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTickerStatuses',
    inputs: [
      {
        name: '_tickers',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
    ],
    outputs: [
      {
        name: 'statuses',
        type: 'bool[]',
        internalType: 'bool[]',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'owner',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'setAllowed',
    inputs: [
      {
        name: '',
        type: 'address',
        internalType: 'address',
      },
      {
        name: '',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'setStatus',
    inputs: [
      {
        name: '_exchanges',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
      {
        name: '_statuses',
        type: 'bool[]',
        internalType: 'bool[]',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'setTickers',
    inputs: [
      {
        name: '_tickers',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
      {
        name: '_exchanges',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'status',
    inputs: [
      {
        name: '_exchange',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
] as const

export const iDataV1ABI = [
  {
    type: 'function',
    name: 'getAccount',
    inputs: [
      {
        name: 'prices',
        type: 'tuple',
        internalType: 'struct PythView',
        components: [
          {
            name: 'ids',
            type: 'bytes32[]',
            internalType: 'bytes32[]',
          },
          {
            name: 'prices',
            type: 'tuple[]',
            internalType: 'struct IPyth.Price[]',
            components: [
              {
                name: 'price',
                type: 'int64',
                internalType: 'int64',
              },
              {
                name: 'conf',
                type: 'uint64',
                internalType: 'uint64',
              },
              {
                name: 'exp',
                type: 'int32',
                internalType: 'int32',
              },
              {
                name: 'timestamp',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
        ],
      },
      {
        name: '_account',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'tuple',
        internalType: 'struct IDataV1.DAccount',
        components: [
          {
            name: 'protocol',
            type: 'tuple',
            internalType: 'struct View.Account',
            components: [
              {
                name: 'addr',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'bals',
                type: 'tuple[]',
                internalType: 'struct View.Balance[]',
                components: [
                  {
                    name: 'addr',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'name',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'token',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'symbol',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'amount',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'val',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'decimals',
                    type: 'uint8',
                    internalType: 'uint8',
                  },
                ],
              },
              {
                name: 'minter',
                type: 'tuple',
                internalType: 'struct View.MAccount',
                components: [
                  {
                    name: 'totals',
                    type: 'tuple',
                    internalType: 'struct View.MTotals',
                    components: [
                      {
                        name: 'valColl',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valDebt',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'cr',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                    ],
                  },
                  {
                    name: 'deposits',
                    type: 'tuple[]',
                    internalType: 'struct View.Position[]',
                    components: [
                      {
                        name: 'amount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'addr',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'symbol',
                        type: 'string',
                        internalType: 'string',
                      },
                      {
                        name: 'amountAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'val',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'index',
                        type: 'int256',
                        internalType: 'int256',
                      },
                      {
                        name: 'price',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'config',
                        type: 'tuple',
                        internalType: 'struct Asset',
                        components: [
                          {
                            name: 'ticker',
                            type: 'bytes32',
                            internalType: 'bytes32',
                          },
                          {
                            name: 'anchor',
                            type: 'address',
                            internalType: 'address',
                          },
                          {
                            name: 'oracles',
                            type: 'uint8[2]',
                            internalType: 'enum Enums.OracleType[2]',
                          },
                          {
                            name: 'factor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'kFactor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'openFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'closeFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentive',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'maxDebtMinter',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'maxDebtSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'depositLimitSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'swapInFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'swapOutFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'protocolFeeShareSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentiveSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'decimals',
                            type: 'uint8',
                            internalType: 'uint8',
                          },
                          {
                            name: 'isMinterCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isMinterMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSwapMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedOrSwappedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isCoverAsset',
                            type: 'bool',
                            internalType: 'bool',
                          },
                        ],
                      },
                    ],
                  },
                  {
                    name: 'debts',
                    type: 'tuple[]',
                    internalType: 'struct View.Position[]',
                    components: [
                      {
                        name: 'amount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'addr',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'symbol',
                        type: 'string',
                        internalType: 'string',
                      },
                      {
                        name: 'amountAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'val',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'index',
                        type: 'int256',
                        internalType: 'int256',
                      },
                      {
                        name: 'price',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'config',
                        type: 'tuple',
                        internalType: 'struct Asset',
                        components: [
                          {
                            name: 'ticker',
                            type: 'bytes32',
                            internalType: 'bytes32',
                          },
                          {
                            name: 'anchor',
                            type: 'address',
                            internalType: 'address',
                          },
                          {
                            name: 'oracles',
                            type: 'uint8[2]',
                            internalType: 'enum Enums.OracleType[2]',
                          },
                          {
                            name: 'factor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'kFactor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'openFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'closeFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentive',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'maxDebtMinter',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'maxDebtSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'depositLimitSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'swapInFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'swapOutFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'protocolFeeShareSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentiveSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'decimals',
                            type: 'uint8',
                            internalType: 'uint8',
                          },
                          {
                            name: 'isMinterCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isMinterMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSwapMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedOrSwappedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isCoverAsset',
                            type: 'bool',
                            internalType: 'bool',
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
              {
                name: 'scdp',
                type: 'tuple',
                internalType: 'struct View.SAccount',
                components: [
                  {
                    name: 'addr',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'totals',
                    type: 'tuple',
                    internalType: 'struct View.SAccountTotals',
                    components: [
                      {
                        name: 'valColl',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                    ],
                  },
                  {
                    name: 'deposits',
                    type: 'tuple[]',
                    internalType: 'struct View.SDepositUser[]',
                    components: [
                      {
                        name: 'amount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'addr',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'symbol',
                        type: 'string',
                        internalType: 'string',
                      },
                      {
                        name: 'amountFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'val',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'feeIndexAccount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'feeIndexCurrent',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'liqIndexAccount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'liqIndexCurrent',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'accountIndexTimestamp',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'price',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'config',
                        type: 'tuple',
                        internalType: 'struct Asset',
                        components: [
                          {
                            name: 'ticker',
                            type: 'bytes32',
                            internalType: 'bytes32',
                          },
                          {
                            name: 'anchor',
                            type: 'address',
                            internalType: 'address',
                          },
                          {
                            name: 'oracles',
                            type: 'uint8[2]',
                            internalType: 'enum Enums.OracleType[2]',
                          },
                          {
                            name: 'factor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'kFactor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'openFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'closeFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentive',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'maxDebtMinter',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'maxDebtSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'depositLimitSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'swapInFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'swapOutFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'protocolFeeShareSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentiveSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'decimals',
                            type: 'uint8',
                            internalType: 'uint8',
                          },
                          {
                            name: 'isMinterCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isMinterMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSwapMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedOrSwappedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isCoverAsset',
                            type: 'bool',
                            internalType: 'bool',
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
            ],
          },
          {
            name: 'collections',
            type: 'tuple[]',
            internalType: 'struct IDataV1.DCollection[]',
            components: [
              {
                name: 'addr',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'name',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'symbol',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'uri',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'items',
                type: 'tuple[]',
                internalType: 'struct IDataV1.DCollectionItem[]',
                components: [
                  {
                    name: 'id',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'uri',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'balance',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
            ],
          },
          {
            name: 'vault',
            type: 'tuple',
            internalType: 'struct IDataV1.DVTokenBalance',
            components: [
              {
                name: 'addr',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'name',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'symbol',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'amount',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'tSupply',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'oracleDecimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'val',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'decimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'price',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'priceRaw',
                type: 'tuple',
                internalType: 'struct RawPrice',
                components: [
                  {
                    name: 'answer',
                    type: 'int256',
                    internalType: 'int256',
                  },
                  {
                    name: 'timestamp',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'staleTime',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'isStale',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'isZero',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'oracle',
                    type: 'uint8',
                    internalType: 'enum Enums.OracleType',
                  },
                  {
                    name: 'feed',
                    type: 'address',
                    internalType: 'address',
                  },
                ],
              },
              {
                name: 'chainId',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
          {
            name: 'eligible',
            type: 'bool',
            internalType: 'bool',
          },
          {
            name: 'phase',
            type: 'uint8',
            internalType: 'uint8',
          },
          {
            name: 'chainId',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getExternalTokens',
    inputs: [
      {
        name: 'tokens',
        type: 'tuple[]',
        internalType: 'struct IDataV1.ExternalTokenArgs[]',
        components: [
          {
            name: 'token',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'feed',
            type: 'address',
            internalType: 'address',
          },
        ],
      },
      {
        name: '_account',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'tuple[]',
        internalType: 'struct IDataV1.DVTokenBalance[]',
        components: [
          {
            name: 'addr',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'name',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'symbol',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'amount',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'tSupply',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'oracleDecimals',
            type: 'uint8',
            internalType: 'uint8',
          },
          {
            name: 'val',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'decimals',
            type: 'uint8',
            internalType: 'uint8',
          },
          {
            name: 'price',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'priceRaw',
            type: 'tuple',
            internalType: 'struct RawPrice',
            components: [
              {
                name: 'answer',
                type: 'int256',
                internalType: 'int256',
              },
              {
                name: 'timestamp',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'staleTime',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'isStale',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'isZero',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'oracle',
                type: 'uint8',
                internalType: 'enum Enums.OracleType',
              },
              {
                name: 'feed',
                type: 'address',
                internalType: 'address',
              },
            ],
          },
          {
            name: 'chainId',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getGlobals',
    inputs: [
      {
        name: 'prices',
        type: 'tuple',
        internalType: 'struct PythView',
        components: [
          {
            name: 'ids',
            type: 'bytes32[]',
            internalType: 'bytes32[]',
          },
          {
            name: 'prices',
            type: 'tuple[]',
            internalType: 'struct IPyth.Price[]',
            components: [
              {
                name: 'price',
                type: 'int64',
                internalType: 'int64',
              },
              {
                name: 'conf',
                type: 'uint64',
                internalType: 'uint64',
              },
              {
                name: 'exp',
                type: 'int32',
                internalType: 'int32',
              },
              {
                name: 'timestamp',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
        ],
      },
    ],
    outputs: [
      {
        name: '',
        type: 'tuple',
        internalType: 'struct IDataV1.DGlobal',
        components: [
          {
            name: 'protocol',
            type: 'tuple',
            internalType: 'struct View.Protocol',
            components: [
              {
                name: 'scdp',
                type: 'tuple',
                internalType: 'struct View.SCDP',
                components: [
                  {
                    name: 'MCR',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'LT',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'MLR',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'deposits',
                    type: 'tuple[]',
                    internalType: 'struct View.SDeposit[]',
                    components: [
                      {
                        name: 'amount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'addr',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'symbol',
                        type: 'string',
                        internalType: 'string',
                      },
                      {
                        name: 'amountSwapDeposit',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'amountFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'val',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'feeIndex',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'liqIndex',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'price',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'config',
                        type: 'tuple',
                        internalType: 'struct Asset',
                        components: [
                          {
                            name: 'ticker',
                            type: 'bytes32',
                            internalType: 'bytes32',
                          },
                          {
                            name: 'anchor',
                            type: 'address',
                            internalType: 'address',
                          },
                          {
                            name: 'oracles',
                            type: 'uint8[2]',
                            internalType: 'enum Enums.OracleType[2]',
                          },
                          {
                            name: 'factor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'kFactor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'openFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'closeFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentive',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'maxDebtMinter',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'maxDebtSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'depositLimitSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'swapInFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'swapOutFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'protocolFeeShareSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentiveSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'decimals',
                            type: 'uint8',
                            internalType: 'uint8',
                          },
                          {
                            name: 'isMinterCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isMinterMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSwapMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedOrSwappedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isCoverAsset',
                            type: 'bool',
                            internalType: 'bool',
                          },
                        ],
                      },
                    ],
                  },
                  {
                    name: 'debts',
                    type: 'tuple[]',
                    internalType: 'struct View.Position[]',
                    components: [
                      {
                        name: 'amount',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'addr',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'symbol',
                        type: 'string',
                        internalType: 'string',
                      },
                      {
                        name: 'amountAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'val',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'index',
                        type: 'int256',
                        internalType: 'int256',
                      },
                      {
                        name: 'price',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'config',
                        type: 'tuple',
                        internalType: 'struct Asset',
                        components: [
                          {
                            name: 'ticker',
                            type: 'bytes32',
                            internalType: 'bytes32',
                          },
                          {
                            name: 'anchor',
                            type: 'address',
                            internalType: 'address',
                          },
                          {
                            name: 'oracles',
                            type: 'uint8[2]',
                            internalType: 'enum Enums.OracleType[2]',
                          },
                          {
                            name: 'factor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'kFactor',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'openFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'closeFee',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentive',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'maxDebtMinter',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'maxDebtSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'depositLimitSCDP',
                            type: 'uint256',
                            internalType: 'uint256',
                          },
                          {
                            name: 'swapInFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'swapOutFeeSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'protocolFeeShareSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'liqIncentiveSCDP',
                            type: 'uint16',
                            internalType: 'uint16',
                          },
                          {
                            name: 'decimals',
                            type: 'uint8',
                            internalType: 'uint8',
                          },
                          {
                            name: 'isMinterCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isMinterMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSwapMintable',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isSharedOrSwappedCollateral',
                            type: 'bool',
                            internalType: 'bool',
                          },
                          {
                            name: 'isCoverAsset',
                            type: 'bool',
                            internalType: 'bool',
                          },
                        ],
                      },
                    ],
                  },
                  {
                    name: 'totals',
                    type: 'tuple',
                    internalType: 'struct View.STotals',
                    components: [
                      {
                        name: 'valColl',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valCollAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valFees',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valDebt',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valDebtOg',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'valDebtOgAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'sdiPrice',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'cr',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'crOg',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'crOgAdj',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                    ],
                  },
                  {
                    name: 'coverIncentive',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'coverThreshold',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                ],
              },
              {
                name: 'gate',
                type: 'tuple',
                internalType: 'struct View.Gate',
                components: [
                  {
                    name: 'kreskian',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'questForKresk',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'phase',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
              {
                name: 'minter',
                type: 'tuple',
                internalType: 'struct View.Minter',
                components: [
                  {
                    name: 'MCR',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'LT',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'MLR',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'minDebtValue',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
              {
                name: 'assets',
                type: 'tuple[]',
                internalType: 'struct View.AssetView[]',
                components: [
                  {
                    name: 'synthwrap',
                    type: 'tuple',
                    internalType: 'struct IKreskoAsset.Wrapping',
                    components: [
                      {
                        name: 'underlying',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'underlyingDecimals',
                        type: 'uint8',
                        internalType: 'uint8',
                      },
                      {
                        name: 'openFee',
                        type: 'uint48',
                        internalType: 'uint48',
                      },
                      {
                        name: 'closeFee',
                        type: 'uint40',
                        internalType: 'uint40',
                      },
                      {
                        name: 'nativeUnderlyingEnabled',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'feeRecipient',
                        type: 'address',
                        internalType: 'address payable',
                      },
                    ],
                  },
                  {
                    name: 'priceRaw',
                    type: 'tuple',
                    internalType: 'struct RawPrice',
                    components: [
                      {
                        name: 'answer',
                        type: 'int256',
                        internalType: 'int256',
                      },
                      {
                        name: 'timestamp',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'staleTime',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'isStale',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isZero',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'oracle',
                        type: 'uint8',
                        internalType: 'enum Enums.OracleType',
                      },
                      {
                        name: 'feed',
                        type: 'address',
                        internalType: 'address',
                      },
                    ],
                  },
                  {
                    name: 'name',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'symbol',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'addr',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'isMarketOpen',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'tSupply',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'mSupply',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'price',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'config',
                    type: 'tuple',
                    internalType: 'struct Asset',
                    components: [
                      {
                        name: 'ticker',
                        type: 'bytes32',
                        internalType: 'bytes32',
                      },
                      {
                        name: 'anchor',
                        type: 'address',
                        internalType: 'address',
                      },
                      {
                        name: 'oracles',
                        type: 'uint8[2]',
                        internalType: 'enum Enums.OracleType[2]',
                      },
                      {
                        name: 'factor',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'kFactor',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'openFee',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'closeFee',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'liqIncentive',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'maxDebtMinter',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'maxDebtSCDP',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'depositLimitSCDP',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'swapInFeeSCDP',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'swapOutFeeSCDP',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'protocolFeeShareSCDP',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'liqIncentiveSCDP',
                        type: 'uint16',
                        internalType: 'uint16',
                      },
                      {
                        name: 'decimals',
                        type: 'uint8',
                        internalType: 'uint8',
                      },
                      {
                        name: 'isMinterCollateral',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isMinterMintable',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isSharedCollateral',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isSwapMintable',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isSharedOrSwappedCollateral',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isCoverAsset',
                        type: 'bool',
                        internalType: 'bool',
                      },
                    ],
                  },
                ],
              },
              {
                name: 'sequencerGracePeriodTime',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'pythEp',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'maxPriceDeviationPct',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'oracleDecimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'sequencerStartedAt',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'safetyStateSet',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'isSequencerUp',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'timestamp',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'blockNr',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'tvl',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
          {
            name: 'vault',
            type: 'tuple',
            internalType: 'struct IDataV1.DVault',
            components: [
              {
                name: 'assets',
                type: 'tuple[]',
                internalType: 'struct IDataV1.DVAsset[]',
                components: [
                  {
                    name: 'addr',
                    type: 'address',
                    internalType: 'address',
                  },
                  {
                    name: 'name',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'symbol',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'oracleDecimals',
                    type: 'uint8',
                    internalType: 'uint8',
                  },
                  {
                    name: 'vSupply',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'isMarketOpen',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'tSupply',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'priceRaw',
                    type: 'tuple',
                    internalType: 'struct RawPrice',
                    components: [
                      {
                        name: 'answer',
                        type: 'int256',
                        internalType: 'int256',
                      },
                      {
                        name: 'timestamp',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'staleTime',
                        type: 'uint256',
                        internalType: 'uint256',
                      },
                      {
                        name: 'isStale',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'isZero',
                        type: 'bool',
                        internalType: 'bool',
                      },
                      {
                        name: 'oracle',
                        type: 'uint8',
                        internalType: 'enum Enums.OracleType',
                      },
                      {
                        name: 'feed',
                        type: 'address',
                        internalType: 'address',
                      },
                    ],
                  },
                  {
                    name: 'config',
                    type: 'tuple',
                    internalType: 'struct VaultAsset',
                    components: [
                      {
                        name: 'token',
                        type: 'address',
                        internalType: 'contract IERC20',
                      },
                      {
                        name: 'feed',
                        type: 'address',
                        internalType: 'contract IAggregatorV3',
                      },
                      {
                        name: 'staleTime',
                        type: 'uint24',
                        internalType: 'uint24',
                      },
                      {
                        name: 'decimals',
                        type: 'uint8',
                        internalType: 'uint8',
                      },
                      {
                        name: 'depositFee',
                        type: 'uint32',
                        internalType: 'uint32',
                      },
                      {
                        name: 'withdrawFee',
                        type: 'uint32',
                        internalType: 'uint32',
                      },
                      {
                        name: 'maxDeposits',
                        type: 'uint248',
                        internalType: 'uint248',
                      },
                      {
                        name: 'enabled',
                        type: 'bool',
                        internalType: 'bool',
                      },
                    ],
                  },
                  {
                    name: 'price',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
              {
                name: 'token',
                type: 'tuple',
                internalType: 'struct IDataV1.DVToken',
                components: [
                  {
                    name: 'symbol',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'decimals',
                    type: 'uint8',
                    internalType: 'uint8',
                  },
                  {
                    name: 'name',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'price',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'oracleDecimals',
                    type: 'uint8',
                    internalType: 'uint8',
                  },
                  {
                    name: 'tSupply',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
            ],
          },
          {
            name: 'collections',
            type: 'tuple[]',
            internalType: 'struct IDataV1.DCollection[]',
            components: [
              {
                name: 'addr',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'name',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'symbol',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'uri',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'items',
                type: 'tuple[]',
                internalType: 'struct IDataV1.DCollectionItem[]',
                components: [
                  {
                    name: 'id',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'uri',
                    type: 'string',
                    internalType: 'string',
                  },
                  {
                    name: 'balance',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                ],
              },
            ],
          },
          {
            name: 'chainId',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
      {
        name: 'wraps',
        type: 'tuple[]',
        internalType: 'struct IDataV1.DWrap[]',
        components: [
          {
            name: 'addr',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'underlying',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'symbol',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'price',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'decimals',
            type: 'uint8',
            internalType: 'uint8',
          },
          {
            name: 'amount',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'nativeAmount',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'val',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'nativeVal',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTradeFees',
    inputs: [
      {
        name: '_assetIn',
        type: 'address',
        internalType: 'address',
      },
      {
        name: '_assetOut',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: 'feePercentage',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'depositorFee',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'protocolFee',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getVAssets',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'tuple[]',
        internalType: 'struct IDataV1.DVAsset[]',
        components: [
          {
            name: 'addr',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'name',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'symbol',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'oracleDecimals',
            type: 'uint8',
            internalType: 'uint8',
          },
          {
            name: 'vSupply',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'isMarketOpen',
            type: 'bool',
            internalType: 'bool',
          },
          {
            name: 'tSupply',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'priceRaw',
            type: 'tuple',
            internalType: 'struct RawPrice',
            components: [
              {
                name: 'answer',
                type: 'int256',
                internalType: 'int256',
              },
              {
                name: 'timestamp',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'staleTime',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'isStale',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'isZero',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'oracle',
                type: 'uint8',
                internalType: 'enum Enums.OracleType',
              },
              {
                name: 'feed',
                type: 'address',
                internalType: 'address',
              },
            ],
          },
          {
            name: 'config',
            type: 'tuple',
            internalType: 'struct VaultAsset',
            components: [
              {
                name: 'token',
                type: 'address',
                internalType: 'contract IERC20',
              },
              {
                name: 'feed',
                type: 'address',
                internalType: 'contract IAggregatorV3',
              },
              {
                name: 'staleTime',
                type: 'uint24',
                internalType: 'uint24',
              },
              {
                name: 'decimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'depositFee',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'withdrawFee',
                type: 'uint32',
                internalType: 'uint32',
              },
              {
                name: 'maxDeposits',
                type: 'uint248',
                internalType: 'uint248',
              },
              {
                name: 'enabled',
                type: 'bool',
                internalType: 'bool',
              },
            ],
          },
          {
            name: 'price',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getVault',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'tuple',
        internalType: 'struct IDataV1.DVault',
        components: [
          {
            name: 'assets',
            type: 'tuple[]',
            internalType: 'struct IDataV1.DVAsset[]',
            components: [
              {
                name: 'addr',
                type: 'address',
                internalType: 'address',
              },
              {
                name: 'name',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'symbol',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'oracleDecimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'vSupply',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'isMarketOpen',
                type: 'bool',
                internalType: 'bool',
              },
              {
                name: 'tSupply',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'priceRaw',
                type: 'tuple',
                internalType: 'struct RawPrice',
                components: [
                  {
                    name: 'answer',
                    type: 'int256',
                    internalType: 'int256',
                  },
                  {
                    name: 'timestamp',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'staleTime',
                    type: 'uint256',
                    internalType: 'uint256',
                  },
                  {
                    name: 'isStale',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'isZero',
                    type: 'bool',
                    internalType: 'bool',
                  },
                  {
                    name: 'oracle',
                    type: 'uint8',
                    internalType: 'enum Enums.OracleType',
                  },
                  {
                    name: 'feed',
                    type: 'address',
                    internalType: 'address',
                  },
                ],
              },
              {
                name: 'config',
                type: 'tuple',
                internalType: 'struct VaultAsset',
                components: [
                  {
                    name: 'token',
                    type: 'address',
                    internalType: 'contract IERC20',
                  },
                  {
                    name: 'feed',
                    type: 'address',
                    internalType: 'contract IAggregatorV3',
                  },
                  {
                    name: 'staleTime',
                    type: 'uint24',
                    internalType: 'uint24',
                  },
                  {
                    name: 'decimals',
                    type: 'uint8',
                    internalType: 'uint8',
                  },
                  {
                    name: 'depositFee',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'withdrawFee',
                    type: 'uint32',
                    internalType: 'uint32',
                  },
                  {
                    name: 'maxDeposits',
                    type: 'uint248',
                    internalType: 'uint248',
                  },
                  {
                    name: 'enabled',
                    type: 'bool',
                    internalType: 'bool',
                  },
                ],
              },
              {
                name: 'price',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
          {
            name: 'token',
            type: 'tuple',
            internalType: 'struct IDataV1.DVToken',
            components: [
              {
                name: 'symbol',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'decimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'name',
                type: 'string',
                internalType: 'string',
              },
              {
                name: 'price',
                type: 'uint256',
                internalType: 'uint256',
              },
              {
                name: 'oracleDecimals',
                type: 'uint8',
                internalType: 'uint8',
              },
              {
                name: 'tSupply',
                type: 'uint256',
                internalType: 'uint256',
              },
            ],
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'previewWithdraw',
    inputs: [
      {
        name: 'args',
        type: 'tuple',
        internalType: 'struct IDataV1.PreviewWithdrawArgs',
        components: [
          {
            name: 'vaultAsset',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'outputAmount',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'path',
            type: 'bytes',
            internalType: 'bytes',
          },
        ],
      },
    ],
    outputs: [
      {
        name: 'withdrawAmount',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'fee',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'payable',
  },
] as const
