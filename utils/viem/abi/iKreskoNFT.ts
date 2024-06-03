export const iKreskoNFTABI = [
	{
		type: 'function',
		name: 'afterInitialization',
		inputs: [
			{
				name: '_lzEndpoint',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_multisig',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_treasury',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_feeNumerator',
				type: 'uint96',
				internalType: 'uint96',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'balanceOf',
		inputs: [
			{
				name: 'account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
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
		name: 'balanceOfBatch',
		inputs: [
			{
				name: 'accounts',
				type: 'address[]',
				internalType: 'address[]',
			},
			{
				name: 'ids',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
		],
		outputs: [
			{
				name: '',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'burn',
		inputs: [
			{
				name: '_from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_id',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'changeOwner',
		inputs: [
			{
				name: '_owner',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'configureRoyalty',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_receiver',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_feeNumerator',
				type: 'uint96',
				internalType: 'uint96',
			},
			{
				name: '_action',
				type: 'uint8',
				internalType: 'uint8',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'estimateSendBatchFee',
		inputs: [
			{
				name: '_dstChainId',
				type: 'uint16',
				internalType: 'uint16',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				internalType: 'bytes',
			},
			{
				name: '_tokenIds',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: '_amounts',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: '_useZro',
				type: 'bool',
				internalType: 'bool',
			},
			{
				name: '_adapterParams',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [
			{
				name: 'nativeFee',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'zroFee',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'estimateSendFee',
		inputs: [
			{
				name: '_dstChainId',
				type: 'uint16',
				internalType: 'uint16',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				internalType: 'bytes',
			},
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_useZro',
				type: 'bool',
				internalType: 'bool',
			},
			{
				name: '_adapterParams',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [
			{
				name: 'nativeFee',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'zroFee',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getRoleAdmin',
		inputs: [
			{
				name: 'role',
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
		name: 'grantRole',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: 'account',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'hasRole',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: 'account',
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
		name: 'initialize',
		inputs: [
			{
				name: '_owner',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_name',
				type: 'string',
				internalType: 'string',
			},
			{
				name: '_symbol',
				type: 'string',
				internalType: 'string',
			},
			{
				name: '_tokenUri',
				type: 'string',
				internalType: 'string',
			},
			{
				name: '_contractURI',
				type: 'string',
				internalType: 'string',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'isApprovedForAll',
		inputs: [
			{
				name: 'account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'operator',
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
		name: 'mint',
		inputs: [
			{
				name: '_to',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
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
		name: 'renounceRole',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: 'account',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'revokeRole',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: 'account',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'safeBatchTransferFrom',
		inputs: [
			{
				name: 'from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'to',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'ids',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'amounts',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'data',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'safeTransferFrom',
		inputs: [
			{
				name: 'from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'to',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'amount',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'data',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'sendBatchFrom',
		inputs: [
			{
				name: '_from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_dstChainId',
				type: 'uint16',
				internalType: 'uint16',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				internalType: 'bytes',
			},
			{
				name: '_tokenIds',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: '_amounts',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: '_refundAddress',
				type: 'address',
				internalType: 'address payable',
			},
			{
				name: '_zroPaymentAddress',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_adapterParams',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'payable',
	},
	{
		type: 'function',
		name: 'sendFrom',
		inputs: [
			{
				name: '_from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_dstChainId',
				type: 'uint16',
				internalType: 'uint16',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				internalType: 'bytes',
			},
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_refundAddress',
				type: 'address',
				internalType: 'address payable',
			},
			{
				name: '_zroPaymentAddress',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_adapterParams',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'payable',
	},
	{
		type: 'function',
		name: 'setApprovalForAll',
		inputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'approved',
				type: 'bool',
				internalType: 'bool',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setContractURI',
		inputs: [
			{
				name: '_contractURI',
				type: 'string',
				internalType: 'string',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setURI',
		inputs: [
			{
				name: '_newURI',
				type: 'string',
				internalType: 'string',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setupLZ',
		inputs: [
			{
				name: '_lzEndpoint',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'storeAppendValue',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: '_value',
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
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'storeClearKey',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
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
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'storeClearKeys',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_keys',
				type: 'bytes32[]',
				internalType: 'bytes32[]',
			},
		],
		outputs: [
			{
				name: '',
				type: 'bool',
				internalType: 'bool',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'storeCreateValue',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: '_value',
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
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'storeGetByIndex',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: '_idx',
				type: 'uint256',
				internalType: 'uint256',
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
		name: 'storeGetByKey',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
				type: 'bytes32',
				internalType: 'bytes32',
			},
		],
		outputs: [
			{
				name: '',
				type: 'bytes32[]',
				internalType: 'bytes32[]',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'storeUpdateValue',
		inputs: [
			{
				name: '_tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '_key',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: '_value',
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
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'supportsInterface',
		inputs: [
			{
				name: 'interfaceId',
				type: 'bytes4',
				internalType: 'bytes4',
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
		type: 'event',
		name: 'ApprovalForAll',
		inputs: [
			{
				name: 'account',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'operator',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'approved',
				type: 'bool',
				indexed: false,
				internalType: 'bool',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'ReceiveBatchFromChain',
		inputs: [
			{
				name: '_srcChainId',
				type: 'uint16',
				indexed: true,
				internalType: 'uint16',
			},
			{
				name: '_srcAddress',
				type: 'bytes',
				indexed: true,
				internalType: 'bytes',
			},
			{
				name: '_toAddress',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: '_tokenIds',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
			{
				name: '_amounts',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'ReceiveFromChain',
		inputs: [
			{
				name: '_srcChainId',
				type: 'uint16',
				indexed: true,
				internalType: 'uint16',
			},
			{
				name: '_srcAddress',
				type: 'bytes',
				indexed: true,
				internalType: 'bytes',
			},
			{
				name: '_toAddress',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: '_tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'RoleAdminChanged',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				indexed: true,
				internalType: 'bytes32',
			},
			{
				name: 'previousAdminRole',
				type: 'bytes32',
				indexed: true,
				internalType: 'bytes32',
			},
			{
				name: 'newAdminRole',
				type: 'bytes32',
				indexed: true,
				internalType: 'bytes32',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'RoleGranted',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				indexed: true,
				internalType: 'bytes32',
			},
			{
				name: 'account',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'sender',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'RoleRevoked',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				indexed: true,
				internalType: 'bytes32',
			},
			{
				name: 'account',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'sender',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'SendBatchToChain',
		inputs: [
			{
				name: '_dstChainId',
				type: 'uint16',
				indexed: true,
				internalType: 'uint16',
			},
			{
				name: '_from',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				indexed: true,
				internalType: 'bytes',
			},
			{
				name: '_tokenIds',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
			{
				name: '_amounts',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'SendToChain',
		inputs: [
			{
				name: '_dstChainId',
				type: 'uint16',
				indexed: true,
				internalType: 'uint16',
			},
			{
				name: '_from',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: '_toAddress',
				type: 'bytes',
				indexed: true,
				internalType: 'bytes',
			},
			{
				name: '_tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: '_amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'TransferBatch',
		inputs: [
			{
				name: 'operator',
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
				name: 'ids',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
			{
				name: 'values',
				type: 'uint256[]',
				indexed: false,
				internalType: 'uint256[]',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'TransferSingle',
		inputs: [
			{
				name: 'operator',
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
				name: 'id',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'value',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'URI',
		inputs: [
			{
				name: 'value',
				type: 'string',
				indexed: false,
				internalType: 'string',
			},
			{
				name: 'id',
				type: 'uint256',
				indexed: true,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
] as const;
