//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{

    NetwrokConfig public activeNetworkConfig;

    uint8 public constant decimals = 8;
    int256 public constant initial_Price = 2000e8;

    constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 5){
            activeNetworkConfig = getGeorliEthConfig();
        }
        else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetwrokConfig{
        address priceFeed;
    }

    function getSepoliaEthConfig() public pure returns(NetwrokConfig memory){
        NetwrokConfig memory sepoliaConfig = NetwrokConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getGeorliEthConfig() public pure returns(NetwrokConfig memory){
        NetwrokConfig memory sepoliaConfig = NetwrokConfig({
            priceFeed: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetwrokConfig memory){
        // for Anvil --->  \

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig; 
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(decimals, initial_Price);
        vm.stopBroadcast();

        NetwrokConfig memory anvilConfig = NetwrokConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}

