// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Fallback {
    using SafeMath for uint256;
    mapping(address => uint256) public contributions; // 余额映射
    address payable public owner;

    constructor() public {
        // 合约部署者为owner
        owner = msg.sender;
        //
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable { // 充值函数
        require(msg.value < 0.001 ether); // 要求交易的金额 < 0.001ether
        contributions[msg.sender] += msg.value; // 余额增加
        if (contributions[msg.sender] > contributions[owner]) { // 如果余额大于管理员的余额,可获得 所有者权限
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) { // 查询余额
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner { // 仅允许合约所有者进行提现
        owner.transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0); // 交易金额大于0 && 本身余额大于0
        owner = msg.sender;
    }
}
