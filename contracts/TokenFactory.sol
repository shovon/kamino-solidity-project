// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    constructor(
        string memory name, 
        string memory symbol,
        uint256 initialSupply,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {
        _mint(initialOwner, initialSupply);
    }
}

contract TokenFactory {
    // Events to log token creation
    event TokenCreated(
        address indexed tokenAddress, 
        string name, 
        string symbol, 
        address indexed creator
    );

    constructor() {}

    // Array to keep track of all created tokens
    address[] public deployedTokens;

    // Mapping to track tokens created by each creator
    mapping(address => address[]) public creatorTokens;

    // Function to create a new token
    function createToken(
        string memory name, 
        string memory symbol,
        uint256 initialSupply
    ) public returns (address) {
        // Create new token contract
        CustomToken newToken = new CustomToken(
            name, 
            symbol, 
            initialSupply, 
            msg.sender  // Set the token creator as the initial owner
        );

        // Store the new token address
        deployedTokens.push(address(newToken));
        creatorTokens[msg.sender].push(address(newToken));

        // Emit event
        emit TokenCreated(address(newToken), name, symbol, msg.sender);

        return address(newToken);
    }

    // Function to get all tokens created by the factory
    function getAllTokens() public view returns (address[] memory) {
        return deployedTokens;
    }

    // Function to get tokens created by a specific address
    function getTokensByCreator(address creator) public view returns (address[] memory) {
        return creatorTokens[creator];
    }
}
