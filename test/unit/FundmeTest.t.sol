//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fund_me.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test{
    FundMe fundMe;

    uint256 constant SEND_VALUE = 0.1 ether;
    address public constant USER = address(1);
    uint256 constant Starting_Balance = 10 ether;
    // uint256 constant Gas_Price = 1;

    modifier funded(){
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();
        _;
    }

    function setUp() external{
        DeployFundMe deployFUndMe = new DeployFundMe();
        fundMe = deployFUndMe.run();
        vm.deal(USER, Starting_Balance);
    }
    function testMinUsdFive() public{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public{
        assertEq(fundMe.getOwner(), msg.sender);
    }    

    function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public{
        
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundGetsUpdatedAfterFunded() public funded{

        // vm.startPrank(USER);
        // fundMe.fund{value: SEND_VALUE}();
        // vm.stopPrank();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunder() public funded{

        // vm.startPrank(USER);
        // fundMe.fund{value: SEND_VALUE}();
        // vm.stopPrank();

        address amountFunded = fundMe.getFunder(0);
        assertEq(amountFunded, USER);
    }

    function testWithdrawFailsIfNotOwner() public funded{

        // vm.prank(USER);
        // fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleOwner() public funded{
        // Arrange->Act->Assert 

        // Arrange
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // Act
        
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // uint256 startingGas = gasleft();
        // vm.txGasPrice(Gas_Price);
        // uint256 endingGas = gasleft();
        // uint256 gasUsed = startingGas - endingGas;
        // console.log(gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function testWithDrawFromMultipleFunders() public funded {

        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), Starting_Balance);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {

        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), Starting_Balance);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }
}


