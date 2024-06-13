// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FacetScript} from "kr/utils/ffi/FacetScript.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";
import {__revert} from "kr/utils/Base.s.sol";
import {Factory} from "c/factory/Factory.sol";
import {FacetCut, FacetCutAction, IDiamondCut, IDiamondLoupeFacet, Initializer} from "c/diamond/IDiamond.sol";
import {create1, getFacetsAndSelectors} from "c/ffi/ffi-facets.s.sol";
import {Scripted} from "kr/utils/Scripted.s.sol";

contract Cutter is Scripted, FacetScript("./utils/getFunctionSelectors.sh") {
    using Help for *;
    using Log for *;
    using Factory for bytes;

    enum CreateMode {
        Create1,
        Create2,
        Create3
    }

    IDiamondCut diamond;
    FacetCut[] cuts;
    string[] _files;
    Initializer initializer;

    CreateMode createMode = CreateMode.Create1;

    modifier output(string memory id) {
        Factory.initOutputJSON(id);
        _;
        Factory.writeOutputJSON();
    }

    function initUpgrader(address _diamond, CreateMode _createMode) internal {
        diamond = IDiamondCut(_diamond);
        createMode = _createMode;
    }

    function executeCuts(string memory id, bool _dry) internal {
        Factory.JSONKey(("diamondCut-").and(id));
        bytes memory data = abi.encodeWithSelector(
            diamond.diamondCut.selector,
            cuts,
            initializer.initializer,
            initializer.data
        );
        Factory.setJsonAddr("to", address(diamond));
        Factory.setJsonBytes("calldata", data);
        Factory.saveJSONKey();

        if (!_dry) {
            (bool success, bytes memory retdata) = address(diamond).call(data);
            if (!success) {
                __revert(retdata);
            }
        }
    }

    function fullUpgrade() internal {
        createFullCut();
        executeCuts("full", false);
    }

    function upgradeOrAdd(string memory artifactName) internal {
        createFacetCut(artifactName);
        executeCuts(artifactName, false);
    }

    function createFacetCut(string memory artifact) internal {
        (
            string[] memory files,
            bytes[] memory facets,
            bytes4[][] memory selectors
        ) = getFacetsAndSelectors(artifact);

        require(facets.length == 1, "Only one facet should be returned");
        for (uint256 i; i < facets.length; i++) {
            handleFacet(files[i], facets[i], selectors[i]);
        }
    }

    function logCuts() internal view {
        cuts.length.clg("FacetCuts:");
        for (uint256 i; i < cuts.length; i++) {
            Log.br();
            Log.hr();
            _files[i].clg(string.concat("[CUT #", i.str(), "]"));
            cuts[i].facetAddress.clg("Facet Address");
            uint8(cuts[i].action).clg("Action");
            uint256 selectorLength = cuts[i].functionSelectors.length;

            string memory selectorStr = "[";
            for (uint256 sel; sel < selectorLength; sel++) {
                selectorStr = string.concat(
                    selectorStr,
                    string(
                        abi.encodePacked(cuts[i].functionSelectors[sel]).str()
                    ),
                    sel == selectorLength - 1 ? "" : ","
                );
            }
            string.concat(selectorStr, "]").clg(
                string.concat("Selectors (", selectorLength.str(), ")")
            );
            selectorLength.clg("Selector Count");
        }
    }

    function createFacetCut(
        string memory name,
        bytes memory facet,
        bytes4[] memory selectors
    ) internal returns (address) {
        return handleFacet(name, facet, selectors);
    }

    function createFullCut() private {
        (
            string[] memory files,
            bytes[] memory facets,
            bytes4[][] memory selectors
        ) = getFacetsAndSelectors();

        for (uint256 i; i < facets.length; i++) {
            handleFacet(files[i], facets[i], selectors[i]);
        }
    }

    function handleFacet(
        string memory fileName,
        bytes memory facet,
        bytes4[] memory selectors
    ) private returns (address facetAddr) {
        address oldFacet = IDiamondLoupeFacet(address(diamond)).facetAddress(
            selectors[0]
        );
        oldFacet = IDiamondLoupeFacet(address(diamond)).facetAddress(
            selectors[selectors.length - 1]
        );
        bytes4[] memory oldSelectors;
        if (oldFacet != address(0) && !fileName.equals("")) {
            bytes memory code = vm.getDeployedCode(
                fileName.and(".sol:").and(fileName)
            );
            // skip if code is the same
            if (
                keccak256(abi.encodePacked(code)) ==
                keccak256(abi.encodePacked(oldFacet.code))
            ) {
                Factory.JSONKey(fileName.and("-skip"));
                Factory.setJsonAddr("address", oldFacet);
                Factory.setJsonBool("skipped", true);
                Factory.saveJSONKey();
                return oldFacet;
            }

            oldSelectors = IDiamondLoupeFacet(address(diamond))
                .facetFunctionSelectors(oldFacet);
            cuts.push(
                FacetCut({
                    facetAddress: address(0),
                    action: FacetCutAction.Remove,
                    functionSelectors: oldSelectors
                })
            );
            _files.push(
                string.concat(
                    "Remove Facet -> ",
                    fileName,
                    " (",
                    oldFacet.str(),
                    ")"
                )
            );
        }
        Factory.JSONKey(fileName);
        Factory.setJsonNumber("oldSelectors", oldSelectors.length);
        facetAddr = _create(fileName, facet);
        Factory.setJsonAddr("address", facetAddr);

        cuts.push(
            FacetCut({
                facetAddress: facetAddr,
                action: FacetCutAction.Add,
                functionSelectors: selectors
            })
        );
        _files.push(string.concat("New Facet -> ", fileName));
        Factory.setJsonNumber("newSelectors", selectors.length);
        Factory.saveJSONKey();
    }

    function _create(
        string memory _fileName,
        bytes memory _code
    ) internal returns (address addr) {
        if (createMode == CreateMode.Create1) {
            addr = create1(_code);
        } else if (createMode == CreateMode.Create2) {
            addr = _code.d2("", bytes32(bytes(_fileName))).implementation;
        } else {
            addr = _code
                .d3("", keccak256(abi.encodePacked(_code)))
                .implementation;
        }
    }
}
