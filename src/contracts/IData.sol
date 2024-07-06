// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {RawPrice} from "kr/core/types/Data.sol";
import {VaultAsset} from "kr/core/IVault.sol";
import {View} from "kr/core/types/Views.sol";
import {PythView} from "kr/vendor/Pyth.sol";

interface IData {
    struct PreviewWithdrawArgs {
        address vaultAsset;
        uint256 outputAmount;
        bytes path;
    }
    struct V {
        VA[] assets;
        VTkn token;
    }
    struct VA {
        address addr;
        string name;
        string symbol;
        uint8 oracleDecimals;
        uint256 vSupply;
        bool isMarketOpen;
        uint256 tSupply;
        RawPrice priceRaw;
        VaultAsset config;
        uint256 price;
    }

    struct VTkn {
        string symbol;
        uint8 decimals;
        string name;
        uint256 price;
        uint8 oracleDecimals;
        uint256 tSupply;
    }

    struct C {
        address addr;
        string name;
        string symbol;
        string uri;
        CItem[] items;
    }

    struct CItem {
        uint256 id;
        string uri;
        uint256 balance;
    }

    struct G {
        View.SCDP scdp;
        View.Minter minter;
        V vault;
        View.AssetView[] assets;
        W[] wraps;
        C[] collections;
        uint256 blockNr;
        uint256 tvl;
        uint32 seqPeriod;
        address pythEp;
        uint32 maxDeviation;
        uint8 oracleDec;
        uint32 seqStart;
        bool safety;
        bool seqUp;
        uint32 timestamp;
        uint256 chainId;
        View.Gate gate;
    }

    struct Ext {
        address addr;
        string name;
        string symbol;
        uint256 amount;
        uint256 tSupply;
        uint8 oracleDecimals;
        uint256 val;
        uint8 decimals;
        uint256 price;
        RawPrice priceRaw;
        uint256 chainId;
    }

    struct A {
        address addr;
        uint256 chainId;
        View.Balance[] bals;
        View.MAccount minter;
        View.SAccount scdp;
        C[] collections;
        Ext vault;
        bool eligible;
        uint8 phase;
    }

    struct W {
        address addr;
        address underlying;
        string symbol;
        uint256 price;
        uint8 decimals;
        uint256 amount;
        uint256 nativeAmount;
        uint256 val;
        uint256 nativeVal;
    }

    function previewWithdraw(
        PreviewWithdrawArgs calldata args
    ) external payable returns (uint256 withdrawAmount, uint256 fee);

    function getGlobals(
        PythView calldata prices,
        address[] calldata ext
    ) external view returns (G memory);

    function getAccount(
        PythView calldata prices,
        address acc,
        address[] calldata ext
    ) external view returns (A memory);

    function getVault() external view returns (V memory);

    function getVAssets() external view returns (VA[] memory);
}
