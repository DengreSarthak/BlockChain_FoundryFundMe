//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fund_me.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns(FundMe){
        //Before StartBroadCast ->for not real txn(we dont want to sped gas in this)
        HelperConfig helperConfig = new HelperConfig();
        address ethusdPriceFeed = helperConfig.activeNetworkConfig();

        //after vm for real txn
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethusdPriceFeed);
        vm.stopBroadcast();     
        return fundMe;
    }
}

