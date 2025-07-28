// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./VaultLibrary.sol";

contract VaultBase {
    using VaultLibrary for uint256;

    // State variables
    mapping(address => uint256) public balances;
    uint256 public totalDeposits;

    // Events
    event Deposited(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 amount, uint256 timestamp);

    // Modifiers
    modifier validAmount(uint256 amount) {
        require(amount > 0, "Amount must be greater than 0");
        _;
    }

    modifier sufficientBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }

    // View functions
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function getTotalDeposits() public view returns (uint256) {
        return totalDeposits;
    }
}
