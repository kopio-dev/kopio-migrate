// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IKreditsDiamond} from "kr/core/IKreditsDiamond.sol";
import {Cutter} from "kr/utils/Cutter.s.sol";
import {Based} from "kr/utils/Based.s.sol";
import {IKresko} from "kr/core/IKresko.sol";

contract KrBase is Cutter, Based {
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
    IKresko constant kresko = IKresko(kreskoAddr);
    IKreditsDiamond constant kredits = IKreditsDiamond(kreditsAddr);
}
