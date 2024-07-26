// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {VaultAsset} from "kr/core/IVault.sol";
import {View} from "kr/core/types/Views.sol";
import {PythView} from "kr/vendor/Pyth.sol";

interface IData {
    struct Oracles {
        address addr;
        bytes32 pythId;
        address clFeed;
        bool invertPyth;
        bool ext;
    }

    struct PreviewWd {
        address vaultAsset;
        uint256 outputAmount;
        bytes path;
    }
    struct V {
        VA[] assets;
        Tkn share;
    }

    struct VA {
        address addr;
        string name;
        string symbol;
        uint8 oracleDec;
        uint256 vSupply;
        bool isMarketOpen;
        uint256 tSupply;
        VaultAsset config;
        uint256 price;
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
        Tkn[] tokens;
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
    }

    struct Tkn {
        string ticker;
        address addr;
        string name;
        string symbol;
        uint256 amount;
        uint256 tSupply;
        uint8 oracleDec;
        uint256 val;
        uint8 decimals;
        uint256 price;
        uint256 chainId;
        bool isKrAsset;
        bool isCollateral;
    }

    struct A {
        address addr;
        uint256 chainId;
        View.MAccount minter;
        View.SAccount scdp;
        C[] collections;
        Tkn[] tokens;
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

    function refreshProtocolAssets() external;

    function previewWithdraw(
        PreviewWd calldata args
    ) external payable returns (uint256 withdrawAmount, uint256 fee);

    function getGlobals(
        PythView calldata prices,
        address[] calldata ext
    ) external view returns (G memory);

    function getAccount(
        PythView calldata _prices,
        address _acc,
        address[] calldata _ext
    ) external view returns (A memory);

    function getTokens(
        PythView calldata _prices,
        address _account,
        address[] calldata _extTokens
    ) external view returns (Tkn[] memory result);

    function getVAssets() external view returns (VA[] memory);
}
