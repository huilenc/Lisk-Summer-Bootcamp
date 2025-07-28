// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VulnerablePiggyBank {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function withdraw() public {
        // Here, the vulnerability is that the withdraw function is not protected from reentrancy attacks.
        // Anyone can call the withdraw function and drain the contract.
        payable(msg.sender).transfer(address(this).balance);
    }

    function attack() public {
        // Anyone can call withdraw() and drain the contract.
        withdraw();
    }
}
