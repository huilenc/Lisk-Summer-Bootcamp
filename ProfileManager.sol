// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ProfileManager {
    struct User {
        string name;
        uint8 age;
        string email;
        uint256 registeredAt;
    }

    mapping(address => User) private users;
    mapping(address => bool) private isRegistered;
    mapping(string => address) private nameToAddress;

    event UserRegistered(
        address indexed user,
        string name,
        uint8 age,
        string email
    );

    modifier notRegistered() {
        require(!isRegistered[msg.sender], "You are already registered!");
        _;
    }

    modifier registered() {
        require(isRegistered[msg.sender], "You need to register first!");
        _;
    }

    modifier isTaken(string memory _name, bool allowOwnedName) {
        if (allowOwnedName) {
            require(
                nameToAddress[_name] == address(0) ||
                    nameToAddress[_name] == msg.sender,
                "Name already taken by another user!"
            );
        } else {
            require(nameToAddress[_name] == address(0), "Name already taken!");
        }
        _;
    }

    function register(
        string memory _name,
        uint8 _age,
        string memory _email
    ) public notRegistered isTaken(_name, false) {
        users[msg.sender] = User({
            name: _name,
            age: _age,
            email: _email,
            registeredAt: block.timestamp
        });
        isRegistered[msg.sender] = true;
        nameToAddress[_name] = msg.sender;
        emit UserRegistered(msg.sender, _name, _age, _email);
    }

    function updateProfile(
        string memory _name,
        uint8 _age,
        string memory _email
    ) public registered isTaken(_name, true) {
        string memory oldName = users[msg.sender].name;
        if (keccak256(bytes(oldName)) != keccak256(bytes(_name))) {
            delete nameToAddress[oldName];
            nameToAddress[_name] = msg.sender;
        }

        User storage user = users[msg.sender];
        user.name = _name;
        user.age = _age;
        user.email = _email;
    }

    function getProfile(
        string memory _name
    )
        public
        view
        registered
        returns (string memory, uint8, string memory, uint256)
    {
        User memory user = users[nameToAddress[_name]];
        return (user.name, user.age, user.email, user.registeredAt);
    }
}
