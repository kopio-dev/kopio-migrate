export const iPythABI = [
  {
    type: 'function',
    name: 'getPriceNoOlderThan',
    inputs: [
      {
        name: '_id',
        type: 'bytes32',
        internalType: 'bytes32',
      },
      {
        name: '_maxAge',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'tuple',
        internalType: 'struct IPyth.Price',
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
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getPriceUnsafe',
    inputs: [
      {
        name: '_id',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'tuple',
        internalType: 'struct IPyth.Price',
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
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getUpdateFee',
    inputs: [
      {
        name: '_updateData',
        type: 'bytes[]',
        internalType: 'bytes[]',
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
  {
    type: 'function',
    name: 'updatePriceFeeds',
    inputs: [
      {
        name: '_updateData',
        type: 'bytes[]',
        internalType: 'bytes[]',
      },
    ],
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    name: 'updatePriceFeedsIfNecessary',
    inputs: [
      {
        name: '_updateData',
        type: 'bytes[]',
        internalType: 'bytes[]',
      },
      {
        name: '_ids',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
      {
        name: '_publishTimes',
        type: 'uint64[]',
        internalType: 'uint64[]',
      },
    ],
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'error',
    name: 'InsufficientFee',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidArgument',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidGovernanceDataSource',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidGovernanceMessage',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidGovernanceTarget',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidUpdateData',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidUpdateDataSource',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidWormholeAddressToSet',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidWormholeVaa',
    inputs: [],
  },
  {
    type: 'error',
    name: 'NoFreshUpdate',
    inputs: [],
  },
  {
    type: 'error',
    name: 'OldGovernanceMessage',
    inputs: [],
  },
  {
    type: 'error',
    name: 'PriceFeedNotFound',
    inputs: [],
  },
  {
    type: 'error',
    name: 'PriceFeedNotFoundWithinRange',
    inputs: [],
  },
  {
    type: 'error',
    name: 'StalePrice',
    inputs: [],
  },
] as const
