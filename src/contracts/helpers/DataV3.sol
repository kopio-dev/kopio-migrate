// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Oracle, Enums, IKopioCore} from "kopio/IKopioCore.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {IAggregatorV3} from "kopio/vendor/IAggregatorV3.sol";
import {PythView, Price} from "kopio/vendor/Pyth.sol";
import {IData} from "./IData.sol";
import {Pyth} from "kopio/utils/Oracles.sol";
import {Utils} from "kopio/utils/Libs.sol";
import {ArbDeployAddr} from "kopio/info/ArbDeployAddr.sol";
import {IPyth} from "kopio/vendor/Pyth.sol";
import {IQuoterV2} from "kopio/vendor/IQuoterV2.sol";
import {ILZ1155} from "kopio/token/ILZ1155.sol";
import {VaultAsset, IVault} from "kopio/IVault.sol";

contract DataV3 is ArbDeployAddr, IData {
    using Utils for *;

    IKopioCore constant core = IKopioCore(protocolAddr);
    ILZ1155 constant kreskian =
        ILZ1155(0xAbDb949a18d27367118573A217E5353EDe5A0f1E);
    ILZ1155 constant qfk = ILZ1155(0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6);

    ILZ1155[2] collections = [kreskian, qfk];
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
        TAsset[] memory protocol = core.aDataProtocol(emptyPrices).assets;
        for (uint256 i; i < protocol.length; i++) {
            TAsset memory item = protocol[i];
            Oracle memory pyth = core.getOracleOfTicker(
                item.config.ticker,
                Enums.OracleType.Pyth
            );
            oracles[item.addr] = Oracles({
                addr: item.addr,
                clFeed: core.getFeedForAddress(
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
        Protocol memory p = core.aDataProtocol(_prices);
        g.scdp = p.scdp;
        g.icdp = p.icdp;
        g.assets = p.assets;
        g.tokens = getTokens(_prices, address(0), _extTokens);

        g.seqPeriod = p.seqGracePeriod;
        g.seqStart = p.seqStartAt;
        g.seqUp = p.seqUp;

        g.maxDeviation = p.maxDeviation;
        g.oracleDec = p.oracleDecimals;
        g.safety = p.safety;
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
        Account memory data = core.aDataAccount(_prices, _account);
        ac.addr = data.addr;
        ac.icdp = data.icdp;
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
        TAsset[] memory assets = core.aDataProtocol(_prices).assets;

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
            isKopio: false,
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
        ILZ1155 _collection
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
            ILZ1155 coll = collections[i];
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
            if (_g.assets[i].wrap.underlying != address(0)) ++items;
        }
        res = new W[](items);
        for (uint256 i; i < _g.assets.length; i++) {
            TAsset memory a = _g.assets[i];
            if (a.wrap.underlying != address(0)) {
                uint256 amount = IERC20(a.wrap.underlying).balanceOf(a.addr);
                uint256 native = a.addr.balance;
                res[--items] = W(
                    a.addr,
                    a.wrap.underlying,
                    a.symbol,
                    a.price,
                    a.config.decimals,
                    amount,
                    native,
                    amount.toWad(a.wrap.underlyingDec).wmul(a.price),
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
                isKopio: false,
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
        TAsset memory _a
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
                isKopio: _a.config.dFactor > 0,
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
