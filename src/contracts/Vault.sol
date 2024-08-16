// SPDX-License-Identifier: BUSL-1.1
pragma solidity <0.9.0 =0.8.26 >=0.8.0 >=0.8.10 >=0.8.19 ^0.8.0 ^0.8.20;

// lib/kopio-lib/lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE =
        0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reininitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage()
        private
        pure
        returns (InitializableStorage storage $)
    {
        assembly {
            $.slot := INITIALIZABLE_STORAGE
        }
    }
}

// lib/kopio-lib/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/access/IAccessControl.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/IAccessControl.sol)

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev The `account` is missing a role.
     */
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    /**
     * @dev The caller of a function is not the expected one.
     *
     * NOTE: Don't confuse with {AccessControlUnauthorizedAccount}.
     */
    error AccessControlBadConfirmation();

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     */
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     */
    function renounceRole(bytes32 role, address callerConfirmation) external;
}

// lib/kopio-lib/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position is the index of the value in the `values` array plus 1.
        // Position 0 is used to mean a value is not in the set.
        mapping(bytes32 value => uint256) _positions;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We cache the value's position to prevent multiple reads from the same storage slot
        uint256 position = set._positions[value];

        if (position != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;

            if (valueIndex != lastIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the lastValue to the index where the value to delete is
                set._values[valueIndex] = lastValue;
                // Update the tracked position of the lastValue (that was just moved)
                set._positions[lastValue] = position;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the tracked position for the deleted slot
            delete set._positions[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(
        Set storage set,
        bytes32 value
    ) private view returns (bool) {
        return set._positions[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(
        Set storage set,
        uint256 index
    ) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        Bytes32Set storage set,
        bytes32 value
    ) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        Bytes32Set storage set,
        uint256 index
    ) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        Bytes32Set storage set
    ) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        AddressSet storage set,
        address value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        AddressSet storage set,
        uint256 index
    ) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        AddressSet storage set
    ) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        UintSet storage set,
        uint256 value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        UintSet storage set,
        uint256 value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        UintSet storage set,
        uint256 index
    ) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        UintSet storage set
    ) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}

// lib/kopio-lib/src/token/IERC20.sol

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    function allowance(address, address) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// lib/kopio-lib/src/vendor/IAPI3.sol

/// @dev See DapiProxy.sol for comments about usage
interface IAPI3 {
    function read() external view returns (int224 value, uint32 timestamp);

    function api3ServerV1() external view returns (address);
}

// lib/kopio-lib/src/vendor/IAggregatorV3.sol

interface IAggregatorV3 {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function latestAnswer() external view returns (int256);

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    event AnswerUpdated(
        int256 indexed current,
        uint256 indexed roundId,
        uint256 updatedAt
    );

    event NewRound(
        uint256 indexed roundId,
        address indexed startedBy,
        uint256 startedAt
    );
}

// lib/kopio-lib/src/vendor/Pyth.sol

/// @dev https://github.com/pyth-network/pyth-sdk-solidity/blob/main/PythStructs.sol
/// @dev Extra ticker is included in the struct
struct PriceFeed {
    // The price ID.
    bytes32 id;
    // Latest available price
    Price price;
    // Latest available exponentially-weighted moving average price
    Price emaPrice;
}

/// @dev  https://github.com/pyth-network/pyth-sdk-solidity/blob/main/PythStructs.sol
struct Price {
    // Price
    int64 price;
    // Confidence interval around the price
    uint64 conf;
    // Price exponent
    int32 expo;
    // Unix timestamp describing when the price was published
    uint256 publishTime;
}

struct PythEPs {
    mapping(uint256 chainId => IPyth pythEp) get;
    IPyth avax;
    IPyth bsc;
    IPyth blast;
    IPyth mainnet;
    IPyth arbitrum;
    IPyth optimism;
    IPyth polygon;
    IPyth polygonzkevm;
    bytes[] update;
    uint256 cost;
    PythView viewData;
    string tickers;
}

struct PythView {
    bytes32[] ids;
    Price[] prices;
}

interface IPyth {
    function getPriceNoOlderThan(
        bytes32 _id,
        uint256 _maxAge
    ) external view returns (Price memory);

    function getPrice(bytes32) external view returns (Price memory);
    function getPriceUnsafe(bytes32) external view returns (Price memory);

    function getUpdateFee(bytes[] memory) external view returns (uint256);

    function updatePriceFeeds(bytes[] memory) external payable;

    function updatePriceFeedsIfNecessary(
        bytes[] calldata data,
        bytes32[] calldata ids,
        uint64[] calldata publishTimes
    ) external payable;

    function queryPriceFeed(bytes32) external view returns (PriceFeed memory);
    function priceFeedExists(bytes32) external view returns (bool);
    function parsePriceFeedUpdates(
        bytes[] calldata data,
        bytes32[] calldata ids,
        uint64 minTime,
        uint64 maxTime
    ) external payable returns (PriceFeed[] memory);

    // Function arguments are invalid (e.g., the arguments lengths mismatch)
    // Signature: 0xa9cb9e0d
    error InvalidArgument();
    // Update data is coming from an invalid data source.
    // Signature: 0xe60dce71
    error InvalidUpdateDataSource();
    // Update data is invalid (e.g., deserialization error)
    // Signature: 0xe69ffece
    error InvalidUpdateData();
    // Insufficient fee is paid to the method.
    // Signature: 0x025dbdd4
    error InsufficientFee();
    // There is no fresh update, whereas expected fresh updates.
    // Signature: 0xde2c57fa
    error NoFreshUpdate();
    // There is no price feed found within the given range or it does not exists.
    // Signature: 0x45805f5d
    error PriceFeedNotFoundWithinRange();
    // Price feed not found or it is not pushed on-chain yet.
    // Signature: 0x14aebe68
    error PriceFeedNotFound();
    // Requested price is stale.
    // Signature: 0x19abf40e
    error StalePrice();
    // Given message is not a valid Wormhole VAA.
    // Signature: 0x2acbe915
    error InvalidWormholeVaa();
    // Governance message is invalid (e.g., deserialization error).
    // Signature: 0x97363b35
    error InvalidGovernanceMessage();
    // Governance message is not for this contract.
    // Signature: 0x63daeb77
    error InvalidGovernanceTarget();
    // Governance message is coming from an invalid data source.
    // Signature: 0x360f2d87
    error InvalidGovernanceDataSource();
    // Governance message is old.
    // Signature: 0x88d1b847
    error OldGovernanceMessage();
    // The wormhole address to set in SetWormholeAddress governance is invalid.
    // Signature: 0x13d3ed82
    error InvalidWormholeAddressToSet();
}

// src/contracts/core/common/Constants.sol

/* -------------------------------------------------------------------------- */
/*                                    Enums                                   */
/* -------------------------------------------------------------------------- */
library Enums {
    enum ICDPFee {
        Open,
        Close
    }

    enum SwapFee {
        In,
        Out
    }

    enum OracleType {
        Empty,
        Redstone,
        Chainlink,
        API3,
        Vault,
        Pyth
    }

    enum Action {
        Deposit,
        Withdraw,
        Repay,
        Borrow,
        Liquidation,
        SCDPDeposit,
        SCDPSwap,
        SCDPWithdraw,
        SCDPRepay,
        SCDPLiquidation,
        SCDPFeeClaim,
        SCDPCover
    }
}

library Role {
    bytes32 internal constant DEFAULT_ADMIN = 0x00;
    bytes32 internal constant ADMIN = keccak256("kopio.role.admin");
    bytes32 internal constant OPERATOR = keccak256("kopio.role.operator");
    bytes32 internal constant MANAGER = keccak256("kopio.role.manager");
    bytes32 internal constant SAFETY_COUNCIL = keccak256("kopio.role.safety");
}

library Constants {
    /// @dev Set the initial value to 1, (not hindering possible gas refunds by setting it to 0 on exit).
    uint8 internal constant NOT_ENTERED = 1;
    uint8 internal constant ENTERED = 2;
    uint8 internal constant NOT_INITIALIZING = 1;
    uint8 internal constant INITIALIZING = 2;

    /// @dev The min oracle decimal precision
    uint256 internal constant MIN_ORACLE_DECIMALS = 8;
    /// @dev The minimum collateral amount for a asset.
    uint256 internal constant MIN_COLLATERAL = 1e12;

    /// @dev The maximum configurable minimum debt USD value. 8 decimals.
    uint256 internal constant MAX_MIN_DEBT_VALUE = 1_000 * 1e8; // $1,000
}

library Percents {
    uint16 internal constant ONE = 0.01e4;
    uint16 internal constant HUNDRED = 1e4;
    uint16 internal constant TWENTY_FIVE = 0.25e4;
    uint16 internal constant FIFTY = 0.50e4;
    uint16 internal constant MAX_DEVIATION = TWENTY_FIVE;

    uint16 internal constant BASIS_POINT = 1;
    /// @dev The maximum configurable close fee.
    uint16 internal constant MAX_CLOSE_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable open fee.
    uint16 internal constant MAX_OPEN_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable protocol fee per asset for collateral pool swaps.
    uint16 internal constant MAX_SCDP_FEE = 0.5e4; // 50%

    /// @dev The minimum configurable minimum collateralization ratio.
    uint16 internal constant MIN_LT = HUNDRED + ONE; // 101%
    uint16 internal constant MIN_MCR = HUNDRED + ONE + ONE; // 102%

    /// @dev The minimum configurable liquidation incentive multiplier.
    /// This means liquidator only receives equal amount of collateral to debt repaid.
    uint16 internal constant MIN_LIQ_INCENTIVE = HUNDRED;

    /// @dev The maximum configurable liquidation incentive multiplier.
    /// This means liquidator receives 25% bonus collateral compared to the debt repaid.
    uint16 internal constant MAX_LIQ_INCENTIVE = 1.25e4; // 125%
}

// src/contracts/core/common/Errors.sol

// solhint-disable

function id(address t) view returns (err.ID memory r) {
    r.addr = t;
    if (t.code.length != 0) r.symbol = tkn(t).symbol();
}

interface tkn {
    function symbol() external view returns (string memory);
}

interface err {
    struct ID {
        string symbol;
        address addr;
    }

