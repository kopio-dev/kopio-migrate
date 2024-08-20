// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IKreditsDiamond} from "c/interfaces/IKreditsDiamond.sol";
import {Cutter} from "kopio/vm-ffi/Cutter.s.sol";
import {Based} from "kopio/vm/Based.s.sol";
import {IKopioCore} from "kopio/IKopioCore.sol";
import {kreditsAddr} from "c/helpers/Kresko.sol";

contract Base is Cutter, Based {
    IKopioCore constant core = IKopioCore(protocolAddr);
    IKreditsDiamond constant kredits = IKreditsDiamond(kreditsAddr);
}
