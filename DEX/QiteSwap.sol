// SPDX-License-Identifier: MIT
// This line specifies the license under which the code is distributed. In this case, it's the MIT license.
pragma solidity ^0.8.25;
// This line specifies the version of the Solidity compiler to be used. The ^ symbol indicates that versions
// greater than or equal to 0.8.25 but less than 0.9.0 can be used.

import "./QitePool.sol";
// This line imports the QitePool contract from the local file system. QitePool is assumed to be defined in QitePool.sol.

contract QiteSwap {
    // This is the declaration of the QiteSwap contract.

    address[] public allPairs;
    // This public array stores the addresses of all liquidity pairs created by the contract.

    mapping(address => mapping(address => QitePool)) public getPair;
    // This nested mapping keeps track of the QitePool contract instances for each pair of token addresses.

    event PairCreated(address indexed token1, address indexed token2, address pair);
    // This event is emitted when a new liquidity pair is created. It includes the addresses of the two tokens and the pair address.

    function createPairs(address token1, address token2, string calldata token1Name, string calldata token2Name) external returns (address) {
        // This function creates a new liquidity pair. It takes the addresses of the two tokens and their names as parameters.
        require(token1 != token2, "Identical token address is not allowed");
        // Ensures that the two tokens are not the same.
        require(address(getPair[token1][token2]) == address(0), "Pair already exists");
        // Ensures that the pair does not already exist.

        string memory liquidityTokenName = string(abi.encodePacked("Liquidity-", token1Name, "-", token2Name));
        // Creates a name for the liquidity token by concatenating the names of the two tokens.
        string memory liquidityTokenSymbol = string(abi.encodePacked("LP-", token1Name, "-", token2Name));
        // Creates a symbol for the liquidity token by concatenating the names of the two tokens.

        QitePool qitePool = new QitePool(token1, token2, liquidityTokenName, liquidityTokenSymbol);
        // Creates a new QitePool contract instance with the provided token addresses and liquidity token details.

        getPair[token1][token2] = qitePool;
        getPair[token2][token1] = qitePool;
        // Stores the created QitePool instance in the mapping for both token address orders.

        allPairs.push(address(qitePool));
        // Adds the address of the created QitePool to the allPairs array.

        emit PairCreated(token1, token2, address(qitePool));
        // Emits the PairCreated event with the token addresses and the address of the created pair.

        return address(qitePool);
        // Returns the address of the created QitePool.
    }

    function allPairsLength() external view returns(uint) {
        // This function returns the number of liquidity pairs created.
        return allPairs.length;
    }

    function getPairs() external view returns (address[] memory) {
        // This function returns the addresses of all created liquidity pairs.
        return allPairs;
    }
}
