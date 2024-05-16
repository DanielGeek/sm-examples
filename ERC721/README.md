# ERC721 NFT TOKEN

A complex solution for ERC721 NFT tokens


Explanation of Key Parts:
License and Pragma:

// SPDX-License-Identifier: MIT: Specifies the MIT License.
- `pragma solidity ^0.8.19;`: Specifies the version of Solidity.

### Imports:

- Various imports from OpenZeppelin contracts, including ERC721, ERC721URIStorage, ERC721Burnable, Counters, ReentrancyGuard, and ERC2981, and a custom CommissionManager.

### Contract Declaration:

- `contract Spozz721`: Declares the Spozz721 contract which inherits from various OpenZeppelin contracts.

### State Variables:

- `string private _customBaseURI;`: Base URI for the tokens.
- `string public _contractURI;`: Contract URI.
- `mapping(address => bool) public authorizedAddresses;`: Mapping of authorized addresses.
- `uint256 public maxSupply;`: Maximum supply of tokens.
- `uint256 public currentSupply;`: Current supply of tokens.
- `Counters.Counter private _tokenIds;`: Counter for token IDs.

### Structs and Mappings:

- `MarketItem`: Struct to represent a market item.
- `Bid`: Struct to represent a bid.
- `mapping(uint256 => MarketItem) private idToMarketItem;`: Mapping of token ID to market item.
- `mapping(uint256 => mapping(address => Bid)) public bids;`: Mapping of token ID and bidder to bid.

### Events:

- Various events for market item creation, sale, bids, and token transfers.

### Modifiers:

- `onlyAuthorized`: Ensures that only authorized addresses can call certain functions.

### Constructor:

- Initializes the contract with the given parameters and sets the base URI and contract URI.

### Functions:

- `_baseURI`: Returns the custom base URI.
- `setContractURI`: Sets the contract URI.
- `contractURI`: Returns the contract URI.
- `createToken`: Mints a new token and lists it in the marketplace.
- `createMarketItem`: Creates a market item.
- `editToken`: Edits the price and sale state of a token.
- `tokenExists`: Checks if a token exists.
- `createMarketSale`: Creates a market sale.
- `validateSale`: Validates a sale.
- `calculateRoyalty`: Calculates the royalty amount.
- `transferOwnershipAndHandlePayments`: Transfers ownership and handles payments.
- `fetchMyNFTs`: Fetches NFTs owned by the caller.
- `fetchItemsListed`: Fetches items listed by the caller.
- `transferToken`: Transfers a token.
- `makeBid`: Makes a bid.
- `acceptBid`: Accepts a bid.
- `withdrawBid`: Withdraws a bid.
- `rejectBid`: Rejects a bid.
- `setAuthorizeAddress`: Sets an authorized address.
- `revokeAuthorization`: Revokes authorization.
- `emitMarketItemSoldEvent`: Emits a MarketItemSold event.
- `tokenURI`: Returns the token URI.
- `burnToken`: Burns a token.
- `getCurrentMinted`: Returns the total tokens minted.
- `supportsInterface`: Supports multiple interfaces.

These comments and explanations should help you understand the functionality and structure of the Spozz721 contract.
