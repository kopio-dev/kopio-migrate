// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ArbDeploy} from "kr/info/ArbDeploy.sol";
import {PythBase} from "c/ffi/ffi-pyth.s.sol";
import {IKreditsDiamond} from "kr/core/IKreditsDiamond.sol";
import {Cutter} from "kr/utils/Cutter.s.sol";
import {Based} from "c/base/Base.s.sol";
import {IKresko} from "kr/core/IKresko.sol";

contract KrBase is Based, Cutter, PythBase {
    IKresko constant kresko = IKresko(kreskoAddr);
    IKreditsDiamond constant kredits = IKreditsDiamond(kreditsAddr);
}
