// SPDX-License-Identifier: MIT
// This line specifies the license under which the code is distributed. In this case, it's the MIT license.
pragma solidity ^0.8.25;
// This line specifies the version of the Solidity compiler to be used. The ^ symbol indicates that versions
// greater than or equal to 0.8.25 but less than 0.9.0 can be used.

import "./QiteLiquidityToken.sol";
// This line imports the QiteLiquidityToken contract from the local file system.

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// This line imports the IERC20 interface from OpenZeppelin, which defines the standard functions for ERC20 tokens.

import "@openzeppelin/contracts/utils/math/Math.sol";
// This line imports the Math library from OpenZeppelin, which provides various mathematical functions.

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// This line imports the SafeMath library from OpenZeppelin, which provides safe arithmetic operations (e.g., add, sub, mul, div).

contract QitePool {
    // This is the declaration of the QitePool contract.

    using SafeMath for uint;
    using Math for uint;
    // These lines indicate that the contract will use the SafeMath and Math libraries for unsigned integer (uint) operations.

    address public token1;
    address public token2;
    // These state variables store the addresses of the two tokens in the liquidity pool.

    uint256 public reserve1;
    uint256 public reserve2;
    // These state variables store the reserves of the two tokens in the liquidity pool.

    uint256 public constantK;
    // This state variable stores the constant product (x * y = k) used to maintain the liquidity pool invariant.

    QiteLiquidityToken public liquidityToken;
    // This state variable stores the liquidity token contract associated with this pool.

    event Swap (
        address indexed sender,
        uint256 amountIn,
        uint256 amountOut,
        address tokenIn,
        address tokenOut
    );
    // This event is emitted when a token swap occurs. It includes the sender, amount in, amount out, and the addresses of the input and output tokens.

    constructor(address _token1, address _token2, string memory _liquidityTokenName, string memory _liquidityTokenSymbol) {
        // This is the constructor function that initializes the contract with two token addresses and liquidity token details.
        token1 = _token1;
        token2 = _token2;
        liquidityToken = new QiteLiquidityToken(_liquidityTokenName, _liquidityTokenSymbol);
        // Creates a new QiteLiquidityToken contract instance.
    }

    function addLiquidity(uint amountToken1, uint amountToken2) external {
        // This function allows users to add liquidity to the pool by providing amounts of the two tokens.
        uint256 liquidity;
        uint256 totalSupplyOfToken = liquidityToken.totalSupply();
        if(totalSupplyOfToken == 0) {
            // Initial liquidity is determined by the geometric mean of the amounts provided.
            liquidity = amountToken1.mul(amountToken2).sqrt();
        } else {
            // Subsequent liquidity is proportional to the existing reserves and total supply of liquidity tokens.
            liquidity = amountToken1.mul(totalSupplyOfToken).div(reserve1).min(amountToken2.mul(totalSupplyOfToken).div(reserve2));
        }
        liquidityToken.mint(msg.sender, liquidity);
        // Mints new liquidity tokens for the liquidity provider.
        require(IERC20(token1).transferFrom(msg.sender, address(this), amountToken1), "Transfer of token1 is failed");
        require(IERC20(token2).transferFrom(msg.sender, address(this), amountToken2), "Transfer of token2 is failed");
        // Transfers the provided token amounts to the pool.
        reserve1 += amountToken1;
        reserve2 += amountToken2;
        // Updates the reserves of the two tokens.
        _updateConstantFormula();
        // Updates the constant product formula.
    }

    function removeLiquidity(uint amountOfLiquidity) external {
        // This function allows users to remove liquidity from the pool by burning liquidity tokens.
        uint256 totalSupply = liquidityToken.totalSupply();
        require(amountOfLiquidity <= totalSupply, "Liquidity is more than total supply");
        // Ensures that the amount of liquidity to be removed does not exceed the total supply.
        liquidityToken.burn(msg.sender, amountOfLiquidity);
        // Burns the specified amount of liquidity tokens.
        uint256 amount1 = (reserve1 * amountOfLiquidity) / totalSupply;
        uint256 amount2 = (reserve2 * amountOfLiquidity) / totalSupply;
        // Calculates the amounts of the two tokens to be returned to the liquidity provider.
        require(IERC20(token1).transfer(msg.sender, amount1), "Transfer of token1 failed");
        require(IERC20(token2).transfer(msg.sender, amount2), "Transfer of token2 failed");
        // Transfers the calculated amounts of the two tokens to the liquidity provider.
        reserve1 -= amount1;
        reserve2 -= amount2;
        // Updates the reserves of the two tokens.
        _updateConstantFormula();
        // Updates the constant product formula.
    }

    function swapTokens(address fromToken, address toToken, uint256 amountIn, uint256 amountOut) external {
        // This function allows users to swap tokens within the liquidity pool.
        require(amountIn > 0 && amountOut > 0, "Amount must be greater than 0");
        // Ensures that the input and output amounts are greater than zero.
        require((fromToken == token1 && toToken == token2) || (fromToken == token2 && toToken == token1), "Tokens need to be pairs of this liquidity pool");
        // Ensures that the tokens being swapped are part of the liquidity pool.
        IERC20 fromTokenContract = IERC20(fromToken);
        IERC20 toTokenContract = IERC20(toToken);
        require(fromTokenContract.balanceOf(msg.sender) > amountIn, "Insufficient balance of tokenFrom");
        require(toTokenContract.balanceOf(address(this)) > amountOut, "Insufficient balance of tokenTo");
        // Ensures that the sender has enough balance of the input token and the pool has enough balance of the output token.
        uint256 expectedAmountOut;
        if(fromToken == token1 && toToken == token2) {
            expectedAmountOut = constantK.div(reserve1.sub(amountIn)).sub(reserve2);
        } else {
            expectedAmountOut = constantK.div(reserve2.sub(amountIn)).sub(reserve1);
        }
        require(amountOut <= expectedAmountOut, "Swap does not preserve constant formula");
        // Ensures that the swap maintains the constant product formula.
        require(fromTokenContract.transferFrom(msg.sender, address(this), amountIn), "Transfer of token from failed");
        require(toTokenContract.transfer(msg.sender, expectedAmountOut), "Transfer of token to failed");
        // Transfers the input amount to the pool and the output amount to the sender.
        if(fromToken == token1 && toToken == token2) {
            reserve1 = reserve1.add(amountIn);
            reserve2 = reserve2.sub(expectedAmountOut);
        } else {
            reserve1 = reserve1.sub(expectedAmountOut);
            reserve2 = reserve2.add(amountIn);
        }
        // Updates the reserves based on the swap.
        require(reserve1.mul(reserve2) <= constantK, "Swap does not preserve constant formula");
        // Ensures that the swap maintains the constant product formula.
        _updateConstantFormula();
        // Updates the constant product formula.
        emit Swap(msg.sender, amountIn, expectedAmountOut, fromToken, toToken);
        // Emits the Swap event.
    }

    function _updateConstantFormula() internal {
        // This function updates the constant product formula.
        constantK = reserve1.mul(reserve2);
        require(constantK > 0, "Constant formula not update");
        // Ensures that the constant product is greater than zero.
    }

    function estimateOutPutAmount(uint256 amountIn, address fromToken) public view returns(uint256 expectedAmountOut) {
        // This function estimates the output amount for a given input amount and token.
        require(amountIn > 0, "Amount must be greater than 0");
        // Ensures that the input amount is greater than zero.
        require(fromToken == token1 || fromToken == token2, "Need to be a token in this pair");
        // Ensures that the input token is part of the liquidity pool.
        if(fromToken == token1) {
            expectedAmountOut = constantK.div(reserve1.sub(amountIn)).sub(reserve2);
        } else {
            expectedAmountOut = constantK.div(reserve2.sub(amountIn)).sub(reserve1);
        }
        // Calculates the expected output amount based on the constant product formula.
    }
}
