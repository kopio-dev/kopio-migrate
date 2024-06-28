export const kreditsABI = [
	{
		type: 'function',
		name: 'approve',
		inputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'payable',
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
		],
		outputs: [
			{
				name: 'balance',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'batchMintProfile',
		inputs: [
			{
				name: 'to',
				type: 'address[]',
				internalType: 'address[]',
			},
			{
				name: 'link',
				type: 'bool[]',
				internalType: 'bool[]',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'burnAndMint',
		inputs: [],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'burnKreditsAndMint',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'proof',
				type: 'bytes32[]',
				internalType: 'bytes32[]',
			},
			{
				name: 'amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'claim',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'proof',
				type: 'bytes32[]',
				internalType: 'bytes32[]',
			},
			{
				name: 'amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'claimAndMint',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'proof',
				type: 'bytes32[]',
				internalType: 'bytes32[]',
			},
			{
				name: 'amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'createClaim',
		inputs: [
			{
				name: 'config',
				type: 'tuple',
				internalType: 'struct ClaimEvent',
				components: [
					{
						name: 'merkleRoot',
						type: 'bytes32',
						internalType: 'bytes32',
					},
					{
						name: 'startDate',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'claimWindow',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'minting',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'burning',
						type: 'bool',
						internalType: 'bool',
					},
				],
			},
		],
		outputs: [
			{
				name: '',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'diamondCut',
		inputs: [
			{
				name: '',
				type: 'tuple[]',
				internalType: 'struct FacetCut[]',
				components: [
					{
						name: 'facetAddress',
						type: 'address',
						internalType: 'address',
					},
					{
						name: 'action',
						type: 'uint8',
						internalType: 'enum FacetCutAction',
					},
					{
						name: 'functionSelectors',
						type: 'bytes4[]',
						internalType: 'bytes4[]',
					},
				],
			},
			{
				name: '',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'executeInitializer',
		inputs: [
			{
				name: '',
				type: 'address',
				internalType: 'address',
			},
			{
				name: '',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'executeInitializer',
		inputs: [
			{
				name: '',
				type: 'tuple',
				internalType: 'struct Initializer',
				components: [
					{
						name: 'initContract',
						type: 'address',
						internalType: 'address',
					},
					{
						name: 'initData',
						type: 'bytes',
						internalType: 'bytes',
					},
				],
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'executeInitializers',
		inputs: [
			{
				name: '',
				type: 'tuple[]',
				internalType: 'struct Initializer[]',
				components: [
					{
						name: 'initContract',
						type: 'address',
						internalType: 'address',
					},
					{
						name: 'initData',
						type: 'bytes',
						internalType: 'bytes',
					},
				],
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'facetAddress',
		inputs: [
			{
				name: '',
				type: 'bytes4',
				internalType: 'bytes4',
			},
		],
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
		name: 'facetAddresses',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'address[]',
				internalType: 'address[]',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'facetFunctionSelectors',
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
				type: 'bytes4[]',
				internalType: 'bytes4[]',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'facets',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'tuple[]',
				internalType: 'struct Facet[]',
				components: [
					{
						name: 'facetAddress',
						type: 'address',
						internalType: 'address',
					},
					{
						name: 'functionSelectors',
						type: 'bytes4[]',
						internalType: 'bytes4[]',
					},
				],
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getAccountInfo',
		inputs: [
			{
				name: '_account',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [
			{
				name: 'account',
				type: 'tuple',
				internalType: 'struct IViewFacet.AccountInfo',
				components: [
					{
						name: 'linked',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'linkedId',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'points',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'walletProfileId',
						type: 'uint256',
						internalType: 'uint256',
					},
					{
						name: 'claimedCurrent',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'lockedQFKs',
						type: 'uint256[]',
						internalType: 'uint256[]',
					},
					{
						name: 'hasKreskian',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'currentClaimId',
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
		name: 'getApproved',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getBurnNftAddress',
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
		name: 'getClaimed',
		inputs: [
			{
				name: 'user',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
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
		name: 'getConfig',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: '',
				type: 'tuple',
				internalType: 'struct ClaimEvent',
				components: [
					{
						name: 'merkleRoot',
						type: 'bytes32',
						internalType: 'bytes32',
					},
					{
						name: 'startDate',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'claimWindow',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'minting',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'burning',
						type: 'bool',
						internalType: 'bool',
					},
				],
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getConfigIds',
		inputs: [],
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
		name: 'getKredits',
		inputs: [
			{
				name: 'tokenId',
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
		name: 'getKreditsForMint',
		inputs: [],
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
		name: 'getLinkedId',
		inputs: [
			{
				name: 'user',
				type: 'address',
				internalType: 'address',
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
		name: 'getLocked',
		inputs: [
			{
				name: 'tokenId721',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'nft',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'tokenId1155',
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
		name: 'getProfileKreditsCost',
		inputs: [
			{
				name: 'kredits',
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
		name: 'getRoleMember',
		inputs: [
			{
				name: 'role',
				type: 'bytes32',
				internalType: 'bytes32',
			},
			{
				name: 'index',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
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
		name: 'getRoleMemberCount',
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
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'getTokenIds',
		inputs: [],
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
				name: 'status',
				type: 'bool',
				internalType: 'bool',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'link',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'lock1155',
		inputs: [
			{
				name: 'nfts',
				type: 'address[]',
				internalType: 'address[]',
			},
			{
				name: 'tokenIds',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'amounts',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'mintProfile',
		inputs: [
			{
				name: 'to',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'link',
				type: 'bool',
				internalType: 'bool',
			},
		],
		outputs: [
			{
				name: '',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'name',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'string',
				internalType: 'string',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'onERC1155BatchReceived',
		inputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'ids',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'values',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'data',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [
			{
				name: '',
				type: 'bytes4',
				internalType: 'bytes4',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'onERC1155Received',
		inputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'value',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'data',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [
			{
				name: '',
				type: 'bytes4',
				internalType: 'bytes4',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'onERC721Received',
		inputs: [
			{
				name: 'operator',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'from',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'data',
				type: 'bytes',
				internalType: 'bytes',
			},
		],
		outputs: [
			{
				name: '',
				type: 'bytes4',
				internalType: 'bytes4',
			},
		],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'owner',
		inputs: [],
		outputs: [
			{
				name: 'owner_',
				type: 'address',
				internalType: 'address',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'ownerOf',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: 'owner',
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
		name: 'royaltyInfo',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'salePrice',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: 'receiever',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'royaltyAmount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
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
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'payable',
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
				name: 'tokenId',
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
				name: 'status',
				type: 'bool',
				internalType: 'bool',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setERC165',
		inputs: [
			{
				name: 'add',
				type: 'bytes4[]',
				internalType: 'bytes4[]',
			},
			{
				name: 'remove',
				type: 'bytes4[]',
				internalType: 'bytes4[]',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setKreditsForMint',
		inputs: [
			{
				name: 'amount',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setRoyalties',
		inputs: [
			{
				name: 'defaultRoyaltyBPS',
				type: 'uint16',
				internalType: 'uint16',
			},
			{
				name: 'royaltiesBPS',
				type: 'uint16[]',
				internalType: 'uint16[]',
			},
			{
				name: 'defaultRoyaltyReceiver',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'setRoyalty',
		inputs: [
			{
				name: 'defaultRoyaltyBPS',
				type: 'uint16',
				internalType: 'uint16',
			},
		],
		outputs: [],
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
		type: 'function',
		name: 'symbol',
		inputs: [],
		outputs: [
			{
				name: '',
				type: 'string',
				internalType: 'string',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'tokenByIndex',
		inputs: [
			{
				name: 'index',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'tokenOfOwnerByIndex',
		inputs: [
			{
				name: 'owner',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'index',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'tokenURI',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [
			{
				name: '',
				type: 'string',
				internalType: 'string',
			},
		],
		stateMutability: 'view',
	},
	{
		type: 'function',
		name: 'totalSupply',
		inputs: [],
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
		name: 'transferFrom',
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
				name: 'tokenId',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
		outputs: [],
		stateMutability: 'payable',
	},
	{
		type: 'function',
		name: 'transferOwnership',
		inputs: [
			{
				name: '_newOwner',
				type: 'address',
				internalType: 'address',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'unlink',
		inputs: [],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'unlock1155',
		inputs: [
			{
				name: 'nfts',
				type: 'address[]',
				internalType: 'address[]',
			},
			{
				name: 'tokenIds',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
			{
				name: 'amounts',
				type: 'uint256[]',
				internalType: 'uint256[]',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'updateClaim',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'config',
				type: 'tuple',
				internalType: 'struct ClaimEvent',
				components: [
					{
						name: 'merkleRoot',
						type: 'bytes32',
						internalType: 'bytes32',
					},
					{
						name: 'startDate',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'claimWindow',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'minting',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'burning',
						type: 'bool',
						internalType: 'bool',
					},
				],
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'function',
		name: 'updateTokenURI',
		inputs: [
			{
				name: 'newURI',
				type: 'string',
				internalType: 'string',
			},
		],
		outputs: [],
		stateMutability: 'nonpayable',
	},
	{
		type: 'event',
		name: 'Approval',
		inputs: [
			{
				name: 'owner',
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
				name: 'tokenId',
				type: 'uint256',
				indexed: true,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'ApprovalForAll',
		inputs: [
			{
				name: 'owner',
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
		name: 'ClaimCreated',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'config',
				type: 'tuple',
				indexed: false,
				internalType: 'struct ClaimEvent',
				components: [
					{
						name: 'merkleRoot',
						type: 'bytes32',
						internalType: 'bytes32',
					},
					{
						name: 'startDate',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'claimWindow',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'minting',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'burning',
						type: 'bool',
						internalType: 'bool',
					},
				],
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'ClaimUpdated',
		inputs: [
			{
				name: 'airdropId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'config',
				type: 'tuple',
				indexed: false,
				internalType: 'struct ClaimEvent',
				components: [
					{
						name: 'merkleRoot',
						type: 'bytes32',
						internalType: 'bytes32',
					},
					{
						name: 'startDate',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'claimWindow',
						type: 'uint128',
						internalType: 'uint128',
					},
					{
						name: 'minting',
						type: 'bool',
						internalType: 'bool',
					},
					{
						name: 'burning',
						type: 'bool',
						internalType: 'bool',
					},
				],
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'Claimed',
		inputs: [
			{
				name: 'user',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'tokenId721',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'airdropId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'KreditsAdded',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'KreditsForMintSet',
		inputs: [
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'KreditsRemoved',
		inputs: [
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'Linked',
		inputs: [
			{
				name: 'user',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'Locked',
		inputs: [
			{
				name: 'user',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'tokenId721',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'token',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: true,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'OwnershipTransferred',
		inputs: [
			{
				name: 'previousOwner',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'newOwner',
				type: 'address',
				indexed: true,
				internalType: 'address',
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
		name: 'Transfer',
		inputs: [
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
				name: 'tokenId',
				type: 'uint256',
				indexed: true,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'Unlinked',
		inputs: [
			{
				name: 'user',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'event',
		name: 'Unlocked',
		inputs: [
			{
				name: 'user',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'tokenId721',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'token',
				type: 'address',
				indexed: true,
				internalType: 'address',
			},
			{
				name: 'amount',
				type: 'uint256',
				indexed: false,
				internalType: 'uint256',
			},
			{
				name: 'tokenId',
				type: 'uint256',
				indexed: true,
				internalType: 'uint256',
			},
		],
		anonymous: false,
	},
	{
		type: 'error',
		name: 'AlreadyClaimed',
		inputs: [
			{
				name: 'who',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'ClaimWindowEnded',
		inputs: [
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'endTime',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'ERC721Base__BalanceQueryZeroAddress',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__ERC721ReceiverNotImplemented',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__InvalidOwner',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__MintToZeroAddress',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__NonExistentToken',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__NotOwnerOrApproved',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__NotTokenOwner',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__SelfApproval',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__TokenAlreadyMinted',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Base__TransferToZeroAddress',
		inputs: [],
	},
	{
		type: 'error',
		name: 'ERC721Metadata__NonExistentToken',
		inputs: [],
	},
	{
		type: 'error',
		name: 'InvalidClaimId',
		inputs: [
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'NotBurningClaim',
		inputs: [
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'NotLinked',
		inputs: [
			{
				name: 'who',
				type: 'address',
				internalType: 'address',
			},
		],
	},
	{
		type: 'error',
		name: 'NotMintingClaim',
		inputs: [
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'NotOwner',
		inputs: [
			{
				name: 'sender',
				type: 'address',
				internalType: 'address',
			},
			{
				name: 'owner',
				type: 'address',
				internalType: 'address',
			},
		],
	},
	{
		type: 'error',
		name: 'NotStarted',
		inputs: [
			{
				name: 'id',
				type: 'uint256',
				internalType: 'uint256',
			},
			{
				name: 'startTime',
				type: 'uint256',
				internalType: 'uint256',
			},
		],
	},
	{
		type: 'error',
		name: 'OnlyLinked',
		inputs: [],
	},
	{
		type: 'error',
		name: 'OnlyUnlinked',
		inputs: [],
	},
] as const;
