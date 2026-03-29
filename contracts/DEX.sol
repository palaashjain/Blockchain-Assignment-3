// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./LPToken.sol";

contract DEX {
    IERC20 public tokenA;
    IERC20 public tokenB;
    LPToken public lpToken;

    uint public reserveA;
    uint public reserveB;

    uint constant FEE = 3; // 0.3%

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        lpToken = new LPToken();
    }

    function getReserves() public view returns (uint, uint) {
        return (reserveA, reserveB);
    }

    function spotPrice() public view returns (uint) {
        return (reserveB * 1e18) / reserveA;
    }

    function addLiquidity(uint amountA, uint amountB) external {
        if (reserveA > 0 && reserveB > 0) {
            require(
                reserveA * amountB == reserveB * amountA,
                "Ratio mismatch"
            );
        }

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint shares;
        if (lpToken.totalSupply() == 0) {
            shares = amountA;
        } else {
            shares = (amountA * lpToken.totalSupply()) / reserveA;
        }

        lpToken.mint(msg.sender, shares);

        reserveA += amountA;
        reserveB += amountB;
    }

    function removeLiquidity(uint shares) external {
        uint totalShares = lpToken.totalSupply();

        uint amountA = (shares * reserveA) / totalShares;
        uint amountB = (shares * reserveB) / totalShares;

        lpToken.burn(msg.sender, shares);

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function swapAforB(uint amountIn) external {
        uint amountInWithFee = (amountIn * 997) / 1000;

        uint amountOut = (amountInWithFee * reserveB) /
            (reserveA + amountInWithFee);

        tokenA.transferFrom(msg.sender, address(this), amountIn);
        tokenB.transfer(msg.sender, amountOut);

        reserveA += amountIn;
        reserveB -= amountOut;
    }

    function swapBforA(uint amountIn) external {
        uint amountInWithFee = (amountIn * 997) / 1000;

        uint amountOut = (amountInWithFee * reserveA) /
            (reserveB + amountInWithFee);

        tokenB.transferFrom(msg.sender, address(this), amountIn);
        tokenA.transfer(msg.sender, amountOut);

        reserveB += amountIn;
        reserveA -= amountOut;
    }
}