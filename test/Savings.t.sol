// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {Savings} from "../src/Savings.sol";
import {Token} from "../src/mocks/Token.sol";

contract CounterTest is Test {
    Counter public counter;
    Token public token;
    Savings public savings;
    address public user1 = makeAddr("user1");

    function setUp() public {
        token = new Token();
        savings = new Savings(address(token));

        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Deposit() public {
        vm.startPrank(user1);
        token.mint(user1, 100 ether);
        token.approve(address(savings), 10 ether);
        savings.deposit(10 ether);
        vm.stopPrank();
    }

    function test_Withdraw() public {
        vm.startPrank(user1);
        token.mint(user1, 100 ether);
        token.approve(address(savings), 10 ether);
        savings.deposit(10 ether);
        vm.warp(366 days);
        savings.withdraw(5 ether, user1);
        savings.getInterestPerAnnum();
        vm.stopPrank();
    }
}
