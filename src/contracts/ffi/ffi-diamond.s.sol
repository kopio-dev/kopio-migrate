// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {create1, getFacetsAndSelectors, DiamondCtor} from "c/ffi/ffi-facets.s.sol";
import {PLog} from "kr/utils/PLog.s.sol";
import {FacetCut, FacetCutAction, IDiamondCut, Initializer} from "c/diamond/IDiamond.sol";

contract DiamondInit {
    function init() external {
        revert("nothing set for init");
    }
}

function getCuts() returns (DiamondCtor memory result) {
    (
        string[] memory files,
        bytes[] memory facets,
        bytes4[][] memory selectors
    ) = getFacetsAndSelectors();

    result.cuts = new FacetCut[](facets.length);

    for (uint256 i; i < facets.length; i++) {
        PLog.clg("Deploying:", files[i]);
        result.cuts[i].facetAddress = address(create1(facets[i]));
        result.cuts[i].functionSelectors = selectors[i];
        PLog.clg(result.cuts[i].facetAddress, "Address:");
        PLog.clg(result.cuts[i].functionSelectors.length, "Functions:");
        PLog.clg("*****************************************");

        result.cuts[i].action = FacetCutAction.Add;
    }

    result.init = Initializer(
        address(new DiamondInit()),
        abi.encodeWithSelector(DiamondInit.init.selector)
    );
}
