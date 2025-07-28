// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SecurePiggyBank {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the owner");
        _;
    }

    modifier hasBalance() {
        require(balances[msg.sender] > 0, "You have no balance to withdraw");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "You must deposit some ETH first");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() public hasBalance {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0; // Prevent reentrancy attack

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function withdrawAll() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "There are no funds to withdraw");

        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(owner, amount);
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
