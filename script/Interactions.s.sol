// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/Fund_me.sol";

contract FundFundMe is Script{
    uint256 SendValue = 0.01 ether;

    function fundFundMe(address mostReacentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostReacentlyDeployed)).fund{value: SendValue}();
        vm.stopBroadcast();
        console.log("FundMe funded with %s", SendValue);
    }

    function run() external{
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostReacentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostReacentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external{
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}


