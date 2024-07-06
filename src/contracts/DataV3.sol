// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {View} from "kr/core/types/Views.sol";
import {IERC20} from "kr/token/IERC20.sol";
import {IKresko1155} from "kr/token/IKresko1155.sol";
import {VaultAsset} from "kr/core/IVault.sol";
import {Enums} from "kr/core/types/Const.sol";
import {RawPrice} from "kr/core/types/Data.sol";
import {IAggregatorV3} from "kr/vendor/IAggregatorV3.sol";
import {PercentageMath, WadRay} from "kr/core/Math.sol";
import {PythView} from "kr/vendor/Pyth.sol";
import {IKresko} from "kr/core/IKresko.sol";
import {Arrays} from "kr/core/Utils.sol";
import {IData} from "./IData.sol";
import {toWad, fromWad} from "kr/utils/Math.sol";
import {ArbDeploy} from "kr/info/ArbDeploy.sol";

contract DataV3 is ArbDeploy, IData {
    using WadRay for uint256;
    using PercentageMath for uint256;
    using Arrays for address[];

    struct Oracles {
        address addr;
        bytes32 pythId;
        address clFeed;
        bool ext;
    }
    mapping(address => Oracles) public oracles;

    constructor(Oracles[] memory _oracles) {
        for (uint256 i; i < _oracles.length; i++) {
            Oracles memory asset = _oracles[i];
            oracles[asset.addr] = asset;
        }
    }

    uint256 public constant QUEST_FOR_KRESK_TOKEN_COUNT = 8;
    uint256 public constant KRESKIAN_LAST_TOKEN_COUNT = 1;
    IKresko public constant KRESKO = IKresko(kreskoAddr);
    PythView emptyPrices;

    function previewWithdraw(
        PreviewWithdrawArgs calldata args
    ) external payable returns (uint256 withdrawAmount, uint256 fee) {
        bool isVaultToAMM = args.vaultAsset != address(0) &&
            args.path.length > 0;
        uint256 vaultAssetAmount = !isVaultToAMM ? 0 : args.outputAmount;
        if (isVaultToAMM) {
            (vaultAssetAmount, , , ) = quoterV2.quoteExactOutput(
                args.path,
                args.outputAmount
            );
        }
        (withdrawAmount, fee) = vault.previewWithdraw(
            args.vaultAsset,
            vaultAssetAmount
        );
    }

    // function getAssetsMeta(
    //     address[] calldata _ext
    // ) external view returns (AssetMeta[] memory result) {
    //     View.AssetView[] memory assets = getAssets();
    //     result = new AssetMeta[](assets.length + _ext.length);
    //     for (uint256 i; i < assets.length; i++) {
    //         result[i] = AssetMeta({
    //             addr: assets[i].addr,
    //             symbol: assets[i].symbol,
    //             ticker: string(bytes.concat(assets[i].config.ticker))
    //         });
    //     }
    //     for (uint256 i; i < _ext.length; i++) {
    //         IERC20 tkn = IERC20(_ext[i]);
    //         result[assets.length + i] = AssetMeta({
    //             addr: _ext[i],
    //             symbol: tkn.symbol(),
    //             ticker: tkn.name()
    //         });
    //     }
    // }

    function getAssets() public view returns (View.AssetView[] memory) {
        return KRESKO.viewProtocolData(emptyPrices).assets;
    }

    function getGlobals(
        PythView calldata _prices,
        address[] calldata _ext
    ) external view returns (G memory g) {
        View.Protocol memory p = KRESKO.viewProtocolData(_prices);
        g.scdp = p.scdp;
        g.minter = p.minter;
        g.assets = p.assets;

        g.sequencerGracePeriodTime = p.sequencerGracePeriodTime;
        g.sequencerStartedAt = p.sequencerStartedAt;
        g.isSequencerUp = p.isSequencerUp;

        g.maxPriceDeviationPct = p.maxPriceDeviationPct;
        g.oracleDecimals = p.oracleDecimals;
        g.gate = p.gate;
        g.pythEp = p.pythEp;
        g.safetyStateSet = p.safetyStateSet;
        g.tvl = p.tvl;

        g.vault = getVault();
        g.collections = getCollectionData(address(1));
        g.wraps = getWraps(result);

        g.chainId = block.chainid;
        g.timestamp = block.timestamp;
        g.blockNr = block.number;
    }

    // SCDP scdp;
    //     Gate gate;
    //     Minter minter;
    //     AssetView[] assets;
    //     uint32 sequencerGracePeriodTime;
    //     address pythEp;
    //     uint32 maxPriceDeviationPct;
    //     uint8 oracleDecimals;
    //     uint32 sequencerStartedAt;
    //     bool safetyStateSet;
    //     bool isSequencerUp;
    //     uint32 timestamp;
    //     uint256 blockNr;
    //     uint256 tvl;
    function getWraps(G memory _g) internal view returns (W[] memory result) {
        uint256 count;
        for (uint256 i; i < _g.assets.length; i++) {
            View.AssetView memory a = _g.assets[i];
            if (a.config.kFactor > 0 && a.synthwrap.underlying != address(0))
                ++count;
        }
        result = new DWrap[](count);
        count = 0;
        for (uint256 i; i < _g.assets.length; i++) {
            View.AssetView memory a = _g.assets[i];
            if (a.config.kFactor > 0 && a.synthwrap.underlying != address(0)) {
                uint256 nativeAmount = a.synthwrap.nativeUnderlyingEnabled
                    ? a.synthwrap.underlying.balance
                    : 0;
                uint256 amount = IERC20(a.synthwrap.underlying).balanceOf(
                    a.addr
                );
                result[count] = DWrap({
                    addr: a.addr,
                    underlying: a.synthwrap.underlying,
                    symbol: a.symbol,
                    price: a.price,
                    decimals: a.config.decimals,
                    val: toWad(amount, a.synthwrap.underlyingDecimals).wadMul(
                        a.price
                    ),
                    amount: amount,
                    nativeAmount: nativeAmount,
                    nativeVal: nativeAmount.wadMul(a.price)
                });
                ++count;
            }
        }
    }

    function getExt(
        address[] calldata _tokens,
        address _account
    ) external view returns (Ext[] memory result) {
        result = new Ext[](tokens.length);

        for (uint256 i; i < tokens.length; i++) {
            IERC20 tkn = IERC20(tokens[i]);

            (
                int256 answer,
                uint256 updatedAt,
                uint8 oracleDecimals
            ) = _possibleOracleValue(token.feed);

            uint256 balance = _account != address(0)
                ? tkn.balanceOf(_account)
                : 0;

            uint8 decimals = tkn.decimals();
            uint256 value = toWad(balance, decimals).wadMul(
                answer > 0 ? uint256(answer) : 0
            );

            result[i] = DVTokenBalance({
                chainId: block.chainid,
                addr: token.token,
                name: tkn.name(),
                symbol: _symbol(token.token),
                decimals: decimals,
                amount: balance,
                val: value,
                tSupply: tkn.totalSupply(),
                price: answer >= 0 ? uint256(answer) : 0,
                oracleDecimals: oracleDecimals,
                priceRaw: RawPrice(
                    answer,
                    block.timestamp,
                    86401,
                    block.timestamp - updatedAt > 86401,
                    answer == 0,
                    Enums.OracleType.Chainlink,
                    token.feed
                )
            });
        }
    }

    function _possibleOracleValue(
        address _feed
    ) internal view returns (int256 answer, uint256 updatedAt, uint8 decimals) {
        if (_feed == address(0)) {
            return (0, 0, 8);
        }
        (, answer, , updatedAt, ) = IAggregatorV3(_feed).latestRoundData();
        decimals = IAggregatorV3(_feed).decimals();
    }

    function getAccount(
        PythView calldata _prices,
        address _account
    ) external view returns (A memory ac) {
        ac.protocol = KRESKO.viewAccountData(_prices, _account);
        DVToken memory vData = getVault().token;
        ac.vault.addr = vaultAddr;
        ac.vault.name = vData.name;
        ac.vault.amount = vault.balanceOf(_account);
        ac.vault.tSupply = vData.tSupply;
        ac.vault.val = fromWad(ac.vault.amount.wadMul(vData.price), 8);
        ac.vault.price = vData.price;
        ac.vault.chainId = block.chainid;
        ac.vault.oracleDecimals = vData.oracleDecimals;
        ac.vault.symbol = vData.symbol;
        ac.vault.decimals = vData.decimals;

        ac.collections = getCollectionData(_account);
        (ac.phase, ac.eligible) = KRESKO.viewAccountGatingPhase(_account);
        ac.chainId = block.chainid;
    }

    function getBalances(
        PythView calldata _prices,
        address _account,
        address[] memory _tokens
    ) external view returns (View.Balance[] memory result) {
        result = KRESKO.viewTokenBalances(_prices, _account, _tokens);
    }

    function getCollectionData(
        address _account
    ) public view returns (C[] memory result) {
        result = new C[](2);

        result[0].uri = kreskian.contractURI();
        result[0].addr = kreskianAddr;
        result[0].name = kreskian.name();
        result[0].symbol = kreskian.symbol();
        result[0].items = getCollectionItems(_account, kreskian);

        result[1].uri = qfk.contractURI();
        result[1].addr = questAddr;
        result[1].name = qfk.name();
        result[1].symbol = qfk.symbol();
        result[1].items = getCollectionItems(_account, qfk);
    }

    function getCollectionItems(
        address _account,
        IKresko1155 _collection
    ) public view returns (CItem[] memory result) {
        uint256 tkns = _collection == kreskian ? 1 : 8;
        result = new CItem[](tkns);

        for (uint256 i; i < tkns; i++) {
            result[i] = CItem({
                id: i,
                uri: _collection.uri(i),
                balance: _collection.balanceOf(_account, i)
            });
        }
    }

    function getVault() public view returns (V memory result) {
        result.assets = getVAssets();
        result.token.price = vault.exchangeRate();
        result.token.symbol = vault.symbol();
        result.token.name = vault.name();
        result.token.tSupply = vault.totalSupply();
        result.token.decimals = vault.decimals();
        result.token.oracleDecimals = 18;
    }

    function getVAssets() public view returns (VA[] memory va) {
        VaultAsset[] memory vAssets = vault.allAssets();
        va = new VA[](vAssets.length);

        for (uint256 i; i < vAssets.length; i++) {
            VaultAsset memory a = vAssets[i];
            (, int256 answer, , uint256 updatedAt, ) = a.feed.latestRoundData();

            va[i] = VA({
                addr: address(a.token),
                name: a.token.name(),
                symbol: _symbol(address(a.token)),
                tSupply: a.token.totalSupply(),
                vSupply: a.token.balanceOf(vaultAddr),
                price: answer > 0 ? uint256(answer) : 0,
                isMarketOpen: KRESKO.getMarketStatus(address(a.token)),
                oracleDecimals: a.feed.decimals(),
                priceRaw: RawPrice(
                    answer,
                    block.timestamp,
                    a.staleTime,
                    block.timestamp - updatedAt > a.staleTime,
                    answer == 0,
                    Enums.OracleType.Chainlink,
                    address(a.feed)
                ),
                config: a
            });
        }
    }

    function _symbol(address _assetAddr) internal view returns (string memory) {
        return
            _assetAddr == 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8
                ? "USDC.e"
                : IERC20(_assetAddr).symbol();
    }
}
