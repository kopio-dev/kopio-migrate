export const iSupportAbi = [
	{
		type: 'function',
		name: 'getTVL',
		inputs: [
			{
				name: '',
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
						internalType: 'struct Price[]',
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
								name: 'expo',
								type: 'int32',
								internalType: 'int32',
							},
							{
								name: 'publishTime',
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
				internalType: 'struct ISupport.TVL',
				components: [
					{
						name: 'total',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'diamond',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'vkiss',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'wraps',
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
		name: 'getTVL',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'tuple',
				internalType: 'struct ISupport.TVL',
				components: [
					{
						name: 'total',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'diamond',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'vkiss',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'wraps',
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
		name: 'getTVLDec',
		inputs: [
			{
				name: '',
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
						internalType: 'struct Price[]',
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
								name: 'expo',
								type: 'int32',
								internalType: 'int32',
							},
							{
								name: 'publishTime',
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
				internalType: 'struct ISupport.TVLDec',
				components: [
					{
						name: 'total',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'diamond',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'vkiss',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'wraps',
						type: 'string',
						internalType: 'string',
					},
				],
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getTVLDec',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'tuple',
				internalType: 'struct ISupport.TVLDec',
				components: [
					{
						name: 'total',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'diamond',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'vkiss',
						type: 'string',
						internalType: 'string',
					},
					{
						name: 'wraps',
						type: 'string',
						internalType: 'string',
					},
				],
			},
		],
		stateMutability: 'view',
	},
] as const

export const iSupportAddr = '0xAC2203937a6e14f1618f659315419f295AF055b4' as const
