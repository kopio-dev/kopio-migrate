// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IData} from "c/helpers/IData.sol";
import {DataV3} from "c/helpers/DataV3.sol";

function deployData() returns (DataV3) {
    return new DataV3(extAssetOracles());
}

function extAssetOracles() pure returns (IData.Oracles[] memory res) {
    res = new IData.Oracles[](4);
    res[0] = IData.Oracles({
        addr: 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9,
        clFeed: 0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7,
        pythId: bytes32(
            0x2b89b9dc8fdf9f34709a5b106b472f0f39bb6ca9ce04b0fd7f2e971688e2e53b
        ),
        invertPyth: false,
        ext: true
    });

    res[1] = IData.Oracles({
        addr: 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1,
        clFeed: 0xc5C8E77B397E531B8EC06BFb0048328B30E9eCfB,
        pythId: bytes32(
            0xb0948a5e5313200c632b51bb5ca32f6de0d36e9950a942d19751e833f70dabfd
        ),
        invertPyth: false,
        ext: true
    });

    res[2] = IData.Oracles({
        addr: 0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a,
        clFeed: 0xDB98056FecFff59D032aB628337A4887110df3dB,
        pythId: bytes32(
            0xb962539d0fcb272a494d65ea56f94851c2bcf8823935da05bd628916e2e9edbf
        ),
        invertPyth: false,
        ext: true
    });
    res[3] = IData.Oracles({
        addr: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
        clFeed: 0x1940fEd49cDBC397941f2D336eb4994D599e568B,
        pythId: bytes32(
            0x3bd860bea28bf982fa06bcf358118064bb114086cc03993bd76197eaab0b8018
        ),
        invertPyth: false,
        ext: true
    });
}
