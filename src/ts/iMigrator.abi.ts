export const iMigratorConfig = {
  addr: '0xaaaaaAaAaAa186774266Ea9b3FC0B588B3232795',
  abi: [
    {
      type: 'function',
      name: 'getPreviewResult',
      inputs: [
        {
          name: '_errorData',
          type: 'bytes',
          internalType: 'bytes',
        },
      ],
      outputs: [
        {
          name: 'result',
          type: 'tuple',
          internalType: 'struct IMigrator.MigrationResult',
          components: [
            {
              name: 'account',
              type: 'address',
              internalType: 'address',
            },
            {
              name: 'icdpColl',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'icdpDebt',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'scdp',
              type: 'tuple',
              internalType: 'struct IMigrator.Transfer',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kresko',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kopio',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'valueBefore',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'valueNow',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'slippage',
              type: 'uint256',
              internalType: 'uint256',
            },
          ],
        },
      ],
      stateMutability: 'pure',
    },
    {
      type: 'function',
      name: 'migrate',
      inputs: [
        {
          name: 'account',
          type: 'address',
          internalType: 'address',
        },
        {
          name: 'prices',
          type: 'bytes[]',
          internalType: 'bytes[]',
        },
      ],
      outputs: [
        {
          name: 'result',
          type: 'tuple',
          internalType: 'struct IMigrator.MigrationResult',
          components: [
            {
              name: 'account',
              type: 'address',
              internalType: 'address',
            },
            {
              name: 'icdpColl',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'icdpDebt',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'scdp',
              type: 'tuple',
              internalType: 'struct IMigrator.Transfer',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kresko',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kopio',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'valueBefore',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'valueNow',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'slippage',
              type: 'uint256',
              internalType: 'uint256',
            },
          ],
        },
      ],
      stateMutability: 'payable',
    },
    {
      type: 'function',
      name: 'previewMigrate',
      inputs: [
        {
          name: 'account',
          type: 'address',
          internalType: 'address',
        },
        {
          name: 'prices',
          type: 'bytes[]',
          internalType: 'bytes[]',
        },
      ],
      outputs: [
        {
          name: 'result',
          type: 'tuple',
          internalType: 'struct IMigrator.MigrationResult',
          components: [
            {
              name: 'account',
              type: 'address',
              internalType: 'address',
            },
            {
              name: 'icdpColl',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'icdpDebt',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'scdp',
              type: 'tuple',
              internalType: 'struct IMigrator.Transfer',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kresko',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kopio',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'valueBefore',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'valueNow',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'slippage',
              type: 'uint256',
              internalType: 'uint256',
            },
          ],
        },
      ],
      stateMutability: 'payable',
    },
    {
      type: 'event',
      name: 'Migration',
      inputs: [
        {
          name: '',
          type: 'address',
          indexed: false,
          internalType: 'address',
        },
        {
          name: '',
          type: 'uint256',
          indexed: false,
          internalType: 'uint256',
        },
        {
          name: '',
          type: 'uint256',
          indexed: false,
          internalType: 'uint256',
        },
      ],
      anonymous: false,
    },
    {
      type: 'event',
      name: 'PositionTransferred',
      inputs: [
        {
          name: 'account',
          type: 'address',
          indexed: true,
          internalType: 'address',
        },
        {
          name: 'from',
          type: 'address',
          indexed: true,
          internalType: 'address',
        },
        {
          name: 'to',
          type: 'address',
          indexed: true,
          internalType: 'address',
        },
        {
          name: 'amountFrom',
          type: 'uint256',
          indexed: false,
          internalType: 'uint256',
        },
        {
          name: 'amountTo',
          type: 'uint256',
          indexed: false,
          internalType: 'uint256',
        },
      ],
      anonymous: false,
    },
    {
      type: 'error',
      name: 'InsufficientAssets',
      inputs: [
        {
          name: 'account',
          type: 'address',
          internalType: 'address',
        },
        {
          name: 'asset',
          type: 'address',
          internalType: 'address',
        },
        {
          name: 'amount',
          type: 'uint256',
          internalType: 'uint256',
        },
      ],
    },
    {
      type: 'error',
      name: 'InvalidSender',
      inputs: [
        {
          name: '',
          type: 'address',
          internalType: 'address',
        },
      ],
    },
    {
      type: 'error',
      name: 'MigrationPreview',
      inputs: [
        {
          name: '',
          type: 'tuple',
          internalType: 'struct IMigrator.MigrationResult',
          components: [
            {
              name: 'account',
              type: 'address',
              internalType: 'address',
            },
            {
              name: 'icdpColl',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'icdpDebt',
              type: 'tuple[]',
              internalType: 'struct IMigrator.Transfer[]',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'scdp',
              type: 'tuple',
              internalType: 'struct IMigrator.Transfer',
              components: [
                {
                  name: 'asset',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'destination',
                  type: 'address',
                  internalType: 'address',
                },
                {
                  name: 'idx',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amount',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'amountTransferred',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'value',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kresko',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'kopio',
              type: 'tuple',
              internalType: 'struct IMigrator.ProtocolResult',
              components: [
                {
                  name: 'valSCDPBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valSCDP',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valCollBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valColl',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebtBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valDebt',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotalBefore',
                  type: 'uint256',
                  internalType: 'uint256',
                },
                {
                  name: 'valTotal',
                  type: 'uint256',
                  internalType: 'uint256',
                },
              ],
            },
            {
              name: 'valueBefore',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'valueNow',
              type: 'uint256',
              internalType: 'uint256',
            },
            {
              name: 'slippage',
              type: 'uint256',
              internalType: 'uint256',
            },
          ],
        },
      ],
    },
    {
      type: 'error',
      name: 'Slippage',
      inputs: [
        {
          name: 'slippage',
          type: 'uint256',
          internalType: 'uint256',
        },
        {
          name: 'maxSlippage',
          type: 'uint256',
          internalType: 'uint256',
        },
        {
          name: 'valIn',
          type: 'uint256',
          internalType: 'uint256',
        },
        {
          name: 'valOut',
          type: 'uint256',
          internalType: 'uint256',
        },
      ],
    },
    {
      type: 'error',
      name: 'ZeroAmount',
      inputs: [
        {
          name: '',
          type: 'address',
          internalType: 'address',
        },
      ],
    },
  ],
} as const