    error ADDRESS_HAS_NO_CODE(address);
    error NOT_INITIALIZING();
    error TO_WAD_AMOUNT_IS_NEGATIVE(int256);
    error COMMON_ALREADY_INITIALIZED();
    error ICDP_ALREADY_INITIALIZED();
    error SCDP_ALREADY_INITIALIZED();
    error STRING_HEX_LENGTH_INSUFFICIENT();
    error SAFETY_COUNCIL_NOT_ALLOWED();
    error SAFETY_COUNCIL_SETTER_IS_NOT_ITS_OWNER(address);
    error SAFETY_COUNCIL_ALREADY_EXISTS(address given, address existing);
    error MULTISIG_NOT_ENOUGH_OWNERS(address, uint256 owners, uint256 required);
    error ACCESS_CONTROL_NOT_SELF(address who, address self);
    error MARKET_CLOSED(ID, string);
    error SCDP_ASSET_ECONOMY(
        ID,
        uint256 seizeReductionPct,
        ID,
        uint256 repayIncreasePct
    );
    error ICDP_ASSET_ECONOMY(
        ID,
        uint256 seizeReductionPct,
        ID,
        uint256 repayIncreasePct
    );
    error INVALID_TICKER(ID, string ticker);
    error PYTH_EP_ZERO();
    error ASSET_SET_FEEDS_FAILED(ID);
    error ASSET_PAUSED_FOR_THIS_ACTION(ID, uint8 action);
    error NOT_COVER_ASSET(ID);
    error NOT_ENABLED(ID);
    error NOT_CUMULATED(ID);
    error NOT_DEPOSITABLE(ID);
    error NOT_MINTABLE(ID);
    error NOT_SWAPPABLE(ID);
    error NOT_COLLATERAL(ID);
    error INVALID_ASSET(address);
    error NO_GLOBAL_DEPOSITS(ID);
    error ASSET_CANNOT_BE_FEE_ASSET(ID);
    error ASSET_NOT_VALID_DEPOSIT_ASSET(ID);
    error ASSET_ALREADY_ENABLED(ID);
    error ASSET_ALREADY_DISABLED(ID);
    error NOT_INCOME_ASSET(address);
    error ASSET_EXISTS(ID);
    error VOID_ASSET();
    error CANNOT_REMOVE_COLLATERAL_THAT_HAS_USER_DEPOSITS(ID);
    error CANNOT_REMOVE_SWAPPABLE_ASSET_THAT_HAS_DEBT(ID);
    error INVALID_KOPIO(ID kopio);
    error INVALID_SHARE(ID share, ID kopio);
    error IDENTICAL_ASSETS(ID);
    error WITHDRAW_NOT_SUPPORTED();
    error MINT_NOT_SUPPORTED();
    error DEPOSIT_NOT_SUPPORTED();
    error REDEEM_NOT_SUPPORTED();
    error NATIVE_TOKEN_DISABLED(ID);
    error EXCEEDS_ASSET_DEPOSIT_LIMIT(ID, uint256 deposits, uint256 limit);
    error EXCEEDS_ASSET_MINTING_LIMIT(ID, uint256 deposits, uint256 limit);
    error UINT128_OVERFLOW(ID, uint256 deposits, uint256 limit);
    error INVALID_SENDER(address, address);
    error INVALID_MIN_DEBT(uint256 invalid, uint256 valid);
    error INVALID_SCDP_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_MCR(uint256 invalid, uint256 valid);
    error MLR_LESS_THAN_LT(uint256 mlt, uint256 lt);
    error INVALID_LIQ_THRESHOLD(uint256 lt, uint256 min, uint256 max);
    error INVALID_PROTOCOL_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_ASSET_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_ORACLE_DEVIATION(uint256 invalid, uint256 valid);
    error INVALID_ORACLE_TYPE(uint8 invalid);
    error INVALID_FEE_RECIPIENT(address invalid);
    error INVALID_LIQ_INCENTIVE(ID, uint256 invalid, uint256 min, uint256 max);
    error INVALID_DFACTOR(ID, uint256 invalid, uint256 valid);
    error INVALID_CFACTOR(ID, uint256 invalid, uint256 valid);
    error INVALID_ICDP_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_PRICE_PRECISION(uint256 decimals, uint256 valid);
    error INVALID_COVER_THRESHOLD(uint256 threshold, uint256 max);
    error INVALID_COVER_INCENTIVE(uint256 incentive, uint256 min, uint256 max);
    error INVALID_DECIMALS(ID, uint256 decimals);
    error INVALID_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_FEE_TYPE(uint8 invalid, uint8 valid);
    error INVALID_VAULT_PRICE(string ticker, address);
    error INVALID_API3_PRICE(string ticker, address);
    error INVALID_CL_PRICE(string ticker, address);
    error INVALID_PRICE(ID, address oracle, int256 price);
    error INVALID_KOPIO_OPERATOR(
        ID,
        address invalidOperator,
        address validOperator
    );
    error INVALID_DENOMINATOR(ID, uint256 denominator, uint256 valid);
    error INVALID_OPERATOR(ID, address who, address valid);
    error INVALID_SUPPLY_LIMIT(ID, uint256 invalid, uint256 valid);
    error NEGATIVE_PRICE(address asset, int256 price);
    error INVALID_PYTH_PRICE(bytes32 id, uint256 price);
    error STALE_PRICE(
        string ticker,
        uint256 price,
        uint256 timeFromUpdate,
        uint256 threshold
    );
    error STALE_PUSH_PRICE(
        ID asset,
        string ticker,
        int256 price,
        uint8 oracleType,
        address feed,
        uint256 timeFromUpdate,
        uint256 threshold
    );
    error PRICE_UNSTABLE(
        uint256 primaryPrice,
        uint256 referencePrice,
        uint256 deviationPct
    );
    error ZERO_OR_STALE_VAULT_PRICE(ID, address, uint256);
    error ZERO_OR_STALE_PRICE(string ticker, uint8[2] oracles);
    error STALE_ORACLE(
        uint8 oracleType,
        address feed,
        uint256 time,
        uint256 staleTime
    );
    error ZERO_OR_NEGATIVE_PUSH_PRICE(
        ID asset,
        string ticker,
        int256 price,
        uint8 oracleType,
        address feed
    );
    error UNSUPPORTED_ORACLE(string ticker, uint8 oracle);
    error NO_PUSH_ORACLE_SET(string ticker);
    error NO_VIEW_PRICE_AVAILABLE(string ticker);
    error NOT_SUPPORTED_YET();
    error WRAP_NOT_SUPPORTED();
    error BURN_AMOUNT_OVERFLOW(ID, uint256 burnAmount, uint256 debtAmount);
    error PAUSED(address who);
    error L2_SEQUENCER_DOWN();
    error FEED_ZERO_ADDRESS(string ticker);
    error INVALID_SEQUENCER_UPTIME_FEED(address);
    error NO_MINTED_ASSETS(address who);
    error NO_COLLATERALS_DEPOSITED(address who);
    error ONLY_WHITELISTED();
    error BLACKLISTED();
    error CANNOT_RE_ENTER();
    error PYTH_ID_ZERO(string ticker);
    error ARRAY_LENGTH_MISMATCH(string ticker, uint256 arr1, uint256 arr2);
    error COLLATERAL_VALUE_GREATER_THAN_REQUIRED(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error COLLATERAL_VALUE_GREATER_THAN_COVER_THRESHOLD(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint48 ratio
    );
    error ACCOUNT_COLLATERAL_TOO_LOW(
        address who,
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error COLLATERAL_TOO_LOW(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error NOT_LIQUIDATABLE(
        address who,
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error CANNOT_LIQUIDATE_SELF();
    error LIQUIDATION_AMOUNT_GREATER_THAN_DEBT(
        ID repayAsset,
        uint256 repayAmount,
        uint256 availableAmount
    );
    error LIQUIDATION_SEIZED_LESS_THAN_EXPECTED(ID, uint256, uint256);
    error ZERO_VALUE_LIQUIDATION(ID repayAsset, ID seizeAsset);
    error NO_DEPOSITS(address who, ID);
    error NOT_ENOUGH_DEPOSITS(
        address who,
        ID,
        uint256 requested,
        uint256 deposits
    );
    error NOT_MINTED(address account, ID, address[] accountCollaterals);
    error NOT_DEPOSITED(address account, ID, address[] accountCollaterals);
    error ARRAY_INDEX_OUT_OF_BOUNDS(
        ID element,
        uint256 index,
        address[] elements
    );
    error ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(
        ID element,
        uint256 index,
        address[] elements
    );
    error NO_FEES_TO_CLAIM(ID asset, address claimer);
    error REPAY_OVERFLOW(
        ID repayAsset,
        ID seizeAsset,
        uint256 invalid,
        uint256 valid
    );
    error INCOME_AMOUNT_IS_ZERO(ID incomeAsset);
    error NO_LIQUIDITY_TO_GIVE_INCOME_FOR(
        ID incomeAsset,
        uint256 userDeposits,
        uint256 totalDeposits
    );
    error NOT_ENOUGH_SWAP_DEPOSITS_TO_SEIZE(
        ID repayAsset,
        ID seizeAsset,
        uint256 invalid,
        uint256 valid
    );
    error SWAP_ROUTE_NOT_ENABLED(ID assetIn, ID assetOut);
    error RECEIVED_LESS_THAN_DESIRED(ID, uint256 invalid, uint256 valid);
    error SWAP_ZERO_AMOUNT_IN(ID tokenIn);
    error INVALID_WITHDRAW(
        ID withdrawAsset,
        uint256 sharesIn,
        uint256 assetsOut
    );
    error ROUNDING_ERROR(ID asset, uint256 sharesIn, uint256 assetsOut);
    error MAX_DEPOSIT_EXCEEDED(ID asset, uint256 assetsIn, uint256 maxDeposit);
    error COLLATERAL_AMOUNT_LOW(
        ID kopioCollateral,
        uint256 amount,
        uint256 minAmount
    );
    error MINT_VALUE_LESS_THAN_MIN_DEBT_VALUE(
        ID,
        uint256 value,
        uint256 minRequiredValue
    );
    error NOT_A_CONTRACT(address who);
    error NO_ALLOWANCE(
        address spender,
        address owner,
        uint256 requested,
        uint256 allowed
    );
    error NOT_ENOUGH_BALANCE(address who, uint256 requested, uint256 available);
    error SENDER_NOT_OPERATOR(ID, address sender, address operator);
    error ZERO_SHARES_FROM_ASSETS(ID, uint256 assets, ID);
    error ZERO_SHARES_OUT(ID, uint256 assets);
    error ZERO_SHARES_IN(ID, uint256 assets);
    error ZERO_ASSETS_FROM_SHARES(ID, uint256 shares, ID);
    error ZERO_ASSETS_OUT(ID, uint256 shares);
    error ZERO_ASSETS_IN(ID, uint256 shares);
    error ZERO_ADDRESS();
    error ZERO_DEPOSIT(ID);
    error ZERO_AMOUNT(ID);
    error ZERO_WITHDRAW(ID);
    error ZERO_MINT(ID);
    error SDI_DEBT_REPAY_OVERFLOW(uint256 debt, uint256 repay);
    error ZERO_REPAY(ID, uint256 repayAmount, uint256 seizeAmount);
    error ZERO_BURN(ID);
    error ZERO_DEBT(ID);
    error UPDATE_FEE_OVERFLOW(uint256 sent, uint256 required);
    error BatchResult(uint256 timestamp, bytes[] results);
    /**
     * @notice Cannot directly rethrow or redeclare panic errors in try/catch - so using a similar error instead.
     * @param code The panic code received.
     */
    error Panicked(uint256 code);
}

// src/contracts/core/scdp/Event.sol

interface SEvent {
    event SCDPDeposit(
        address indexed depositor,
        address indexed collateral,
        uint256 amount,
        uint256 feeIndex,
        uint256 timestamp
    );
    event SCDPWithdraw(
        address indexed account,
        address indexed receiver,
        address indexed collateral,
        address withdrawer,
        uint256 amount,
        uint256 feeIndex,
        uint256 timestamp
    );
    event SCDPFeeReceipt(
        address indexed account,
        address indexed collateral,
        uint256 accDeposits,
        uint256 assetFeeIndex,
        uint256 accFeeIndex,
        uint256 assetLiqIndex,
        uint256 accLiqIndex,
        uint256 blockNumber,
        uint256 timestamp
    );
    event SCDPFeeClaim(
        address indexed claimer,
        address indexed receiver,
        address indexed collateral,
        uint256 feeAmount,
        uint256 newIndex,
        uint256 prevIndex,
        uint256 timestamp
    );
    event SCDPRepay(
        address indexed repayer,
        address indexed repayKopio,
        uint256 repayAmount,
        address indexed receiveKopio,
        uint256 receiveAmount,
        uint256 timestamp
    );

    event SCDPLiquidationOccured(
        address indexed liquidator,
        address indexed repayKopio,
        uint256 repayAmount,
        address indexed seizeCollateral,
        uint256 seizeAmount,
        uint256 prevLiqIndex,
        uint256 newLiqIndex,
        uint256 timestamp
    );
    event SCDPCoverOccured(
        address indexed coverer,
        address indexed asset,
        uint256 amount,
        address indexed seizeCollateral,
        uint256 seizeAmount,
        uint256 prevLiqIndex,
        uint256 newLiqIndex,
        uint256 timestamp
    );

    // Emitted when a swap pair is disabled / enabled.
    event PairSet(
        address indexed assetIn,
        address indexed assetOut,
        bool enabled
    );
    // Emitted when a asset fee is updated.
    event FeeSet(
        address indexed asset,
        uint256 openFee,
        uint256 closeFee,
        uint256 protocolFee
    );

    // Emitted on global configuration updates.
    event CollateralGlobalUpdate(
        address indexed collateral,
        uint256 newThreshold
    );

    // Emitted on global configuration updates.
    event KopioGlobalUpdate(
        address indexed kopio,
        uint256 feeIn,
        uint256 feeOut,
        uint256 protocolFee,
        uint256 debtLimit
    );

    event Swap(
        address indexed who,
        address indexed assetIn,
        address indexed assetOut,
        uint256 amountIn,
        uint256 amountOut,
        uint256 timestamp
    );

    event SwapFee(
        address indexed feeAsset,
        address indexed assetIn,
        uint256 feeAmount,
        uint256 protocolFeeAmount,
        uint256 timestamp
    );

    event Income(address asset, uint256 amount);

    /**
     * @notice Emitted when liquidation incentive multiplier is updated for a kopio.
     * @param symbol token symbol
     * @param asset address of the kopio
     * @param from previous multiplier
     * @param to the new multiplier
     */
    event GlobalLiqIncentiveUpdated(
        string indexed symbol,
        address indexed asset,
        uint256 from,
        uint256 to
    );

    /**
     * @notice Emitted when the MCR of SCDP is updated.
     * @param from previous ratio
     * @param to new ratio
     */
    event GlobalMCRUpdated(uint256 from, uint256 to);

    /**
     * @notice Emitted when the liquidation threshold is updated
     * @param from previous threshold
     * @param to new threshold
     * @param mlr new max liquidation ratio
     */
    event GlobalLTUpdated(uint256 from, uint256 to, uint256 mlr);

    /**
     * @notice Emitted when the max liquidation ratio is updated
     * @param from previous ratio
     * @param to new ratio
     */
    event GlobalMLRUpdated(uint256 from, uint256 to);
}

// src/contracts/core/scdp/Types.sol

/**
 * @notice SCDP initializer configuration.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param coverThreshold Threshold after which cover can be performed.
 * @param coverIncentive Incentive for covering debt instead of performing a liquidation.
 */
struct SCDPInitializer {
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint48 coverThreshold;
    uint48 coverIncentive;
}

/**
 * @notice SCDP initializer configuration.
 * @param feeAsset Asset that all fees from swaps are collected in.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param maxLiquidationRatio The maximum CR resulting from liquidations.
 * @param coverThreshold Threshold after which cover can be performed.
 * @param coverIncentive Incentive for covering debt instead of performing a liquidation.
 */
struct SCDPParameters {
    address feeAsset;
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint32 maxLiquidationRatio;
    uint128 coverThreshold;
    uint128 coverIncentive;
}

// Used for setting swap pairs enabled or disabled in the pool.
struct SwapRouteSetter {
    address assetIn;
    address assetOut;
    bool enabled;
}

struct SCDPAssetData {
    uint256 debt;
    uint128 totalDeposits;
    uint128 swapDeposits;
}

/**
 * @notice Indices for SCDP fees and liquidations.
 * @param currFeeIndex ever increasing fee index used for fee calculation.
 * @param currLiqIndex ever increasing liquidation index to calculate liquidated amounts from principal.
 */
struct SCDPAssetIndexes {
    uint128 currFeeIndex;
    uint128 currLiqIndex;
}

/**
 * @notice SCDP seize data
 * @param prevLiqIndex previous liquidation index.
 * @param feeIndex fee index at the time of the seize.
 * @param liqIndex liquidation index after the seize.
 */
struct SCDPSeizeData {
    uint256 prevLiqIndex;
    uint128 feeIndex;
    uint128 liqIndex;
}

/**
 * @notice SCDP account indexes
 * @param lastFeeIndex fee index at the time of the action.
 * @param lastLiqIndex liquidation index at the time of the action.
 * @param timestamp time of last update.
 */
struct SCDPAccountIndexes {
    uint128 lastFeeIndex;
    uint128 lastLiqIndex;
    uint256 timestamp;
}

// src/contracts/core/vault/Events.sol

interface VEvent {
    /* -------------------------------------------------------------------------- */
    /*                                   Events                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Emitted when a deposit/mint is made
     * @param caller Caller of the deposit/mint
     * @param receiver Receiver of the minted assets
     * @param asset Asset that was deposited/minted
     * @param assetsIn Amount of assets deposited
     * @param sharesOut Amount of shares minted
     */
    event Deposit(
        address indexed caller,
        address indexed receiver,
        address indexed asset,
        uint256 assetsIn,
        uint256 sharesOut
    );

    /**
     * @notice Emitted when a new oracle is set for an asset
     * @param asset Asset that was updated
     * @param feed Feed that was set
     * @param staletime Time in seconds for the feed to be considered stale
     * @param price Price at the time of setting the feed
     * @param timestamp Timestamp of the update
     */
    event OracleSet(
        address indexed asset,
        address indexed feed,
        uint256 staletime,
        uint256 price,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a new asset is added to the shares contract
     * @param asset Address of the asset
     * @param feed Price feed of the asset
     * @param symbol Asset symbol
     * @param staletime Time in seconds for the feed to be considered stale
     * @param price Price of the asset
     * @param depositLimit Deposit limit of the asset
     * @param timestamp Timestamp of the addition
     */
    event AssetAdded(
        address indexed asset,
        address indexed feed,
        string indexed symbol,
        uint256 staletime,
        uint256 price,
        uint256 depositLimit,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a previously existing asset is removed from the shares contract
     * @param asset Asset that was removed
     * @param timestamp Timestamp of the removal
     */
    event AssetRemoved(address indexed asset, uint256 timestamp);
    /**
     * @notice Emitted when the enabled status for asset is changed
     * @param asset Asset that was removed
     * @param enabled Enabled status set
     * @param timestamp Timestamp of the removal
     */
    event AssetEnabledChange(
        address indexed asset,
        bool enabled,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a withdraw/redeem is made
     * @param caller Caller of the withdraw/redeem
     * @param receiver Receiver of the withdrawn assets
     * @param asset Asset that was withdrawn/redeemed
     * @param owner Owner of the withdrawn assets
     * @param assetsOut Amount of assets withdrawn
     * @param sharesIn Amount of shares redeemed
     */
    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed asset,
        address owner,
        uint256 assetsOut,
        uint256 sharesIn
    );
}

// src/contracts/diamond/Types.sol

struct Facet {
    address facetAddress;
    bytes4[] functionSelectors;
}

struct FacetAddressAndPosition {
    address facetAddress;
    // position in facetFunctionSelectors.functionSelectors array
    uint96 functionSelectorPosition;
}

struct FacetFunctionSelectors {
    bytes4[] functionSelectors;
    // position of facetAddress in facetAddresses array
    uint256 facetAddressPosition;
}

/// @dev  Add=0, Replace=1, Remove=2
enum FacetCutAction {
    Add,
    Replace,
    Remove
}

struct FacetCut {
    address facetAddress;
    FacetCutAction action;
    bytes4[] functionSelectors;
}

struct Initializer {
    address initContract;
    bytes initData;
}

interface DTypes {
    event DiamondCut(FacetCut[] diamondCut, address initializer, bytes data);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event PendingOwnershipTransfer(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @notice Emitted when `execute` is called with some initializer.
     * @dev Overlaps DiamondCut but thats fine as its used by some indexers.
     * @param version Resulting new diamond storage version.
     * @param sender Caller of this execution.
     * @param initializer Contract containing the execution logic.
     * @param data Bytes passed to the initializer contract.
     * @param diamondOwner Diamond owner at the time of execution.
     * @param facetCount Facet count at the time of execution.
     * @param block Block number of the call.
     * @param timestamp Timestamp of the call.
     */
    event InitializerExecuted(
        uint256 indexed version,
        address sender,
        address diamondOwner,
        address initializer,
        bytes data,
        uint256 facetCount,
        uint256 block,
        uint256 timestamp
    );

    error DIAMOND_FUNCTION_DOES_NOT_EXIST(bytes4 selector);
    error DIAMOND_INIT_DATA_PROVIDED_BUT_INIT_ADDRESS_WAS_ZERO(bytes data);
    error DIAMOND_INIT_ADDRESS_PROVIDED_BUT_INIT_DATA_WAS_EMPTY(
        address initializer
    );
    error DIAMOND_FUNCTION_ALREADY_EXISTS(
        address newFacet,
        address oldFacet,
        bytes4 func
    );
    error DIAMOND_INIT_FAILED(address initializer, bytes data);
    error DIAMOND_NOT_INITIALIZING();
    error DIAMOND_ALREADY_INITIALIZED(
        uint256 initializerVersion,
        uint256 currentVersion
    );
    error DIAMOND_CUT_ACTION_WAS_NOT_ADD_REPLACE_REMOVE();
    error DIAMOND_FACET_ADDRESS_CANNOT_BE_ZERO_WHEN_ADDING_FUNCTIONS(
        bytes4[] selectors
    );
    error DIAMOND_FACET_ADDRESS_CANNOT_BE_ZERO_WHEN_REPLACING_FUNCTIONS(
        bytes4[] selectors
    );
    error DIAMOND_FACET_ADDRESS_MUST_BE_ZERO_WHEN_REMOVING_FUNCTIONS(
        address facet,
        bytes4[] selectors
    );
    error DIAMOND_NO_FACET_SELECTORS(address facet);
    error DIAMOND_FACET_ADDRESS_CANNOT_BE_ZERO_WHEN_REMOVING_ONE_FUNCTION(
        bytes4 selector
    );
    error DIAMOND_REPLACE_FUNCTION_NEW_FACET_IS_SAME_AS_OLD(
        address facet,
        bytes4 selector
    );
    error NEW_OWNER_CANNOT_BE_ZERO_ADDRESS();
    error NOT_DIAMOND_OWNER(address who, address owner);
    error NOT_PENDING_DIAMOND_OWNER(address who, address pendingOwner);
}

// src/contracts/interfaces/IKopioIssuer.sol

/// @title An issuer for kopio
/// @author the kopio project
/// @notice contract that creates/destroys kopios.
/// @dev protocol enforces this implementation on kopios.
interface IKopioIssuer {
    /**
     * @notice Mints @param assets of kopio for @param to,
     * @notice Mints relative amount of fixed @return shares.
     */
    function issue(
        uint256 assets,
        address to
    ) external returns (uint256 shares);

    /**
     * @notice Burns @param assets of kopio from @param from,
     * @notice Burns relative amount of fixed @return shares.
     */
    function destroy(
        uint256 assets,
        address from
    ) external returns (uint256 shares);

    /**
     * @notice Preview conversion from kopio amount: @param assets to matching fixed amount: @return shares
     */
    function convertToShares(
        uint256 assets
    ) external view returns (uint256 shares);

    /**
     * @notice Preview conversion from fixed amount: @param shares to matching kopio amount: @return assets
     */
    function convertToAssets(
        uint256 shares
    ) external view returns (uint256 assets);

    /**
     * @notice Preview conversion from fixed amounts: @param shares to matching amounts of kopios: @return assets
     */
    function convertManyToAssets(
        uint256[] calldata shares
    ) external view returns (uint256[] memory assets);

    /**
     * @notice Preview conversion from kopio amounts: @param assets to matching fixed amount: @return shares
     */
    function convertManyToShares(
        uint256[] calldata assets
    ) external view returns (uint256[] memory shares);
}

// src/contracts/interfaces/IMarketStatus.sol

interface IMarketStatus {
    function allowed(address) external view returns (bool);

    function exchanges(bytes32) external view returns (bytes32);

    function status(bytes32) external view returns (uint256);

    function setStatus(bytes32[] calldata, bool[] calldata) external;

    function setTickers(bytes32[] calldata, bytes32[] calldata) external;

    function setAllowed(address, bool) external;

    function getExchangeStatus(bytes32) external view returns (bool);

    function getExchangeStatuses(
        bytes32[] calldata
    ) external view returns (bool[] memory);

    function getExchange(bytes32) external view returns (bytes32);

    function getTickerStatus(bytes32) external view returns (bool);

    function getTickerExchange(bytes32) external view returns (bytes32);

    function getTickerStatuses(
        bytes32[] calldata
    ) external view returns (bool[] memory);

    function owner() external view returns (address);
}

// src/contracts/interfaces/IVaultExtender.sol

interface IVaultExtender {
    event Deposit(address indexed _from, address indexed _to, uint256 _amount);
    event Withdraw(address indexed _from, address indexed _to, uint256 _amount);

    /**
     * @notice Deposit tokens to vault for shares and convert them to equal amount of extender token.
     * @param _assetAddr Supported vault asset address
     * @param _assets amount of `_assetAddr` to deposit
     * @param _receiver Address receive extender tokens
     * @return sharesOut amount of shares/extender tokens minted
     * @return assetFee amount of `_assetAddr` vault took as fee
     */
    function vaultDeposit(
        address _assetAddr,
        uint256 _assets,
        address _receiver
    ) external returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice Deposit supported vault assets to receive `_shares`, depositing the shares for equal amount of extender token.
     * @param _assetAddr Supported vault asset address
     * @param _receiver Address receive extender tokens
     * @param _shares Amount of shares to receive
     * @return assetsIn Amount of assets for `_shares`
     * @return assetFee Amount of `_assetAddr` vault took as fee
     */

    /**
     * @notice Vault mint, an external state-modifying function.
     * @param _assetAddr The asset addr address.
     * @param _shares The shares (uint256).
     * @param _receiver The receiver address.
     * @return assetsIn An uint256 value.
     * @return assetFee An uint256 value.
     * @custom:signature vaultMint(address,uint256,address)
     * @custom:selector 0x0c8daea9
     */
    function vaultMint(
        address _assetAddr,
        uint256 _shares,
        address _receiver
    ) external returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice Withdraw supported vault asset, burning extender tokens and withdrawing shares from vault.
     * @param _assetAddr Supported vault asset address
     * @param _assets amount of `_assetAddr` to deposit
     * @param _receiver Address receive extender tokens
     * @param _owner Owner of extender tokens
     * @return sharesIn amount of shares/extender tokens burned
     * @return assetFee amount of `_assetAddr` vault took as fee
     */
    function vaultWithdraw(
        address _assetAddr,
        uint256 _assets,
        address _receiver,
        address _owner
    ) external returns (uint256 sharesIn, uint256 assetFee);

    /**
     * @notice  Withdraw supported vault asset for  `_shares` of extender tokens.
     * @param _assetAddr Token to deposit into vault for shares.
     * @param _shares amount of extender tokens to burn
     * @param _receiver Address to receive assets withdrawn
     * @param _owner Owner of extender tokens
     * @return assetsOut amount of assets out
     * @return assetFee amount of `_assetAddr` vault took as fee
     */
    function vaultRedeem(
        address _assetAddr,
        uint256 _shares,
        address _receiver,
        address _owner
    ) external returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice Max redeem for underlying extender token.
     * @param assetAddr The withdraw asset address.
     * @param owner The extender token owner.
     * @return max Maximum amount withdrawable.
     * @return fee Fee paid if max is withdrawn.
     * @custom:signature maxRedeem(address,address)
     * @custom:selector 0x95b734fb
     */
    function maxRedeem(
        address assetAddr,
        address owner
    ) external view returns (uint256 max, uint256 fee);

    /**
     * @notice Deposit shares for equal amount of extender token.
     * @param _shares amount of vault shares to deposit
     * @param _receiver address to mint extender tokens to
     * @dev Does not return a value
     */
    function deposit(uint256 _shares, address _receiver) external;

    /**
     * @notice Withdraw shares for equal amount of extender token.
     * @param _amount amount of vault extender tokens to burn
     * @param _receiver address to send shares to
     * @dev Does not return a value
     */
    function withdraw(uint256 _amount, address _receiver) external;

    /**
     * @notice Withdraw shares for equal amount of extender token with allowance.
     * @param _from address to burn extender tokens from
     * @param _to address to send shares to
     * @param _amount amount to convert
     * @dev Does not return a value
     */
    function withdrawFrom(address _from, address _to, uint256 _amount) external;
}

// src/contracts/interfaces/IVaultRateProvider.sol

/**
 * @title IVaultRateProvider
 * @author the kopio project
 * @notice Minimal exchange rate interface for vaults.
 */
interface IVaultRateProvider {
    /**
     * @notice Gets the exchange rate of one vault share to USD.
     * @return uint256 The current exchange rate of the vault share in 18 decimals precision.
     */
    function exchangeRate() external view returns (uint256);
}

// src/contracts/vendor/FixedPointMath.sol

/// @notice Arithmetic library with operations for fixed-point numbers.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
/// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
library FixedPointMath {
    /*//////////////////////////////////////////////////////////////
                    SIMPLIFIED FIXED POINT OPERATIONS
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

    uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.

    function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
    }

    function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
    }

    function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
    }

    function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
    }

    /*//////////////////////////////////////////////////////////////
                    LOW LEVEL FIXED POINT OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function mulDivDown(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
            if iszero(
                mul(denominator, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))
            ) {
                revert(0, 0)
            }

            // Divide x * y by the denominator.
            z := div(mul(x, y), denominator)
        }
    }

    function mulDivUp(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
            if iszero(
                mul(denominator, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))
            ) {
                revert(0, 0)
            }

            // If x * y modulo the denominator is strictly greater than 0,
            // 1 is added to round up the division of x * y by the denominator.
            z := add(
                gt(mod(mul(x, y), denominator), 0),
                div(mul(x, y), denominator)
            )
        }
    }

    function rpow(
        uint256 x,
        uint256 n,
        uint256 scalar
    ) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            switch x
            case 0 {
                switch n
                case 0 {
                    // 0 ** 0 = 1
                    z := scalar
                }
                default {
                    // 0 ** n = 0
                    z := 0
                }
            }
            default {
                switch mod(n, 2)
                case 0 {
                    // If n is even, store scalar in z for now.
                    z := scalar
                }
                default {
                    // If n is odd, store x in z for now.
                    z := x
                }

                // Shifting right by 1 is like dividing by 2.
                let half := shr(1, scalar)

                for {
                    // Shift n right by 1 before looping to halve it.
                    n := shr(1, n)
                } n {
                    // Shift n right by 1 each iteration to halve it.
                    n := shr(1, n)
                } {
                    // Revert immediately if x ** 2 would overflow.
                    // Equivalent to iszero(eq(div(xx, x), x)) here.
                    if shr(128, x) {
                        revert(0, 0)
                    }

                    // Store x squared.
                    let xx := mul(x, x)

                    // Round to the nearest number.
                    let xxRound := add(xx, half)

                    // Revert if xx + half overflowed.
                    if lt(xxRound, xx) {
                        revert(0, 0)
                    }

                    // Set x to scaled xxRound.
                    x := div(xxRound, scalar)

                    // If n is even:
                    if mod(n, 2) {
                        // Compute z * x.
                        let zx := mul(z, x)

                        // If z * x overflowed:
                        if iszero(eq(div(zx, x), z)) {
                            // Revert if x is non-zero.
                            if iszero(iszero(x)) {
                                revert(0, 0)
                            }
                        }

                        // Round to the nearest number.
                        let zxRound := add(zx, half)

                        // Revert if zx + half overflowed.
                        if lt(zxRound, zx) {
                            revert(0, 0)
                        }

                        // Return properly scaled zxRound.
                        z := div(zxRound, scalar)
                    }
                }
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                        GENERAL NUMBER UTILITIES
    //////////////////////////////////////////////////////////////*/

    function sqrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            let y := x // We start y at x, which will help us make our initial estimate.

            z := 181 // The "correct" value is 1, but this saves a multiplication later.

            // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
            // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.

            // We check y >= 2^(k + 8) but shift right by k bits
            // each branch to ensure that if x >= 256, then y >= 256.
            if iszero(lt(y, 0x10000000000000000000000000000000000)) {
                y := shr(128, y)
                z := shl(64, z)
            }
            if iszero(lt(y, 0x1000000000000000000)) {
                y := shr(64, y)
                z := shl(32, z)
            }
            if iszero(lt(y, 0x10000000000)) {
                y := shr(32, y)
                z := shl(16, z)
            }
            if iszero(lt(y, 0x1000000)) {
                y := shr(16, y)
                z := shl(8, z)
            }

            // Goal was to get z*z*y within a small factor of x. More iterations could
            // get y in a tighter range. Currently, we will have y in [256, 256*2^16).
            // We ensured y >= 256 so that the relative difference between y and y+1 is small.
            // That's not possible if x < 256 but we can just verify those cases exhaustively.

            // Now, z*z*y <= x < z*z*(y+1), and y <= 2^(16+8), and either y >= 256, or x < 256.
            // Correctness can be checked exhaustively for x < 256, so we assume y >= 256.
            // Then z*sqrt(y) is within sqrt(257)/sqrt(256) of sqrt(x), or about 20bps.

            // For s in the range [1/256, 256], the estimate f(s) = (181/1024) * (s+1) is in the range
            // (1/2.84 * sqrt(s), 2.84 * sqrt(s)), with largest error when s = 1 and when s = 256 or 1/256.

            // Since y is in [256, 256*2^16), let a = y/65536, so that a is in [1/256, 256). Then we can estimate
            // sqrt(y) using sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2^18.

            // There is no overflow risk here since y < 2^136 after the first branch above.
            z := shr(18, mul(z, add(y, 65536))) // A mul() is saved from starting z at 181.

            // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            // If x+1 is a perfect square, the Babylonian method cycles between
            // floor(sqrt(x)) and ceil(sqrt(x)). This statement ensures we return floor.
            // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
            // Since the ceil is rare, we save gas on the assignment and repeat division in the rare case.
            // If you don't care whether the floor or ceil square root is returned, you can remove this statement.
            z := sub(z, lt(div(x, z), z))
        }
    }

    function unsafeMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Mod x by y. Note this will return
            // 0 instead of reverting if y is zero.
            z := mod(x, y)
        }
    }

    function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            // Divide x by y. Note this will return
            // 0 instead of reverting if y is zero.
            r := div(x, y)
        }
    }

    function unsafeDivUp(
        uint256 x,
        uint256 y
    ) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Add 1 to x * y if x % y > 0. Note this will
            // return 0 instead of reverting if y is zero.
            z := add(gt(mod(x, y), 0), div(x, y))
        }
    }
}

// src/contracts/vendor/IERC165.sol

interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceId The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// src/contracts/vendor/PercentageMath.sol

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to perform percentage calculations
 * @dev PercentageMath are defined by default with 2 decimals of precision (100.00).
 * The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
 **/
library PercentageMath {
    // Maximum percentage factor (100.00%)
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;

    // Half percentage factor (50.00%)
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;

    /**
     * @notice Executes a percentage multiplication
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param value The value of which the percentage needs to be calculated
     * @param percentage The percentage of the value to be calculated
     * @return result value percentmul percentage
     **/
    function percentMul(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
        assembly {
            if iszero(
                or(
                    iszero(percentage),
                    iszero(
                        gt(
                            value,
                            div(sub(not(0), HALF_PERCENTAGE_FACTOR), percentage)
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, percentage), HALF_PERCENTAGE_FACTOR),
                PERCENTAGE_FACTOR
            )
        }
    }

    /**
     * @notice Executes a percentage division
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param value The value of which the percentage needs to be calculated
     * @param percentage The percentage of the value to be calculated
     * @return result value percentdiv percentage
     **/
    function percentDiv(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
        assembly {
            if or(
                iszero(percentage),
                iszero(
                    iszero(
                        gt(
                            value,
                            div(
                                sub(not(0), div(percentage, 2)),
                                PERCENTAGE_FACTOR
                            )
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, PERCENTAGE_FACTOR), div(percentage, 2)),
                percentage
            )
        }
    }
}

// src/contracts/vendor/WadRay.sol

/**
 * @title WadRayMath library
 * @author Aave
 * @notice Provides functions to perform calculations with Wad and Ray units
 * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
 * with 27 digits of precision)
 * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
 **/
library WadRay {
    // HALF_WAD and HALF_RAY expressed with extended notation
    // as constant with operations are not supported in Yul assembly
    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;

    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;

    uint256 internal constant WAD_RAY_RATIO = 1e9;

    uint128 internal constant RAY128 = 1e27;

    /**
     * @dev Multiplies two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a*b, in wad
     **/
    function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_WAD), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_WAD), WAD)
        }
    }

    /**
     * @dev Divides two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a/b, in wad
     **/
    function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), WAD))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, WAD), div(b, 2)), b)
        }
    }

    /**
     * @notice Multiplies two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raymul b
     **/
    function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_RAY), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_RAY), RAY)
        }
    }

    /**
     * @notice Divides two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raydiv b
     **/
    function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), RAY))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, RAY), div(b, 2)), b)
        }
    }

    /**
     * @dev Casts ray down to wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @return b = a converted to wad, rounded half up to the nearest wad
     **/
    function rayToWad(uint256 a) internal pure returns (uint256 b) {
        assembly {
            b := div(a, WAD_RAY_RATIO)
            let remainder := mod(a, WAD_RAY_RATIO)
            if iszero(lt(remainder, div(WAD_RAY_RATIO, 2))) {
                b := add(b, 1)
            }
        }
    }

    /**
     * @dev Converts wad up to ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @return b = a converted in ray
     **/
    function wadToRay(uint256 a) internal pure returns (uint256 b) {
        // to avoid overflow, b/WAD_RAY_RATIO == a
        assembly {
            b := mul(a, WAD_RAY_RATIO)

            if iszero(eq(div(b, WAD_RAY_RATIO), a)) {
                revert(0, 0)
            }
        }
    }
}

// lib/kopio-lib/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/access/extensions/IAccessControlEnumerable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/extensions/IAccessControlEnumerable.sol)

/**
 * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
 */
interface IAccessControlEnumerable is IAccessControl {
    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
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
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
}

// lib/kopio-lib/src/token/IERC20Permit.sol

/* solhint-disable func-name-mixedcase */

interface IERC20Permit is IERC20 {
    error PERMIT_DEADLINE_EXPIRED(address, address, uint256, uint256);
    error INVALID_SIGNER(address, address);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function nonces(address) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

// src/contracts/core/icdp/Event.sol

interface MEvent {
    /**
     * @notice Emitted when a collateral is added.
     * @dev only emitted once per asset.
     * @param ticker underlying ticker.
     * @param symbol token symbol
     * @param collateral address of the asset
     * @param factor the collateral factor
     * @param share possible fixed share address
     * @param liqIncentive the liquidation incentive
     */
    event CollateralAdded(
        string indexed ticker,
        string indexed symbol,
        address indexed collateral,
        uint256 factor,
        address share,
        uint256 liqIncentive
    );

    /**
     * @notice Emitted when collateral is updated.
     * @param ticker underlying ticker.
     * @param symbol token symbol
     * @param collateral address of the collateral.
     * @param factor the collateral factor.
     * @param share possible fixed share address
     * @param liqIncentive the liquidation incentive
     */
    event CollateralUpdated(
        string indexed ticker,
        string indexed symbol,
        address indexed collateral,
        uint256 factor,
        address share,
        uint256 liqIncentive
    );

