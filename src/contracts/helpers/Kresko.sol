// SPDX-License-Identifier: MIT
// solhint-disable no-inline-assembly, one-contract-per-file, state-visibility, const-name-snakecase
pragma solidity ^0.8.0;
import {IKresko, Asset} from "kresko/core/IKresko.sol";
import {IKreditsDiamond} from "c/interfaces/IKreditsDiamond.sol";
import {IKISS} from "kresko/core/IKISS.sol";
import {IVault} from "kresko/core/IVault.sol";
import {IKreskoAsset} from "kresko/core/IKreskoAsset.sol";

IKresko constant kr = IKresko(0x0000000000177abD99485DCaea3eFaa91db3fe72);
IKreditsDiamond constant kredits = IKreditsDiamond(
    0x8E84a3B8e0b074c149b8277c753Dc6396bB95F48
);
address constant kreditsAddr = 0x8E84a3B8e0b074c149b8277c753Dc6396bB95F48;
abstract contract Kresko {
    address constant kreskoAddr = 0x0000000000177abD99485DCaea3eFaa91db3fe72;
    address constant kissAddr = 0x6A1D6D2f4aF6915e6bBa8F2db46F442d18dB5C9b;
    address constant krVaultAddr = 0x2dF01c1e472eaF880e3520C456b9078A5658b04c;

    IKresko constant kresko = kr;
    IKISS constant kiss = IKISS(kissAddr);
    IVault constant krVault = IVault(krVaultAddr);

    address constant krDataAddr = 0xef5196c4bDd74356943dcC20A7d27eAdD0F9b9D7;
    address constant krStatusAddr = 0xf6188e085ebEB716a730F8ecd342513e72C8AD04;

    address constant krETHAddr = 0x24dDC92AA342e92f26b4A676568D04d2E3Ea0abc;
    address constant krBTCAddr = 0x11EF4EcF3ff1c8dB291bc3259f3A4aAC6e4d2325;
    address constant krSOLAddr = 0x96084d2E3389B85f2Dc89E321Aaa3692Aed05eD2;
    address constant krEURAddr = 0x83BB68a7437b02ebBe1ab2A0E8B464CC5510Aafe;
    address constant krJPYAddr = 0xc4fEE1b0483eF73352447b1357adD351Bfddae77;
    address constant krGBPAddr = 0xdb274afDfA7f395ef73ab98C18cDf3D9C03b538C;
    address constant krXAUAddr = 0xe0A49C9215206f9cfb79981901bDF1f2716d3215;
    address constant krXAGAddr = 0x1d6A65BBfbbc995a19Fc19cB17FA135f9EdB6A24;
    address constant krDOGEAddr = 0x4a719F02aF3f0FFf15447B6824464857ADB5210D;

    IKreskoAsset constant krETH = IKreskoAsset(krETHAddr);
    IKreskoAsset constant krBTC = IKreskoAsset(krBTCAddr);

    address constant krSafe = 0x266489Bde85ff0dfe1ebF9f0a7e6Fed3a973cEc3;
    address constant kreskianAddr = 0xAbDb949a18d27367118573A217E5353EDe5A0f1E;
    address constant questAddr = 0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6;

    address constant ETH = address(0);
}
