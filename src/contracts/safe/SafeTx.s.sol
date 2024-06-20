// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {Scripted} from "kr/utils/Scripted.s.sol";
import {Based} from "c/base/Base.s.sol";
import {PLog} from "kr/utils/PLog.s.sol";

abstract contract SafeTx is Based {
    address internal SAFE_ADDRESS;

    function safeBase(
        string memory _mnemonic,
        string memory _network
    ) internal {
        super.base(_mnemonic, _network);
        SAFE_ADDRESS = vm.envAddress("SAFE_ADDRESS");

        require(SAFE_ADDRESS != address(0), "SAFE_ADDRESS not set");

        PLog.clg(SAFE_ADDRESS, "Safe Address");
        PLog.clg(block.chainid, "Chain ID");
    }
}