    /**
     * @notice Emitted when an account deposits collateral.
     * @param account The address of the account depositing collateral.
     * @param collateral The address of the collateral asset.
     * @param amount The amount of the collateral asset that was deposited.
     */
    event CollateralDeposited(
        address indexed account,
        address indexed collateral,
        uint256 amount
    );

    /**
     * @notice Emitted on collateral withdraws.
     * @param account account withdrawing collateral.
     * @param collateral the withdrawn collateral.
     * @param amount the amount withdrawn.
     */
    event CollateralWithdrawn(
        address indexed account,
        address indexed collateral,
        uint256 amount
    );
    event CollateralFlashWithdrawn(
        address indexed account,
        address indexed collateral,
        uint256 amount
    );

    /* -------------------------------------------------------------------------- */
    /*                                   Kopios                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Emitted when a new kopio is added.
     * @dev emitted once per asset.
     * @param ticker underlying ticker.
     * @param symbol token symbol
     * @param kopio address of the asset.
     * @param share fixed share address
     * @param dFactor debt factor.
     * @param icdpLimit icdp supply cap.
     * @param closeFee close fee percentage.
     * @param openFee open fee percentage.
     */
    event KopioAdded(
        string indexed ticker,
        string indexed symbol,
        address indexed kopio,
        address share,
        uint256 dFactor,
        uint256 icdpLimit,
        uint256 closeFee,
        uint256 openFee
    );

    /**
     * @notice Emitted when a kopio is updated.
     * @param ticker underlying ticker.
     * @param symbol token symbol
     * @param kopio address of the asset.
     * @param share fixed share address
     * @param dFactor debt factor.
     * @param icdpLimit icdp supply cap.
     * @param closeFee The close fee percentage.
     * @param openFee The open fee percentage.
     */
    event KopioUpdated(
        string indexed ticker,
        string indexed symbol,
        address indexed kopio,
        address share,
        uint256 dFactor,
        uint256 icdpLimit,
        uint256 closeFee,
        uint256 openFee
    );

    /**
     * @notice Emitted when a kopio is minted.
     * @param account account minting the kopio.
     * @param kopio address of the kopio
     * @param amount amount minted.
     * @param receiver receiver of the minted kopio.
     */
    event KopioMinted(
        address indexed account,
        address indexed kopio,
        uint256 amount,
        address receiver
    );

    /**
     * @notice Emitted when asset is burned.
     * @param account account burning the assets
     * @param kopio address of the kopio
     * @param amount amount burned
     */
    event KopioBurned(
        address indexed account,
        address indexed kopio,
        uint256 amount
    );

    /**
     * @notice Emitted when collateral factor is updated.
     * @param symbol token symbol
     * @param collateral address of the collateral.
     * @param from previous factor.
     * @param to new factor.
     */
    event CFactorUpdated(
        string indexed symbol,
        address indexed collateral,
        uint256 from,
        uint256 to
    );
    /**
     * @notice Emitted when dFactor is updated.
     * @param symbol token symbol
     * @param kopio address of the asset.
     * @param from previous debt factor
     * @param to new debt factor
     */
    event DFactorUpdated(
        string indexed symbol,
        address indexed kopio,
        uint256 from,
        uint256 to
    );

    /**
     * @notice Emitted when account closes a full debt position.
     * @param account address of the account
     * @param kopio asset address
     * @param amount amount burned to close the position.
     */
    event DebtPositionClosed(
        address indexed account,
        address indexed kopio,
        uint256 amount
    );

    /**
     * @notice Emitted when an account pays the open/close fee.
     * @dev can be emitted multiple times for a single asset.
     * @param account address that paid the fee.
     * @param collateral collateral used to pay the fee.
     * @param feeType type of the fee.
     * @param amount amount paid
     * @param value value paid
     * @param valueRemaining remaining fee value after.
     */
    event FeePaid(
        address indexed account,
        address indexed collateral,
        uint256 indexed feeType,
        uint256 amount,
        uint256 value,
        uint256 valueRemaining
    );

    /**
     * @notice Emitted when a liquidation occurs.
     * @param account account liquidated.
     * @param liquidator account that liquidated it.
     * @param kopio asset repaid.
     * @param amount amount repaid.
     * @param seizedCollateral collateral the liquidator seized.
     * @param seizedAmount amount of collateral seized
     */
    event LiquidationOccurred(
        address indexed account,
        address indexed liquidator,
        address indexed kopio,
        uint256 amount,
        address seizedCollateral,
        uint256 seizedAmount
    );

    /* -------------------------------------------------------------------------- */
    /*                                Parameters                                  */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Emitted when a safety state is triggered for an asset
     * @param action target action
     * @param symbol token symbol
     * @param asset address of the target asset
     * @param description description for this event
     */
    event SafetyStateChange(
        Enums.Action indexed action,
        string indexed symbol,
        address indexed asset,
        string description
    );

    /**
     * @notice Emitted when the fee recipient is updated.
     * @param from previous recipient
     * @param to new recipient
     */
    event FeeRecipientUpdated(address from, address to);

    /**
     * @notice Emitted the asset's liquidation incentive is updated.
     * @param symbol token symbol
     * @param collateral asset address
     * @param from previous incentive
     * @param to new incentive
     */
    event LiquidationIncentiveUpdated(
        string indexed symbol,
        address indexed collateral,
        uint256 from,
        uint256 to
    );

    /**
     * @notice Emitted when the MCR is updated.
     * @param from previous MCR.
     * @param to new MCR.
     */
    event MinCollateralRatioUpdated(uint256 from, uint256 to);

    /**
     * @notice Emitted when the minimum debt value is updated.
     * @param from previous value
     * @param to new value
     */
    event MinimumDebtValueUpdated(uint256 from, uint256 to);

    /**
     * @notice Emitted when the liquidation threshold is updated
     * @param from previous threshold
     * @param to new threshold
     * @param mlr new max liquidation ratio.
     */
    event LiquidationThresholdUpdated(uint256 from, uint256 to, uint256 mlr);
    /**
     * @notice Emitted when the max liquidation ratio is updated
     * @param from previous ratio
     * @param to new ratio
     */
    event MaxLiquidationRatioUpdated(uint256 from, uint256 to);
}

// src/contracts/core/libs/Meta.sol

/* solhint-disable no-inline-assembly */

library Meta {
    bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
        keccak256(
            bytes(
                "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
            )
        );

    function domainSeparator(
        string memory name,
        string memory version
    ) internal view returns (bytes32 domainSeparator_) {
        domainSeparator_ = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                getChainID(),
                address(this)
            )
        );
    }

    function getChainID() internal view returns (uint256 id_) {
        assembly {
            id_ := chainid()
        }
    }

    function msgSender() internal view returns (address sender_) {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender_ := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender_ = msg.sender;
        }
    }

    function enforceHasContractCode(address _contract) internal view {
        uint256 contractSize;
        /// @solidity memory-safe-assembly
        assembly {
            contractSize := extcodesize(_contract)
        }
        if (contractSize == 0) {
            revert err.ADDRESS_HAS_NO_CODE(_contract);
        }
    }
}

// src/contracts/diamond/State.sol

struct DiamondState {
    mapping(bytes4 selector => FacetAddressAndPosition) selectorToFacetAndPosition;
    mapping(address facet => FacetFunctionSelectors) facetFunctionSelectors;
    address[] facetAddresses;
    mapping(bytes4 => bool) supportedInterfaces;
    /// @notice address(this) replacement for FF
    address self;
    bool initialized;
    uint8 initializing;
    bytes32 diamondDomainSeparator;
    address contractOwner;
    address pendingOwner;
    uint96 storageVersion;
}

// keccak256(abi.encode(uint256(keccak256("kopio.slot.diamond")) - 1)) & ~bytes32(uint256(0xff));
bytes32 constant DIAMOND_SLOT = 0xc8ecce9aacc3428c4044cc49a9f54752635242cfef8d73e0144ec29b0ac16a00;

function ds() pure returns (DiamondState storage state) {
    bytes32 position = DIAMOND_SLOT;
    assembly {
        state.slot := position
    }
}

// src/contracts/vendor/Strings.sol

// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(bytes32 value) internal pure returns (string memory) {
        return string(abi.encodePacked(value));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        if (value != 0) revert err.STRING_HEX_LENGTH_INSUFFICIENT();
        return string(buffer);
    }
}

// lib/kopio-lib/src/token/ERC20Base.sol

