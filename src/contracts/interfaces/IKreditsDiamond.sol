// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {IExtendedDiamondCutFacet, IDiamondLoupeFacet} from "kopio/IKopioCore.sol";
import {IERC165} from "kopio/vendor/IERC165.sol";
import {IERC173} from "kopio/vendor/IERC173.sol";

// lib/solidstate/contracts/access/access_control/IAccessControlInternal.sol

/**
 * @title Partial AccessControl interface needed by internal functions
 */
interface IAccessControlInternal {
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
}

// lib/solidstate/contracts/token/ERC721/enumerable/IERC721Enumerable.sol

interface IERC721Enumerable {
    /**
     * @notice get total token supply
     * @return total supply
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice get token of given owner at given internal storage index
     * @param owner token holder to query
     * @param index position in owner's token list to query
     * @return tokenId id of retrieved token
     */
    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view returns (uint256 tokenId);

    /**
     * @notice get token at given internal storage index
     * @param index position in global token list to query
     * @return tokenId id of retrieved token
     */
    function tokenByIndex(
        uint256 index
    ) external view returns (uint256 tokenId);
}

// src/core/interfaces/IActionFacet.sol

interface IActionFacet {
    function link(uint256 tokenId) external;

    function unlink() external;

    function lock1155(
        address[] memory nfts,
        uint256[] memory tokenIds,
        uint256[] memory amounts
    ) external;

    function unlock1155(
        address[] calldata nfts,
        uint256[] calldata tokenIds,
        uint256[] calldata amounts
    ) external;
}

// src/core/interfaces/IClaimerFacet.sol

