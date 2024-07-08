// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {kr, Help, Log} from "s/kr.s.sol";

contract testkr is kr, Tested {
    using Log for *;
    using Help for *;

    Forwarder forwarder;

    function setUp() public override {
        super.setUp();
    }

    function test3Kr() public {
        kresko.getGatingManager().clg("manager");
    }
}

contract Forwarder {
    function msgSender() public view returns (address payable sender) {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender = payable(msg.sender);
        }
        return sender;
    }

    function execMetaNoCheck(
        address userAddress,
        bytes memory functionSignature,
        bytes32 _r,
        bytes32 _s,
        uint8 _v
    ) public payable returns (bytes memory) {
        // erAddress and relayer address at the end to extract it from calling context
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodePacked(functionSignature, userAddress)
        );
        require(success, "Function call not successful");

        return returnData;
    }

    function verify(
        address _who,
        bytes32 _data,
        bytes32 _r,
        bytes32 _s,
        uint8 _v
    ) public pure returns (bool) {
        return _who == ecrecover(keccak256(abi.encode(_data)), _v, _r, _s);
    }

    function toTypedMessageHash(
        bytes32 messageHash
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    hex"86946f1e08cf66069334b1438bc3a5eca44a0efb740aad7f5abed8d9f64fc6a8",
                    messageHash
                )
            );
    }

    struct MetaTransaction {
        uint256 nonce;
        address from;
        bytes functionSignature;
    }

    function verify(
        address signer,
        MetaTransaction memory metaTx,
        bytes32 sigR,
        bytes32 sigS,
        uint8 sigV
    ) internal pure returns (bool) {
        require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
        return
            signer ==
            ecrecover(
                toTypedMessageHash(hashMetaTransaction(metaTx)),
                sigV,
                sigR,
                sigS
            );
    }

    bytes32 private constant META_TRANSACTION_TYPEHASH =
        keccak256(
            bytes(
                "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
            )
        );

    mapping(address => uint256) nonces;

    function getTx(
        address _from,
        bytes memory _data
    ) public view returns (MetaTransaction memory res) {
        res.nonce = nonces[_from] + 1;
        res.from = _from;
        res.functionSignature = _data;
    }

    function execMeta(
        address userAddress,
        bytes memory functionSignature,
        bytes32 sigR,
        bytes32 sigS,
        uint8 sigV
    ) public payable returns (bytes memory) {
        MetaTransaction memory metaTx = MetaTransaction({
            nonce: nonces[userAddress],
            from: userAddress,
            functionSignature: functionSignature
        });

        require(
            verify(userAddress, metaTx, sigR, sigS, sigV),
            "Signer and signature do not match"
        );

        // increase nonce for user (to avoid re-use)
        nonces[userAddress] = nonces[userAddress] + 1;

        // Append userAddress and relayer address at the end to extract it from calling context
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodePacked(functionSignature, userAddress)
        );
        require(success, "Function call not successful");

        return returnData;
    }

    function hashMetaTransaction(
        MetaTransaction memory metaTx
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    META_TRANSACTION_TYPEHASH,
                    metaTx.nonce,
                    metaTx.from,
                    keccak256(metaTx.functionSignature)
                )
            );
    }
}