/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
abstract contract ERC20Base is IERC20Permit {
    string public name;
    string public symbol;
    uint8 public immutable decimals = 18;

    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    /* -------------------------------------------------------------------------- */
    /*                                  EIP-2612                                  */
    /* -------------------------------------------------------------------------- */

    mapping(address => uint256) public nonces;

    /* -------------------------------------------------------------------------- */
    /*                                    READ                                    */
    /* -------------------------------------------------------------------------- */

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /* -------------------------------------------------------------------------- */
    /*                                 ERC20 Logic                                */
    /* -------------------------------------------------------------------------- */

    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool) {
        _allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        return _transfer(msg.sender, to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance(from, msg.sender); // Saves gas for limited approvals.

        if (allowed != type(uint256).max)
            _allowances[from][msg.sender] = allowed - amount;

        return _transfer(from, to, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual returns (bool) {
        _beforeTokenTransfer(from, to, amount);

        _balances[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /* -------------------------------------------------------------------------- */
    /*                               EIP-2612 Logic                               */
    /* -------------------------------------------------------------------------- */

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        if (block.timestamp > deadline)
            revert PERMIT_DEADLINE_EXPIRED(
                owner,
                spender,
                deadline,
                block.timestamp
            );

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            );
            if (recoveredAddress == address(0) || recoveredAddress != owner)
                revert INVALID_SIGNER(owner, recoveredAddress);

            _allowances[recoveredAddress][spender] = value;
        }

        emit Approval(owner, spender, value);
    }

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return computeDomainSeparator();
    }

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    ),
                    keccak256(bytes(name)),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            );
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Internals                                 */
    /* -------------------------------------------------------------------------- */

    function _mint(address to, uint256 amount) internal virtual {
        _beforeTokenTransfer(address(0), to, amount);

        _totalSupply += amount;
        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            _balances[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        _beforeTokenTransfer(from, address(0), amount);

        _balances[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            _totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        //
    }
}

// lib/kopio-lib/src/token/SafeTransfer.sol

// solhint-disable

error APPROVE_FAILED(address, address, address, uint256);
error ETH_TRANSFER_FAILED(address, uint256);
error TRANSFER_FAILED(address, address, address, uint256);
error PERMIT_DUP_NONCE(address, uint256, uint256);

/// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
/// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
/// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
library SafeTransfer {
    /*//////////////////////////////////////////////////////////////
                             ETH OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferETH(address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Transfer the ETH and store if it succeeded or not.
            success := call(gas(), to, amount, 0, 0, 0, 0)
        }

        if (!success) revert ETH_TRANSFER_FAILED(to, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            ERC20 OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0x23b872dd00000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(from, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "from" argument.
            mstore(
                add(freeMemoryPointer, 36),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
            )
        }

        if (!success) revert TRANSFER_FAILED(address(token), from, to, amount);
    }

    function safeTransfer(IERC20 token, address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0xa9059cbb00000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
            )
        }

        if (!success)
            revert TRANSFER_FAILED(address(token), msg.sender, to, amount);
    }

    function safeApprove(IERC20 token, address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0x095ea7b300000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
            )
        }

        if (!success)
            revert APPROVE_FAILED(address(token), msg.sender, to, amount);
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        if (nonceAfter != nonceBefore + 1)
            revert PERMIT_DUP_NONCE(owner, nonceBefore, nonceAfter);
    }
}

// src/contracts/core/libs/Arrays.sol

/**
 * @title Library for operations on arrays
 */
library Arrays {
    using Arrays for address[];
    using Arrays for bytes32[];
    using Arrays for string[];

    struct FindResult {
        uint256 index;
        bool exists;
    }

    function empty(address[2] memory list) internal pure returns (bool) {
        return list[0] == address(0) && list[1] == address(0);
    }

    function empty(
        Enums.OracleType[2] memory _oracles
    ) internal pure returns (bool) {
        return
            _oracles[0] == Enums.OracleType.Empty &&
            _oracles[1] == Enums.OracleType.Empty;
    }

    function findIndex(
        address[] memory items,
        address val
    ) internal pure returns (int256 idx) {
        for (uint256 i; i < items.length; ) {
            if (items[i] == val) {
                return int256(i);
            }
            unchecked {
                ++i;
            }
        }

        return -1;
    }

    function find(
        address[] storage items,
        address val
    ) internal pure returns (FindResult memory result) {
        address[] memory elements = items;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == val) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage items,
        bytes32 val
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory elements = items;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == val) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage items,
        string memory val
    ) internal pure returns (FindResult memory result) {
        string[] memory elements = items;
        for (uint256 i; i < elements.length; ) {
            if (
                keccak256(abi.encodePacked(elements[i])) ==
                keccak256(abi.encodePacked(val))
            ) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(address[] storage items, address val) internal {
        if (!items.find(val).exists) {
            items.push(val);
        }
    }

    function pushUnique(bytes32[] storage items, bytes32 val) internal {
        if (!items.find(val).exists) {
            items.push(val);
        }
    }

    function pushUnique(string[] storage items, string memory val) internal {
        if (!items.find(val).exists) {
            items.push(val);
        }
    }

    function removeExisting(address[] storage list, address val) internal {
        FindResult memory result = list.find(val);
        if (result.exists) {
            list.removeAddress(val, result.index);
        }
    }

    /**
     * @dev Removes an element by copying the last element to the element to remove's place and removing
     * the last element.
     * @param list The address array containing the item to be removed.
     * @param addr The element to be removed.
     * @param idx The index of the element to be removed.
     */
    function removeAddress(
        address[] storage list,
        address addr,
        uint256 idx
    ) internal {
        if (list[idx] != addr)
            revert err.ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(
                id(addr),
                idx,
                list
            );

        uint256 lastIndex = list.length - 1;
        // If the index to remove is not the last one, overwrite the element at the index
        // with the last element.
        if (idx != lastIndex) list[idx] = list[lastIndex];
        // Remove the last element.
        list.pop();
    }
    function removeAddress(address[] storage list, address val) internal {
        removeAddress(list, val, list.find(val).index);
    }
}

// src/contracts/core/vault/Types.sol

/**
 * @notice Asset struct for deposit assets in contract
 * @param token The ERC20 token
 * @param feed IAggregatorV3 feed for the asset
 * @param staleTime Time in seconds for the feed to be considered stale
 * @param maxDeposits Max deposits allowed for the asset
 * @param depositFee Deposit fee of the asset
 * @param withdrawFee Withdraw fee of the asset
 * @param enabled Enabled status of the asset
 */
struct VaultAsset {
    IERC20 token;
    IAggregatorV3 feed;
    uint24 staleTime;
    uint8 decimals;
    uint32 depositFee;
    uint32 withdrawFee;
    uint248 maxDeposits;
    bool enabled;
}

/**
 * @notice Vault configuration struct
 * @param sequencerUptimeFeed The feed address for the sequencer uptime
 * @param sequencerGracePeriodTime The grace period time for the sequencer
 * @param governance The governance address
 * @param feeRecipient The fee recipient address
 * @param oracleDecimals The oracle decimals
 */
struct VaultConfiguration {
    address sequencerUptimeFeed;
    uint96 sequencerGracePeriodTime;
    address governance;
    address pendingGovernance;
    address feeRecipient;
    uint8 oracleDecimals;
}

// src/contracts/core/common/funcs/Math.sol

using WadRay for uint256;
using PercentageMath for uint256;
using PercentageMath for uint16;

/* -------------------------------------------------------------------------- */
/*                                   General                                  */
/* -------------------------------------------------------------------------- */

/**
 * @notice Calculate amount for value provided with possible incentive multiplier for value.
 * @param val Value to convert into amount.
 * @param price The price to apply.
 * @param multiplier Multiplier to apply, 1e4 = 100.00% precision.
 */
function valueToAmount(
    uint256 val,
    uint256 price,
    uint16 multiplier
) pure returns (uint256) {
    return val.percentMul(multiplier).wadDiv(price);
}

/**
 * @notice Converts some decimal precision of `amount` to wad decimal precision, which is 18 decimals.
 * @dev Multiplies if precision is less and divides if precision is greater than 18 decimals.
 * @param amount Amount to convert.
 * @param dec Decimal precision for `amount`.
 * @return uint256 Amount converted to wad precision.
 */
function toWad_0(uint256 amount, uint8 dec) pure returns (uint256) {
    // Most tokens use 18 decimals.
    if (dec == 18 || amount == 0) return amount;

    if (dec < 18) {
        // Multiply for decimals less than 18 to get a wad value out.
        // If the token has 17 decimals, multiply by 10 ** (18 - 17) = 10
        // Results in a value of 1e18.
        return amount * (10 ** (18 - dec));
    }

    // Divide for decimals greater than 18 to get a wad value out.
    // Loses precision, eg. 1 wei of token with 19 decimals:
    // Results in 1 / 10 ** (19 - 18) =  1 / 10 = 0.
    return amount / (10 ** (dec - 18));
}

function toWad_1(int256 amount, uint8 dec) pure returns (uint256) {
    if (amount < 0) {
        revert err.TO_WAD_AMOUNT_IS_NEGATIVE(amount);
    }
    return toWad_0(uint256(amount), dec);
}

/**
 * @notice  Converts wad precision `amount`  to some decimal precision.
 * @dev Multiplies if precision is greater and divides if precision is less than 18 decimals.
 * @param wad Wad amount to convert.
 * @param dec Decimals for the result.
 * @return uint256 Converted amount.
 */
function fromWad(uint256 wad, uint8 dec) pure returns (uint256) {
    // Most tokens use 18 decimals.
    if (dec == 18 || wad == 0) return wad;

    if (dec < 18) {
        // Divide if decimals are less than 18 to get the correct amount out.
        // If token has 17 decimals, dividing by 10 ** (18 - 17) = 10
        // Results in a value of 1e17, which can lose precision.
        return wad / (10 ** (18 - dec));
    }
    // Multiply for decimals greater than 18 to get the correct amount out.
    // If the token has 19 decimals, multiply by 10 ** (19 - 18) = 10
    // Results in a value of 1e19.
    return wad * (10 ** (dec - 18));
}

/**
 * @notice Get the value of `amount` and convert to 18 decimal precision.
 * @param amount Amount of tokens to calculate.
 * @param dec Precision of `amount`.
 * @param price Price to use.
 * @param priceDec Precision of `price`.
 * @return uint256 Value of `amount` in 18 decimal precision.
 */
function wadUSD(
    uint256 amount,
    uint8 dec,
    uint256 price,
    uint8 priceDec
) pure returns (uint256) {
    if (amount == 0 || price == 0) return 0;
    return toWad_0(amount, dec).wadMul(toWad_0(price, priceDec));
}

// lib/kopio-lib/src/token/ERC20Upgradeable.sol

contract ERC20Upgradeable is ERC20Base, Initializable {
    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should set it in constructor.
     */
    function __ERC20Upgradeable_init(
        string memory _name,
        string memory _symbol
    ) internal onlyInitializing {
        name = _name;
        symbol = _symbol;
    }
}

// src/contracts/interfaces/IKopio.sol

interface IKopio is IERC20Permit, IAccessControlEnumerable, IERC165 {
    event Wrap(
        address indexed asset,
        address underlying,
        address indexed to,
        uint256 amount
    );
    event Unwrap(
        address indexed asset,
        address underlying,
        address indexed to,
        uint256 amount
    );

    /**
     * @notice Rebase information
     * @param positive supply increasing/reducing rebase
     * @param denominator the denominator for the operator, 1 ether = 1
     */
    struct Rebase {
        uint248 denominator;
        bool positive;
    }

    /**
     * @notice Configuration to allot wrapping an underlying token to a kopio.
     * @param underlying The underlying ERC20.
     * @param underlyingDec Decimals of the token.
     * @param openFee wrap fee from underlying to assets.
     * @param closeFee fee when wrapping from kopio to underlying.
     * @param native Whether native is supported.
     * @param feeRecipient Fee recipient.
     */
    struct Wraps {
        address underlying;
        uint8 underlyingDec;
        uint48 openFee;
        uint40 closeFee;
        bool native;
        address payable feeRecipient;
    }

    function protocol() external view returns (address);
    function share() external view returns (address);

    function rebaseInfo() external view returns (Rebase memory);

    function wraps() external view returns (Wraps memory);

    function isRebased() external view returns (bool);

    /**
     * @notice Perform a rebase by changing the balance denominator and/or the operator
     * @param denominator denominator for the operator, 1 ether = 1
     * @param positive supply increasing/reducing rebase
     * @param afterRebase external call after rebase
     * @dev denominator of 0 or 1e18 cancels the rebase
     */
    function rebase(
        uint248 denominator,
        bool positive,
        bytes calldata afterRebase
    ) external;

    /**
     * @notice Updates ERC20 metadata for the token in case eg. a ticker change
     * @param _name new name for the asset
     * @param _symbol new symbol for the asset
     * @param _version number that must be greater than latest emitted `Initialized` version
     */
    function reinitializeERC20(
        string memory _name,
        string memory _symbol,
        uint8 _version
    ) external;

    /**
     * @notice Mints tokens to an address.
     * @dev Only callable by operator.
     * @dev Internal balances are always unrebased, events emitted are not.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external;

    /**
     * @notice Burns tokens from an address.
     * @dev Only callable by operator.
     * @dev Internal balances are always unrebased, events emitted are not.
     * @param from The address to burn tokens from.
     * @param amount The amount of tokens to burn.
     */
    function burn(address from, uint256 amount) external;

    /**
     * @notice Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pause() external;

    /**
     * @notice  Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unpause() external;

    /**
     * @notice Deposit underlying tokens to receive equal value of kopio (-fee).
     * @param to address to send the wrapped tokens.
     * @param amount amount to deposit
     */
    function wrap(address to, uint256 amount) external;

    /**
     * @notice Withdraw underlying tokens. (-fee).
     * @param to address receiving the withdrawal.
     * @param amount amount to withdraw
     * @param toNative bool whether to receive underlying as native
     */
    function unwrap(address to, uint256 amount, bool toNative) external;

    /**
     * @notice Sets the fixed share address.
     * @param addr the address of the fixed share.
     */
    function setShare(address addr) external;

    /**
     * @notice enables wraps with native underlying
     * @param enabled enabled (bool).
     */
    function enableNative(bool enabled) external;

    /**
     * @notice Sets fee recipient address
     * @param newRecipient The fee recipient address.
     */
    function setFeeRecipient(address newRecipient) external;

    /**
     * @notice Sets deposit fee
     * @param newOpenFee The open fee (uint48).
     */
    function setOpenFee(uint48 newOpenFee) external;

    /**
     * @notice Sets the fee on unwrap.
     * @param newCloseFee The open fee (uint48).
     */
    function setCloseFee(uint40 newCloseFee) external;

    /**
     * @notice Sets underlying token address (and its decimals)
     * @notice Zero address will disable wraps.
     * @param underlyingAddr The underlying address.
     */
    function setUnderlying(address underlyingAddr) external;
}

// src/contracts/interfaces/IVault.sol

interface IVault is IERC20Permit, VEvent {
    /**
     * @notice This function deposits `assetsIn` of `asset`, regardless of the amount of vault shares minted.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     * @param assetAddr Asset to deposit.
     * @param assetsIn Amount of `asset` to deposit.
     * @param receiver Address to receive `sharesOut` of vault shares.
     * @return sharesOut Amount of vault shares minted for `assetsIn`.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function deposit(
        address assetAddr,
        uint256 assetsIn,
        address receiver
    ) external returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function mints `sharesOut` of vault shares, regardless of the amount of `asset` received.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @param assetAddr Asset to deposit.
     * @param sharesOut Amount of vault shares desired to mint.
     * @param receiver Address to receive `sharesOut` of shares.
     * @return assetsIn Assets used to mint `sharesOut` of vault shares.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     */
    function mint(
        address assetAddr,
        uint256 sharesOut,
        address receiver
    ) external returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function burns `sharesIn` of shares from `owner`, regardless of the amount of `asset` received.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param assetAddr Asset to redeem.
     * @param sharesIn Amount of vault shares to redeem.
     * @param receiver Address to receive the redeemed assets.
     * @param owner Owner of vault shares.
     * @return assetsOut Amount of `asset` used for redeem `assetsOut`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function redeem(
        address assetAddr,
        uint256 sharesIn,
        address receiver,
        address owner
    ) external returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function withdraws `assetsOut` of assets, regardless of the amount of vault shares required.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param assetAddr Asset to withdraw.
     * @param assetsOut Amount of `asset` desired to withdraw.
     * @param receiver Address to receive the withdrawn assets.
     * @param owner Owner of vault shares.
     * @return sharesIn Amount of vault shares used to withdraw `assetsOut` of `asset`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function withdraw(
        address assetAddr,
        uint256 assetsOut,
        address receiver,
        address owner
    ) external returns (uint256 sharesIn, uint256 assetFee);

    /* -------------------------------------------------------------------------- */
    /*                                    Views                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the current vault configuration
     * @return config Vault configuration struct
     */
    function getConfig()
        external
        view
        returns (VaultConfiguration memory config);

    /**
     * @notice Returns the total value of all assets in the shares contract in USD WAD precision.
     */
    function totalAssets() external view returns (uint256 result);

    /**
     * @notice Array of all assets
     */
    function allAssets() external view returns (VaultAsset[] memory assets);

    /**
     * @notice Assets array used for iterating through the assets in the shares contract
     */
    function assetList(uint256 index) external view returns (address assetAddr);

    /**
     * @notice Returns the asset struct for a given asset
     * @param asset Supported asset address
     * @return asset Asset struct for `asset`
     */
    function assets(address) external view returns (VaultAsset memory asset);

    function assetPrice(address assetAddr) external view returns (uint256);

    /**
     * @notice This function is used for previewing the amount of shares minted for `assetsIn` of `asset`.
     * @param assetAddr Supported asset address
     * @param assetsIn Amount of `asset` in.
     * @return sharesOut Amount of vault shares minted.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewDeposit(
        address assetAddr,
        uint256 assetsIn
    ) external view returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsIn` of `asset` required to mint `sharesOut` of vault shares.
     * @param assetAddr Supported asset address
     * @param sharesOut Desired amount of vault shares to mint.
     * @return assetsIn Amount of `asset` required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewMint(
        address assetAddr,
        uint256 sharesOut
    ) external view returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsOut` of `asset` received for `sharesIn` of vault shares.
     * @param assetAddr Supported asset address
     * @param sharesIn Desired amount of vault shares to burn.
     * @return assetsOut Amount of `asset` received.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewRedeem(
        address assetAddr,
        uint256 sharesIn
    ) external view returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `sharesIn` of vault shares required to burn for `assetsOut` of `asset`.
     * @param assetAddr Supported asset address
     * @param assetsOut Desired amount of `asset` out.
     * @return sharesIn Amount of vault shares required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewWithdraw(
        address assetAddr,
        uint256 assetsOut
    ) external view returns (uint256 sharesIn, uint256 assetFee);

    /**
     * @notice Returns the maximum deposit amount of `asset`
     * @param assetAddr Supported asset address
     * @return assetsIn Maximum depositable amount of assets.
     */
    function maxDeposit(
        address assetAddr
    ) external view returns (uint256 assetsIn);

    /**
     * @notice Returns the maximum mint using `asset`
     * @param assetAddr Supported asset address.
     * @param owner Owner of assets.
     * @return sharesOut Maximum mint amount.
     */
    function maxMint(
        address assetAddr,
        address owner
    ) external view returns (uint256 sharesOut);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param assetAddr Supported asset address.
     * @param owner Owner of vault shares.
     * @return sharesIn Maximum redeemable amount of `shares` (vault share balance)
     */
    function maxRedeem(
        address assetAddr,
        address owner
    ) external view returns (uint256 sharesIn);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param assetAddr Supported asset address.
     * @param owner Owner of vault shares.
     * @return amountOut Maximum amount of `asset` received.
     */
    function maxWithdraw(
        address assetAddr,
        address owner
    ) external view returns (uint256 amountOut);

    /**
     * @notice Returns the exchange rate of one vault share to USD.
     * @return rate Exchange rate of one vault share to USD in wad precision.
     */
    function exchangeRate() external view returns (uint256 rate);

    /* -------------------------------------------------------------------------- */
    /*                                    Admin                                   */
    /* -------------------------------------------------------------------------- */

    function setBaseRate(uint256 newBaseRate) external;

    /**
     * @notice Adds a new asset to the vault
     * @param assetConfig Asset to add
     */
    function addAsset(
        VaultAsset memory assetConfig
    ) external returns (VaultAsset memory);

    /**
     * @notice Removes an asset from the vault
     * @param assetAddr Asset address to remove
     * emits assetRemoved(asset, block.timestamp);
     */
    function removeAsset(address assetAddr) external;

    /**
     * @notice Current governance sets a new governance address
     * @param newGovernance The new governance address
     */
    function setGovernance(address newGovernance) external;

    function acceptGovernance() external;

    /**
     * @notice Current governance sets a new fee recipient address
     * @param newFeeRecipient The new fee recipient address
     */
    function setFeeRecipient(address newFeeRecipient) external;

    /**
     * @notice Sets a new oracle for a asset
     * @param assetAddr Asset to set the oracle for
     * @param feedAddr Feed to set
     * @param newStaleTime Time in seconds for the feed to be considered stale
     */
    function setAssetFeed(
        address assetAddr,
        address feedAddr,
        uint24 newStaleTime
    ) external;

    /**
     * @notice Sets a new oracle decimals
     * @param newDecimals New oracle decimal precision
     */
    function setFeedPricePrecision(uint8 newDecimals) external;

    /**
     * @notice Sets the max deposit amount for a asset
     * @param assetAddr Asset to set the max deposits for
     * @param newMaxDeposits Max deposits to set
     */
    function setMaxDeposits(address assetAddr, uint248 newMaxDeposits) external;

    /**
     * @notice Sets the enabled status for a asset
     * @param assetAddr Asset to set the enabled status for
     * @param isEnabled Enabled status to set
     */
    function setAssetEnabled(address assetAddr, bool isEnabled) external;

    /**
     * @notice Sets the deposit fee for a asset
     * @param assetAddr Asset to set the deposit fee for
     * @param newDepositFee Fee to set
     */
    function setDepositFee(address assetAddr, uint16 newDepositFee) external;

    /**
     * @notice Sets the withdraw fee for a asset
     * @param assetAddr Asset to set the withdraw fee for
     * @param newWithdrawFee Fee to set
     */
    function setWithdrawFee(address assetAddr, uint16 newWithdrawFee) external;
}

// src/contracts/interfaces/IERC4626.sol

interface IERC4626 {
    /**
     * @notice The underlying kopio
     */
    function asset() external view returns (IKopio);

    event Issue(
        address indexed caller,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    event Deposit(
        address indexed caller,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    event Destroy(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    function convertToShares(
        uint256 assets
    ) external view returns (uint256 shares);

    function convertToAssets(
        uint256 shares
    ) external view returns (uint256 assets);

    /**
     * @notice Deposit assets for equivalent amount of shares
     * @param assets Amount of assets to deposit
     * @param receiver Address to send shares to
     * @return shares Amount of shares minted
     */
    function deposit(
        uint256 assets,
        address receiver
    ) external returns (uint256 shares);

    /**
     * @notice Withdraw assets for equivalent amount of shares
     * @param assets Amount of assets to withdraw
     * @param receiver Address to send assets to
     * @param owner Address to burn shares from
     * @return shares Amount of shares burned
     * @dev shares are burned from owner, not msg.sender
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256 shares);

    function maxDeposit(address) external view returns (uint256);

    function maxMint(address) external view returns (uint256 assets);

    function maxRedeem(address owner) external view returns (uint256 assets);

    function maxWithdraw(address owner) external view returns (uint256 assets);

    /**
     * @notice Mint shares for equivalent amount of assets
     * @param shares Amount of shares to mint
     * @param receiver Address to send shares to
     * @return assets Amount of assets redeemed
     */
    function mint(
        uint256 shares,
        address receiver
    ) external returns (uint256 assets);

    function previewDeposit(
        uint256 assets
    ) external view returns (uint256 shares);

    function previewMint(uint256 shares) external view returns (uint256 assets);

    function previewRedeem(
        uint256 shares
    ) external view returns (uint256 assets);

    function previewWithdraw(
        uint256 assets
    ) external view returns (uint256 shares);

    /**
     * @notice Track the underlying amount
     * @return Total supply for the underlying kopio
     */
    function totalAssets() external view returns (uint256);

    /**
     * @notice Redeem shares for assets
     * @param shares Amount of shares to redeem
     * @param receiver Address to send assets to
     * @param owner Address to burn shares from
     * @return assets Amount of assets redeemed
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 assets);
}

// src/contracts/interfaces/IKopioShare.sol

interface IKopioShare is
    IKopioIssuer,
    IERC4626,
    IERC20Permit,
    IAccessControlEnumerable,
    IERC165
{
    function issue(
        uint256 assets,
        address to
    ) external returns (uint256 shares);

    function destroy(
        uint256 assets,
        address from
    ) external returns (uint256 shares);

    function convertToShares(
        uint256 assets
    ) external view override(IKopioIssuer, IERC4626) returns (uint256 shares);

    function convertToAssets(
        uint256 shares
    ) external view override(IKopioIssuer, IERC4626) returns (uint256 assets);

    function reinitializeERC20(
        string memory _name,
        string memory _symbol,
        uint8 _version
    ) external;

    /**
     * @notice Mints shares to asset contract.
     * @param assets amount of assets.
     */
    function wrap(uint256 assets) external;

    /**
     * @notice Burns shares from the asset contract.
     * @param assets amount of assets.
     */
    function unwrap(uint256 assets) external;
}

// src/contracts/interfaces/IONE.sol

interface IONE is IERC20Permit, IVaultExtender, IKopioIssuer, IERC165 {
    function protocol() external view returns (address);
    /**
     * @notice This function adds ONE to circulation
     * Caller must be a contract and have the OPERATOR_ROLE
     * @param amount amount to mint
     * @param to address to mint tokens to
     * @return uint256 amount minted
     */
    function issue(uint256 amount, address to) external returns (uint256);

    /**
     * @notice This function removes ONE from circulation
     * Caller must be a contract and have the OPERATOR_ROLE
     * @param amount amount to burn
     * @param from address to burn tokens from
     * @return uint256 amount burned
     */
    function destroy(uint256 amount, address from) external returns (uint256);

    function vault() external view returns (IVault);
    /**
     * @notice Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pause() external;

    /**
     * @notice  Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unpause() external;

    /**
     * @notice Exchange rate of vONE to USD.
     * @return rate vONE/USD exchange rate.
     */
    function exchangeRate() external view returns (uint256 rate);
}

// src/contracts/core/common/Auth.sol

interface IGnosisSafeL2 {
    function isOwner(address owner) external view returns (bool);

    function getOwners() external view returns (address[] memory);
}

/**
 * @title Shared library for access control
 * @author the kopio project
 */
library Auth {
    using EnumerableSet for EnumerableSet.AddressSet;
    /* -------------------------------------------------------------------------- */
    /*                                   Events                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /* -------------------------------------------------------------------------- */
    /*                                Functionality                               */
    /* -------------------------------------------------------------------------- */

    function hasRole(
        bytes32 role,
        address account
    ) internal view returns (bool) {
        return cs()._roles[role].members[account];
    }

    function getRoleMemberCount(bytes32 role) internal view returns (uint256) {
        return cs()._roleMembers[role].length();
    }

    /**
     * @dev Revert with a standard message if `msg.sender` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function checkRole(bytes32 role) internal view {
        _checkRole(role, msg.sender);
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(uint160(account), 20),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) internal view returns (bytes32) {
        return cs()._roles[role].adminRole;
    }

    function getRoleMember(
        bytes32 role,
        uint256 index
    ) internal view returns (address) {
        return cs()._roleMembers[role].at(index);
    }

    /**
     * @notice setups the security council
     *
     */
    function setupSecurityCouncil(address _councilAddress) internal {
        if (getRoleMemberCount(Role.SAFETY_COUNCIL) != 0)
            revert err.SAFETY_COUNCIL_ALREADY_EXISTS(
                _councilAddress,
                getRoleMember(Role.SAFETY_COUNCIL, 0)
            );

        cs()._roles[Role.SAFETY_COUNCIL].members[_councilAddress] = true;
        cs()._roleMembers[Role.SAFETY_COUNCIL].add(_councilAddress);

        emit RoleGranted(Role.SAFETY_COUNCIL, _councilAddress, msg.sender);
    }

    function transferSecurityCouncil(address _newCouncil) internal {
        checkRole(Role.SAFETY_COUNCIL);
        uint256 owners = IGnosisSafeL2(_newCouncil).getOwners().length;
        if (owners < 5)
            revert err.MULTISIG_NOT_ENOUGH_OWNERS(_newCouncil, owners, 5);

        cs()._roles[Role.SAFETY_COUNCIL].members[msg.sender] = false;
        cs()._roleMembers[Role.SAFETY_COUNCIL].remove(msg.sender);

        cs()._roles[Role.SAFETY_COUNCIL].members[_newCouncil] = true;
        cs()._roleMembers[Role.SAFETY_COUNCIL].add(_newCouncil);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) internal {
        checkRole(getRoleAdmin(role));
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) internal {
        checkRole(getRoleAdmin(role));
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function _renounceRole(bytes32 role, address account) internal {
        if (account != msg.sender)
            revert err.ACCESS_CONTROL_NOT_SELF(account, msg.sender);

        _revokeRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal {
        bytes32 previousAdminRole = getRoleAdmin(role);
        cs()._roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * @notice Cannot grant the role `SAFETY_COUNCIL` - must be done via explicit function.
     *
     * Internal function without access restriction.
     */
    function _grantRole(
        bytes32 role,
        address account
    ) internal ensureNotSafetyCouncil(role) {
        if (!hasRole(role, account)) {
            cs()._roles[role].members[account] = true;
            cs()._roleMembers[role].add(account);
            emit RoleGranted(role, account, msg.sender);
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     */
    function _revokeRole(bytes32 role, address account) internal {
        if (hasRole(role, account)) {
            cs()._roles[role].members[account] = false;
            cs()._roleMembers[role].remove(account);
            emit RoleRevoked(role, account, Meta.msgSender());
        }
    }

    /**
     * @dev Ensure we use the explicit `grantSafetyCouncilRole` function.
     */
    modifier ensureNotSafetyCouncil(bytes32 role) {
        if (role == Role.SAFETY_COUNCIL)
            revert err.SAFETY_COUNCIL_NOT_ALLOWED();
        _;
    }
}

// src/contracts/core/common/Modifiers.sol

library LibModifiers {
    /// @dev Simple check for the enabled flag
    /// @param addr The address of the asset.
    /// @param action The action to this is called from.
    /// @return asset The asset struct.
    function onlyUnpaused(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage asset) {
        if (
            self.safetyStateSet && self.safetyState[addr][action].pause.enabled
        ) {
            revert err.ASSET_PAUSED_FOR_THIS_ACTION(id(addr), uint8(action));
        }
        return self.assets[addr];
    }

    function onlyExistingAsset(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[addr];
        if (!asset.exists()) {
            revert err.INVALID_ASSET(addr);
        }
    }

    /**
     * @notice Reverts if address is not a collateral asset.
     * @param addr The address of the asset.
     * @return cfg The asset struct.
     */
    function onlyCollateral(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (!cfg.isCollateral) {
            revert err.NOT_COLLATERAL(id(addr));
        }
    }

    function onlyCollateral(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage cfg) {
        cfg = onlyUnpaused(self, addr, action);
        if (!cfg.isCollateral) {
            revert err.NOT_COLLATERAL(id(addr));
        }
    }

    /**
     * @notice Ensure asset returned is mintable.
     * @param addr The address of the asset.
     * @return cfg The asset struct.
     */
    function onlyKopio(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (!cfg.isKopio) {
            revert err.NOT_MINTABLE(id(addr));
        }
    }

    function onlyKopio(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage cfg) {
        cfg = onlyUnpaused(self, addr, action);
        if (!cfg.isKopio) {
            revert err.NOT_MINTABLE(id(addr));
        }
    }

    /**
     * @notice Reverts if address is not depositable to SCDP.
     * @param addr The address of the asset.
     * @return cfg The asset struct.
     */
    function onlyGlobalDepositable(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (!cfg.isGlobalDepositable) {
            revert err.NOT_DEPOSITABLE(id(addr));
        }
    }

    /**
     * @notice Reverts if asset is not the feeAsset and does not have any shared fees accumulated.
     * @notice Assets that pass are guaranteed to never have zero liquidity index.
     * @param addr address of the asset.
     * @return cfg the config struct.
     */
    function onlyCumulated(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (
            !cfg.isGlobalDepositable ||
            (addr != scdp().feeAsset &&
                scdp().assetIndexes[addr].currFeeIndex <= WadRay.RAY)
        ) {
            revert err.NOT_CUMULATED(id(addr));
        }
    }

    function onlyCumulated(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage asset) {
        asset = onlyUnpaused(self, addr, action);
        if (
            !asset.isGlobalDepositable ||
            (addr != scdp().feeAsset &&
                scdp().assetIndexes[addr].currFeeIndex <= WadRay.RAY)
        ) {
            revert err.NOT_CUMULATED(id(addr));
        }
    }

    /**
     * @notice Reverts if address is not swappable kopio.
     * @param addr address of the asset.
     * @return cfg the config struct.
     */
    function onlySwapMintable(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (!cfg.isSwapMintable) {
            revert err.NOT_SWAPPABLE(id(addr));
        }
    }

    function onlySwapMintable(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage cfg) {
        cfg = onlyUnpaused(self, addr, action);
        if (!cfg.isSwapMintable) {
            revert err.NOT_SWAPPABLE(id(addr));
        }
    }

    /**
     * @notice Reverts if address does not have any deposits.
     * @param addr address of the asset.
     * @return cfg asset config.
     * @dev main use is to check for deposits before removing it.
     */
    function onlyGlobalDeposited(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (scdp().assetIndexes[addr].currFeeIndex == 0) {
            revert err.NO_GLOBAL_DEPOSITS(id(addr));
        }
    }

    function onlyGlobalDeposited(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage cfg) {
        cfg = onlyUnpaused(self, addr, action);
        if (scdp().assetIndexes[addr].currFeeIndex == 0) {
            revert err.NO_GLOBAL_DEPOSITS(id(addr));
        }
    }

    function onlyCoverAsset(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        cfg = self.assets[addr];
        if (!cfg.isCoverAsset) {
            revert err.NOT_COVER_ASSET(id(addr));
        }
    }

    function onlyCoverAsset(
        CommonState storage self,
        address addr,
        Enums.Action action
    ) internal view returns (Asset storage cfg) {
        cfg = onlyUnpaused(self, addr, action);
        if (!cfg.isCoverAsset) {
            revert err.NOT_COVER_ASSET(id(addr));
        }
    }

    function onlyIncomeAsset(
        CommonState storage self,
        address addr
    ) internal view returns (Asset storage cfg) {
        if (addr != scdp().feeAsset) revert err.NOT_SUPPORTED_YET();
        cfg = onlyGlobalDeposited(self, addr);
        if (!cfg.isGlobalDepositable) revert err.NOT_INCOME_ASSET(addr);
    }
}

contract Modifiers {
    /**
     * @dev Modifier that checks if the contract is initializing and if so, gives the caller the ADMIN role
     */
    modifier initializeAsAdmin() {
        if (ds().initializing != Constants.INITIALIZING)
            revert err.NOT_INITIALIZING();
        if (!Auth.hasRole(Role.ADMIN, msg.sender)) {
            Auth._grantRole(Role.ADMIN, msg.sender);
            _;
            Auth._revokeRole(Role.ADMIN, msg.sender);
        } else {
            _;
        }
    }
    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        Auth.checkRole(role);
        _;
    }

    /**
     * @notice Check for role if the condition is true.
     * @param _shouldCheckRole Should be checking the role.
     */
    modifier onlyRoleIf(bool _shouldCheckRole, bytes32 role) {
        if (_shouldCheckRole) {
            Auth.checkRole(role);
        }
        _;
    }

    modifier nonReentrant() {
        if (cs().entered == Constants.ENTERED) {
            revert err.CANNOT_RE_ENTER();
        }
        cs().entered = Constants.ENTERED;
        _;
        cs().entered = Constants.NOT_ENTERED;
    }

    modifier usePyth(bytes[] calldata prices) {
        handlePythUpdate(prices);
        _;
    }
}

// src/contracts/core/common/State.sol

using LibModifiers for CommonState global;

struct CommonState {
    mapping(address asset => Asset) assets;
    mapping(bytes32 ticker => mapping(Enums.OracleType provider => Oracle)) oracles;
    mapping(address asset => mapping(Enums.Action action => SafetyState)) safetyState;
    address feeRecipient;
    address pythEp;
    address sequencerUptimeFeed;
    uint32 sequencerGracePeriodTime;
    /// @notice The max deviation percentage between primary and secondary price.
    uint16 maxPriceDeviationPct;
    /// @notice Offchain oracle decimals
    uint8 oracleDecimals;
    /// @notice Flag tells if there is a need to perform safety checks on user actions
    bool safetyStateSet;
    uint256 entered;
    mapping(bytes32 role => RoleData data) _roles;
    mapping(bytes32 role => EnumerableSet.AddressSet member) _roleMembers;
    address marketStatusProvider;
}

// keccak256(abi.encode(uint256(keccak256("kopio.slot.common")) - 1)) & ~bytes32(uint256(0xff));
bytes32 constant COMMON_SLOT = 0xfc1d014d58da005150440e1217b5f770417f3480965a1e2032e843d013624600;

function cs() pure returns (CommonState storage state) {
    bytes32 position = bytes32(COMMON_SLOT);
    assembly {
        state.slot := position
    }
}

// src/contracts/core/common/Types.sol

using Assets for Asset global;

/* ========================================================================== */
/*                                   Structs                                  */
/* ========================================================================== */

/// @notice Oracle configuration mapped to a ticker.
struct Oracle {
    address feed;
    bytes32 pythId;
    uint256 staleTime;
    bool invertPyth;
    bool isClosable;
}

/**
 * @notice Feed configuration.
 * @param oracleIds two supported oracle types.
 * @param feeds the feeds - eg, pyth / redstone will be address(0).
 * @param staleTimes stale times for the feeds.
 * @param pythId pyth id.
 * @param invertPyth invert the pyth price.
 * @param isClosable is market for ticker closable.
 */
struct FeedConfiguration {
    Enums.OracleType[2] oracleIds;
    address[2] feeds;
    uint256[2] staleTimes;
    bytes32 pythId;
    bool invertPyth;
    bool isClosable;
}

/**
 * @title Asset configuration
 * @author the kopio project
 * @notice all assets in the protocol share this configuration.
 * @notice ticker is shared eg. kETH and WETH use "ETH"
 * @dev Percentages use 2 decimals: 1e4 (10000) == 100.00%. See {PercentageMath.sol}.
 * @dev Noting the percentage value of uint16 caps at 655.36%.
 */
struct Asset {
    /// @notice Underlying asset ticker (eg. "ETH")
    bytes32 ticker;
    /// @notice The share address, if any.
    address share;
    /// @notice Oracles for this asset.
    /// @notice 0 is the primary price source, 1 being the reference price for deviation checks.
    Enums.OracleType[2] oracles;
    /// @notice Decreases collateral valuation, Always <= 100% or 1e4.
    uint16 factor;
    /// @notice Increases debt valution, >= 100% or 1e4.
    uint16 dFactor;
    /// @notice Fee percent for opening a debt position, deducted from collaterals.
    uint16 openFee;
    /// @notice Fee percent for closing a debt position, deducted from collaterals.
    uint16 closeFee;
    /// @notice Liquidation incentive when seized as collateral.
    uint16 liqIncentive;
    /// @notice Supply cap of the ICDP.
    uint256 mintLimit;
    /// @notice Supply cap of the SCDP.
    uint256 mintLimitSCDP;
    /// @notice Limit for SCDP deposit amount
    uint256 depositLimitSCDP;
    /// @notice Fee percent for swaps that sell the asset.
    uint16 swapInFee;
    /// @notice Fee percent for swaps that buy the asset.
    uint16 swapOutFee;
    /// @notice Protocol share of swap fees. Cap 50% == a.feeShare + b.feeShare <= 100%.
    uint16 protocolFeeShareSCDP;
    /// @notice Liquidation incentive for kopio debt in the SCDP.
    /// @notice Discounts the seized collateral in SCDP liquidations.
    uint16 liqIncentiveSCDP;
    /// @notice Set once during setup - kopios have 18 decimals.
    uint8 decimals;
    /// @notice Asset can be deposited as ICDP collateral.
    bool isCollateral;
    /// @notice Asset can be minted from the ICDP.
    bool isKopio;
    /// @notice Asset can be explicitly deposited into the SCDP.
    bool isGlobalDepositable;
    /// @notice Asset can be minted for swap output in the SCDP.
    bool isSwapMintable;
    /// @notice Asset belongs to total collateral value calculation in the SCDP.
    /// @notice kopios default to true due to indirect deposits from swaps.
    bool isGlobalCollateral;
    /// @notice Asset can be used to cover SCDP debt.
    bool isCoverAsset;
}

/// @notice The access control role data.
struct RoleData {
    mapping(address => bool) members;
    bytes32 adminRole;
}

/// @notice Variables used for calculating the max liquidation value.
struct MaxLiqVars {
    Asset collateral;
    uint256 accountCollateralValue;
    uint256 minCollateralValue;
    uint256 seizeCollateralAccountValue;
    uint192 minDebtValue;
    uint32 gainFactor;
    uint32 maxLiquidationRatio;
    uint32 debtFactor;
}

struct MaxLiqInfo {
    address account;
    address seizeAssetAddr;
    address repayAssetAddr;
    uint256 repayValue;
    uint256 repayAmount;
    uint256 seizeAmount;
    uint256 seizeValue;
    uint256 repayAssetPrice;
    uint256 repayAssetIndex;
    uint256 seizeAssetPrice;
    uint256 seizeAssetIndex;
}

/// @notice Convenience struct for checking configurations
struct RawPrice {
    int256 answer;
    uint256 timestamp;
    uint256 staleTime;
    bool isStale;
    bool isZero;
    Enums.OracleType oracle;
    address feed;
}

/// @notice Configuration for pausing `Action`
struct Pause {
    bool enabled;
    uint256 timestamp0;
    uint256 timestamp1;
}

/// @notice Safety configuration for assets
struct SafetyState {
    Pause pause;
}

/**
 * @notice Initialization arguments for common values
 */
struct CommonInitializer {
    address admin;
    address council;
    address treasury;
    uint16 maxPriceDeviationPct;
    uint8 oracleDecimals;
    uint32 sequencerGracePeriodTime;
    address sequencerUptimeFeed;
    address pythEp;
    address marketStatusProvider;
}

// src/contracts/core/common/funcs/Actions.sol

using Strings for bytes32;

/* -------------------------------------------------------------------------- */
/*                                   Actions                                  */
/* -------------------------------------------------------------------------- */

/// @notice Burn assets with share already known.
/// @param amount The amount being burned
/// @param from The account to burn assets from.
/// @param share The share token of asset being burned.
function burnAssets(
    uint256 amount,
    address from,
    address share
) returns (uint256 burned) {
    burned = IKopioIssuer(share).destroy(amount, from);
    if (burned == 0) revert err.ZERO_BURN(id(share));
}

/// @notice Mint assets with share already known.
/// @param amount The asset amount being minted
/// @param to The account receiving minted assets.
/// @param share The share token of the minted asset.
function mintAssets(
    uint256 amount,
    address to,
    address share
) returns (uint256 minted) {
    minted = IKopioIssuer(share).issue(amount, to);
    if (minted == 0) revert err.ZERO_MINT(id(share));
}

/// @notice Repay SCDP swap debt.
/// @param cfg the asset being repaid
/// @param amount the asset amount being burned
/// @param from the account to burn assets from
/// @return burned Normalized amount of burned assets.
function burnSCDP(
    Asset storage cfg,
    uint256 amount,
    address from
) returns (uint256 burned) {
    burned = burnAssets(amount, from, cfg.share);

    uint256 sdiBurned = cfg.debtToSDI(amount, false);
    if (sdiBurned > sdi().totalDebt) {
        if ((sdiBurned - sdi().totalDebt) > 10 ** cs().oracleDecimals) {
            revert err.SDI_DEBT_REPAY_OVERFLOW(sdi().totalDebt, sdiBurned);
        }
        sdi().totalDebt = 0;
    } else {
        sdi().totalDebt -= sdiBurned;
    }
}

/// @notice Mint assets from SCDP swap.
/// @notice Reverts if market for asset is not open.
/// @param cfg the asset requested
/// @param amount the asset amount requested
/// @param to the account to mint the assets to
/// @return issued Normalized amount of minted assets.
function mintSCDP(
    Asset storage cfg,
    uint256 amount,
    address to
) returns (uint256 issued) {
    if (!cfg.isMarketOpen())
        revert err.MARKET_CLOSED(id(cfg.share), cfg.ticker.toString());
    issued = mintAssets(amount, to, cfg.share);
    unchecked {
        sdi().totalDebt += cfg.debtToSDI(amount, false);
    }
}

// src/contracts/core/common/funcs/Assets.sol

library Assets {
    using WadRay for uint256;
    using PercentageMath for uint256;

    /* -------------------------------------------------------------------------- */
    /*                                Asset Prices                                */
    /* -------------------------------------------------------------------------- */

    function price(Asset storage self) internal view returns (uint256) {
        return safePrice(self.ticker, self.oracles, cs().maxPriceDeviationPct);
    }

    function price(
        Asset storage self,
        uint256 maxDeviationPct
    ) internal view returns (uint256) {
        return safePrice(self.ticker, self.oracles, maxDeviationPct);
    }

    /**
     * @notice Get value for @param amount of @param self in uint256
     */
    function kopioUSD(
        Asset storage self,
        uint256 amount
    ) internal view returns (uint256) {
        return self.price().wadMul(amount);
    }

    /**
     * @notice Get value for @param amount of @param self in uint256
     */
    function assetUSD(
        Asset storage self,
        uint256 amount
    ) internal view returns (uint256) {
        return self.toCollateralValue(amount, true);
    }

    function isMarketOpen(Asset storage self) internal view returns (bool) {
        return
            IMarketStatus(cs().marketStatusProvider).getTickerStatus(
                self.ticker
            );
    }

    /* -------------------------------------------------------------------------- */
    /*                                 Conversions                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Ensure repayment value (and amount), clamp to max if necessary.
     * @param maxRepayValue The max liquidatable USD (uint256).
     * @param repayAmount The repay amount (uint256).
     * @return uint256 Effective repayment value.
     * @return uint256 Effective repayment amount.
     */
    function boundRepayValue(
        Asset storage self,
        uint256 maxRepayValue,
        uint256 repayAmount
    ) internal view returns (uint256, uint256) {
        uint256 assetPrice = self.price();
        uint256 repayValue = repayAmount.wadMul(assetPrice);

        if (repayValue > maxRepayValue) {
            repayAmount = maxRepayValue.wadDiv(assetPrice);
            repayValue = maxRepayValue;
        }

        return (repayValue, repayAmount);
    }

    /**
     * @notice Gets the value + factored value of `amount` with price.
     * @param amount Amount of asset
     * @param factor Factor to apply to the value.
     * @return value Value.
     * @return valueAdj Factored value.
     * @return price_ Price of the asset.
     */

    function toValues(
        Asset storage self,
        uint256 amount,
        uint256 factor
    ) internal view returns (uint256 value, uint256 valueAdj, uint256 price_) {
        price_ = self.price();
        if (amount == 0) return (0, 0, price_);

        value = toWad_0(amount, self.decimals).wadMul(price_);
        valueAdj = factor != 0 ? value.percentMul(factor) : value;
    }

    function toCollateralValue(
        Asset storage self,
        uint256 amount,
        bool noFactors
    ) internal view returns (uint256 value) {
        (, value, ) = self.toValues(amount, noFactors ? 0 : self.factor);
    }

    /**
     * @notice Gets the USD value for asset and amount.
     * @param amount Amount of the asset to calculate the value for.
     * @param noFactors Value ignores factors.
     * @return value The value of the amount
     */
    function toDebtValue(
        Asset storage self,
        uint256 amount,
        bool noFactors
    ) internal view returns (uint256 value) {
        if (amount == 0) return 0;
        value = self.kopioUSD(amount);

        if (!noFactors) {
            value = value.percentMul(self.dFactor);
        }
    }

    /**
     * @notice Get amount from a value.
     * @param value value to use
     * @param noFactors whether to use factors or not.
     * @return amount amount for the provided value.
     */
    function toDebtAmount(
        Asset storage self,
        uint256 value,
        bool noFactors
    ) internal view returns (uint256 amount) {
        if (value == 0) return 0;

        uint256 price_ = self.price();
        if (!noFactors) {
            price_ = price_.percentMul(self.dFactor);
        }

        return value.wadDiv(price_);
    }

    /// @notice Converts amount of assets to SDI.
    function debtToSDI(
        Asset storage asset,
        uint256 amount,
        bool noFactors
    ) internal view returns (uint256 shares) {
        return
            toWad_0(asset.toDebtValue(amount, noFactors), cs().oracleDecimals)
                .wadDiv(SDIPrice());
    }

    /**
     * @notice Keep debt over the minimum debt value.
     * @param self asset being burned.
     * @param burned mmount burned.
     * @param debt amount before burn.
     * @return amount >= minDebtAmount
     */
    function checkDust(
        Asset storage self,
        uint256 burned,
        uint256 debt
    ) internal view returns (uint256 amount) {
        if (burned == debt) return burned;
        // If the requested burn would put the user's debt position below the minimum
        // debt value, close up to the minimum debt value instead.
        uint256 value = self.toDebtValue(debt - burned, true);
        uint256 minDebtValue = ms().minDebtValue;
        if (value > 0 && value < minDebtValue) {
            amount = debt - minDebtValue.wadDiv(self.price());
        } else {
            amount = burned;
        }
    }

    /**
     * @notice Check min debt value against an amount.
     * @param self asset configuration
     * @param asset kopio address.
     * @param debt the debt amount
     */
    function ensureMinDebtValue(
        Asset storage self,
        address asset,
        uint256 debt
    ) internal view {
        uint256 value = self.kopioUSD(debt);
        uint256 minDebtValue = ms().minDebtValue;
        if (value < minDebtValue)
            revert err.MINT_VALUE_LESS_THAN_MIN_DEBT_VALUE(
                id(asset),
                value,
                minDebtValue
            );
    }

    /**
     * @notice EDGE CASE: If collateral is also a kopio, ensure deposit amount is above 1e12.
     * @dev this is due to rebases.
     */
    function ensureMinCollateralAmount(
        Asset storage self,
        address addr,
        uint256 amount
    ) internal view {
        if (
            amount > Constants.MIN_COLLATERAL ||
            amount == 0 ||
            self.share == address(0)
        ) return;

        revert err.COLLATERAL_AMOUNT_LOW(
            id(addr),
            amount,
            Constants.MIN_COLLATERAL
        );
    }

    /**
     * @notice Get the minimum value required to back debt at a given CR.
     * @param amount the debt amount.
     * @param ratio ratio to apply for the minimum collateral value.
     * @return minCollateral the minimum collateral required for `amount`t.
     */
    function minCollateralValueAtRatio(
        Asset storage self,
        uint256 amount,
        uint32 ratio
    ) internal view returns (uint256 minCollateral) {
        if (amount == 0) return 0;
        // Calculate the collateral value required to back this asset amount at the given ratio
        return self.toDebtValue(amount, false).percentMul(ratio);
    }

    /* -------------------------------------------------------------------------- */
    /*                                    Utils                                   */
    /* -------------------------------------------------------------------------- */
    function exists(Asset storage self) internal view returns (bool) {
        return self.ticker != 0;
    }

    function oracleAt(
        Asset storage self,
        uint8 idx
    ) internal view returns (Enums.OracleType oracle, Oracle storage config) {
        oracle = self.oracles[idx];
        config = cs().oracles[self.ticker][oracle];
    }

    /**
     * @notice Amount of shares -> amount of assets
     * @dev DO use this function when reading values storage.
     * @dev DONT use this function when writing to storage.
     * @param shares Unrebased amount to convert.
     * @return uint256 Possibly rebased amount of asset
     */
    function toDynamic(
        Asset storage self,
        uint256 shares
    ) internal view returns (uint256) {
        if (shares == 0) return 0;
        if (self.share != address(0)) {
            return IKopioShare(self.share).convertToAssets(shares);
        }
        return shares;
    }

    /**
     * @notice Amount of assets -> amount of shares
     * @dev DONT use this function when reading from storage.
     * @dev DO use this function when writing to storage.
     * @param self asset.
     * @param assets amount of assets.
     * @return uint256 amount of shares
     */
    function toStatic(
        Asset storage self,
        uint256 assets
    ) internal view returns (uint256) {
        if (assets == 0) return 0;
        if (self.share != address(0)) {
            return IKopioShare(self.share).convertToShares(assets);
        }
        return assets;
    }

    /**
     * @notice Validate debt limit is not exceeded.
     * @param self asset
     * @param addr Address of the asset minted.
     * @param amount Amount minted.
     * @dev Reverts debt limit is exceeded.
     */
    function ensureMintLimitICDP(
        Asset storage self,
        address addr,
        uint256 amount
    ) internal view {
        uint256 newSupply = getMintedSupply(self, addr) + amount;
        if (newSupply > self.mintLimit) {
            revert err.EXCEEDS_ASSET_MINTING_LIMIT(
                id(addr),
                newSupply,
                self.mintLimit
            );
        }
    }

    /**
     * @notice Get the icdp supply of a given asset
     * @param self asset
     * @param addr Address of the asset being minted.
     * @return uint256 the minted supply
     */
    function getMintedSupply(
        Asset storage self,
        address addr
    ) internal view returns (uint256) {
        if (self.share == addr) {
            return _getONESupply(addr);
        }
        return _getSupply(addr, self.share);
    }

    function _getSupply(
        address asset,
        address _share
    ) private view returns (uint256) {
        IKopioShare share = IKopioShare(_share);
        uint256 supply = share.totalSupply() -
            share.balanceOf(asset) -
            scdp().assetData[asset].debt;
        if (supply == 0) return 0;
        return share.convertToAssets(supply);
    }

    function _getONESupply(address asset) private view returns (uint256) {
        return
            IERC20(asset).totalSupply() -
            (IERC20(IONE(asset).vault()).balanceOf(asset) +
                scdp().assetData[asset].debt);
    }
}

// src/contracts/core/common/funcs/Prices.sol

using WadRay for uint256;
using PercentageMath for uint256;
using Strings for bytes32;

/* -------------------------------------------------------------------------- */
/*                                   Getters                                  */
/* -------------------------------------------------------------------------- */

/**
 * @notice Gets the oracle price using safety checks for deviation and sequencer uptime
 * @notice Reverts when price deviates more than `_oracleDeviationPct`
 * @notice Allows stale price when market is closed, market status must be checked before calling this function if needed.
 * @param _ticker Ticker of the price
 * @param _oracles The list of oracle identifiers
 * @param _oracleDeviationPct the deviation percentage
 */
function safePrice(
    bytes32 _ticker,
    Enums.OracleType[2] memory _oracles,
    uint256 _oracleDeviationPct
) view returns (uint256) {
    Oracle memory primaryConfig = cs().oracles[_ticker][_oracles[0]];
    Oracle memory referenceConfig = cs().oracles[_ticker][_oracles[1]];

    bool isClosed = (primaryConfig.isClosable || referenceConfig.isClosable) &&
        !IMarketStatus(cs().marketStatusProvider).getTickerStatus(_ticker);

    uint256 primaryPrice = oraclePrice(
        _oracles[0],
        primaryConfig,
        _ticker,
        isClosed
    );
    uint256 referencePrice = oraclePrice(
        _oracles[1],
        referenceConfig,
        _ticker,
        isClosed
    );

    if (primaryPrice == 0 && referencePrice == 0) {
        revert err.ZERO_OR_STALE_PRICE(
            _ticker.toString(),
            [uint8(_oracles[0]), uint8(_oracles[1])]
        );
    }

    // Enums.OracleType.Vault uses the same check, reverting if the sequencer is down.
    if (
        !isSequencerUp(cs().sequencerUptimeFeed, cs().sequencerGracePeriodTime)
    ) {
        revert err.L2_SEQUENCER_DOWN();
    }

    return deducePrice(primaryPrice, referencePrice, _oracleDeviationPct);
}

/**
 * @notice Call the price getter for the oracle provided and return the price.
 * @param _oracleId The oracle id (uint8).
 * @param _ticker Ticker for the asset
 * @param _allowStale Flag to allow stale price in the case when market is closed.
 * @return uint256 oracle price.
 * This will return 0 if the oracle is not set.
 */
function oraclePrice(
    Enums.OracleType _oracleId,
    Oracle memory _config,
    bytes32 _ticker,
    bool _allowStale
) view returns (uint256) {
    if (_oracleId == Enums.OracleType.Empty) return 0;

    uint256 staleTime = !_allowStale ? _config.staleTime : 4 days;

    if (_oracleId == Enums.OracleType.Pyth)
        return pythPrice(_config.pythId, _config.invertPyth, staleTime);

    if (_oracleId == Enums.OracleType.Chainlink) {
        return aggregatorV3Price(_config.feed, staleTime);
    }

    if (_oracleId == Enums.OracleType.Vault) {
        return vaultPrice(_config.feed);
    }

    if (_oracleId == Enums.OracleType.API3) {
        return API3Price(_config.feed, staleTime);
    }

    // Revert if no answer is found
    revert err.UNSUPPORTED_ORACLE(_ticker.toString(), uint8(_oracleId));
}

/**
 * @notice Checks the primary and reference price for deviations.
 * @notice Reverts if the price deviates more than `_oracleDeviationPct`
 * @param _primaryPrice the primary price source to use
 * @param _referencePrice the reference price to compare primary against
 * @param _oracleDeviationPct the deviation percentage to use for the oracle
 * @return uint256 Primary price if its within deviation range of reference price.
 * = the primary price is reference price is 0.
 * = the reference price if primary price is 0.
 * = reverts if price deviates more than `_oracleDeviationPct`
 */
function deducePrice(
    uint256 _primaryPrice,
    uint256 _referencePrice,
    uint256 _oracleDeviationPct
) pure returns (uint256) {
    if (_referencePrice == 0 && _primaryPrice != 0) return _primaryPrice;
    if (_primaryPrice == 0 && _referencePrice != 0) return _referencePrice;
    if (
        (_referencePrice.percentMul(1e4 - _oracleDeviationPct) <=
            _primaryPrice) &&
        (_referencePrice.percentMul(1e4 + _oracleDeviationPct) >= _primaryPrice)
    ) {
        return _primaryPrice;
    }

    // Revert if price deviates more than `_oracleDeviationPct`
    revert err.PRICE_UNSTABLE(
        _primaryPrice,
        _referencePrice,
        _oracleDeviationPct
    );
}

function pythPrice(
    bytes32 _id,
    bool _invert,
    uint256 _staleTime
) view returns (uint256 price_) {
    Price memory result = IPyth(cs().pythEp).getPriceNoOlderThan(
        _id,
        _staleTime
    );

    if (!_invert) {
        price_ = normalizePythPrice(result, cs().oracleDecimals);
    } else {
        price_ = invertNormalizePythPrice(result, cs().oracleDecimals);
    }

    if (price_ == 0 || price_ > type(uint56).max) {
        revert err.INVALID_PYTH_PRICE(_id, price_);
    }
}

function normalizePythPrice(
    Price memory _price,
    uint8 oracleDec
) pure returns (uint256) {
    uint256 result = uint64(_price.price);
    uint256 exp = uint32(-_price.expo);
    if (exp > oracleDec) {
        result = result / 10 ** (exp - oracleDec);
    }
    if (exp < oracleDec) {
        result = result * 10 ** (oracleDec - exp);
    }

    return result;
}

function invertNormalizePythPrice(
    Price memory _price,
    uint8 oracleDec
) pure returns (uint256) {
    _price.price = int64(
        uint64(1 * (10 ** uint32(-_price.expo)).wadDiv(uint64(_price.price)))
    );
    _price.expo = -18;
    return normalizePythPrice(_price, oracleDec);
}

/**
 * @notice Gets the price from the provided vault.
 * @dev Vault exchange rate is in 18 decimal precision so we normalize to 8 decimals.
 * @param _vaultAddr The vault address.
 * @return uint256 The price of the vault share in 8 decimal precision.
 */
function vaultPrice(address _vaultAddr) view returns (uint256) {
    return
        fromWad(
            IVaultRateProvider(_vaultAddr).exchangeRate(),
            cs().oracleDecimals
        );
}

/// @notice Get the price of SDI in USD (WAD precision, so 18 decimals).
function SDIPrice() view returns (uint256) {
    uint256 totalValue = scdp().totalDebtValueAtRatioSCDP(
        Percents.HUNDRED,
        false
    );
    if (totalValue == 0) {
        return 1e18;
    }
    return toWad_0(totalValue, cs().oracleDecimals).wadDiv(sdi().totalDebt);
}

/**
 * @notice Gets answer from AggregatorV3 type feed.
 * @param _feedAddr The feed address.
 * @param _staleTime Time in seconds for the feed to be considered stale.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function aggregatorV3Price(
    address _feedAddr,
    uint256 _staleTime
) view returns (uint256) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_feedAddr)
        .latestRoundData();
    if (answer < 0) {
        revert err.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // IMPORTANT: Returning zero when answer is stale, to activate fallback oracle.
    if (block.timestamp - updatedAt > _staleTime) {
        revert err.STALE_ORACLE(
            uint8(Enums.OracleType.Chainlink),
            _feedAddr,
            block.timestamp - updatedAt,
            _staleTime
        );
    }
    return uint256(answer);
}

/**
 * @notice Gets answer from IAPI3 type feed.
 * @param _feedAddr The feed address.
 * @param _staleTime Staleness threshold.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function API3Price(
    address _feedAddr,
    uint256 _staleTime
) view returns (uint256) {
    (int256 answer, uint256 updatedAt) = IAPI3(_feedAddr).read();
    if (answer < 0) {
        revert err.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // IMPORTANT: Returning zero when answer is stale, to activate fallback oracle.
    if (block.timestamp - updatedAt > _staleTime) {
        revert err.STALE_ORACLE(
            uint8(Enums.OracleType.API3),
            _feedAddr,
            block.timestamp - updatedAt,
            _staleTime
        );
    }
    return fromWad(uint256(answer), cs().oracleDecimals); // API3 returns 18 decimals always.
}

/* -------------------------------------------------------------------------- */
/*                                    Util                                    */
/* -------------------------------------------------------------------------- */

/**
 * @notice Gets raw answer info from AggregatorV3 type feed.
 * @param _config Configuration for the oracle.
 * @return RawPrice Unparsed answer with metadata.
 */
function aggregatorV3RawPrice(
    Oracle memory _config
) view returns (RawPrice memory) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_config.feed)
        .latestRoundData();
    bool isStale = block.timestamp - updatedAt > _config.staleTime;
    return
        RawPrice(
            answer,
            updatedAt,
            _config.staleTime,
            isStale,
            answer == 0,
            Enums.OracleType.Chainlink,
            _config.feed
        );
}

/**
 * @notice Gets raw answer info from IAPI3 type feed.
 * @param _config Configuration for the oracle.
 * @return RawPrice Unparsed answer with metadata.
 */
function API3RawPrice(Oracle memory _config) view returns (RawPrice memory) {
    (int256 answer, uint256 updatedAt) = IAPI3(_config.feed).read();
    bool isStale = block.timestamp - updatedAt > _config.staleTime;
    return
        RawPrice(
            answer,
            updatedAt,
            _config.staleTime,
            isStale,
            answer == 0,
            Enums.OracleType.API3,
            _config.feed
        );
}

/**
 * @notice Return raw answer info from the oracles provided
 * @param _oracles Oracles to check.
 * @param _ticker Ticker for the asset.
 * @return RawPrice Unparsed answer with metadata.
 */
function pushPrice(
    Enums.OracleType[2] memory _oracles,
    bytes32 _ticker
) view returns (RawPrice memory) {
    for (uint256 i; i < _oracles.length; i++) {
        Enums.OracleType oracleType = _oracles[i];
        Oracle storage oracle = cs().oracles[_ticker][_oracles[i]];

        if (oracleType == Enums.OracleType.Chainlink)
            return aggregatorV3RawPrice(oracle);
        if (oracleType == Enums.OracleType.API3) return API3RawPrice(oracle);
        if (oracleType == Enums.OracleType.Vault) {
            int256 answer = int256(vaultPrice(oracle.feed));
            return
                RawPrice(
                    answer,
                    block.timestamp,
                    0,
                    false,
                    answer == 0,
                    Enums.OracleType.Vault,
                    oracle.feed
                );
        }
    }

    // Revert if no answer is found
    revert err.NO_PUSH_ORACLE_SET(_ticker.toString());
}

function viewPrice(
    bytes32 _ticker,
    PythView calldata views
) view returns (RawPrice memory) {
    Oracle memory config;

    if (_ticker == "ONE") {
        config = cs().oracles[_ticker][Enums.OracleType.Vault];
        int256 answer = int256(vaultPrice(config.feed));
        return
            RawPrice(
                answer,
                block.timestamp,
                0,
                false,
                answer == 0,
                Enums.OracleType.Vault,
                config.feed
            );
    }

    config = cs().oracles[_ticker][Enums.OracleType.Pyth];

    for (uint256 i; i < views.ids.length; i++) {
        if (views.ids[i] == config.pythId) {
            Price memory _price = views.prices[i];
            RawPrice memory result = RawPrice(
                int256(
                    !config.invertPyth
                        ? normalizePythPrice(_price, cs().oracleDecimals)
                        : invertNormalizePythPrice(_price, cs().oracleDecimals)
                ),
                _price.publishTime,
                config.staleTime,
                false,
                _price.price == 0,
                Enums.OracleType.Pyth,
                address(0)
            );
            return result;
        }
    }

    revert err.NO_VIEW_PRICE_AVAILABLE(_ticker.toString());
}

// src/contracts/core/common/funcs/Utils.sol

using PercentageMath for uint256;
using WadRay for uint256;

/**
 * @notice Checks if the L2 sequencer is up.
 * 1 means the sequencer is down, 0 means the sequencer is up.
 * @param _uptimeFeed The address of the uptime feed.
 * @param _gracePeriod The grace period in seconds.
 * @return bool returns true/false if the sequencer is up/not.
 */
function isSequencerUp(
    address _uptimeFeed,
    uint256 _gracePeriod
) view returns (bool) {
    bool up = true;
    if (_uptimeFeed != address(0)) {
        (, int256 answer, uint256 startedAt, , ) = IAggregatorV3(_uptimeFeed)
            .latestRoundData();

        up = answer == 0;
        if (!up) {
            return false;
        }
        // Make sure the grace period has passed after the
        // sequencer is back up.
        if (block.timestamp - startedAt < _gracePeriod) {
            return false;
        }
    }
    return up;
}

/**
 * If update data exists, updates the prices in the pyth endpoint. Does nothing when data is empty.
 * @param _updateData The update data.
 * @dev Reverts if msg.value does not match the update fee required.
 * @dev Sending empty data + non-zero msg.value should be handled by the caller.
 */
function handlePythUpdate(bytes[] calldata _updateData) {
    if (_updateData.length == 0) {
        return;
    }

    IPyth pythEp = IPyth(cs().pythEp);
    uint256 updateFee = pythEp.getUpdateFee(_updateData);

    if (msg.value > updateFee) {
        revert err.UPDATE_FEE_OVERFLOW(msg.value, updateFee);
    }

    pythEp.updatePriceFeeds{value: updateFee}(_updateData);
}

// src/contracts/core/icdp/State.sol

using MAccounts for ICDPState global;
using MCore for ICDPState global;

/**
 * @title Storage for the ICDP.
 * @author the kopio project
 */
struct ICDPState {
    mapping(address account => address[]) collateralsOf;
    mapping(address account => mapping(address collateral => uint256)) deposits;
    mapping(address account => mapping(address kopio => uint256)) debt;
    mapping(address account => address[]) mints;
    /* --------------------------------- Assets --------------------------------- */
    address[] kopios;
    address[] collaterals;
    address feeRecipient;
    /// @notice max liquidation ratio, this is the max collateral ratio liquidations can liquidate to.
    uint32 maxLiquidationRatio;
    /// @notice minimum ratio of collateral to debt that can be taken by direct action.
    uint32 minCollateralRatio;
    /// @notice collateralization ratio at which positions may be liquidated.
    uint32 liquidationThreshold;
    /// @notice minimum debt value of a single account.
    uint256 minDebtValue;
}

// keccak256(abi.encode(uint256(keccak256("kopio.slot.icdp")) - 1)) & ~bytes32(uint256(0xff));
bytes32 constant ICDP_SLOT = 0xa8f8248bd2623d2ac4f9086213698319675a053d994914e3b428d54e1b894d00;

function ms() pure returns (ICDPState storage state) {
    bytes32 position = ICDP_SLOT;
    assembly {
        state.slot := position
    }
}

// src/contracts/core/icdp/funcs/Accounts.sol

library MAccounts {
    using WadRay for uint256;
    using PercentageMath for uint256;
    using Arrays for address[];

    /**
     * @notice Checks if accounts collateral value is less than required.
     * @notice Reverts if account is not liquidatable.
     * @param acc Account to check.
     */
    function checkAccountLiquidatable(
        ICDPState storage self,
        address acc
    ) internal view {
        uint256 collateralValue = self.accountTotalCollateralValue(acc);
        uint256 minCollateralValue = self.accountMinCollateralAtRatio(
            acc,
            self.liquidationThreshold
        );
        if (collateralValue >= minCollateralValue) {
            revert err.NOT_LIQUIDATABLE(
                acc,
                collateralValue,
                minCollateralValue,
                self.liquidationThreshold
            );
        }
    }

    /**
     * @notice Gets the liquidatable status of an account.
     * @param acc Account to check.
     * @return bool Indicating if the account is liquidatable.
     */
    function isAccountLiquidatable(
        ICDPState storage self,
        address acc
    ) internal view returns (bool) {
        return
            self.accountTotalCollateralValue(acc) <
            self.accountMinCollateralAtRatio(acc, self.liquidationThreshold);
    }

    /**
     * @notice verifies that the account has enough collateral value
     * @param acc The address of the account to verify the collateral for.
     */
    function checkAccountCollateral(
        ICDPState storage self,
        address acc
    ) internal view {
        uint256 collateralValue = self.accountTotalCollateralValue(acc);
        // Get the account's minimum collateral value.
        uint256 minCollateralValue = self.accountMinCollateralAtRatio(
            acc,
            self.minCollateralRatio
        );

        if (collateralValue < minCollateralValue) {
            revert err.ACCOUNT_COLLATERAL_TOO_LOW(
                acc,
                collateralValue,
                minCollateralValue,
                self.minCollateralRatio
            );
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                                Account Debt                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Gets the total debt value in USD for an account.
     * @param acc Account to calculate the kopio value for.
     * @return value Total asset debt value of `acc`.
     */
    function accountTotalDebtValue(
        ICDPState storage self,
        address acc
    ) internal view returns (uint256 value) {
        address[] memory assets = self.mints[acc];
        for (uint256 i; i < assets.length; ) {
            Asset storage cfg = cs().assets[assets[i]];
            uint256 debt = self.accountDebtAmount(acc, assets[i], cfg);
            unchecked {
                if (debt != 0) {
                    value += cfg.toDebtValue(debt, false);
                }
                i++;
            }
        }
        return value;
    }

    /**
     * @notice Gets `acc` debt for `_asset`
     * @dev Principal debt is rebase adjusted due to possible stock splits/reverse splits
     * @param acc account to get debt amount for.
     * @param asset kopio address
     * @param cfg configuration of the asset
     * @return debtAmount debt `acc` has for `_asset`
     */
    function accountDebtAmount(
        ICDPState storage self,
        address acc,
        address asset,
        Asset storage cfg
    ) internal view returns (uint256 debtAmount) {
        return cfg.toDynamic(self.debt[acc][asset]);
    }

    /**
     * @notice Gets an array of assets the account has minted.
     * @param acc Account to get the minted assets for.
     * @return address[] of assets the account has minted.
     */
    function accountDebtAssets(
        ICDPState storage self,
        address acc
    ) internal view returns (address[] memory) {
        return self.mints[acc];
    }

    /**
     * @notice Gets accounts min collateral value required to cover debt at a given collateralization ratio.
     * @notice Account with min collateral value under MCR cannot borrow.
     * @notice Account with min collateral value under LT can be liquidated up to maxLiquidationRatio.
     * @param acc Account to calculate the minimum collateral value for.
     * @param ratio Collateralization ratio to apply for the minimum collateral value.
     * @return uint256 Minimum collateral value required for the account with `ratio`.
     */
    function accountMinCollateralAtRatio(
        ICDPState storage self,
        address acc,
        uint32 ratio
    ) internal view returns (uint256) {
        return self.accountTotalDebtValue(acc).percentMul(ratio);
    }

    /* -------------------------------------------------------------------------- */
    /*                             Account Collateral                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Gets the array of collateral assets the account has deposited.
     * @param acc Account to get the deposited collateral assets for.
     * @return address[] deposited collaterals for `acc`.
     */
    function accountCollateralAssets(
        ICDPState storage self,
        address acc
    ) internal view returns (address[] memory) {
        return self.collateralsOf[acc];
    }

    /**
     * @notice Gets the deposit amount for an account
     * @notice Performs rebasing conversion if necessary
     * @param acc account
     * @param asset the collateral asset
     * @param cfg asset configuration
     * @return uint256 Collateral deposit amount of `_asset` for `acc`
     */
    function accountCollateralAmount(
        ICDPState storage self,
        address acc,
        address asset,
        Asset storage cfg
    ) internal view returns (uint256) {
        return cfg.toDynamic(self.deposits[acc][asset]);
    }

    /**
     * @notice Gets the collateral value of an account.
     * @param acc Account to get the value for
     * @return totalValue of a particular account.
     */
    function accountTotalCollateralValue(
        ICDPState storage self,
        address acc
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collateralsOf[acc];
        for (uint256 i; i < assets.length; ) {
            Asset storage cfg = cs().assets[assets[i]];
            uint256 amount = self.accountCollateralAmount(acc, assets[i], cfg);
            unchecked {
                if (amount != 0) {
                    totalValue += cfg.toCollateralValue(amount, false);
                }
                i++;
            }
        }

        return totalValue;
    }

    /**
     * @notice Gets the total collateral deposits value of an account while extracting value for `collateral`.
     * @param acc Account to calculate the collateral value for.
     * @param collateral Collateral asset to extract value for.
     * @return totalValue Total collateral value of `acc`
     * @return assetValue Collateral value of `collateral` for `acc`
     */
    function accountTotalCollateralValue(
        ICDPState storage self,
        address acc,
        address collateral
    ) internal view returns (uint256 totalValue, uint256 assetValue) {
        address[] memory assets = self.collateralsOf[acc];
        for (uint256 i; i < assets.length; ) {
            Asset storage cfg = cs().assets[assets[i]];
            uint256 amount = self.accountCollateralAmount(acc, assets[i], cfg);

            unchecked {
                if (amount != 0) {
                    uint256 value = cfg.toCollateralValue(amount, false);
                    totalValue += value;
                    if (assets[i] == collateral) assetValue = value;
                }
                i++;
            }
        }
    }

    /**
     * @notice Gets the deposit index of the asset for the account.
     * @param acc account
     * @param collateral the asset deposited
     * @return uint256 index of the asset or revert.
     */
    function accountDepositIndex(
        ICDPState storage self,
        address acc,
        address collateral
    ) internal view returns (uint256) {
        Arrays.FindResult memory item = self.collateralsOf[acc].find(
            collateral
        );
        if (!item.exists) {
            revert err.NOT_DEPOSITED(
                acc,
                id(collateral),
                self.collateralsOf[acc]
            );
        }
        return item.index;
    }

    /**
     * @notice Gets the mint index for an asset the account has minted.
     * @param acc account
     * @param asset the minted asset
     * @return uint256 index of the asset or revert.
     */
    function accountMintIndex(
        ICDPState storage self,
        address acc,
        address asset
    ) internal view returns (uint256) {
        Arrays.FindResult memory item = self.mints[acc].find(asset);
        if (!item.exists) {
            revert err.NOT_MINTED(acc, id(asset), self.mints[acc]);
        }
        return item.index;
    }
}

// src/contracts/core/icdp/funcs/Core.sol

library MCore {
    using Arrays for address[];
    using WadRay for uint256;

    function mint(
        ICDPState storage s,
        Asset storage a,
        address asset,
        address account,
        uint256 amount,
        address to
    ) internal {
        unchecked {
            a.ensureMintLimitICDP(asset, amount);
            // Mint and record it.
            uint256 minted = mintAssets(
                amount,
                to == address(0) ? account : to,
                a.share
            );
            uint256 debt = (s.debt[account][asset] += minted);
            // The synthetic asset debt position must be greater than the minimum debt position value
            a.ensureMinDebtValue(asset, debt);

            // If this is the first time the account mints this asset, add to its minted assets
            if (debt == minted) s.mints[account].pushUnique(asset);
        }
    }

    function burn(
        ICDPState storage s,
        Asset storage a,
        address asset,
        address account,
        uint256 amount,
        address from
    ) internal {
        if (
            (s.debt[account][asset] -= burnAssets(amount, from, a.share)) == 0
        ) {
            s.mints[account].removeAddress(asset);
        }
    }

    /**
     * @notice Records a collateral deposit.
     * @param cfg asset configuration
     * @param acc account receiving the deposit.
     * @param collateral address of the asset.
     * @param amount amount to deposit
     */
    function handleDeposit(
        ICDPState storage self,
        Asset storage cfg,
        address acc,
        address collateral,
        uint256 amount
    ) internal {
        if (amount == 0) revert err.ZERO_DEPOSIT(id(collateral));

        unchecked {
            uint256 stored = cfg.toStatic(amount);
            uint256 deposits = (self.deposits[acc][collateral] += stored);

            // ensure new amount is not < 1e12
            cfg.ensureMinCollateralAmount(collateral, deposits);
            if (deposits == stored)
                self.collateralsOf[acc].pushUnique(collateral);
        }

        emit MEvent.CollateralDeposited(acc, collateral, amount);
    }

    /**
     * @notice Verifies that account has enough collateral for the withdrawal and then records it
     * @param cfg asset configuration
     * @param acc the account withdrawing.
     * @param collateral asset withdrawn
     * @param amount amount to withdraw
     * @param deposits existing deposits of the account
     */
    function handleWithdrawal(
        ICDPState storage self,
        Asset storage cfg,
        address acc,
        address collateral,
        uint256 amount,
        uint256 deposits
    ) internal {
        if (amount == 0) revert err.ZERO_WITHDRAW(id(collateral));
        uint256 newAmount = deposits - amount;

        // If no deposits remain, remove from the deposited collaterals
        if (newAmount == 0) self.collateralsOf[acc].removeAddress(collateral);
        else {
            // ensure new amount is not < 1e12
            cfg.ensureMinCollateralAmount(collateral, newAmount);
        }

        // Record the withdrawal.
        self.deposits[acc][collateral] = cfg.toStatic(newAmount);
    }
}

// src/contracts/core/scdp/State.sol

using SGlobal for SCDPState global;
using SDeposits for SCDPState global;
using SAccounts for SCDPState global;
using Swaps for SCDPState global;
using SDebtIndex for SDIState global;

/**
 * @title Storage layout for the shared cdp state
 * @author the kopio project
 */
struct SCDPState {
    /// @notice Array of deposit assets which can be swapped
    address[] collaterals;
    /// @notice Array of kopio assets which can be swapped
    address[] kopios;
    mapping(address assetIn => mapping(address assetOut => bool)) isRoute;
    mapping(address asset => bool enabled) isEnabled;
    mapping(address asset => SCDPAssetData) assetData;
    mapping(address account => mapping(address collateral => uint256 amount)) deposits;
    mapping(address account => mapping(address collateral => uint256 amount)) depositsPrincipal;
    mapping(address collateral => SCDPAssetIndexes) assetIndexes;
    mapping(address account => mapping(address collateral => SCDPAccountIndexes)) accountIndexes;
    mapping(address account => mapping(uint256 liqIndex => SCDPSeizeData)) seizeEvents;
    /// @notice current income asset
    address feeAsset;
    /// @notice minimum ratio of collateral to debt.
    uint32 minCollateralRatio;
    /// @notice collateralization ratio at which positions may be liquidated.
    uint32 liquidationThreshold;
    /// @notice limits the liquidatable value of a position to a CR.
    uint32 maxLiquidationRatio;
}

struct SDIState {
    uint256 totalDebt;
    uint256 totalCover;
    address coverRecipient;
    /// @notice Threshold after cover can be performed.
    uint48 coverThreshold;
    /// @notice Incentive for covering debt
    uint48 coverIncentive;
    address[] coverAssets;
}

// keccak256(abi.encode(uint256(keccak256("kopio.slot.scdp")) - 1)) & ~bytes32(uint256(0xff));
bytes32 constant SCDP_SLOT = 0xd405b07e7e3f6f53febc8186644ff1e0824332653a01e9279bde7f3bfc6b7600;
// keccak256(abi.encode(uint256(keccak256("kopio.slot.sdi")) - 1)) & ~bytes32(uint256(0xff));
bytes32 constant SDI_SLOT = 0x815abab76eb0df79b12d9cc625bb13a185c396fdf9ccb04c9f8a7a4e9d419600;

function scdp() pure returns (SCDPState storage state) {
    bytes32 position = SCDP_SLOT;
    assembly {
        state.slot := position
    }
}

function sdi() pure returns (SDIState storage state) {
    bytes32 position = SDI_SLOT;
    assembly {
        state.slot := position
    }
}

// src/contracts/core/scdp/funcs/Accounts.sol

library SAccounts {
    using WadRay for uint256;

    /**
     * @notice Get accounts principal deposits.
     * @notice Uses scaled deposits if its lower than principal (realizing liquidations).
     * @param _account The account to get the amount for
     * @param _assetAddr The deposit asset address
     * @param _asset The deposit asset struct
     * @return principalDeposits The principal deposit amount for the account.
     */
    function accountDeposits(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        Asset storage _asset
    ) internal view returns (uint256 principalDeposits) {
        return
            self.divByLiqIndex(
                _assetAddr,
                _asset.toDynamic(self.depositsPrincipal[_account][_assetAddr])
            );
    }

    /**
     * @notice Returns the value of the deposits for `_account`.
     * @param _account Account to get total deposit value for
     * @param _ignoreFactors Whether to ignore cFactor and dFactor
     */
    function accountDepositsValue(
        SCDPState storage self,
        address _account,
        bool _ignoreFactors
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.accountDeposits(
                _account,
                assets[i],
                asset
            );
            unchecked {
                if (depositAmount != 0) {
                    totalValue += asset.toCollateralValue(
                        depositAmount,
                        _ignoreFactors
                    );
                }
                i++;
            }
        }
    }

    /**
     * @notice Get accounts total fees gained for this asset.
     * @notice To get this value it compares deposit time liquidity index with current.
     * @notice If the account has endured liquidation events, separate logic is used to combine fees according to historical balance.
     * @param _account The account to get the amount for
     * @param _assetAddr The asset address
     * @param _asset The asset struct
     * @return feeAmount Amount of fees accrued.
     */
    function accountFees(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        Asset storage _asset
    ) internal view returns (uint256 feeAmount) {
        SCDPAssetIndexes memory assetIndexes = self.assetIndexes[_assetAddr];
        SCDPAccountIndexes memory accountIndexes = self.accountIndexes[
            _account
        ][_assetAddr];
        // Return early if there are no fees accrued.
        if (
            accountIndexes.lastFeeIndex == 0 ||
            accountIndexes.lastFeeIndex == assetIndexes.currFeeIndex
        ) return 0;

        // Get the principal deposits for the account.
        uint256 principalDeposits = _asset
            .toDynamic(self.depositsPrincipal[_account][_assetAddr])
            .wadToRay();

        // If accounts last liquidation index is lower than current, it means they endured a liquidation.
        SCDPSeizeData memory latestSeize = self.seizeEvents[_assetAddr][
            assetIndexes.currLiqIndex
        ];

        if (accountIndexes.lastLiqIndex < latestSeize.liqIndex) {
            // Accumulated fees before now and after latest seize.
            uint256 feesAfterLastSeize = principalDeposits
                .rayMul(assetIndexes.currFeeIndex - latestSeize.feeIndex)
                .rayDiv(latestSeize.liqIndex);

            uint256 feesBeforeLastSeize;
            // Just loop through all events until we hit the same index as the account.
            while (
                accountIndexes.lastLiqIndex < latestSeize.liqIndex &&
                accountIndexes.lastFeeIndex < latestSeize.feeIndex
            ) {
                SCDPSeizeData memory previousSeize = self.seizeEvents[
                    _assetAddr
                ][latestSeize.prevLiqIndex];

                if (previousSeize.liqIndex == 0) break;
                if (previousSeize.feeIndex < accountIndexes.lastFeeIndex) {
                    previousSeize.feeIndex = accountIndexes.lastFeeIndex;
                }
                uint256 feePct = latestSeize.feeIndex - previousSeize.feeIndex;
                if (feePct > 0) {
                    // Get the historical balance according to liquidation index at the time
                    // Then we simply multiply by fee index difference to get the fees accrued.
                    feesBeforeLastSeize += principalDeposits
                        .rayMul(feePct)
                        .rayDiv(latestSeize.prevLiqIndex);
                }
                // Iterate backwards in time.
                latestSeize = previousSeize;
            }

            return (feesBeforeLastSeize + feesAfterLastSeize).rayToWad();
        }

        // If we are here, it means the account has not endured a liquidation.
        // We can simply calculate the fees by multiplying the difference in fee indexes with the principal deposits.
        return
            principalDeposits
                .rayMul(assetIndexes.currFeeIndex - accountIndexes.lastFeeIndex)
                .rayDiv(assetIndexes.currLiqIndex)
                .rayToWad();
    }

    /**
     * @notice Returns the total fees value for `_account`.
     * @notice Ignores all factors.
     * @param _account Account to get fees for
     * @return totalValue Total fees value for `_account`
     */
    function accountTotalFeeValue(
        SCDPState storage self,
        address _account
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 fees = self.accountFees(_account, assets[i], asset);
            unchecked {
                if (fees != 0)
                    totalValue += asset.toCollateralValue(fees, true);
                i++;
            }
        }
    }
}

// src/contracts/core/scdp/funcs/Deposits.sol

library SDeposits {
    using WadRay for uint256;
    using WadRay for uint128;
    using SafeTransfer for IERC20;

    /**
     * @notice Records a deposit of collateral asset.
     * @notice It will withdraw any pending fees first.
     * @notice Saves global deposit amount and principal for user.
     * @param cfg Asset struct for the deposit asset
     * @param account depositor
     * @param assetAddr the deposit asset
     * @param amount amount of collateral asset to deposit
     */
    function handleDepositSCDP(
        SCDPState storage self,
        Asset storage cfg,
        address account,
        address assetAddr,
        uint256 amount
    ) internal returns (uint256 feeIndex) {
        // Withdraw any fees first.
        uint256 fees = handleFeeClaim(
            self,
            cfg,
            account,
            assetAddr,
            account,
            false
        );
        // Save account liquidation and fee indexes if they werent saved before.
        if (fees == 0) {
            (, feeIndex) = updateAccountIndexes(self, account, assetAddr);
        }

        unchecked {
            // Save global deposits using normalized amount.
            uint128 normalizedAmount = uint128(cfg.toStatic(amount));
            self.assetData[assetAddr].totalDeposits += normalizedAmount;

            // Save account deposit amount, its scaled up by the liquidation index.
            self.depositsPrincipal[account][assetAddr] += self.mulByLiqIndex(
                assetAddr,
                normalizedAmount
            );

            // Check if the deposit limit is exceeded.
            if (self.userDepositAmount(assetAddr, cfg) > cfg.depositLimitSCDP) {
                revert err.EXCEEDS_ASSET_DEPOSIT_LIMIT(
                    id(assetAddr),
                    self.userDepositAmount(assetAddr, cfg),
                    cfg.depositLimitSCDP
                );
            }
        }
    }

    /**
     * @notice Records a withdrawal of collateral asset from the SCDP.
     * @notice It will withdraw any pending fees first.
     * @notice Saves global deposit amount and principal for user.
     * @param cfg Asset struct for the deposit asset
     * @param account The withdrawing account
     * @param assetAddr the deposit asset
     * @param amount The amount of collateral to withdraw
     * @param receiver The receiver of the withdrawn fees
     * @param noClaim Emergency flag to skip claiming fees
     */
    function handleWithdrawSCDP(
        SCDPState storage self,
        Asset storage cfg,
        address account,
        address assetAddr,
        uint256 amount,
        address receiver,
        bool noClaim
    ) internal returns (uint256 feeIndex) {
        // Handle fee claiming.
        uint256 fees = handleFeeClaim(
            self,
            cfg,
            account,
            assetAddr,
            receiver,
            noClaim
        );
        // Save account liquidation and fee indexes if they werent updated on fee claim.
        if (fees == 0) {
            (, feeIndex) = updateAccountIndexes(self, account, assetAddr);
        }

        // Get accounts principal deposits.
        uint256 depositsPrincipal = self.accountDeposits(
            account,
            assetAddr,
            cfg
        );

        // Check that we can perform the withdrawal.
        if (depositsPrincipal == 0) {
            revert err.NO_DEPOSITS(account, id(assetAddr));
        }
        if (depositsPrincipal < amount) {
            revert err.NOT_ENOUGH_DEPOSITS(
                account,
                id(assetAddr),
                amount,
                depositsPrincipal
            );
        }

        unchecked {
            // Save global deposits using normalized amount.
            uint128 normalizedAmount = uint128(cfg.toStatic(amount));
            self.assetData[assetAddr].totalDeposits -= normalizedAmount;

            // Save account deposit amount, the amount withdrawn is scaled up by the liquidation index.
            self.depositsPrincipal[account][assetAddr] -= self.mulByLiqIndex(
                assetAddr,
                normalizedAmount
            );
        }
    }

    /**
     * @notice This function seizes collateral from the shared pool.
     * @notice It will reduce all deposits in the case where swap deposits do not cover the amount.
     * @notice Each event touching user deposits will save a checkpoint of the indexes.
     * @param _sAsset asset config
     * @param assetAddr seized asset.
     * @param amount amount seized
     */
    function handleSeizeSCDP(
        SCDPState storage self,
        Asset storage _sAsset,
        address assetAddr,
        uint256 amount
    ) internal returns (uint128 prevLiqIndex, uint128 newLiqIndex) {
        uint128 swapDeposits = self.swapDepositAmount(assetAddr, _sAsset);

        if (swapDeposits >= amount) {
            uint128 amountOut = uint128(_sAsset.toStatic(amount));
            // swap deposits cover the amount
            unchecked {
                self.assetData[assetAddr].swapDeposits -= amountOut;
                self.assetData[assetAddr].totalDeposits -= amountOut;
            }
        } else {
            // swap deposits do not cover the amount
            self.assetData[assetAddr].swapDeposits = 0;
            // total deposits = user deposits at this point
            self.assetData[assetAddr].totalDeposits -= uint128(
                _sAsset.toStatic(amount)
            );

            // We need this later for seize data as well.
            prevLiqIndex = self.assetIndexes[assetAddr].currLiqIndex;
            newLiqIndex = uint128(
                prevLiqIndex +
                    (amount - swapDeposits)
                        .wadToRay()
                        .rayMul(prevLiqIndex)
                        .rayDiv(
                            _sAsset.toDynamic(
                                self
                                    .assetData[assetAddr]
                                    .totalDeposits
                                    .wadToRay()
                            )
                        )
            );

            // Increase liquidation index, note this uses rebased amounts instead of normalized.
            self.assetIndexes[assetAddr].currLiqIndex = newLiqIndex;

            // Save the seize data.
            self.seizeEvents[assetAddr][
                self.assetIndexes[assetAddr].currLiqIndex
            ] = SCDPSeizeData({
                prevLiqIndex: prevLiqIndex,
                feeIndex: self.assetIndexes[assetAddr].currFeeIndex,
                liqIndex: self.assetIndexes[assetAddr].currLiqIndex
            });
        }

        IERC20(assetAddr).safeTransfer(msg.sender, amount);
        return (prevLiqIndex, self.assetIndexes[assetAddr].currLiqIndex);
    }

    /**
     * @notice Fully handles fee claim.
     * @notice Checks whether some fees exists, withdrawis them and updates account indexes.
     * @param cfg The asset struct.
     * @param account The account to withdraw fees for.
     * @param assetAddr The asset address.
     * @param receiver Receiver of fees withdrawn, if 0 then the receiver is the account.
     * @param _skip Emergency flag, skips claiming fees due and logs a receipt for off-chain processing
     * @return feeAmount Amount of fees withdrawn.
     * @dev This function is used by deposit and withdraw functions.
     */
    function handleFeeClaim(
        SCDPState storage self,
        Asset storage cfg,
        address account,
        address assetAddr,
        address receiver,
        bool _skip
    ) internal returns (uint256 feeAmount) {
        if (_skip) {
            _logFeeReceipt(self, account, assetAddr);
            return 0;
        }
        uint256 fees = self.accountFees(account, assetAddr, cfg);
        if (fees > 0) {
            (uint256 prevIndex, uint256 newIndex) = updateAccountIndexes(
                self,
                account,
                assetAddr
            );
            IERC20(assetAddr).transfer(receiver, fees);
            emit SEvent.SCDPFeeClaim(
                account,
                receiver,
                assetAddr,
                fees,
                newIndex,
                prevIndex,
                block.timestamp
            );
        }

        return fees;
    }

    function _logFeeReceipt(
        SCDPState storage self,
        address account,
        address assetAddr
    ) private {
        emit SEvent.SCDPFeeReceipt(
            account,
            assetAddr,
            self.depositsPrincipal[account][assetAddr],
            self.assetIndexes[assetAddr].currFeeIndex,
            self.accountIndexes[account][assetAddr].lastFeeIndex,
            self.assetIndexes[assetAddr].currLiqIndex,
            self.accountIndexes[account][assetAddr].lastLiqIndex,
            block.number,
            block.timestamp
        );
    }

    /**
     * @notice Updates account indexes to checkpoint the fee index and liquidation index at the time of action.
     * @param account The account to update indexes for.
     * @param assetAddr The asset being withdrawn/deposited.
     * @dev This function is used by deposit and withdraw functions.
     */
    function updateAccountIndexes(
        SCDPState storage self,
        address account,
        address assetAddr
    ) private returns (uint128 prevIndex, uint128 newIndex) {
        prevIndex = self.accountIndexes[account][assetAddr].lastFeeIndex;
        newIndex = self.assetIndexes[assetAddr].currFeeIndex;
        self.accountIndexes[account][assetAddr].lastFeeIndex = self
            .assetIndexes[assetAddr]
            .currFeeIndex;
        self.accountIndexes[account][assetAddr].lastLiqIndex = self
            .assetIndexes[assetAddr]
            .currLiqIndex;
        self.accountIndexes[account][assetAddr].timestamp = block.timestamp;
    }

    function mulByLiqIndex(
        SCDPState storage self,
        address assetAddr,
        uint256 amount
    ) internal view returns (uint128) {
        return
            uint128(
                amount
                    .wadToRay()
                    .rayMul(self.assetIndexes[assetAddr].currLiqIndex)
                    .rayToWad()
            );
    }

    function divByLiqIndex(
        SCDPState storage self,
        address assetAddr,
        uint256 _depositAmount
    ) internal view returns (uint128) {
        return
            uint128(
                _depositAmount
                    .wadToRay()
                    .rayDiv(self.assetIndexes[assetAddr].currLiqIndex)
                    .rayToWad()
            );
    }
}

// src/contracts/core/scdp/funcs/Global.sol

library SGlobal {
    using WadRay for uint256;
    using WadRay for uint128;
    using PercentageMath for uint256;

    /**
     * @notice Checks whether the shared debt pool can be liquidated.
     * @notice Reverts if collateral value .
     */
    function ensureLiquidatableSCDP(SCDPState storage self) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            self.liquidationThreshold
        );
        if (collateralValue >= minCollateralValue) {
            revert err.COLLATERAL_VALUE_GREATER_THAN_REQUIRED(
                collateralValue,
                minCollateralValue,
                self.liquidationThreshold
            );
        }
    }

    /**
     * @notice Checks whether the shared debt pool can be liquidated.
     * @notice Reverts if collateral value .
     */
    function checkCoverableSCDP(SCDPState storage self) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCoverValue = sdi().effectiveDebtValue().percentMul(
            sdi().coverThreshold
        );
        if (collateralValue >= minCoverValue) {
            revert err.COLLATERAL_VALUE_GREATER_THAN_COVER_THRESHOLD(
                collateralValue,
                minCoverValue,
                sdi().coverThreshold
            );
        }
    }

    /**
     * @notice Checks whether the collateral value is less than minimum required.
     * @notice Reverts when collateralValue is below minimum required.
     * @param _ratio Ratio to check in 1e4 percentage precision (uint32).
     */
    function ensureCollateralRatio(
        SCDPState storage self,
        uint32 _ratio
    ) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            _ratio
        );
        if (collateralValue < minCollateralValue) {
            revert err.COLLATERAL_TOO_LOW(
                collateralValue,
                minCollateralValue,
                _ratio
            );
        }
    }

    /**
     * @notice Returns the value of the kopio held in the pool at a ratio.
     * @param _ratio Percentage ratio to apply for the value in 1e4 percentage precision (uint32).
     * @param noFactors Whether to ignore dFactor
     * @return totalValue Total value in USD
     */
    function totalDebtValueAtRatioSCDP(
        SCDPState storage self,
        uint32 _ratio,
        bool noFactors
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.kopios;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 debtAmount = asset.toDynamic(
                self.assetData[assets[i]].debt
            );
            unchecked {
                if (debtAmount != 0) {
                    totalValue += asset.toDebtValue(debtAmount, noFactors);
                }
                i++;
            }
        }

        // Multiply if needed
        if (_ratio != Percents.HUNDRED) {
            totalValue = totalValue.percentMul(_ratio);
        }
    }

    /**
     * @notice Calculates the total collateral value of collateral assets in the pool.
     * @param noFactors Whether to ignore cFactor.
     * @return totalValue Total value in USD
     */
    function totalCollateralValueSCDP(
        SCDPState storage self,
        bool noFactors
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.totalDepositAmount(assets[i], asset);
            if (depositAmount != 0) {
                unchecked {
                    totalValue += asset.toCollateralValue(
                        depositAmount,
                        noFactors
                    );
                }
            }

            unchecked {
                i++;
            }
        }
    }

    /**
     * @notice Calculates total collateral value while extracting single asset value.
     * @param _collateralAsset Collateral asset to extract value for
     * @param noFactors Whether to ignore cFactor.
     * @return totalValue Total value in USD
     * @return assetValue Asset value in USD
     */
    function totalCollateralValueSCDP(
        SCDPState storage self,
        address _collateralAsset,
        bool noFactors
    ) internal view returns (uint256 totalValue, uint256 assetValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.totalDepositAmount(assets[i], asset);
            unchecked {
                if (depositAmount != 0) {
                    uint256 value = asset.toCollateralValue(
                        depositAmount,
                        noFactors
                    );
                    totalValue += value;
                    if (assets[i] == _collateralAsset) {
                        assetValue = value;
                    }
                }
                i++;
            }
        }
    }

    /**
     * @notice Get pool collateral deposits of an asset.
     * @param _assetAddress The asset address
     * @param _asset The asset struct
     * @return Effective collateral deposit amount for this asset.
     */
    function totalDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint128) {
        return
            uint128(
                _asset.toDynamic(self.assetData[_assetAddress].totalDeposits)
            );
    }

    /**
     * @notice Get pool user collateral deposits of an asset.
     * @param _assetAddress The asset address
     * @param _asset The asset struct
     * @return Collateral deposits originating from users.
     */
    function userDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint256) {
        return
            _asset.toDynamic(self.assetData[_assetAddress].totalDeposits) -
            _asset.toDynamic(self.assetData[_assetAddress].swapDeposits);
    }

    /**
     * @notice Get "swap" collateral deposits.
     * @param _assetAddress The asset address
     * @param _asset The asset struct.
     * @return Amount of debt.
     */
    function swapDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint128) {
        return
            uint128(
                _asset.toDynamic(self.assetData[_assetAddress].swapDeposits)
            );
    }
}