interface IClaimerFacet {
    function claimAndMint(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function claim(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function burnKreditsAndMint(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function burnAndMint() external;
}

// src/core/libs/Errors.sol

interface Errors {
    error NotOwner(address sender, address owner);
    error OnlyUnlinked();
    error OnlyLinked();
    error InvalidClaimId(uint256 id);
    error AlreadyClaimed(address who, uint256 id);

    error NotStarted(uint256 id, uint256 startTime);
    error ClaimWindowEnded(uint256 id, uint256 endTime);

    error NotLinked(address who);

    error NotMintingClaim(uint256 id);
    error NotBurningClaim(uint256 id);
}

interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` amount of tokens of type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the value of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);

    /**
     * @dev Transfers a `value` amount of tokens of type `id` from `from` to `to`.
     *
     * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
     * to an untrusted contract, when invoking {onERC1155Received} on the receiver.
     * Ensure to follow the checks-effects-interactions pattern and consider employing
     * reentrancy guards when interacting with untrusted contracts.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `value` amount.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
     * to an untrusted contract, when invoking {onERC1155BatchReceived} on the receiver.
     * Ensure to follow the checks-effects-interactions pattern and consider employing
     * reentrancy guards when interacting with untrusted contracts.
     *
     * Emits either a {TransferSingle} or a {TransferBatch} event, depending on the length of the array arguments.
     *
     * Requirements:
     *
     * - `ids` and `values` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;
}

// lib/solidstate/contracts/access/access_control/IAccessControl.sol

/**
 * @title AccessControl interface
 */
interface IAccessControl is IAccessControlInternal {
    /*
     * @notice query whether role is assigned to account
     * @param role role to query
     * @param account account to query
     * @return whether role is assigned to account
     */
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);

    /*
     * @notice query admin role for given role
     * @param role role to query
     * @return admin role
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /*
     * @notice assign role to given account
     * @param role role to assign
     * @param account recipient of role assignment
     */
    function grantRole(bytes32 role, address account) external;

    /*
     * @notice unassign role from given account
     * @param role role to unassign
     * @parm account
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @notice relinquish role
     * @param role role to relinquish
     */
    function renounceRole(bytes32 role) external;

    /**
     * @notice Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(
        bytes32 role,
        uint256 index
    ) external view returns (address);

    /**
     * @notice Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
}

// src/diamond/interfaces/IOwnershipFacet.sol

// solhint-disable no-empty-blocks

interface IOwnershipFacet is IERC173 {}

// src/core/RegistryState.sol

/**
 * @title Claim Event
 * @param merkleRoot Merkle root of the claim
 * @param startDate Start date of the claim
 * @param claimWindow Claim window of the claim
 * @param minting Is the claim a minting event
 * @param burning Is the claim a burning event
 * @dev Claim event struct
 */
struct ClaimEvent {
    bytes32 merkleRoot;
    uint128 startDate;
    uint128 claimWindow;
    bool minting;
    bool burning;
}

/**
 * @title Storage layout for the registry state
 * @author Kresko
 */
struct RegistryState {
    // Airdrops
    uint256 airdropsIds;
    // Kredits to be burnt for Minting 721
    uint256 maxKreditsForMint;
    // Mapping kredits airdrop to merkle roots
    mapping(uint256 => ClaimEvent) claimEvents;
    // Claimed airdrops
    mapping(address => mapping(uint256 => bool)) claimed;
    // ERC721 Minted
    uint256 currentTokenIds;
    // Valid Kresko 1155 NFT
    mapping(address => bool) isValid;
    // Mapping from token ID to kredits
    mapping(uint256 => uint256) kredits;
    // Mapping from user to token ID
    mapping(address => uint256) linkedId;
    // NFT token Id to 1155 token to 1155 id to amounts locked
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) locked;
}

// Storage position
bytes32 constant REGISTRY_STORAGE_POSITION = keccak256(
    "kresko.registry.storage"
);

/* -------------------------------------------------------------------------- */
/*                                   Getter                                   */
/* -------------------------------------------------------------------------- */

function rs() pure returns (RegistryState storage state) {
    bytes32 position = REGISTRY_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}

// lib/solidstate/contracts/interfaces/IERC2981.sol

/**
 * @title ERC2981 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-2981
 */
interface IERC2981 is IERC165 {
    /**
     * @notice called with the sale price to determine how much royalty is owed and to whom
     * @param tokenId the ERC721 or ERC1155 token id to query for royalty information
     * @param salePrice the sale price of the given asset
     * @return receiever rightful recipient of royalty
     * @return royaltyAmount amount of royalty owed
     */
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view returns (address receiever, uint256 royaltyAmount);
}

// lib/solidstate/contracts/interfaces/IERC721.sol

/**
 * @title ERC721 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721 is IERC165 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed operator,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    error ERC721Base__NotOwnerOrApproved();
    error ERC721Base__SelfApproval();
    error ERC721Base__BalanceQueryZeroAddress();
    error ERC721Base__ERC721ReceiverNotImplemented();
    error ERC721Base__InvalidOwner();
    error ERC721Base__MintToZeroAddress();
    error ERC721Base__NonExistentToken();
    error ERC721Base__NotTokenOwner();
    error ERC721Base__TokenAlreadyMinted();
    error ERC721Base__TransferToZeroAddress();

    /**
     * @notice query the balance of given address
     * @return balance quantity of tokens held
     */
    function balanceOf(address account) external view returns (uint256 balance);

    /**
     * @notice query the owner of given token
     * @param tokenId token to query
     * @return owner token owner
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @notice transfer token between given addresses, checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;

    /**
     * @notice transfer token between given addresses, checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     * @param data data payload
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external payable;

    /**
     * @notice transfer token between given addresses, without checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;

    /**
     * @notice grant approval to given account to spend token
     * @param operator address to be approved
     * @param tokenId token to approve
     */
    function approve(address operator, uint256 tokenId) external payable;

    /**
     * @notice get approval status for given token
     * @param tokenId token to query
     * @return operator address approved to spend token
     */
    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    /**
     * @notice grant approval to or revoke approval from given account to spend all tokens held by sender
     * @param operator address to be approved
     * @param status approval status
     */
    function setApprovalForAll(address operator, bool status) external;

    /**
     * @notice query approval status of given operator with respect to given address
     * @param account address to query for approval granted
     * @param operator address to query for approval received
     * @return status whether operator is approved to spend tokens held by account
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool status);
}

// lib/solidstate/contracts/token/ERC721/metadata/IERC721Metadata.sol

/**
 * @title ERC721Metadata interface
 */
interface IERC721Metadata {
    error ERC721Metadata__NonExistentToken();

    /**
     * @notice get token name
     * @return token name
     */
    function name() external view returns (string memory);

    /**
     * @notice get token symbol
     * @return token symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @notice get generated URI for given token
     * @return token URI
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// src/core/interfaces/IClaimerConfigFacet.sol

interface IClaimerConfigFacet {
    function createClaim(ClaimEvent memory config) external returns (uint256);

    function updateClaim(uint256 airdropId, ClaimEvent memory config) external;

    function setKreditsForMint(uint256 amount) external;

    function mintProfile(address to, bool link) external returns (uint256);

    function batchMintProfile(
        address[] calldata to,
        bool[] calldata link
    ) external;
}

// src/core/interfaces/IViewFacet.sol

interface IViewFacet {
    struct AccountInfo {
        bool linked;
        uint256 linkedId;
        uint256 points;
        uint256 walletProfileId;
        bool claimedCurrent;
        uint256[] lockedQFKs;
        bool hasKreskian;
        uint256 currentClaimId;
    }

    function getAccountInfo(
        address _account
    ) external view returns (AccountInfo memory account);

    function getBurnNftAddress() external view returns (address);

    function getClaimed(
        address user,
        uint256 airdropId
    ) external view returns (bool);

    function getKredits(uint256 tokenId) external view returns (uint256);

    function getLinkedId(address user) external view returns (uint256);

    function getLocked(
        uint256 tokenId721,
        address nft,
        uint256 tokenId1155
    ) external view returns (uint256);

    function getConfigIds() external view returns (uint256);

    function getTokenIds() external view returns (uint256);

    function getConfig(
        uint256 airdropId
    ) external view returns (ClaimEvent memory);

    function getKreditsForMint() external view returns (uint256);

    function getProfileKreditsCost(
        uint256 kredits
    ) external view returns (uint256);
}

// src/core/libs/Events.sol

interface Events {
    event Linked(address indexed user, uint256 tokenId);
    event Unlinked(address indexed user, uint256 tokenId);
    event KreditsAdded(uint256 tokenId, uint256 amount);
    event KreditsRemoved(uint256 tokenId, uint256 amount);
    event Locked(
        address indexed user,
        uint256 tokenId721,
        address indexed token,
        uint256 amount,
        uint256 indexed tokenId
    );
    event Unlocked(
        address indexed user,
        uint256 tokenId721,
        address indexed token,
        uint256 amount,
        uint256 indexed tokenId
    );
    event Claimed(
        address indexed user,
        uint256 tokenId721,
        uint256 airdropId,
        uint256 amount
    );
    event ClaimCreated(uint256 airdropId, ClaimEvent config);
    event ClaimUpdated(uint256 airdropId, ClaimEvent config);
    event KreditsForMintSet(uint256 amount);
}

// src/core/interfaces/IRoyaltyFacet.sol

interface IRoyaltyFacet is IERC2981 {
    function setRoyalties(
        uint16 defaultRoyaltyBPS,
        uint16[] memory royaltiesBPS,
        address defaultRoyaltyReceiver
    ) external;

    function setRoyalty(uint16 defaultRoyaltyBPS) external;
}

// lib/solidstate/contracts/token/ERC721/base/IERC721Base.sol

// src/core/interfaces/IERC721Facet.sol

interface IERC721Facet is IERC721, IERC721Enumerable, IERC721Metadata {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function updateTokenURI(string memory newURI) external;
}

// src/core/interfaces/IKreditsDiamond.sol

interface IKreditsDiamond is
    IExtendedDiamondCutFacet,
    IDiamondLoupeFacet,
    IOwnershipFacet,
    IClaimerFacet,
    IClaimerConfigFacet,
    IRoyaltyFacet,
    IAccessControl,
    IActionFacet,
    IViewFacet,
    IERC721Facet,
    Errors,
    Events
{}
