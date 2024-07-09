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
import {IData} from "./IData.sol";
import {Pyth} from "kr/utils/Oracles.sol";
import {Utils} from "kr/utils/Libs.sol";
import {ArbDeploy} from "kr/info/ArbDeploy.sol";
import {Price} from "kr/vendor/Pyth.sol";

contract DataV3 is ArbDeploy, IData {
    using WadRay for uint256;
    using PercentageMath for uint256;
    using Utils for *;

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

    function getAssets() public view returns (View.AssetView[] memory) {
        return KRESKO.viewProtocolData(emptyPrices).assets;
    }

    function getGlobals(
        PythView calldata _prices,
        address[] calldata _extTokens
    ) external view returns (G memory g) {
        View.Protocol memory p = KRESKO.viewProtocolData(_prices);
        g.scdp = p.scdp;
        g.minter = p.minter;
        g.assets = p.assets;
        g.tokens = getTokens(_prices, address(0), _extTokens);

        g.seqPeriod = p.sequencerGracePeriodTime;
        g.seqStart = p.sequencerStartedAt;
        g.seqUp = p.isSequencerUp;

        g.maxDeviation = p.maxPriceDeviationPct;
        g.oracleDec = p.oracleDecimals;
        g.pythEp = p.pythEp;
        g.safety = p.safetyStateSet;
        g.tvl = p.tvl;

        g.vault = getVault();
        g.collections = getCollectionData(address(1));
        g.wraps = getWraps(g);

        g.chainId = block.chainid;
        g.timestamp = uint32(block.timestamp);
        g.blockNr = block.number;
    }

    function getWraps(G memory _g) internal view returns (W[] memory result) {
        uint256 count;
        for (uint256 i; i < _g.assets.length; i++) {
            View.AssetView memory a = _g.assets[i];
            if (a.config.kFactor > 0 && a.synthwrap.underlying != address(0))
                ++count;
        }
        result = new W[](count);
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
                result[count] = W({
                    addr: a.addr,
                    underlying: a.synthwrap.underlying,
                    symbol: a.symbol,
                    price: a.price,
                    decimals: a.config.decimals,
                    val: amount.toWad(a.synthwrap.underlyingDecimals).wadMul(
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

    function getExtToken(
        address _account,
        address _token
    ) internal view returns (Tkn memory res) {
        TokenData memory data = tokenData(_account, _token, 0, 0);

        res = Tkn({
            addr: _token,
            ticker: data.symbol,
            name: data.name,
            symbol: data.symbol,
            decimals: data.decimals,
            amount: data.balance,
            val: data.value,
            tSupply: IERC20(_token).totalSupply(),
            price: data.price,
            isKrAsset: false,
            isCollateral: false,
            oracleDec: data.oracleDecimals,
            chainId: block.chainid
        });
    }

    function getAccount(
        PythView calldata _prices,
        address _account,
        address[] calldata _extTokens
    ) external view returns (A memory ac) {
        View.Account memory data = KRESKO.viewAccountData(_prices, _account);
        ac.addr = data.addr;
        ac.chainId = ac.chainId;
        ac.minter = data.minter;
        ac.scdp = data.scdp;

        ac.collections = getCollectionData(_account);
        ac.chainId = block.chainid;

        Tkn memory vKISS = getVault().share;
        vKISS.amount = vault.balanceOf(_account);
        vKISS.val = vKISS.amount.wadMul(vKISS.price).fromWad(8);

        ac.tokens = getTokens(_prices, _account, _extTokens);
    }

    function getTokens(
        PythView calldata _prices,
        address _account,
        address[] calldata _extTokens
    ) public view returns (Tkn[] memory result) {
        View.AssetView[] memory protocolAssets = KRESKO
            .viewProtocolData(_prices)
            .assets;
        result = new Tkn[](protocolAssets.length + _extTokens.length + 1);
        uint256 i;
        uint256 ethPrice;
        for (i; i < protocolAssets.length; i++) {
            result[i] = _assetViewToTkn(_account, protocolAssets[i]);
            if (
                keccak256(abi.encodePacked(result[i].ticker)) ==
                keccak256(abi.encodePacked((string("ETH"))))
            ) ethPrice = result[i].price;
        }

        for (uint256 j; j < _extTokens.length; j++) {
            result[i++] = getExtToken(_account, _extTokens[j]);
        }

        uint256 nativeBal = _account != (address(0)) ? _account.balance : 0;
        result[i] = Tkn({
            addr: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
            name: "Ethereum",
            symbol: "ETH",
            decimals: 18,
            amount: nativeBal,
            val: nativeBal.wadMul(ethPrice),
            tSupply: 0,
            price: ethPrice,
            chainId: block.chainid,
            isKrAsset: false,
            isCollateral: true,
            ticker: "ETH",
            oracleDec: 8
        });
    }
    function _assetViewToTkn(
        address _account,
        View.AssetView memory asset
    ) internal view returns (Tkn memory res) {
        TokenData memory data = tokenData(_account, asset.addr, asset.price, 8);
        res = Tkn({
            addr: asset.addr,
            ticker: _str(bytes.concat(asset.config.ticker)),
            name: data.name,
            symbol: data.symbol,
            decimals: data.decimals,
            amount: data.balance,
            val: data.value,
            tSupply: asset.tSupply,
            price: data.price,
            chainId: block.chainid,
            isKrAsset: asset.config.kFactor > 0,
            isCollateral: asset.config.factor > 0,
            oracleDec: data.oracleDecimals
        });
    }
    function tokenData(
        address _account,
        address _token,
        uint256 _price,
        uint8 _oracleDec
    ) internal view returns (TokenData memory res) {
        IERC20 token = IERC20(_token);
        if (_price == 0) {
            (_price, _oracleDec) = _getPrice(_token);
        }
        uint8 dec = token.decimals();
        uint256 bal = _account != address(0) ? token.balanceOf(_account) : 0;
        uint256 value = bal > 0
            ? bal.toWad(dec).wadMul(_price.toWad(_oracleDec)).fromWad(8)
            : 0;
        res.name = token.name();
        res.symbol = _symbol(_token);
        res.balance = bal;
        res.value = value;
        res.price = _price;
        res.decimals = dec;
        res.oracleDecimals = 8;
    }
    function getVault() public view returns (V memory result) {
        result.assets = getVAssets();
        result.share.addr = vaultAddr;
        result.share.price = vault.exchangeRate();
        result.share.symbol = vault.symbol();
        result.share.name = vault.name();
        result.share.tSupply = vault.totalSupply();
        result.share.decimals = vault.decimals();
        result.share.oracleDec = 18;
        result.share.chainId = block.chainid;
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

    function _getPrice(
        address _token
    ) internal view returns (uint256 price, uint8 decimals) {
        Oracles memory cfg = oracles[_token];
        try pythEP.getPriceNoOlderThan(cfg.pythId, 30) returns (
            Price memory p
        ) {
            (price, decimals) = Pyth.processPyth(p, cfg.addr == krJPYAddr);
        } catch {
            (, int256 answer, , , ) = IAggregatorV3(cfg.clFeed)
                .latestRoundData();
            price = uint256(answer);
            decimals = IAggregatorV3(cfg.clFeed).decimals();
        }
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

    function _str(bytes memory data) internal pure returns (string memory res) {
        for (uint256 i; i < data.length; i++) {
            if (data[i] == 0x00) continue;
            res = string.concat(res, string(bytes.concat(data[i])));
        }
    }
}

struct TokenData {
    string name;
    string symbol;
    uint256 balance;
    uint256 value;
    uint256 price;
    uint8 decimals;
    uint8 oracleDecimals;
}
