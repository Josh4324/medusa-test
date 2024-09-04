// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/**
 * @title Token
 * @author Josh
 */
contract Token is ERC20 {
    constructor() ERC20("TestToken", "TT") {}

    function mint(address addr, uint256 amount) public {
        _mint(addr, amount);
    }
}
