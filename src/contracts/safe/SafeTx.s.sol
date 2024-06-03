// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {Scripted} from "kr/utils/Scripted.s.sol";

abstract contract SafeTx is Scripted {
    address internal SAFE_ADDRESS;

    function setUp() public virtual {
        vm.createSelectFork(vm.envString("SAFE_NETWORK"));
        SAFE_ADDRESS = vm.envAddress("SAFE_ADDRESS");
        require(SAFE_ADDRESS != address(0), "SAFE_ADDRESS not set");
    }
}
