// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LPToken is ERC20 {
    address public dex;

    constructor() ERC20("LP Token", "LPT") {
        dex = msg.sender;
    }

    modifier onlyDEX() {
        require(msg.sender == dex, "Only DEX");
        _;
    }

    function mint(address to, uint amount) external onlyDEX {
        _mint(to, amount);
    }

    function burn(address from, uint amount) external onlyDEX {
        _burn(from, amount);
    }
}