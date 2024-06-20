// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Scripted} from "kr/utils/Scripted.s.sol";
import {PLog} from "kr/utils/PLog.s.sol";
import {IDeploymentFactory} from "kr/core/IDeploymentFactory.sol";

abstract contract Based is Scripted {
    address sender;
    address constant binance = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D;
    address[] testAccs = [
        0x5a6B3E907b83DE2AbD9010509429683CF5ad5984, // dev
        0x99999A0B66AF30f6FEf832938a5038644a72180a, // self
        0x7e04f2812F952fB16df52C25aAefb96fcA7c8574, // miko
        0xADDB385343d851d92CC8639162e5aD18c16E47Df, // ayuush
        0xada18123Bf1788119Dd557DaCA618a2e92e1BE3c, // self
        0x13458523bFCb8F0c30C440e77945C392AaA5020f, // qual
        0xd6bEDEcDeC6Dc1C5900abeFD2CAB1663BCED8E22, // akira
        0x3dD318bE619FaaedCF49D582Efa9fb087C688670, // george?
        0x0E3DE118782bC7e4C7AFaFdD29Af762F4CdEcab5, // fenix
        0xFcbB93547B7C1936fEbfe56b4cEeD9Ab66dA1857, // dev
        0x36d50Cf7b7dfac786f3F14d251299F0593517E17, // miko
        0x361Bae08CDd251b022889d8eA9fb8ddb84012516
    ];

    function base(string memory _mnemonic, string memory _network) internal {
        PLog.clg(
            "***********************************************************************************"
        );
        base(_mnemonic);
        createSelectFork(_network);
        PLog.clg(
            "***********************************************************************************"
        );
    }

    function base(string memory _mnemonic) internal {
        useMnemonic(_mnemonic);
        sender = getAddr(0);
        PLog.clg(sender, "sender:");
    }

    function createSelectFork(string memory _env) internal {
        string memory rpc = getEnv(_env, "RPC_ARBITRUM_ALCHEMY");
        vm.createSelectFork(rpc);
        PLog.clg(
            "rpc:",
            string.concat(
                vm.rpcUrl(rpc),
                " (",
                vm.toString(block.chainid),
                ", ",
                vm.toString(((getTime() - block.timestamp) / 60)),
                "m ago)"
            )
        );
    }

    function getEnv(
        string memory _envKey,
        string memory _defaultKey
    ) internal view returns (string memory) {
        return vm.envOr(_envKey, vm.envString(_defaultKey));
    }

    function getTime() internal returns (uint256) {
        return vm.unixTime() / 1000;
    }
}
