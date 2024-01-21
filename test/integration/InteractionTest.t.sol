//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fund_me.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test{

    FundMe fundMe;

    uint256 constant SEND_VALUE = 0.1 ether;
    address public constant USER = address(1);
    uint256 constant Starting_Balance = 10 ether;
    uint256 constant Gas_Price = 1;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, Starting_Balance);
    }

    function testUserCanFundInteractions() public{
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe wthdrawFundMe = new WithdrawFundMe();
        wthdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}