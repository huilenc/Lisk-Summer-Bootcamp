// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

library VaultLibrary {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "VaultLibrary: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "VaultLibrary: subtraction overflow");
        return a - b;
    }
}
