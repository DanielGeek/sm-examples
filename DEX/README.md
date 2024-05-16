# DeFi & DEX (Uniswap): Build Your Own DEX

A Complex solution for a DEX Smart Contract

Steps for deploy each smart contract
1 - deploy QiteSwap.sol Smart Contract
2 - Create 2 QiteRandomToken.sol Smart Contract
3 - call function createPairs from QiteSwap.sol and send the parameters
4 - copy the output Smart Contract address
5 - compile QitePool.sol and add the previous contract address with At Address
6 - In QitePool call liquidityToken
7 - Compile the QiteLiquidityToken and at the previous address from QitePool with At Address
8 - Use QitePool for addLiquidity, Remove and so on
