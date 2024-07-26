// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {View} from "kr/core/types/Views.sol";
import {Utils} from "kr/utils/Libs.sol";
import {IKresko} from "kr/core/IKresko.sol";
import {IVault} from "kr/core/IVault.sol";
import {IERC20} from "kr/token/IERC20.sol";
import {ISupport, PythView} from "c/helpers/ISupport.sol";

contract Support is ArbDeployAddr, ISupport {
    using Utils for *;

    IKresko constant KRESKO = IKresko(kreskoAddr);
    IVault constant vault = IVault(vaultAddr);
    PythView noPyth;

    function getTVL() external view returns (TVL memory tvl) {
        return getTVL(noPyth);
    }

    function getTVL(
        PythView memory _prices
    ) public view returns (TVL memory tvl) {
        View.Protocol memory p = KRESKO.viewProtocolData(_prices);

        tvl.diamond = p.tvl;
        tvl.vkiss += vault.totalAssets().toDec(18, 8); // kiss vault

        // synthwraps
        for (uint256 i; i < p.assets.length; i++) {
            if (p.assets[i].synthwrap.underlying == address(0)) continue;
            View.AssetView memory a = p.assets[i];
            tvl.wraps += IERC20(a.synthwrap.underlying)
                .balanceOf(a.addr)
                .toWad(a.synthwrap.underlyingDecimals)
                .wmul(a.price);
            tvl.wraps += a.addr.balance.wmul(a.price);
        }

        tvl.total = tvl.diamond + tvl.vkiss + tvl.wraps;
    }

    function getTVLDec() external view returns (TVLDec memory) {
        return getTVLDec(noPyth);
    }

    function getTVLDec(
        PythView memory _prices
    ) public view returns (TVLDec memory) {
        TVL memory tvl = getTVL(_prices);

        return
            TVLDec(
                tvl.total.dstr(8),
                tvl.diamond.dstr(8),
                tvl.vkiss.dstr(8),
                tvl.wraps.dstr(8)
            );
    }
}
