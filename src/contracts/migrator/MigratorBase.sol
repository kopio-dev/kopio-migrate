// SPDX-License-Identifier: MIT
// solhint-disable no-inline-assembly, one-contract-per-file, state-visibility, const-name-snakecase

pragma solidity ^0.8.0;

import {MintArgs, SwapArgs} from "kopio/IKopioCore.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {ISwapRouter} from "kopio/vendor/ISwapRouter.sol";
import {Utils} from "kopio/utils/Libs.sol";
import {__revert} from "kopio/utils/Funcs.sol";
import {IMigrator} from "./IMigrator.sol";
import {LibMigration} from "c/migrator/LibMigration.sol";
import "kresko/core/types/Args.sol" as TKresko;

using Utils for uint256;

abstract contract MigrationAssets is IMigrator {
    function isKrAsset(address asset) internal view returns (bool) {
        return ms().getAsset[asset] != address(0);
    }

    function isKopioAsset(address asset) internal pure returns (bool) {
        return
            asset == oneAddr ||
            asset == kXAGAddr ||
            asset == kXAUAddr ||
            asset == kGBPAddr ||
            asset == kJPYAddr ||
            asset == kEURAddr ||
            asset == kSOLAddr ||
            asset == kBTCAddr ||
            asset == kETHAddr ||
            asset == kDOGEAddr;
    }

    function isStable(address asset) internal pure returns (bool) {
        return isVaultAsset(asset) || asset == daiAddr || asset == usdtAddr;
    }

    function isVaultAsset(address asset) internal pure returns (bool) {
        return asset == usdcAddr || asset == usdceAddr;
    }

    function isKISS(address asset) internal pure returns (bool) {
        return asset == kissAddr;
    }

    function isONE(address asset) internal pure returns (bool) {
        return asset == oneAddr;
    }

    function isKrETH(address asset) internal pure returns (bool) {
        return asset == krETHAddr;
    }

    function isKETH(address asset) internal pure returns (bool) {
        return asset == kETHAddr;
    }

    function isWETH(address asset) internal pure returns (bool) {
        return asset == wethAddr;
    }
    function isETH(address asset) internal pure returns (bool) {
        return asset == ETH;
    }

    function isExt(address asset) internal view returns (bool) {
        return
            !isKrAsset(asset) && !isVaultAsset(asset) && !isKopioAsset(asset);
    }

    function _getFeeV3(address a, address b) internal pure returns (uint24) {
        if (isStable(a) && isStable(b)) return 100;
        return 500;
    }

    function _toAmount(
        Pos storage pos,
        uint256 value
    ) internal view returns (uint256) {
        return
            value.wdiv(kresko.getPrice(pos.a.addr)).fromWad(
                pos.a.asset.decimals
            );
    }

    function bal(address _asset) internal view returns (uint256) {
        if (_asset == ETH) {
            return address(this).balance;
        } else {
            return IERC20(_asset).balanceOf(address(this));
        }
    }

    function amt(
        address _asset,
        uint256 _amtIn
    ) internal view returns (uint256) {
        uint256 balance = bal(_asset);
        if (_amtIn == 0 || balance < _amtIn) return balance;
        return _amtIn;
    }

    function _vAsset(address vault) internal view returns (address vasset) {
        vasset = usdc.balanceOf(vault) > usdce.balanceOf(vault)
            ? usdcAddr
            : usdceAddr;
    }
}

