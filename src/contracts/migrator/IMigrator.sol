// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Asset, Kresko} from "c/helpers/Kresko.sol";
import {ArbDeploy} from "kopio/info/ArbDeploy.sol";
import {IKopioCore} from "kopio/IKopioCore.sol";

interface ICollateralReceiver {
    function onUncheckedCollateralWithdraw(
        address _account,
        address _collateralAsset,
        uint256 _withdrawalAmount,
        uint256 _depositedCollateralAssetIndex,
        bytes memory _userData
    ) external returns (bytes memory);
}

// solhint-disable no-empty-blocks

bytes32 constant MIGRATOR_SLOT = keccak256(
    abi.encode(uint256(keccak256("migration.migrator.slot")) - 1)
) & ~bytes32(uint256(0xff));

struct MigratorState {
    mapping(address => address) getAsset;
    mapping(address => uint256) points;
    address[] krAssets;
    address[] kopios;
    address[] exts;
    IMigrator.Pos[] posColl;
    IMigrator.Pos[] posDebt;
    IMigrator.Transfer[] txColl;
    IMigrator.Transfer[] txDebt;
    uint256 maxSlippage;
    uint256 debtValue;
    uint256 collValue;
    address[] assetsUsed;
}

abstract contract IMigrator is ArbDeploy, Kresko {
    IKopioCore constant core = IKopioCore(protocolAddr);

    struct Token {
        address addr;
        Asset asset;
    }

    struct Pos {
        Token a;
        uint256 amount;
        uint256 value;
        uint256 valueAdj;
        uint256 idx;
    }

    event PositionTransferred(
        address indexed account,
        address indexed from,
        address indexed to,
        uint256 amountFrom,
        uint256 amountTo
    );
    error Slippage(
        uint256 slippage,
        uint256 maxSlippage,
        uint256 valIn,
        uint256 valOut
    );

    error InsufficientAssets(address account, address asset, uint256 amount);

    error InvalidSender(address);

    error ZeroAmount(address);

    error MigrationPreview(MigrationResult);

    event Migration(address, uint256, uint256);

    struct Transfer {
        address asset;
        address destination;
        uint256 idx;
        uint256 amount;
        uint256 amountTransferred;
        uint256 value;
    }

    struct ProtocolResult {
        uint256 valSCDPBefore;
        uint256 valSCDP;
        uint256 valCollBefore;
        uint256 valColl;
        uint256 valDebtBefore;
        uint256 valDebt;
        uint256 valTotalBefore;
        uint256 valTotal;
    }

    struct MigrationResult {
        address account;
        Transfer[] icdpColl;
        Transfer[] icdpDebt;
        Transfer scdp;
        ProtocolResult kresko;
        ProtocolResult kopio;
        uint256 valueBefore;
        uint256 valueNow;
        uint256 slippage;
    }

    function ms() internal pure returns (MigratorState storage state) {
        bytes32 slot = MIGRATOR_SLOT;
        assembly {
            state.slot := slot
        }
    }

    function clearState() internal {
        delete ms().txColl;
        delete ms().txDebt;
        delete ms().posColl;
        delete ms().posDebt;
        delete ms().assetsUsed;
        ms().debtValue = 0;
        ms().collValue = 0;
    }

    function migrate(
        address account,
        bytes[] calldata prices
    ) external payable virtual returns (MigrationResult memory result) {}

    function previewMigrate(
        address account,
        bytes[] calldata prices
    ) external payable virtual returns (MigrationResult memory result) {}

    function getPreviewResult(
        bytes calldata _errorData
    ) external pure virtual returns (MigrationResult memory result) {}

    function emitTransfers(address) external virtual {}
}
