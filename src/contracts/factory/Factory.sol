// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {Deployment, IDeploymentFactory} from "c/factory/IDeploymentFactory.sol";
import {mvm} from "kr/utils/MinVm.s.sol";

library Factory {
    IDeploymentFactory internal constant FACTORY =
        IDeploymentFactory(0x000000000070AB95211e32fdA3B706589D3482D5);

    struct DeployState {
        IDeploymentFactory factory;
        string id;
        string outputLocation;
        string currentKey;
        string currentJson;
        string outputJson;
        bool disableLog;
    }

    bytes32 internal constant DEPLOY_STATE_SLOT = keccak256("DeployState");

    function initOutputJSON(string memory configId) internal {
        string memory outputDir = string.concat(
            "./temp/",
            mvm.toString(block.chainid),
            "/"
        );
        if (!mvm.exists(outputDir)) mvm.createDir(outputDir, true);
        state().id = configId;
        state().outputLocation = outputDir;
        state().outputJson = configId;
    }

    function writeOutputJSON() internal {
        string memory runsDir = string.concat(state().outputLocation, "runs/");
        if (!mvm.exists(runsDir)) mvm.createDir(runsDir, true);
        mvm.writeFile(
            string.concat(
                runsDir,
                state().id,
                "-",
                mvm.toString(mvm.unixTime()),
                ".json"
            ),
            state().outputJson
        );
        mvm.writeFile(
            string.concat(
                state().outputLocation,
                state().id,
                "-",
                "latest",
                ".json"
            ),
            state().outputJson
        );
    }

    function state() internal pure returns (DeployState storage ds) {
        bytes32 slot = DEPLOY_STATE_SLOT;
        assembly {
            ds.slot := slot
        }
    }

    modifier saveOutput(string memory id) {
        JSONKey(id);
        _;
        saveJSONKey();
    }

    function JSONKey(string memory id) internal {
        state().currentKey = id;
        state().currentJson = "";
    }

    function setJsonAddr(string memory key, address val) internal {
        state().currentJson = mvm.serializeAddress(
            state().currentKey,
            key,
            val
        );
    }

    function setJsonBool(string memory key, bool val) internal {
        state().currentJson = mvm.serializeBool(state().currentKey, key, val);
    }

    function setJsonNumber(string memory key, uint256 val) internal {
        state().currentJson = mvm.serializeUint(state().currentKey, key, val);
    }

    function setJsonBytes(string memory key, bytes memory val) internal {
        state().currentJson = mvm.serializeBytes(state().currentKey, key, val);
    }

    function saveJSONKey() internal {
        state().outputJson = mvm.serializeString(
            "out",
            state().currentKey,
            state().currentJson
        );
    }

    function pd3(bytes32 salt) internal view returns (address) {
        return FACTORY.getCreate3Address(salt);
    }

    function pp3(bytes32 salt) internal view returns (address, address) {
        return FACTORY.previewCreate3ProxyAndLogic(salt);
    }

    function ctor(
        bytes memory bcode,
        bytes memory args
    ) internal returns (bytes memory ccode) {
        setJsonBytes("ctor", args);
        return abi.encodePacked(bcode, args);
    }

    function d2(
        bytes memory ccode,
        bytes memory _init,
        bytes32 _salt
    ) internal returns (Deployment memory result) {
        result = FACTORY.deployCreate2(ccode, _init, _salt);
        setJsonAddr("address", result.implementation);
    }

    function d3(
        bytes memory ccode,
        bytes memory _init,
        bytes32 _salt
    ) internal returns (Deployment memory result) {
        result = FACTORY.deployCreate3(ccode, _init, _salt);
        setJsonAddr("address", result.implementation);
    }

    function p3(
        bytes memory ccode,
        bytes memory _init,
        bytes32 _salt
    ) internal returns (Deployment memory result) {
        result = FACTORY.create3ProxyAndLogic(ccode, _init, _salt);
        setJsonAddr("address", address(result.proxy));
        setJsonBytes(
            "initializer",
            abi.encode(result.implementation, address(FACTORY), _init)
        );
        setJsonAddr("implementation", result.implementation);
    }
}
