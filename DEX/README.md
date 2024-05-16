# DeFi & DEX (Uniswap): Build Your Own DEX

A Complex solution for a DEX Smart Contract

Steps for deploy each smart contract
- deploy QiteSwap.sol Smart Contract
- Create 2 QiteRandomToken.sol Smart Contract
- call function createPairs from QiteSwap.sol and send the parameters
- copy the output Smart Contract address
- compile QitePool.sol and add the previous contract address with At Address
- In QitePool call liquidityToken
- Compile the QiteLiquidityToken and at the previous address from QitePool with At Address
- Use QitePool for addLiquidity, Remove and so on