// src/contracts/core/scdp/funcs/SDI.sol

library SDebtIndex {
    using SafeTransfer for IERC20;
    using WadRay for uint256;

    function cover(
        SDIState storage self,
        address asset,
        uint256 amount,
        uint256 value
    ) internal {
        scdp().checkCoverableSCDP();
        if (amount == 0) revert err.ZERO_AMOUNT(id(asset));

        IERC20(asset).safeTransferFrom(msg.sender, self.coverRecipient, amount);
        self.totalCover += valueToSDI(value);
    }

    function valueToSDI(uint256 valueWad) internal view returns (uint256) {
        return toWad_0(valueWad, cs().oracleDecimals).wadDiv(SDIPrice());
    }

    /// @notice Returns the total effective debt amount of the SCDP.
    function effectiveDebt(
        SDIState storage self
    ) internal view returns (uint256) {
        uint256 currentCover = self.totalCoverAmount();
        uint256 totalDebt = self.totalDebt;
        if (currentCover >= totalDebt) {
            return 0;
        }
        return (totalDebt - currentCover);
    }

    /// @notice Returns the total effective debt value of the SCDP.
    /// @notice Calculation is done in wad precision but returned as oracle precision.
    function effectiveDebtValue(
        SDIState storage self
    ) internal view returns (uint256 result) {
        uint256 sdiPrice = SDIPrice();
        uint256 coverValue = self.totalCoverValue();
        uint256 coverAmount = coverValue != 0 ? coverValue.wadDiv(sdiPrice) : 0;
        uint256 totalDebt = self.totalDebt;

        if (coverAmount >= totalDebt) return 0;

        if (coverValue == 0) {
            result = totalDebt;
        } else {
            result = (totalDebt - coverAmount);
        }

        return fromWad(result.wadMul(sdiPrice), cs().oracleDecimals);
    }

    function totalCoverAmount(
        SDIState storage self
    ) internal view returns (uint256) {
        return self.totalCoverValue().wadDiv(SDIPrice());
    }

    /// @notice Gets the total cover debt value, wad precision
    function totalCoverValue(
        SDIState storage self
    ) internal view returns (uint256 result) {
        address[] memory assets = self.coverAssets;
        for (uint256 i; i < assets.length; ) {
            unchecked {
                result += coverAssetValue(self, assets[i]);
                i++;
            }
        }
    }

    /// @notice Simply returns the total supply of SDI.
    function totalSDI(SDIState storage self) internal view returns (uint256) {
        return self.totalDebt + self.totalCoverAmount();
    }

    /// @notice Get total deposit value of `asset` in USD, wad precision.
    function coverAssetValue(
        SDIState storage self,
        address asset
    ) internal view returns (uint256) {
        uint256 bal = IERC20(asset).balanceOf(self.coverRecipient);
        if (bal == 0) return 0;

        Asset storage cfg = cs().assets[asset];
        if (!cfg.isCoverAsset) return 0;

        return wadUSD(bal, cfg.decimals, cfg.price(), cs().oracleDecimals);
    }
}

