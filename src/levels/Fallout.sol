// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;
    mapping(address => uint256) allocations; // 类似余额
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender; //
        allocations[owner] = msg.value; //
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable { //
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0); // 余额大于0
        allocator.transfer(allocations[allocator]);
    }
    // 权限: 所有者
    //
    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
    // 查询余额
    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
