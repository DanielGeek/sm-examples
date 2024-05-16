// SPDX-License-Identifier: MIT
// This line specifies the license under which the code is distributed. In this case, it's the MIT license.
pragma solidity ^0.8.25;
// This line specifies the version of the Solidity compiler to be used. The ^ symbol indicates that versions
// greater than or equal to 0.8.25 but less than 0.9.0 can be used.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// This line imports the ERC20 contract implementation from the OpenZeppelin library.
// OpenZeppelin provides secure and community-vetted implementations of standards like ERC20.

contract QiteRandomToken is ERC20 {
    // This is the declaration of the QiteRandomToken contract which inherits from the ERC20 contract.

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // The constructor function is called once when the contract is deployed.
        // It calls the constructor of the ERC20 contract with the name and symbol of the token.
        _mint(msg.sender, 100 * 10**decimals());
        // This line mints 100 tokens (adjusted for decimals) and assigns them to the account that deployed the contract.
        // `msg.sender` is the address that deployed the contract.
        // `decimals()` is a function from the ERC20 contract that returns the number of decimal places used by the token (typically 18).
    }

    function mint(address to, uint256 amount) external {
        // This function allows new tokens to be minted and assigned to a specified address.
        // `external` means this function can be called from outside the contract.

        _mint(to, amount);
        // `_mint` is an internal function from the ERC20 contract that creates `amount` tokens and assigns them to the `to` address.
        // It increases the total supply of the token.
    }
}