// src/contracts/core/scdp/funcs/Swap.sol

library Swaps {
    using WadRay for uint256;
    using WadRay for uint128;
    using SafeTransfer for IERC20;

    /**
     * @notice Records the assets received from account in a swap.
     * Burning any existing shared debt or increasing collateral deposits.
     * @param addrIn The asset received.
     * @param assetIn The asset in struct.
     * @param amtIn The amount of the asset received.
     * @param burnFrom The account that holds the assets to burn.
     * @return The value of the assets received into the protocol, used to calculate assets out.
     */
    function handleAssetsIn(
        SCDPState storage self,
        address addrIn,
        Asset storage assetIn,
        uint256 amtIn,
        address burnFrom
    ) internal returns (uint256) {
        SCDPAssetData storage assetData = self.assetData[addrIn];
        uint256 debt = assetIn.toDynamic(assetData.debt);

        uint256 collateralIn; // assets used increase "swap" owned collateral
        uint256 debtOut; // assets used to burn debt

        if (debt < amtIn) {
            // == Debt is less than the amount received.
            // 1. Burn full debt.
            debtOut = debt;
            // 2. Increase collateral by remainder.
            unchecked {
                collateralIn = amtIn - debt;
            }
        } else {
            // == Debt is greater than the amount.
            // 1. Burn full amount received.
            debtOut = amtIn;
            // 2. No increase in collateral.
        }

        if (collateralIn > 0) {
            uint128 collateralInNormalized = uint128(
                assetIn.toStatic(collateralIn)
            );
            unchecked {
                // 1. Increase collateral deposits.
                assetData.totalDeposits += collateralInNormalized;
                // 2. Increase "swap" collateral.
                assetData.swapDeposits += collateralInNormalized;
            }
        }

        if (debtOut > 0) {
            unchecked {
                // 1. Burn debt that was repaid from the assets received.
                assetData.debt -= burnSCDP(assetIn, debtOut, burnFrom);
            }
        }

        assert(amtIn == debtOut + collateralIn);
        return assetIn.toDebtValue(amtIn, true); // ignore dFactor here
    }

    /**
     * @notice Records the assets to send out in a swap.
     * Increasing debt of the pool by minting new assets when required.
     * @param _assetOutAddr The asset to send out.
     * @param _assetOut The asset out struct.
     * @param _valueIn The value received in.
     * @param _assetsTo The asset receiver.
     * @return amountOut The amount of the asset out.
     */
    function handleAssetsOut(
        SCDPState storage self,
        address _assetOutAddr,
        Asset storage _assetOut,
        uint256 _valueIn,
        address _assetsTo
    ) internal returns (uint256 amountOut) {
        SCDPAssetData storage assetData = self.assetData[_assetOutAddr];
        uint128 swapDeposits = uint128(
            _assetOut.toDynamic(assetData.swapDeposits)
        ); // current "swap" collateral

        // Calculate amount to send out from value received in.
        amountOut = _assetOut.toDebtAmount(_valueIn, true);

        uint256 collateralOut; // decrease in "swap" collateral
        uint256 debtIn; // new debt required to mint

        if (swapDeposits < amountOut) {
            // == "Swap" owned collateral is less than requested amount.
            // 1. Issue debt for remainder.
            unchecked {
                debtIn = amountOut - swapDeposits;
            }
            // 2. Reduce "swap" owned collateral to zero.
            collateralOut = swapDeposits;
        } else {
            // == "Swap" owned collateral exceeds requested amount
            // 1. No debt issued.
            // 2. Decrease collateral by full amount.
            collateralOut = amountOut;
        }

        if (collateralOut > 0) {
            uint128 collateralOutNormalized = uint128(
                _assetOut.toStatic(collateralOut)
            );
            unchecked {
                // 1. Decrease collateral deposits.
                assetData.totalDeposits -= collateralOutNormalized;
                // 2. Decrease "swap" owned collateral.
                assetData.swapDeposits -= collateralOutNormalized;
            }
            if (_assetsTo != address(this)) {
                // 3. Transfer collateral to receiver if it is not this contract.
                IERC20(_assetOutAddr).safeTransfer(_assetsTo, collateralOut);
            }
        }

        if (debtIn > 0) {
            // 1. Issue required debt to the pool, minting new assets to receiver.
            unchecked {
                assetData.debt += mintSCDP(_assetOut, debtIn, _assetsTo);
                uint256 newTotalDebt = _assetOut.toDynamic(assetData.debt);
                if (newTotalDebt > _assetOut.mintLimitSCDP) {
                    revert err.EXCEEDS_ASSET_MINTING_LIMIT(
                        id(_assetOutAddr),
                        newTotalDebt,
                        _assetOut.mintLimitSCDP
                    );
                }
            }
        }

        assert(amountOut == debtIn + collateralOut);
    }

    /**
     * @notice Accumulates fees to deposits as a fixed, instantaneous income.
     * @param _assetAddr The asset address
     * @param _asset The asset struct
     * @param _amount The amount to accumulate
     * @return nextLiquidityIndex The next liquidity index of the reserve
     */
    function cumulateIncome(
        SCDPState storage self,
        address _assetAddr,
        Asset storage _asset,
        uint256 _amount
    ) internal returns (uint256 nextLiquidityIndex) {
        if (_amount == 0) {
            revert err.INCOME_AMOUNT_IS_ZERO(id(_assetAddr));
        }

        uint256 userDeposits = self.userDepositAmount(_assetAddr, _asset);
        if (userDeposits == 0) {
            revert err.NO_LIQUIDITY_TO_GIVE_INCOME_FOR(
                id(_assetAddr),
                userDeposits,
                self.totalDepositAmount(_assetAddr, _asset)
            );
        }

        // liquidity index increment is calculated this way: `(amount / totalLiquidity)`
        // division `amount / totalLiquidity` done in ray for precision
        unchecked {
            return (scdp().assetIndexes[_assetAddr].currFeeIndex += uint128(
                (_amount.wadToRay().rayDiv(userDeposits.wadToRay()))
            ));
        }
    }
}

