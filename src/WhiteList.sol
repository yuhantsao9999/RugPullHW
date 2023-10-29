// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract WhiteList {
    string public name;
    string public symbol;
    uint8 public decimals;
    string public currency;
    address public masterMinter;
    bool internal initialized;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 internal totalSupply_ = 0;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;

    mapping(address => bool) public whitelist;

    function setWhiltelist(address _address) public {
        whitelist[_address] = true;
    }

    modifier checkWhiltelist(address _address) {
        require(
            whitelist[_address],
            "Only the address in whitelist can call this function"
        );
        _;
    }

    function transfer(
        address _to,
        uint256 _amount
    ) public checkWhiltelist(msg.sender) {
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function mint(uint256 _amount) external checkWhiltelist(msg.sender) {
        totalSupply_ += _amount;
        balances[msg.sender] += _amount;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return balances[account];
    }
}
