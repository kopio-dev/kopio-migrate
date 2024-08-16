// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Utils} from "kopio/utils/Libs.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {Files} from "kopio/vm/Files.s.sol";
import {Base} from "s/base/Base.s.sol";
import {deployData} from "c/helpers/Deploy.sol";
import {IProxyFactory} from "kopio/IProxyFactory.sol";
import {deployDataBytes} from "c/helpers/Deploy.sol";

contract ktx is Base {
    using PLog for *;

    using Utils for *;

    function setUp() public virtual {
        base("MNEMONIC_KOPIO", "arbitrum", 243212200);
    }

    function kopioTx() public withJSON("data-v3") broadcasted(sender) {}
}
