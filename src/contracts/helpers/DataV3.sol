// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {View} from "kr/core/types/Views.sol";
import {IERC20} from "kr/token/IERC20.sol";
import {IKresko1155} from "kr/token/IKresko1155.sol";
import {VaultAsset} from "kr/core/IVault.sol";
import {Enums} from "kr/core/types/Const.sol";
import {IAggregatorV3} from "kr/vendor/IAggregatorV3.sol";
import {PythView} from "kr/vendor/Pyth.sol";
import {IKresko} from "kr/core/IKresko.sol";
import {IData} from "./IData.sol";
import {Pyth} from "kr/utils/Oracles.sol";
import {Utils} from "kr/utils/Libs.sol";
import {Price} from "kr/vendor/Pyth.sol";
import {Oracle} from "kr/core/types/Data.sol";
import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {IVault} from "kr/core/IVault.sol";
import {IPyth} from "kr/vendor/Pyth.sol";
import {IQuoterV2} from "kr/vendor/IQuoterV2.sol";
import {IKreskoAsset} from "kr/core/IKreskoAsset.sol";

contract DataV3 is ArbDeployAddr, IData {
    using Utils for *;

    IKresko constant KRESKO = IKresko(kreskoAddr);
    IKresko1155 constant kreskian = IKresko1155(kreskianAddr);
    IKresko1155 constant qfk = IKresko1155(questAddr);
    IKresko1155[2] collections = [kreskian, qfk];
    IVault constant vault = IVault(vaultAddr);

    PythView emptyPrices;
    mapping(address => Oracles) public oracles;

    constructor(Oracles[] memory _oracles) {
        refreshProtocolAssets();
        for (uint256 i; i < _oracles.length; i++) {
            oracles[_oracles[i].addr] = _oracles[i];
        }
    }

    function refreshProtocolAssets() public {
        View.AssetView[] memory protocol = KRESKO
            .viewProtocolData(emptyPrices)
            .assets;
        for (uint256 i; i < protocol.length; i++) {
            View.AssetView memory item = protocol[i];
            Oracle memory pyth = KRESKO.getOracleOfTicker(
                item.config.ticker,
                Enums.OracleType.Pyth
            );
            oracles[item.addr] = Oracles({
                addr: item.addr,
                clFeed: KRESKO.getFeedForAddress(
                    item.addr,
                    Enums.OracleType.Chainlink
                ),
                pythId: pyth.pythId,
                invertPyth: pyth.invertPyth,
                ext: false
            });
        }
    }

    function getGlobals(
        PythView calldata _prices,
        address[] memory _extTokens
    ) public view returns (G memory g) {
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
        g.safety = p.safetyStateSet;
        g.tvl = p.tvl;

        g.vault = _vault();
        g.collections = getCollectionData(address(1));
        g.wraps = _wraps(g);

        g.chainId = block.chainid;
        g.timestamp = uint32(block.timestamp);
        g.blockNr = block.number;
    }

    function getAccount(
        PythView calldata _prices,
        address _account,
        address[] calldata _extTokens
    ) external view returns (A memory ac) {
        View.Account memory data = KRESKO.viewAccountData(_prices, _account);
        ac.addr = data.addr;
        ac.minter = data.minter;
        ac.scdp = data.scdp;

        ac.collections = getCollectionData(_account);
        ac.chainId = block.chainid;
        ac.tokens = getTokens(_prices, _account, _extTokens);
    }

    function getTokens(
        PythView calldata _prices,
        address _account,
        address[] memory _extTokens
    ) public view returns (Tkn[] memory result) {
        View.AssetView[] memory assets = KRESKO
            .viewProtocolData(_prices)
            .assets;

        result = new Tkn[](assets.length + _extTokens.length + 1);

        uint256 i;
        uint256 ethPrice;

        for (i; i < assets.length; i++) {
            if (assets[i].config.ticker == "ETH") ethPrice = result[i].price;
            result[i] = _assetToToken(_account, assets[i]);
        }

        for (uint256 j; j < _extTokens.length; j++) {
            result[i++] = _getExtToken(_account, _extTokens[j]);
        }

        uint256 nativeBal = _account != address(0) ? _account.balance : 0;
        result[i] = Tkn({
            addr: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
            name: "Ethereum",
            symbol: "ETH",
            decimals: 18,
            amount: nativeBal,
            val: nativeBal.wmul(ethPrice),
            tSupply: 0,
            price: ethPrice,
            chainId: block.chainid,
            isKrAsset: false,
            isCollateral: true,
            ticker: "ETH",
            oracleDec: 8
        });
    }

    function getVAssets() public view returns (VA[] memory va) {
        VaultAsset[] memory vAssets = vault.allAssets();
        va = new VA[](vAssets.length);

        for (uint256 i; i < vAssets.length; i++) {
            VaultAsset memory a = vAssets[i];
            (, int256 answer, , , ) = a.feed.latestRoundData();

            va[i] = VA({
                addr: address(a.token),
                name: a.token.name(),
                symbol: _symbol(address(a.token)),
                tSupply: a.token.totalSupply(),
                vSupply: a.token.balanceOf(vaultAddr),
                price: uint256(answer),
                isMarketOpen: true,
                oracleDec: a.feed.decimals(),
                config: a
            });
        }
    }

    function getCollectionItems(
        address _account,
        IKresko1155 _collection
    ) public view returns (CItem[] memory res) {
        res = new CItem[](_collection == kreskian ? 1 : 8);

        for (uint256 i; i < res.length; i++) {
            res[i] = CItem(
                i,
                _collection.uri(i),
                _collection.balanceOf(_account, i)
            );
        }
    }

    function getCollectionData(
        address _account
    ) public view returns (C[] memory res) {
        res = new C[](2);

        for (uint256 i; i < collections.length; i++) {
            IKresko1155 coll = collections[i];
            res[i].uri = coll.contractURI();
            res[i].addr = address(coll);
            res[i].name = coll.name();
            res[i].symbol = coll.symbol();
            res[i].items = getCollectionItems(_account, coll);
        }
    }

    function previewWithdraw(
        PreviewWd calldata args
    ) external payable returns (uint256 amount, uint256 fee) {
        amount = args.outputAmount;

        if (args.path.length != 0) {
            (amount, , , ) = IQuoterV2(quoterV2Addr).quoteExactOutput(
                args.path,
                args.outputAmount
            );
        }
        return vault.previewWithdraw(args.vaultAsset, amount);
    }

    function _wraps(G memory _g) internal view returns (W[] memory res) {
        uint256 items;
        for (uint256 i; i < _g.assets.length; i++) {
            if (_g.assets[i].synthwrap.underlying != address(0)) ++items;
        }
        res = new W[](items);
        for (uint256 i; i < _g.assets.length; i++) {
            View.AssetView memory a = _g.assets[i];
            IKreskoAsset.Wrapping memory wrap = a.synthwrap;
            if (wrap.underlying != address(0)) {
                uint256 amount = IERC20(wrap.underlying).balanceOf(a.addr);
                uint256 native = a.addr.balance;
                res[--items] = W(
                    a.addr,
                    wrap.underlying,
                    a.symbol,
                    a.price,
                    a.config.decimals,
                    amount,
                    native,
                    amount.toWad(wrap.underlyingDecimals).wmul(a.price),
                    native.wmul(a.price)
                );
            }
        }
    }

    function _getExtToken(
        address _acc,
        address _tkn
    ) internal view returns (Tkn memory) {
        TokenData memory tkn = _tokenData(_acc, _tkn, 0, 0);

        return
            Tkn({
                addr: _tkn,
                ticker: tkn.symbol,
                name: tkn.name,
                symbol: tkn.symbol,
                decimals: tkn.decimals,
                amount: tkn.balance,
                val: tkn.value,
                tSupply: tkn.tSupply,
                price: tkn.price,
                isKrAsset: false,
                isCollateral: false,
                oracleDec: tkn.oracleDec,
                chainId: block.chainid
            });
    }

    function _symbol(address _tkn) internal view returns (string memory) {
        if (_tkn == 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8) return "USDC.e";
        return IERC20(_tkn).symbol();
    }

    function _getPrice(
        address _token
    ) internal view returns (uint256 price, uint8 decimals) {
        Oracles memory cfg = oracles[_token];
        try IPyth(pythAddr).getPriceNoOlderThan(cfg.pythId, 30) returns (
            Price memory p
        ) {
            return Pyth.processPyth(p, cfg.invertPyth);
        } catch {
            IAggregatorV3 clFeed = IAggregatorV3(cfg.clFeed);
            (, int256 answer, , , ) = clFeed.latestRoundData();
            return (uint256(answer), clFeed.decimals());
        }
    }

    function _assetToToken(
        address _account,
        View.AssetView memory _a
    ) internal view returns (Tkn memory) {
        TokenData memory t = _tokenData(_account, _a.addr, _a.price, 8);
        return
            Tkn({
                addr: _a.addr,
                ticker: _a.config.ticker.str(),
                name: t.name,
                symbol: t.symbol,
                decimals: t.decimals,
                amount: t.balance,
                val: t.value,
                tSupply: t.tSupply,
                price: t.price,
                chainId: block.chainid,
                isKrAsset: _a.config.kFactor > 0,
                isCollateral: _a.config.factor > 0,
                oracleDec: t.oracleDec
            });
    }

    function _tokenData(
        address _account,
        address _token,
        uint256 _price,
        uint8 _oracleDec
    ) internal view returns (TokenData memory res) {
        if (_price == 0) (_price, _oracleDec) = _getPrice(_token);

        IERC20 token = IERC20(_token);
        res.name = token.name();
        res.symbol = _symbol(_token);
        res.tSupply = token.totalSupply();
        res.balance = _account != address(0) ? token.balanceOf(_account) : 0;
        res.price = _price;
        res.value = res
            .balance
            .toWad((res.decimals = token.decimals()))
            .wmul(_price.toWad(_oracleDec))
            .fromWad((res.oracleDec = 8));
    }

    function _vault() internal view returns (V memory result) {
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
}

struct TokenData {
    string name;
    string symbol;
    uint256 balance;
    uint256 value;
    uint256 price;
    uint256 tSupply;
    uint8 decimals;
    uint8 oracleDec;
}