// src/contracts/core/common/Validations.sol

// solhint-disable code-complexity
library Validations {
    using PercentageMath for uint256;
    using PercentageMath for uint16;
    using Strings for bytes32;

    function validatePriceDeviationPct(uint16 _deviationPct) internal pure {
        if (_deviationPct > Percents.MAX_DEVIATION) {
            revert err.INVALID_ORACLE_DEVIATION(
                _deviationPct,
                Percents.MAX_DEVIATION
            );
        }
    }

    function validateMinDebtValue(uint256 _minDebtValue) internal pure {
        if (_minDebtValue > Constants.MAX_MIN_DEBT_VALUE) {
            revert err.INVALID_MIN_DEBT(
                _minDebtValue,
                Constants.MAX_MIN_DEBT_VALUE
            );
        }
    }

    function validateFeeRecipient(address _feeRecipient) internal pure {
        if (_feeRecipient == address(0))
            revert err.INVALID_FEE_RECIPIENT(_feeRecipient);
    }

    function validateOraclePrecision(uint256 _decimalPrecision) internal pure {
        if (_decimalPrecision < Constants.MIN_ORACLE_DECIMALS) {
            revert err.INVALID_PRICE_PRECISION(
                _decimalPrecision,
                Constants.MIN_ORACLE_DECIMALS
            );
        }
    }

    function validateCoverThreshold(
        uint256 _coverThreshold,
        uint256 _mcr
    ) internal pure {
        if (_coverThreshold > _mcr) {
            revert err.INVALID_COVER_THRESHOLD(_coverThreshold, _mcr);
        }
    }

    function validateCoverIncentive(uint256 _coverIncentive) internal pure {
        if (
            _coverIncentive > Percents.MAX_LIQ_INCENTIVE ||
            _coverIncentive < Percents.HUNDRED
        ) {
            revert err.INVALID_COVER_INCENTIVE(
                _coverIncentive,
                Percents.HUNDRED,
                Percents.MAX_LIQ_INCENTIVE
            );
        }
    }

    function validateMCR(uint256 mcr, uint256 lt) internal pure {
        if (mcr < Percents.MIN_MCR) {
            revert err.INVALID_MCR(mcr, Percents.MIN_MCR);
        }
        // this should never be hit, but just in case
        if (lt >= mcr) {
            revert err.INVALID_MCR(mcr, lt);
        }
    }

    function validateLT(uint256 lt, uint256 mcr) internal pure {
        if (lt < Percents.MIN_LT || lt >= mcr) {
            revert err.INVALID_LIQ_THRESHOLD(lt, Percents.MIN_LT, mcr);
        }
    }

    function validateMLR(uint256 ratio, uint256 threshold) internal pure {
        if (ratio < threshold) {
            revert err.MLR_LESS_THAN_LT(ratio, threshold);
        }
    }

    function validateAddAssetArgs(
        address asset,
        Asset memory _config
    )
        internal
        view
        returns (string memory symbol, string memory tickerStr, uint8 decimals)
    {
        if (asset == address(0)) revert err.ZERO_ADDRESS();

        symbol = IERC20(asset).symbol();
        if (cs().assets[asset].exists())
            revert err.ASSET_EXISTS(err.ID(symbol, asset));

        tickerStr = _config.ticker.toString();
        if (_config.ticker == 0)
            revert err.INVALID_TICKER(err.ID(symbol, asset), tickerStr);

        decimals = IERC20(asset).decimals();
        validateDecimals(asset, decimals);
    }

    function validateUpdateAssetArgs(
        address assetAddr,
        Asset memory _config
    )
        internal
        view
        returns (
            string memory symbol,
            string memory tickerStr,
            Asset storage asset
        )
    {
        if (assetAddr == address(0)) revert err.ZERO_ADDRESS();

        symbol = IERC20(assetAddr).symbol();
        asset = cs().assets[assetAddr];

        if (!asset.exists()) revert err.INVALID_ASSET(assetAddr);

        tickerStr = _config.ticker.toString();
        if (_config.ticker == 0)
            revert err.INVALID_TICKER(err.ID(symbol, assetAddr), tickerStr);
    }

    function validateAsset(
        address asset,
        Asset memory _config
    ) internal view returns (bool) {
        validateCollateral(asset, _config);
        validateKopio(asset, _config);
        validateSCDPDepositable(asset, _config);
        validateSCDPKopio(asset, _config);
        validatePushPrice(asset);
        validateLiqConfig(asset);
        return true;
    }

    function validateCollateral(
        address asset,
        Asset memory _config
    ) internal view returns (bool isCollateral) {
        if (_config.isCollateral) {
            validateCFactor(asset, _config.factor);
            validateLiqIncentive(asset, _config.liqIncentive);
            return true;
        }
    }

    function validateSCDPDepositable(
        address asset,
        Asset memory _config
    ) internal view returns (bool isGlobalDepositable) {
        if (_config.isGlobalDepositable) {
            validateCFactor(asset, _config.factor);
            return true;
        }
    }

    function validateKopio(
        address asset,
        Asset memory _config
    ) internal view returns (bool isKopio) {
        if (_config.isKopio) {
            validateDFactor(asset, _config.dFactor);
            validateFees(asset, _config.openFee, _config.closeFee);
            validateContracts(asset, _config.share);
            return true;
        }
    }

    function validateSCDPKopio(
        address asset,
        Asset memory _config
    ) internal view returns (bool isSwapMintable) {
        if (_config.isSwapMintable) {
            validateFees(asset, _config.swapInFee, _config.swapOutFee);
            validateFees(
                asset,
                _config.protocolFeeShareSCDP,
                _config.protocolFeeShareSCDP
            );
            validateLiqIncentive(asset, _config.liqIncentiveSCDP);
            return true;
        }
    }

    function validateSDICoverAsset(
        address asset
    ) internal view returns (Asset storage cfg) {
        cfg = cs().assets[asset];
        if (!cfg.exists()) revert err.INVALID_ASSET(asset);
        if (cfg.isCoverAsset) revert err.ASSET_ALREADY_ENABLED(id(asset));
        validatePushPrice(asset);
    }

    function validateContracts(
        address assetAddr,
        address shareAddr
    ) internal view {
        IERC165 asset = IERC165(assetAddr);
        if (
            !asset.supportsInterface(type(IONE).interfaceId) &&
            !asset.supportsInterface(type(IKopio).interfaceId)
        ) {
            revert err.INVALID_KOPIO(id(assetAddr));
        }
        if (
            !IERC165(shareAddr).supportsInterface(
                type(IKopioIssuer).interfaceId
            )
        ) {
            revert err.INVALID_SHARE(id(shareAddr), id(assetAddr));
        }
        if (!IKopio(assetAddr).hasRole(Role.OPERATOR, address(this))) {
            revert err.INVALID_KOPIO_OPERATOR(
                id(assetAddr),
                address(this),
                IKopio(assetAddr).getRoleMember(Role.OPERATOR, 0)
            );
        }
    }

    function ensureUnique(address a, address b) internal view {
        if (a == b) revert err.IDENTICAL_ASSETS(id(a));
    }

    function validateRoute(address assetIn, address assetOut) internal view {
        if (!scdp().isRoute[assetIn][assetOut])
            revert err.SWAP_ROUTE_NOT_ENABLED(id(assetIn), id(assetOut));
    }

    function validateDecimals(address asset, uint8 dec) internal view {
        if (dec == 0) {
            revert err.INVALID_DECIMALS(id(asset), dec);
        }
    }

    function validateVaultAssetDecimals(
        address asset,
        uint8 dec
    ) internal view {
        if (dec == 0) {
            revert err.INVALID_DECIMALS(id(asset), dec);
        }
        if (dec > 18) revert err.INVALID_DECIMALS(id(asset), dec);
    }

    function validateUint128(address asset, uint256 val) internal view {
        if (val > type(uint128).max) {
            revert err.UINT128_OVERFLOW(id(asset), val, type(uint128).max);
        }
    }

    function validateCFactor(address asset, uint16 _cFactor) internal view {
        if (_cFactor > Percents.HUNDRED) {
            revert err.INVALID_CFACTOR(id(asset), _cFactor, Percents.HUNDRED);
        }
    }

    function validateDFactor(address asset, uint16 _dFactor) internal view {
        if (_dFactor < Percents.HUNDRED) {
            revert err.INVALID_DFACTOR(id(asset), _dFactor, Percents.HUNDRED);
        }
    }

    function validateFees(
        address asset,
        uint16 _fee1,
        uint16 _fee2
    ) internal view {
        if (_fee1 + _fee2 > Percents.HUNDRED) {
            revert err.INVALID_FEE(id(asset), _fee1 + _fee2, Percents.HUNDRED);
        }
    }

    function validateLiqIncentive(
        address asset,
        uint16 incentive
    ) internal view {
        if (
            incentive > Percents.MAX_LIQ_INCENTIVE ||
            incentive < Percents.MIN_LIQ_INCENTIVE
        ) {
            revert err.INVALID_LIQ_INCENTIVE(
                id(asset),
                incentive,
                Percents.MIN_LIQ_INCENTIVE,
                Percents.MAX_LIQ_INCENTIVE
            );
        }
    }

    function validateLiqConfig(address asset) internal view {
        Asset storage cfg = cs().assets[asset];
        if (cfg.isKopio) {
            address[] memory icdpCollaterals = ms().collaterals;
            for (uint256 i; i < icdpCollaterals.length; i++) {
                address collateralAddr = icdpCollaterals[i];
                Asset storage collateral = cs().assets[collateralAddr];
                validateLiquidationMarket(
                    collateralAddr,
                    collateral,
                    asset,
                    cfg
                );
                validateLiquidationMarket(
                    asset,
                    cfg,
                    collateralAddr,
                    collateral
                );
            }
        }

        if (cfg.isCollateral) {
            address[] memory minteds = ms().kopios;
            for (uint256 i; i < minteds.length; i++) {
                address assetAddr = minteds[i];
                Asset storage kopio = cs().assets[assetAddr];
                validateLiquidationMarket(asset, cfg, assetAddr, kopio);
                validateLiquidationMarket(assetAddr, kopio, asset, cfg);
            }
        }

        if (cfg.isGlobalDepositable) {
            address[] memory scdpKopios = scdp().kopios;
            for (uint256 i; i < scdpKopios.length; i++) {
                address scdpKopio = scdpKopios[i];
                Asset storage kopio = cs().assets[scdpKopio];
                validateLiquidationMarket(asset, cfg, scdpKopio, kopio);
                validateLiquidationMarket(scdpKopio, kopio, asset, cfg);
            }
        }

        if (cfg.isSwapMintable) {
            address[] memory scdpCollaterals = scdp().collaterals;
            for (uint256 i; i < scdpCollaterals.length; i++) {
                address scdpCollateralAddr = scdpCollaterals[i];
                Asset storage scdpCollateral = cs().assets[scdpCollateralAddr];
                validateLiquidationMarket(
                    asset,
                    cfg,
                    scdpCollateralAddr,
                    scdpCollateral
                );
                validateLiquidationMarket(
                    scdpCollateralAddr,
                    scdpCollateral,
                    asset,
                    cfg
                );
            }
        }
    }

    function validateLiquidationMarket(
        address seizedAddr,
        Asset storage seizeAsset,
        address repayKopio,
        Asset storage repayAsset
    ) internal view {
        if (seizeAsset.isGlobalDepositable && repayAsset.isSwapMintable) {
            uint256 seizeReductionPct = (
                repayAsset.liqIncentiveSCDP.percentMul(seizeAsset.factor)
            );
            uint256 repayIncreasePct = (
                repayAsset.dFactor.percentMul(scdp().maxLiquidationRatio)
            );
            if (seizeReductionPct >= repayIncreasePct) {
                revert err.SCDP_ASSET_ECONOMY(
                    id(seizedAddr),
                    seizeReductionPct,
                    id(repayKopio),
                    repayIncreasePct
                );
            }
        }
        if (seizeAsset.isCollateral && repayAsset.isKopio) {
            uint256 seizeReductionPct = (
                seizeAsset.liqIncentive.percentMul(seizeAsset.factor)
            ) + repayAsset.closeFee;
            uint256 repayIncreasePct = (
                repayAsset.dFactor.percentMul(ms().maxLiquidationRatio)
            );
            if (seizeReductionPct >= repayIncreasePct) {
                revert err.ICDP_ASSET_ECONOMY(
                    id(seizedAddr),
                    seizeReductionPct,
                    id(repayKopio),
                    repayIncreasePct
                );
            }
        }
    }

    function getPushOraclePrice(
        Asset storage self
    ) internal view returns (RawPrice memory) {
        return pushPrice(self.oracles, self.ticker);
    }

    function validatePushPrice(address asset) internal view {
        Asset storage cfg = cs().assets[asset];
        RawPrice memory result = getPushOraclePrice(cfg);
        if (result.answer <= 0) {
            revert err.ZERO_OR_NEGATIVE_PUSH_PRICE(
                id(asset),
                cfg.ticker.toString(),
                result.answer,
                uint8(result.oracle),
                result.feed
            );
        }
        if (result.isStale) {
            revert err.STALE_PUSH_PRICE(
                id(asset),
                cfg.ticker.toString(),
                result.answer,
                uint8(result.oracle),
                result.feed,
                block.timestamp - result.timestamp,
                result.staleTime
            );
        }
    }
}

