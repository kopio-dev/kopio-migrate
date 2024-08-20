// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {__revert} from "kopio/utils/Funcs.sol";
import {IMigrationRouter, Route} from "c/migrator/router/IMigrationRouter.sol";

contract MigrationRouter is IMigrationRouter {
    constructor(address _owner, Route[] memory routes) {
        rs().auth[_owner] = true;
        emit Authorized(_owner);

        for (uint256 i; i < routes.length; i++) {
            rs().routes[routes[i].sig] = routes[i].impl;
            emit RouteAdded(routes[i]);
        }
    }

    function setRoute(Route memory route) external auth {
        rs().routes[route.sig] = route.impl;

        if (route.impl == address(0)) {
            emit RouteRemoved(route.sig);
        } else {
            emit RouteAdded(route);
        }
    }

    function authorize(address addr) external auth {
        rs().auth[addr] = true;
        emit Authorized(addr);
    }

    // solhint-disable-next-line no-complex-fallback
    fallback() external payable {
        address impl = rs().routes[msg.sig];
        if (impl == address(0)) revert InvalidRoute(msg.sig);

        (bool success, bytes memory data) = impl.delegatecall(msg.data);
        if (!success) __revert(data);

        assembly {
            return(add(data, 0x20), mload(data))
        }
    }

    receive() external payable {}
}
