// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Savings} from "../../src/Savings.sol";
import {Token} from "../../src/mocks/Token.sol";
import "./Utils/Cheats.sol";

contract SavingsInv {
    Savings public savings;
    Token public token;
    StdCheats cheats = StdCheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    uint256 public totalBalances;

    constructor() {
        token = new Token();
        savings = new Savings(address(token));
    }

    // function level Invariants
    // INV 1 - User deposit must increase by amount added after deposits
    function testDeposit(uint256 amount) public {
        // mint and approve
        token.mint(msg.sender, amount);
        cheats.prank(msg.sender);
        token.approve(address(savings), amount);
        totalBalances += amount;

        // Retrieve balance of user before deposit
        uint256 preBalance = savings.balances(msg.sender);

        cheats.prank(msg.sender);
        savings.deposit(amount);

        // Retrieve balance of user after deposit
        uint256 afterBalance = savings.balances(msg.sender);

        // Assertion
        assert(afterBalance - preBalance == amount);
    }

    // function level Invariants
    // INV 2 - User balance must decrease by amount withdrawed
    function testWithdraw(uint256 amount) public {
        // Retrieve balance of user before deposit
        uint256 preBalance = savings.balances(msg.sender);
        totalBalances -= amount;

        cheats.prank(msg.sender);
        savings.withdraw(amount, msg.sender);

        // Retrieve balance of user after deposit
        uint256 afterBalance = savings.balances(msg.sender);

        // Assertion
        assert(preBalance - afterBalance == amount);
    }

    // System level Invariants
    // INV 3 - Deposits must not exceed contract max deposits

    function testMaxDeposits(uint256 amount) public {
        // Assertion
        assert(savings.totalDeposited() <= savings.MAX_DEPOSIT_AMOUNT());
    }

    // function level Invariants
    // INV 4 - . User must get interest after every year
    function testGetInterests(uint256 time) public {
        cheats.warp(time);

        uint256 preBalance = token.balanceOf(msg.sender);

        if (preBalance > 0) {
            cheats.prank(msg.sender);
            savings.getInterestPerAnnum();

            uint256 afterBalance = token.balanceOf(msg.sender);

            assert(afterBalance > preBalance);
        }
    }

    // System level Invariants
    // INV 5 - Contract must have enough funds to pay users
    function testHaveEnoughToPayDeposits() public {
        assert(token.balanceOf(address(savings)) >= totalBalances);
    }
}