// src/contracts/core/vault/funcs/VAssets.sol

/**
 * @title LibVault
 * @author the kopio project
 * @notice Helper library for vaults
 */
library VAssets {
    using WadRay for uint256;
    using PercentageMath for uint256;
    using PercentageMath for uint32;
    using VAssets for VaultAsset;
    using VAssets for uint256;

    /// @notice Gets the price of an asset from the oracle speficied.
    function price(
        VaultAsset storage self,
        VaultConfiguration storage config
    ) internal view returns (uint256 answer) {
        if (
            !isSequencerUp(
                config.sequencerUptimeFeed,
                config.sequencerGracePeriodTime
            )
        ) {
            revert err.L2_SEQUENCER_DOWN();
        }
        answer = aggregatorV3Price(address(self.feed), self.staleTime);
        if (answer == 0)
            revert err.ZERO_OR_STALE_VAULT_PRICE(
                id(address(self.token)),
                address(self.feed),
                answer
            );
    }

    /// @notice Gets the price of an asset from the oracle speficied.
    function handleDepositFee(
        VaultAsset storage self,
        uint256 assets
    ) internal view returns (uint256 assetsWithFee, uint256 fee) {
        uint256 depositFee = self.depositFee;
        if (depositFee == 0) {
            return (assets, 0);
        }

        fee = assets.percentMul(depositFee);
        assetsWithFee = assets - fee;
    }

    /// @notice Gets the price of an asset from the oracle speficied.
    function handleMintFee(
        VaultAsset storage self,
        uint256 assets
    ) internal view returns (uint256 assetsIn, uint256 fee) {
        uint256 depositFee = self.depositFee;
        if (depositFee == 0) {
            assetsIn = assets;
        } else {
            assetsIn = assets.percentDiv(Percents.HUNDRED - depositFee);
            fee = assetsIn - assets;
        }
        ++assetsIn;
    }

    /// @notice Gets the price of an asset from the oracle speficied.
    function handleWithdrawFee(
        VaultAsset storage self,
        uint256 assets
    ) internal view returns (uint256 assetsWithFee, uint256 fee) {
        uint256 withdrawFee = self.withdrawFee;
        if (withdrawFee == 0) {
            return (assets, 0);
        }

        assetsWithFee = assets.percentDiv(Percents.HUNDRED - withdrawFee);
        fee = assetsWithFee - assets;
    }

    /// @notice Gets the price of an asset from the oracle speficied.
    function handleRedeemFee(
        VaultAsset storage self,
        uint256 assets
    ) internal view returns (uint256 assetsWithFee, uint256 fee) {
        uint256 withdrawFee = self.withdrawFee;
        if (withdrawFee == 0) {
            return (assets, 0);
        }

        fee = assets.percentMul(withdrawFee);
        assetsWithFee = assets - fee;
    }

    /// @notice Gets the oracle decimal precision USD value for `amount`.
    /// @param config vault configuration.
    /// @param amount amount of tokens to get USD value for.
    function usdWad(
        VaultAsset storage self,
        VaultConfiguration storage config,
        uint256 amount
    ) internal view returns (uint256) {
        return
            wadUSD(
                amount,
                self.decimals,
                self.price(config),
                config.oracleDecimals
            );
    }

    /// @notice Gets the total deposit value of `self` in USD, oracle precision.
    function getDepositValue(
        VaultAsset storage self,
        VaultConfiguration storage config
    ) internal view returns (uint256) {
        uint256 bal = self.token.balanceOf(address(this));
        if (bal == 0) return 0;
        return bal.wadMul(self.price(config));
    }

    /// @notice Gets the total deposit value of `self` in USD, oracle precision.
    function getDepositValueWad(
        VaultAsset storage self,
        VaultConfiguration storage config
    ) internal view returns (uint256) {
        uint256 bal = self.token.balanceOf(address(this));
        if (bal == 0) return 0;
        return self.usdWad(config, bal);
    }

    /// @notice Gets the a token amount for `value` USD, oracle precision.
    function getAmount(
        VaultAsset storage self,
        VaultConfiguration storage config,
        uint256 value
    ) internal view returns (uint256) {
        uint256 valueScaled = (value * 1e18) /
            10 ** ((36 - config.oracleDecimals) - self.decimals);

        return valueScaled / self.price(config);
    }
}

// src/contracts/core/vault/Vault.sol

/**
 * @title Vault - A multiple deposit token vault.
 * @author the kopio project
 * @notice This is derived from ERC4626 standard.
 * @notice Users deposit tokens into the vault and receive shares of equal value in return.
 * @notice Shares are redeemable for the underlying tokens at any time.
 * @notice Price or exchange rate of SHARE/USD is determined by the total value of the underlying tokens in the vault and the share supply.
 */
contract Vault is IVault, ERC20Upgradeable, err {
    using SafeTransfer for IERC20;
    using FixedPointMath for uint256;
    using VAssets for uint256;
    using VAssets for VaultAsset;
    using Arrays for address[];

    constructor() {
        _disableInitializers();
    }

    /* -------------------------------------------------------------------------- */
    /*                                    State                                   */
    /* -------------------------------------------------------------------------- */
    VaultConfiguration internal _config;
    mapping(address => VaultAsset) internal _assets;
    address[] public assetList;
    uint256 public baseRate;

    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _oracleDecimals,
        address _owner,
        address _feeRecipient,
        address _seqFeed
    ) public initializer {
        __ERC20Upgradeable_init(_name, _symbol);
        _config.governance = _owner;
        _config.oracleDecimals = _oracleDecimals;
        _config.feeRecipient = _feeRecipient;
        _config.sequencerUptimeFeed = _seqFeed;
        _config.sequencerGracePeriodTime = 3600;
        baseRate = 1 ether;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Modifiers                                 */
    /* -------------------------------------------------------------------------- */

    modifier onlyGovernance() {
        if (msg.sender != _config.governance)
            revert INVALID_SENDER(msg.sender, _config.governance);
        _;
    }

    modifier check(address assetAddr) {
        if (!_assets[assetAddr].enabled) revert NOT_ENABLED(id(assetAddr));
        _;
    }

    /// @notice Validate deposits.
    function _checkAssetsIn(
        address assetAddr,
        uint256 assetsIn,
        uint256 sharesOut
    ) private view {
        uint256 depositLimit = maxDeposit(assetAddr);

        if (sharesOut == 0) revert ZERO_SHARES_OUT(id(assetAddr), assetsIn);
        if (assetsIn == 0) revert ZERO_ASSETS_IN(id(assetAddr), sharesOut);
        if (assetsIn > depositLimit)
            revert EXCEEDS_ASSET_DEPOSIT_LIMIT(
                id(assetAddr),
                assetsIn,
                depositLimit
            );
    }

    /* -------------------------------------------------------------------------- */
    /*                                Functionality                               */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IVault
    function deposit(
        address assetAddr,
        uint256 assetsIn,
        address receiver
    )
        public
        virtual
        check(assetAddr)
        returns (uint256 sharesOut, uint256 assetFee)
    {
        (sharesOut, assetFee) = previewDeposit(assetAddr, assetsIn);

        _checkAssetsIn(assetAddr, assetsIn, sharesOut);

        IERC20 token = IERC20(assetAddr);

        token.safeTransferFrom(msg.sender, address(this), assetsIn);

        if (assetFee > 0) token.safeTransfer(_config.feeRecipient, assetFee);

        _mint(receiver == address(0) ? msg.sender : receiver, sharesOut);

        emit Deposit(msg.sender, receiver, assetAddr, assetsIn, sharesOut);
    }

    /// @inheritdoc IVault
    function mint(
        address assetAddr,
        uint256 sharesOut,
        address receiver
    )
        public
        virtual
        check(assetAddr)
        returns (uint256 assetsIn, uint256 assetFee)
    {
        (assetsIn, assetFee) = previewMint(assetAddr, sharesOut);

        _checkAssetsIn(assetAddr, assetsIn, sharesOut);

        IERC20 token = IERC20(assetAddr);

        token.safeTransferFrom(msg.sender, address(this), assetsIn);

        if (assetFee > 0) token.safeTransfer(_config.feeRecipient, assetFee);

        _mint(receiver == address(0) ? msg.sender : receiver, sharesOut);

        emit Deposit(msg.sender, receiver, assetAddr, assetsIn, sharesOut);
    }

    /// @inheritdoc IVault
    function redeem(
        address assetAddr,
        uint256 sharesIn,
        address receiver,
        address owner
    )
        public
        virtual
        check(assetAddr)
        returns (uint256 assetsOut, uint256 assetFee)
    {
        (assetsOut, assetFee) = previewRedeem(assetAddr, sharesIn);

        if (assetsOut == 0) revert ZERO_ASSETS_OUT(id(assetAddr), sharesIn);

        IERC20 token = IERC20(assetAddr);

        uint256 balance = token.balanceOf(address(this));

        if (assetsOut + assetFee > balance) {
            VaultAsset storage asset = _assets[assetAddr];

            (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();
            sharesIn = asset.usdWad(_config, balance).mulDivUp(
                tSupply,
                tAssets
            );
            (assetsOut, assetFee) = previewRedeem(assetAddr, sharesIn);

            if (assetsOut > balance) {
                assetsOut = balance;
            }
            token.safeTransfer(receiver, assetsOut);
        } else {
            token.safeTransfer(receiver, assetsOut);
        }

        if (assetFee > 0) token.safeTransfer(_config.feeRecipient, assetFee);

        if (msg.sender != owner) {
            uint256 allowed = _allowances[owner][msg.sender]; // Saves gas for limited approvals.
            if (allowed != type(uint256).max)
                _allowances[owner][msg.sender] = allowed - sharesIn;
        }

        _burn(owner, sharesIn);

        emit Withdraw(
            msg.sender,
            receiver,
            assetAddr,
            owner,
            assetsOut,
            sharesIn
        );
    }

    /// @inheritdoc IVault
    function withdraw(
        address assetAddr,
        uint256 assetsOut,
        address receiver,
        address owner
    )
        public
        virtual
        check(assetAddr)
        returns (uint256 sharesIn, uint256 assetFee)
    {
        (sharesIn, assetFee) = previewWithdraw(assetAddr, assetsOut);

        if (sharesIn == 0) revert ZERO_SHARES_IN(id(assetAddr), assetsOut);

        if (msg.sender != owner) {
            uint256 allowed = _allowances[owner][msg.sender]; // Saves gas for limited approvals.
            if (allowed != type(uint256).max)
                _allowances[owner][msg.sender] = allowed - sharesIn;
        }

        IERC20 token = IERC20(assetAddr);

        if (assetFee > 0) token.safeTransfer(_config.feeRecipient, assetFee);

        _burn(owner, sharesIn);

        token.safeTransfer(receiver, assetsOut);

        emit Withdraw(
            msg.sender,
            receiver,
            assetAddr,
            owner,
            assetsOut,
            sharesIn
        );
    }

    /* -------------------------------------------------------------------------- */
    /*                                    Views                                   */
    /* -------------------------------------------------------------------------- */
    /// @inheritdoc IVault
    function getConfig() external view returns (VaultConfiguration memory) {
        return _config;
    }

    /// @inheritdoc IVault
    function assets(
        address assetAddr
    ) external view returns (VaultAsset memory) {
        return _assets[assetAddr];
    }

    /// @inheritdoc IVault
    function allAssets() external view returns (VaultAsset[] memory result) {
        result = new VaultAsset[](assetList.length);
        for (uint256 i; i < assetList.length; i++) {
            result[i] = _assets[assetList[i]];
        }
    }

    function assetPrice(address assetAddr) external view returns (uint256) {
        return _assets[assetAddr].price(_config);
    }

    /// @inheritdoc IVault
    function totalAssets() public view virtual returns (uint256 result) {
        for (uint256 i; i < assetList.length; ) {
            result += _assets[assetList[i]].getDepositValueWad(_config);
            unchecked {
                i++;
            }
        }
    }

    /// @inheritdoc IVault
    function exchangeRate() public view virtual returns (uint256) {
        uint256 tAssets = totalAssets();
        uint256 tSupply = totalSupply();
        if (tSupply == 0 || tAssets == 0) return baseRate;
        return (tAssets * 1e18) / tSupply;
    }

    /// @inheritdoc IVault
    function previewDeposit(
        address assetAddr,
        uint256 assetsIn
    ) public view virtual returns (uint256 sharesOut, uint256 assetFee) {
        (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();

        VaultAsset storage asset = _assets[assetAddr];

        (assetsIn, assetFee) = asset.handleDepositFee(assetsIn);

        sharesOut = asset.usdWad(_config, assetsIn).mulDivDown(
            tSupply,
            tAssets
        );
    }

    /// @inheritdoc IVault
    function previewMint(
        address assetAddr,
        uint256 sharesOut
    ) public view virtual returns (uint256 assetsIn, uint256 assetFee) {
        (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();

        VaultAsset storage asset = _assets[assetAddr];

        (assetsIn, assetFee) = asset.handleMintFee(
            asset.getAmount(_config, sharesOut.mulDivUp(tAssets, tSupply))
        );
    }

    /// @inheritdoc IVault
    function previewRedeem(
        address assetAddr,
        uint256 sharesIn
    ) public view virtual returns (uint256 assetsOut, uint256 assetFee) {
        (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();

        VaultAsset storage asset = _assets[assetAddr];

        (assetsOut, assetFee) = asset.handleRedeemFee(
            asset.getAmount(_config, sharesIn.mulDivDown(tAssets, tSupply))
        );
    }

    /// @inheritdoc IVault
    function previewWithdraw(
        address assetAddr,
        uint256 assetsOut
    ) public view virtual returns (uint256 sharesIn, uint256 assetFee) {
        (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();

        VaultAsset storage asset = _assets[assetAddr];

        (assetsOut, assetFee) = asset.handleWithdrawFee(assetsOut);

        sharesIn = asset.usdWad(_config, assetsOut).mulDivUp(tSupply, tAssets);

        if (sharesIn > tSupply)
            revert ROUNDING_ERROR(id(assetAddr), sharesIn, tSupply);
    }

    /// @inheritdoc IVault
    function maxRedeem(
        address assetAddr,
        address owner
    ) public view virtual returns (uint256 max) {
        (uint256 assetsOut, uint256 fee) = previewRedeem(
            assetAddr,
            _balances[owner]
        );
        uint256 balance = IERC20(assetAddr).balanceOf(address(this));

        if (assetsOut + fee > balance) {
            (uint256 tSupply, uint256 tAssets) = _getTSupplyTAssets();
            return
                _assets[assetAddr].usdWad(_config, balance).mulDivDown(
                    tSupply,
                    tAssets
                );
        } else {
            return _balances[owner];
        }
    }

    /// @inheritdoc IVault
    function maxWithdraw(
        address assetAddr,
        address owner
    ) external view returns (uint256 max) {
        (max, ) = previewRedeem(assetAddr, maxRedeem(assetAddr, owner));
    }

    /// @inheritdoc IVault
    function maxDeposit(
        address assetAddr
    ) public view virtual returns (uint256) {
        return
            _assets[assetAddr].maxDeposits -
            _assets[assetAddr].token.balanceOf(address(this));
    }

    /// @inheritdoc IVault
    function maxMint(
        address assetAddr,
        address user
    ) external view virtual returns (uint256 max) {
        uint256 balance = IERC20(assetAddr).balanceOf(user);
        uint256 depositLimit = maxDeposit(assetAddr);
        if (balance > depositLimit) {
            (max, ) = previewDeposit(assetAddr, depositLimit);
        } else {
            (max, ) = previewDeposit(assetAddr, balance);
        }
    }

    function _getTSupplyTAssets()
        private
        view
        returns (uint256 tSupply, uint256 tAssets)
    {
        tSupply = totalSupply();
        tAssets = totalAssets();

        if (tSupply == 0 || tAssets == 0) {
            tSupply = 1 ether;
            tAssets = baseRate;
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                                    Admin                                   */
    /* -------------------------------------------------------------------------- */

    function setBaseRate(uint256 newBaseRate) external onlyGovernance {
        baseRate = newBaseRate;
    }

    function setSequencerUptimeFeed(
        address newFeedAddr,
        uint96 gracePeriod
    ) external onlyGovernance {
        if (newFeedAddr != address(0)) {
            if (!isSequencerUp(newFeedAddr, gracePeriod))
                revert INVALID_SEQUENCER_UPTIME_FEED(newFeedAddr);
        }
        _config.sequencerUptimeFeed = newFeedAddr;
        _config.sequencerGracePeriodTime = gracePeriod;
    }

    /// @inheritdoc IVault
    function addAsset(
        VaultAsset memory assetConfig
    ) external onlyGovernance returns (VaultAsset memory) {
        address assetAddr = address(assetConfig.token);
        if (assetAddr == address(0)) revert ZERO_ADDRESS();
        if (_assets[assetAddr].decimals != 0)
            revert ASSET_EXISTS(id(assetAddr));

        assetConfig.decimals = assetConfig.token.decimals();
        Validations.validateVaultAssetDecimals(assetAddr, assetConfig.decimals);
        Validations.validateFees(
            assetAddr,
            uint16(assetConfig.depositFee),
            uint16(assetConfig.withdrawFee)
        );

        _assets[assetAddr] = assetConfig;
        assetList.pushUnique(assetAddr);

        emit AssetAdded(
            assetAddr,
            address(assetConfig.feed),
            assetConfig.token.symbol(),
            assetConfig.staleTime,
            _assets[assetAddr].price(_config),
            assetConfig.maxDeposits,
            block.timestamp
        );

        return assetConfig;
    }

    /// @inheritdoc IVault
    function removeAsset(address assetAddr) external onlyGovernance {
        assetList.removeExisting(assetAddr);
        delete _assets[assetAddr];
        emit AssetRemoved(assetAddr, block.timestamp);
    }

    /// @inheritdoc IVault
    function setAssetFeed(
        address assetAddr,
        address newFeedAddr,
        uint24 newStaleTime
    ) external onlyGovernance {
        _assets[assetAddr].feed = IAggregatorV3(newFeedAddr);
        _assets[assetAddr].staleTime = newStaleTime;
        emit OracleSet(
            assetAddr,
            newFeedAddr,
            newStaleTime,
            _assets[assetAddr].price(_config),
            block.timestamp
        );
    }

    /// @inheritdoc IVault
    function setFeedPricePrecision(uint8 newDecimals) external onlyGovernance {
        _config.oracleDecimals = newDecimals;
    }

    /// @inheritdoc IVault
    function setAssetEnabled(
        address assetAddr,
        bool isEnabled
    ) external onlyGovernance {
        _assets[assetAddr].enabled = isEnabled;
        emit AssetEnabledChange(assetAddr, isEnabled, block.timestamp);
    }

    /// @inheritdoc IVault
    function setDepositFee(
        address assetAddr,
        uint16 newDepositFee
    ) external onlyGovernance {
        Validations.validateFees(assetAddr, newDepositFee, newDepositFee);
        _assets[assetAddr].depositFee = newDepositFee;
    }

    /// @inheritdoc IVault
    function setWithdrawFee(
        address assetAddr,
        uint16 newWithdrawFee
    ) external onlyGovernance {
        Validations.validateFees(assetAddr, newWithdrawFee, newWithdrawFee);
        _assets[assetAddr].withdrawFee = newWithdrawFee;
    }

    /// @inheritdoc IVault
    function setMaxDeposits(
        address assetAddr,
        uint248 newMaxDeposits
    ) external onlyGovernance {
        _assets[assetAddr].maxDeposits = newMaxDeposits;
    }

    /// @inheritdoc IVault
    function setGovernance(address newGovernance) external onlyGovernance {
        _config.pendingGovernance = newGovernance;
    }

    /// @inheritdoc IVault
    function acceptGovernance() external {
        if (msg.sender != _config.pendingGovernance)
            revert INVALID_SENDER(msg.sender, _config.pendingGovernance);
        _config.governance = _config.pendingGovernance;
        _config.pendingGovernance = address(0);
    }

    /// @inheritdoc IVault
    function setFeeRecipient(address newFeeRecipient) external onlyGovernance {
        _config.feeRecipient = newFeeRecipient;
    }
}
