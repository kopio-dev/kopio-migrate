// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

bytes32 constant SLOT = keccak256(
    abi.encode(uint256(keccak256("migration.router.slot")) - 1)
) & ~bytes32(uint256(0xff));

struct Route {
    address impl;
    bytes4 sig;
}

struct RouterState {
    mapping(bytes4 => address) routes;
    mapping(address => bool) auth;
}

abstract contract IMigrationRouter {
    error Unauthorized(address);
    error InvalidRoute(bytes4);

    event RouteAdded(Route);
    event RouteRemoved(bytes4 indexed sig);
    event Authorized(address indexed addr);

    modifier auth() {
        if (!rs().auth[msg.sender]) revert Unauthorized(msg.sender);
        _;
    }

    modifier self() {
        if (msg.sender != address(this)) revert Unauthorized(msg.sender);
        _;
    }

    function rs() internal pure returns (RouterState storage st) {
        bytes32 slot = SLOT;
        assembly {
            st.slot := slot
        }
    }
}
