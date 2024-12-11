// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {}

    // Function to mint tokens when ETH is received
    function deposit() public payable {
        require(msg.value > 0, "Must send ETH to mint tokens");
        _mint(msg.sender, msg.value);
    }

    // Allow the contract to receive ETH
    receive() external payable {
        deposit();
    }

    // Function to burn tokens and return ETH
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
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
        string memory symbol
    ) public returns (address) {
        // Create new token contract
        CustomToken newToken = new CustomToken(
            name,
            symbol,
            msg.sender // Set the token creator as the initial owner
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
    function getTokensByCreator(
        address creator
    ) public view returns (address[] memory) {
        return creatorTokens[creator];
    }
}
