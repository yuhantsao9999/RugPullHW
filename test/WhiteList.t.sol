// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {IERC20} from "../src/TradingCenter.sol";
import {Proxy} from "../src/Proxy.sol";
import {WhiteList} from "../src/WhiteList.sol";
import {UpgradeableProxy} from "../src/UpgradeableProxy.sol";

interface IUSDC {
    function upgradeTo(address newImplementation) external;
}

contract WhiteListTest is Test {
    // Owner and users
    address owner = 0xFcb19e6a322b27c06842A71e8c725399f049AE3a;
    address admin = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    // Contracts
    WhiteList whiteList;
    WhiteList proxyWhiteList;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        // Fork mainnet
        //TODO:
        //please use your endpoint
        vm.createSelectFork("use your endpoint");
    }

    function testMint() public {
        //Upgrade
        vm.startPrank(admin);
        whiteList = new WhiteList();
        IUSDC(usdc).upgradeTo(address(whiteList));
        proxyWhiteList = WhiteList(address(usdc));
        vm.stopPrank();

        //test mint
        vm.startPrank(user1);
        proxyWhiteList.setWhiltelist(user1);
        proxyWhiteList.mint(100);
        vm.stopPrank();
        assertEq(proxyWhiteList.balanceOf(user1), 100);

        vm.startPrank(user2);
        vm.expectRevert();
        proxyWhiteList.mint(100);
        vm.stopPrank();
    }

    function testTransfer() public {
        //Upgrade
        vm.startPrank(admin);
        whiteList = new WhiteList();
        IUSDC(usdc).upgradeTo(address(whiteList));
        proxyWhiteList = WhiteList(address(usdc));
        vm.stopPrank();

        //test transfer
        vm.startPrank(user1);
        proxyWhiteList.setWhiltelist(user1);
        proxyWhiteList.mint(100);
        proxyWhiteList.transfer(user2, 60);
        vm.stopPrank();
        assertEq(proxyWhiteList.balanceOf(user1), 40);
        assertEq(proxyWhiteList.balanceOf(user2), 60);

        vm.startPrank(user2);
        vm.expectRevert();
        proxyWhiteList.transfer(user1, 60);
        vm.stopPrank();
    }
}
