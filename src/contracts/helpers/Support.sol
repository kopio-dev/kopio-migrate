// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ArbDeployAddr} from "kopio/info/ArbDeployAddr.sol";
import {IKopioCore, TData} from "kopio/IKopioCore.sol";
import {Utils} from "kopio/utils/Libs.sol";
import {IVault} from "kopio/IVault.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {ISupport, PythView} from "c/helpers/ISupport.sol";

contract Support is ArbDeployAddr, TData, ISupport {
    using Utils for *;

    IKopioCore constant core = IKopioCore(protocolAddr);
    IVault constant vault = IVault(vaultAddr);
    PythView noPyth;

    function getTVL() external view returns (TVL memory tvl) {
        return getTVL(noPyth);
    }

    function getTVL(
        PythView memory _prices
    ) public view returns (TVL memory tvl) {
        Protocol memory p = core.aDataProtocol(_prices);

        tvl.diamond = p.tvl;
        tvl.vkiss += vault.totalAssets().toDec(18, 8); // kiss vault

        // synthwraps
        for (uint256 i; i < p.assets.length; i++) {
            if (p.assets[i].wrap.underlying == address(0)) continue;
            TAsset memory a = p.assets[i];
            tvl.wraps += IERC20(a.wrap.underlying)
                .balanceOf(a.addr)
                .toWad(a.wrap.underlyingDec)
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
