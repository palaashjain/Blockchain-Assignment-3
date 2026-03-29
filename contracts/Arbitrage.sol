// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDEX {
    function spotPrice() external view returns (uint);
    function swapAforB(uint amount) external;
    function swapBforA(uint amount) external;
}

contract Arbitrage {

    function execute(
        address dex1,
        address dex2,
        address tokenA,
        address tokenB,
        uint amount
    ) external {

        // Step 1: Take TokenA from user
        IERC20(tokenA).transferFrom(msg.sender, address(this), amount);

        uint price1 = IDEX(dex1).spotPrice();
        uint price2 = IDEX(dex2).spotPrice();

        require(price1 != price2, "No arbitrage");

        if (price1 > price2) {
            // Buy B cheap from dex2
            IERC20(tokenA).approve(dex2, amount);
            IDEX(dex2).swapAforB(amount);

            uint tokenBBalance = IERC20(tokenB).balanceOf(address(this));

            // Sell B expensive on dex1
            IERC20(tokenB).approve(dex1, tokenBBalance);
            IDEX(dex1).swapBforA(tokenBBalance);

        } else {
            // Buy B cheap from dex1
            IERC20(tokenA).approve(dex1, amount);
            IDEX(dex1).swapAforB(amount);

            uint tokenBBalance = IERC20(tokenB).balanceOf(address(this));

            // Sell B expensive on dex2
            IERC20(tokenB).approve(dex2, tokenBBalance);
            IDEX(dex2).swapBforA(tokenBBalance);
        }

        // Return all TokenA to user
        uint finalBalance = IERC20(tokenA).balanceOf(address(this));
        IERC20(tokenA).transfer(msg.sender, finalBalance);
    }
}