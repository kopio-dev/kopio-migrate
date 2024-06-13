// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {ArbDeploy} from "kr/info/ArbDeploy.sol";
import {PythBase} from "c/ffi/ffi-pyth.s.sol";
import {IKreditsDiamond, ClaimEvent} from "kr/core/IKreditsDiamond.sol";
import {Cutter} from "c/diamond/Cutter.s.sol";
import {IKresko} from "kr/core/IKresko.sol";

contract KrBase is Cutter, PythBase, ArbDeploy {
    address sender;
    IKresko constant kresko = IKresko(kreskoAddr);
    IKreditsDiamond constant kredits = IKreditsDiamond(kreditsAddr);

    function setUp() public virtual {
        useMnemonic("MNEMONIC");
        sender = getAddr(0);
    }

    function getEnv(
        string memory name,
        string memory defaultName
    ) internal view returns (string memory) {
        return vm.envOr(name, vm.envString(defaultName));
    }
}
