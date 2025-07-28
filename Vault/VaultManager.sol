// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./VaultBase.sol";

contract VaultManager is VaultBase {
    function deposit() public payable validAmount(msg.value) {
        balances[msg.sender] = VaultLibrary.add(
            balances[msg.sender],
            msg.value
        );
        totalDeposits = VaultLibrary.add(totalDeposits, msg.value);

        emit Deposited(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(
        uint256 amount
    ) public validAmount(amount) sufficientBalance(amount) {
        balances[msg.sender] = VaultLibrary.sub(balances[msg.sender], amount);
        totalDeposits = VaultLibrary.sub(totalDeposits, amount);

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount, block.timestamp);
    }

    // Function to get contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
