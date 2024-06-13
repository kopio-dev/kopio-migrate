// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {Enums} from "kr/core/types/Data.sol";
import {ForkBase} from "c/base/ForkBase.s.sol";
import {ICommonConfigFacet} from "kr/core/IKresko.sol";

contract KreskoScriptFork is ForkBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual override {
        super.setUp();
        vm.createSelectFork(getEnv("RPC_KRESKO_FORK", "RPC_ARBITRUM_ALCHEMY"));

        broadcastWith(sender);
        fetchPythAndUpdate();
    }

    bytes32[] pythFeeds = [bytes32("ETH")];
    bytes32[] pythIds = [
        bytes32(
            0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace
        )
    ];
    uint256[] staleTimes = [1000000000];
    bool[] invertPyth = [false];
    bool[] isClosable = [false];
    ICommonConfigFacet.PythConfig pythConfig =
        ICommonConfigFacet.PythConfig({
            pythIds: pythIds,
            staleTimes: staleTimes,
            invertPyth: invertPyth,
            isClosables: isClosable
        });

    function execKreskoFork() public {
        broadcastWith(safe);
        kresko.setPythFeeds(pythFeeds, pythConfig);
    }
}
