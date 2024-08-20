// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Utils} from "kopio/utils/Libs.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {Base} from "s/base/Base.s.sol";

import {Route} from "c/migrator/router/IMigrationRouter.sol";
import {MigrationExtras} from "c/migrator/MigrationExtras.sol";
import {Migrator} from "c/migrator/Migrator.sol";
import {IMigrator} from "c/migrator/IMigrator.sol";
import {MigrationRouter} from "c/migrator/router/MigrationRouter.sol";
import {SafeScript} from "kopio/vm-ffi/SafeScript.s.sol";
import {PythUpdater} from "c/migrator/PythUpdater.sol";

contract MigrationDeploy is SafeScript, Base {
    using PLog for *;
    using Utils for *;

    Migrator migrator = Migrator(0xaaaaaAaAaAa186774266Ea9b3FC0B588B3232795);
    MigrationRouter router;
    address routerAddr = 0xaaaaaAaAaAa186774266Ea9b3FC0B588B3232795;

    Route[] internal routes;

    function setUp() public virtual {
        base("MNEMONIC_KOPIO", "arbitrum");
    }

    function deployPythUpdater() external broadcastedById(0) {
        // bytes32 salt = 0xfeefeefee4cc1f612d3c3810e4deec59daf49d40;
        bytes32 salt = 0x37f4b7730f140871991c78a3e866294fe500b653ca82273b7bfad8045d85a470;

        bytes memory ctor = abi.encode(getAddr(0));

        jsons("ctor-pythupdater", ctor);
        bytes memory impl = bytes.concat(type(PythUpdater).creationCode, ctor);

        address updater = factory
        .deployCreate3{value: 1e9}(impl, "", salt).implementation;

        updater.clg("updater");
    }

    function updateMigrationRouter() public broadcastedById(0) {
        router = MigrationRouter(payable(routerAddr));
        Route[] memory funcs = new Route[](2);

        funcs[0] = Route({
            impl: address(new Migrator()),
            sig: Migrator.migrate.selector
        });
        funcs[1] = Route({
            impl: funcs[0].impl,
            sig: Migrator.onUncheckedCollateralWithdraw.selector
        });
        router.setRoute(funcs[0]);
        router.setRoute(funcs[1]);
    }

    function deployMigrationRouter(
        address owner
    ) internal broadcasted(owner) withJSON("MigrationRouter") {
        jsonKey("deployment");
        json(owner, "owner");
        address _migrator = address(new Migrator());
        json(_migrator, "migrator");
        address _extras = address(new MigrationExtras());
        json(_extras, "extras");

        bytes memory ctor = abi.encode(owner, getRoutes(_migrator, _extras));
        json(ctor, "ctor");
        bytes memory routerImpl = abi.encodePacked(
            type(MigrationRouter).creationCode,
            ctor
        );

        routerAddr = factory
            .deployCreate3(
                routerImpl,
                "",
                0x263519a90d43362f176df75009b92836e500b653ca82273b7bfad8045d85a470
            )
            .implementation;
        json(routerAddr, "router");

        router = MigrationRouter(payable(routerAddr));
        routerAddr = address(router);

        migrator = Migrator(address(router));

        MigrationExtras(routerAddr).initializeMigrationState();
        payable(routerAddr).transfer(1e9);
        router.authorize(safe);

        core.grantRole(keccak256("kopio.role.manager"), routerAddr);
        jsonKey();
    }

    function getRoutes(
        address _logic,
        address _extras
    ) internal returns (Route[] memory) {
        routes = [
            Route({
                impl: _extras,
                sig: MigrationExtras.setMaxMigrationSlippage.selector
            }),
            Route({
                impl: _extras,
                sig: MigrationExtras.initializeMigrationState.selector
            }),
            Route({impl: _extras, sig: IMigrator.previewMigrate.selector}),
            Route({impl: _extras, sig: IMigrator.getPreviewResult.selector}),
            Route({impl: _extras, sig: IMigrator.emitTransfers.selector}),
            Route({impl: _logic, sig: IMigrator.migrate.selector}),
            Route({
                impl: _logic,
                sig: Migrator.onUncheckedCollateralWithdraw.selector
            })
        ];

        return routes;
    }
}
