// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) { // 是否是最高层
            // 不是最高层
            floor = _floor; //
            top = building.isLastFloor(floor); // 也不是最高层
        }
    }
}
