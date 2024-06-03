// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

import {vmFFI, FFIResult} from "kr/utils/Base.s.sol";
import {PythView, IPyth, PriceFeed, getPythPriceView} from "kr/vendor/Pyth.sol";

IPyth constant pythEP = IPyth(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);

function getPythData(
    string memory _ids
) returns (bytes[] memory payload, PythView memory views) {
    (payload, , views) = _ffi(_ids);
}

function getPythData(
    bytes32[] memory _ids
) returns (bytes[] memory payload, PythView memory views) {
    string memory arg;
    for (uint256 i; i < _ids.length; i++) {
        arg = string.concat(arg, i == 0 ? "" : ",", vmFFI.toString(_ids[i]));
    }
    (payload, , views) = _ffi(arg);
}

abstract contract PythBase {
    bytes[] pythUpdate;
    PythView pythView;
    string pythAssets = "DAI,ETH,SOL,BTC,USDC,EUR,JPY";

    function fetchPyth(string memory assets) internal {
        (bytes[] memory update, PythView memory values) = getPythData(assets);
        pythUpdate = update;
        pythView.ids = values.ids;
        delete pythView.prices;
        for (uint256 i; i < values.prices.length; i++) {
            pythView.prices.push(values.prices[i]);
        }
    }

    function fetchPyth() internal {
        fetchPyth(pythAssets);
    }

    function fetchPythAndUpdate() internal {
        fetchPyth();
        pythEP.updatePriceFeeds{value: pythEP.getUpdateFee(pythUpdate)}(
            pythUpdate
        );
    }
}

function _ffi(
    string memory _arg
)
    returns (
        bytes[] memory payload,
        PriceFeed[] memory assets,
        PythView memory views
    )
{
    string[] memory args = new string[](4);
    args[0] = "bun";
    args[1] = "utils/ffi.ts";
    args[2] = "fetchPythData";
    args[3] = _arg;

    FFIResult memory result = vmFFI.tryFfi(args);
    if (result.exitCode == 1) {
        revert(abi.decode(result.stdout, (string)));
    }

    (payload, assets) = abi.decode(vmFFI.ffi(args), (bytes[], PriceFeed[]));
    views = getPythPriceView(assets);
}
