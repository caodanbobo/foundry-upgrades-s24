// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract BoxV2 is UUPSUpgradeable {
    uint256 internal number;

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        //empty function allows everybody to call this
        //it would be fine since this is only for testing.
    }

    function setNumber(uint256 _number) public {
        number = _number;
    }
}
