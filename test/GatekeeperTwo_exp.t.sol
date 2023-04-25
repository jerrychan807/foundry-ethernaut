// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/GatekeeperTwo.sol";
import "src/levels/GatekeeperTwoFactory.sol";

contract TestGatekeeperTwo is BaseTest {
    GatekeeperTwo private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new GatekeeperTwoFactory();
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
        level = GatekeeperTwo(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.entrant(), address(0));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */
        vm.startPrank(player, player);

        uint64 max = uint64(0) - 1;
        console.log("max %s", max);

        bytes8 gateKey;
        Exploiter exp = new Exploiter(level, gateKey);
//        assertEq(level.entrant(), player);
        vm.stopPrank();
    }
}

contract Exploiter {
    constructor  (GatekeeperTwo gtContract, bytes8 _gateKey) public {
        gtContract.enter(_gateKey);
    }

}
