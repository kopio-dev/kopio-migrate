// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/s/LibVm.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";
import {DataV3} from "c/DataV3.sol";
import {__revert} from "kr/utils/s/Base.s.sol";
import {IERC20} from "kr/token/IERC20.sol";
import {PythView} from "kr/vendor/Pyth.sol";
import {View} from "kr/core/types/Views.sol";
import {IData} from "c/IData.sol";
import {Enums} from "kr/core/types/Const.sol";

contract kr is KrBase {
    using Log for *;
    using Help for *;
    DataV3 data;
    function setUp() public virtual {
        base("MNEMONIC", "RPC_ARBITRUM_ALCHEMY");
    }
    IData.Oracles[] ctor;
    function krTx() public broadcasted(sender) returns (address) {
        createCtor();
        return address(data = new DataV3(ctor));
    }

    function createCtor() internal {
        PythView memory pythview;
        View.AssetView[] memory protocol = kresko
            .viewProtocolData(pythview)
            .assets;
        for (uint256 i; i < protocol.length; i++) {
            View.AssetView memory item = protocol[i];
            ctor.push(
                IData.Oracles({
                    addr: protocol[i].addr,
                    clFeed: kresko.getFeedForAddress(
                        item.addr,
                        Enums.OracleType.Chainlink
                    ),
                    pythId: kresko
                        .getOracleOfTicker(
                            item.config.ticker,
                            Enums.OracleType.Pyth
                        )
                        .pythId,
                    ext: false
                })
            );
        }

        ctor.push(
            IData.Oracles({
                addr: 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9,
                clFeed: 0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7,
                pythId: bytes32(
                    0x2b89b9dc8fdf9f34709a5b106b472f0f39bb6ca9ce04b0fd7f2e971688e2e53b
                ),
                ext: true
            })
        );
        ctor.push(
            IData.Oracles({
                addr: 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1,
                clFeed: 0xc5C8E77B397E531B8EC06BFb0048328B30E9eCfB,
                pythId: bytes32(
                    0xb0948a5e5313200c632b51bb5ca32f6de0d36e9950a942d19751e833f70dabfd
                ),
                ext: true
            })
        );
        ctor.push(
            IData.Oracles({
                addr: 0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a,
                clFeed: 0xDB98056FecFff59D032aB628337A4887110df3dB,
                pythId: bytes32(
                    0xb962539d0fcb272a494d65ea56f94851c2bcf8823935da05bd628916e2e9edbf
                ),
                ext: true
            })
        );
        ctor.push(
            IData.Oracles({
                addr: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
                clFeed: 0x1940fEd49cDBC397941f2D336eb4994D599e568B,
                pythId: bytes32(
                    0x3bd860bea28bf982fa06bcf358118064bb114086cc03993bd76197eaab0b8018
                ),
                ext: true
            })
        );
    }
}