abstract contract MigrationLogic is MigrationAssets {
    function _depositKopio(address account, Transfer storage item) internal {
        address depositAsset = item.destination != address(0)
            ? item.destination
            : item.asset;

        uint256 depositAmount = amt(
            depositAsset,
            item.amount - item.amountTransferred
        );
        if (depositAmount == 0) return;
        core.depositCollateral(account, depositAsset, depositAmount);
        item.amountTransferred += depositAmount;
    }

    function _mintKopioDebt(address account, Transfer storage item) internal {
        uint256 amount = item.amount - item.amountTransferred;
        if (amount == 0) return;

        uint256 mintAmount = _getMintAmount(account, item.destination, amount);

        if (mintAmount == 0) return;
        core.mintKopio(
            MintArgs(account, item.destination, mintAmount, address(this)),
            new bytes[](0)
        );
        item.amountTransferred += mintAmount;

        return;
    }

    function _getMintAmount(
        address account,
        address kopio,
        uint256 amount
    ) internal view returns (uint256 result) {
        uint256 assetPrice = core.getPrice(kopio).pmul(
            core.getAsset(kopio).dFactor + 150e2
        );

        uint256 valueAvailable = core.getAccountTotalCollateralValue(account) -
            core.getAccountMinCollateralAtRatio(account, 150e2);
        if (valueAvailable < 0.01e8) return 0;
        uint256 debtVal = amount != 0
            ? assetPrice.wmul(amount)
            : valueAvailable + 1;

        if (valueAvailable < debtVal) {
            amount = valueAvailable.wdiv(assetPrice);
        }

        return amount;
    }

    function _withdrawUncheck(address account, uint256 idx) internal {
        kresko.withdrawCollateralUnchecked(
            TKresko.UncheckedWithdrawArgs({
                account: account,
                asset: ms().posColl[idx].a.addr,
                amount: type(uint256).max,
                collateralIndex: kresko.getAccountDepositIndex(
                    account,
                    ms().posColl[idx].a.addr
                ),
                userData: abi.encode(idx)
            }),
            new bytes[](0)
        );
    }

    function _swapSCDP(
        address _from,
        address _to,
        uint256 _amtIn
    ) internal returns (uint256 amtOut) {
        if (_from == _to) return _amtIn;

        uint256 balBefore = bal(_to);
        try
            kresko.swapSCDP(
                TKresko.SwapArgs({
                    assetIn: _from,
                    assetOut: _to,
                    amountIn: _amtIn,
                    amountOutMin: 0,
                    prices: new bytes[](0),
                    receiver: address(this)
                })
            )
        {
            return bal(_to) - balBefore;
        } catch {
            return 0;
        }
    }

    function _synthwrap(
        address to,
        uint256 amount
    ) internal returns (uint256 amtOut) {
        uint256 balBefore = bal(to);
        if (to == krETHAddr || to == kETHAddr) {
            if (address(this).balance >= amount) {
                _call(to, amount, "");
            } else {
                _call(
                    to,
                    0,
                    abi.encodeWithSelector(0xbf376c7a, address(this), amount)
                );
            }
        }

        if (to == wethAddr) {
            uint256 bal = IERC20(wethAddr).balanceOf(krETHAddr);
            amount = bal >= amount ? amount : bal;
            krETH.unwrap(address(this), amount, false);
        }

        if (to == ETH) {
            amount = krETHAddr.balance >= amount ? amount : krETHAddr.balance;

            krETH.unwrap(address(this), amount, true);
        }

        if (to == krBTCAddr) {
            krBTC.wrap(address(this), amount);
        }

        if (to == wbtcAddr && IERC20(wbtcAddr).balanceOf(krBTCAddr) >= amount) {
            krBTC.unwrap(address(this), amount.fromWad(8), false);
        }

        return bal(to) - balBefore;
    }

    function _call(address to, uint256 value, bytes memory data) internal {
        (bool success, bytes memory err) = to.call{value: value}(data);
        if (!success) __revert(err);
    }

    function _burn(address account, address asset, uint256 amount) internal {
        kresko.burnKreskoAsset(
            TKresko.BurnArgs({
                account: account,
                krAsset: asset,
                amount: amount,
                mintIndex: kresko.getAccountMintIndex(account, asset),
                repayee: address(this)
            }),
            new bytes[](0)
        );
    }

    function _withdrawAll(
        address account,
        address asset
    ) internal returns (uint256) {
        uint256 deposits = kresko.getAccountCollateralAmount(account, asset);
        if (deposits == 0) return 0;

        kresko.withdrawCollateral(
            TKresko.WithdrawArgs({
                account: account,
                asset: asset,
                amount: deposits,
                collateralIndex: kresko.getAccountDepositIndex(account, asset),
                receiver: address(this)
            }),
            new bytes[](0)
        );

        return deposits;
    }

    function _pathV3(
        address from,
        address to
    ) internal pure returns (bytes memory) {
        return
            bytes.concat(
                bytes20(from),
                bytes3(_getFeeV3(from, to)),
                bytes20(to)
            );
    }

    function _swapKopio(
        address from,
        address to,
        uint256 amtIn
    ) internal returns (uint256) {
        if (from == to) return amtIn;

        if (amtIn == 0) return 0;

        uint256 balBefore = bal(to);

        core.swapSCDP(
            SwapArgs({
                assetIn: from,
                assetOut: to,
                amountIn: amtIn,
                amountOutMin: 0,
                prices: new bytes[](0),
                receiver: address(this)
            })
        );

        return bal(to) - balBefore;
    }

    // solhint-disable-next-line
    function _toAsset(
        address from,
        address to,
        uint256 amount
    ) internal returns (uint256 amountOut) {
        amount = amt(from, amount);

        if (from == to || amount == 0) return amount;

        if (isVaultAsset(from)) {
            if (isVaultAsset(to)) {
                if (from != to) {
                    return _swapV3(from, amount, to);
                }
                return amount;
            }
            if (isKrAsset(to)) {
                amountOut = _toKISS(from, amount);
                if (isKISS(to)) return amountOut;
                return _swapSCDP(kissAddr, to, amountOut);
            }

            if (isKopioAsset(to)) {
                amountOut = _toONE(from, amount);
                if (isONE(to)) return amountOut;
                return _swapKopio(oneAddr, to, amount);
            }

            return _swapV3(from, amount, to);
        }

        if (isKrAsset(from)) {
            if (isKrAsset(to)) {
                amountOut = _toKISS(from, amount);
                if (isKISS(to)) return amountOut;
                return _swapSCDP(kissAddr, to, amountOut);
            }

            if (isKopioAsset(to)) {
                amountOut = _toONE(from, amount);
                if (isONE(to)) return amountOut;
                return _swapKopio(oneAddr, to, amountOut);
            }
            (address vasset, uint256 usdcOut) = _toUSDC(from, amount);
            if (vasset == to) return usdcOut;

            return _swapV3(vasset, usdcOut, to);
        }

        if (isKopioAsset(from)) {
            if (isKopioAsset(to)) {
                return _swapKopio(from, to, amount);
            }
            if (isKrAsset(to)) {
                amountOut = _toKISS(from, amount);
                if (isKISS(to)) return amountOut;
                return _swapSCDP(kissAddr, to, amountOut);
            }
            (address vasset, uint256 usdcOut) = _toUSDC(from, amount);
            if (vasset == to) return usdcOut;

            return _swapV3(vasset, usdcOut, to);
        }

        if (isExt(from)) {
            if (isExt(to)) {
                return _swapV3(from, amount, to);
            }

            if (isKrAsset(to)) {
                if ((isWETH(from) || isETH(from)) && isKrETH(to))
                    return _synthwrap(krETHAddr, amount);

                amountOut = _toKISS(from, amount);
                return _swapSCDP(kissAddr, to, amountOut);
            }

            if (isKopioAsset(to)) {
                if ((isWETH(from) || isETH(from)) && isKETH(to)) {
                    uint256 wrapAmount = _synthwrap(kETHAddr, amount);
                    if (wrapAmount >= amount) return wrapAmount;
                }

                amountOut = _toONE(from, amount);

                if (isONE(to)) return amountOut;

                return _swapKopio(oneAddr, to, amountOut);
            }

            (address vasset, uint256 usdcOut) = _toUSDC(from, amount);
            if (vasset == to) return usdcOut;

            return _swapV3(vasset, usdcOut, to);
        }
    }

    function _toKISS(
        address from,
        uint256 amount
    ) internal returns (uint256 kissOut) {
        amount = amt(from, amount);
        if (amount == 0) return 0;

        if (isKISS(from)) return amount;

        if (isKrAsset(from)) kissOut = _swapSCDP(from, kissAddr, amount);
        if (kissOut != 0) return kissOut;
        (address vasset, uint256 out) = _toUSDC(from, amount);
        if (out == 0) return 0;
        (kissOut, ) = kiss.vaultDeposit(vasset, out, address(this));
    }

    function _toONE(
        address from,
        uint256 amount
    ) internal returns (uint256 oneOut) {
        amount = amt(from, amount);

        if (isONE(from)) return amount;
        if (isKopioAsset(from)) oneOut = _swapKopio(from, oneAddr, amount);

        if (oneOut >= amount) return oneOut;

        (address vasset, uint256 usdcAmount) = _toUSDC(from, amount);

        (oneOut, ) = one.vaultDeposit(vasset, usdcAmount, address(this));
    }

    function _toUSDC(
        address from,
        uint256 amount
    ) internal returns (address vasset, uint256 out) {
        amount = amt(from, amount);
        if (isVaultAsset(from)) return (from, amount);
        vasset = usdceAddr;

        if (isExt(from)) return (vasset, _swapV3(from, amount, vasset));

        if (isKopioAsset(from)) {
            vasset = _vAsset(oneAddr);
            (out, ) = one.vaultRedeem(
                vasset,
                _toONE(from, amount),
                address(this),
                address(this)
            );
        }

        if (isKrAsset(from)) {
            vasset = _vAsset(kissAddr);
            uint256 kissOut = _toKISS(from, amount);
            if (kissOut != 0) {
                (out, ) = kiss.vaultRedeem(
                    vasset,
                    kissOut,
                    address(this),
                    address(this)
                );
            } else {
                uint256 _bal = bal(from);
                if (_bal == 0) return (vasset, 0);
                _synthwrap(ETH, _swapSCDP(from, krETHAddr, _bal));
                _call(wethAddr, address(this).balance, "");
                out = _swapV3(wethAddr, weth.balanceOf(address(this)), vasset);
            }
        }
    }

    function _toDebtAsset(
        Pos storage coll,
        Pos storage debt,
        uint256 debtAmount
    ) internal returns (uint256 amountOut) {
        uint256 value = kresko.getValue(debt.a.addr, debtAmount).pmul(105e2);
        value = value > coll.value ? coll.value : value;

        if (coll.a.addr != debt.a.addr) {
            _toAsset(coll.a.addr, debt.a.addr, _toAmount(coll, value));
        }

        uint256 received = bal(debt.a.addr);
        return received > debt.amount ? debt.amount : received;
    }

    function _swapV3(
        address from,
        uint256 amount,
        address to
    ) internal returns (uint256 amtOut) {
        IERC20(from).transfer(routerv3Addr, amount);
        amtOut = routerV3.exactInput(
            ISwapRouter.ExactInputParams({
                path: _pathV3(from, to),
                recipient: address(this),
                amountIn: 0,
                minOut: 0
            })
        );
        if (amtOut == 0) revert ZeroAmount(from);
    }

    function _convertAmt(
        address from,
        uint256 amount,
        address to,
        uint256 fee
    ) internal view returns (uint256 result) {
        uint256 value = core.getValue(from, amount);
        result = value.wdiv(core.getPrice(to)).fromWad(IERC20(to).decimals());
        if (fee != 0) result += result.pmul(fee);
    }
}
