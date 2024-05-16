// SPDX-License-Identifier: MIT
// This line specifies the license under which the code is distributed. In this case, it's the MIT license.
pragma solidity ^0.8.25;
// This line specifies the version of the Solidity compiler to be used. The ^ symbol indicates that versions
// greater than or equal to 0.8.25 but less than 0.9.0 can be used.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// This line imports the ERC20 contract implementation from OpenZeppelin, which provides the standard functions for ERC20 tokens.

import "@openzeppelin/contracts/access/AccessControl.sol";
// This line imports the AccessControl contract from OpenZeppelin, which provides role-based access control mechanisms.

contract QiteLiquidityToken is ERC20, AccessControl {
    // This is the declaration of the QiteLiquidityToken contract which inherits from the ERC20 and AccessControl contracts.

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        // The constructor function is called once when the contract is deployed.
        // It initializes the ERC20 contract with the token name and symbol.
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // Grants the DEFAULT_ADMIN_ROLE to the deployer of the contract (msg.sender).
    }

    function mint(address to, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // This function allows minting of new tokens.
        // It can only be called by accounts with the DEFAULT_ADMIN_ROLE.
        _mint(to, amount);
        // Calls the internal _mint function from the ERC20 contract to create amount tokens and assign them to the to address.
    }

    function burn(address to, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // This function allows burning of tokens.
        // It can only be called by accounts with the DEFAULT_ADMIN_ROLE.
        _burn(to, amount);
        // Calls the internal _burn function from the ERC20 contract to destroy amount tokens from the to address.
    }
}
