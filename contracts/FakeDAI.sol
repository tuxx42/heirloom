// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC20.sol";

contract FakeDAI is ERC20 {
	string public name = "Fake DAI Token";
	string public symbol = "FDAI";
	uint256 public totalSupply = 1000000000000000000;
	uint8 public decimal = 2;

	event Transfer(
		address indexed _from,
		address indexed _to,
		uint256 value
	);

	event Approval(
		address indexed _sender,
		address indexed _spender,
		uint256 _value
	);

	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;

	constructor() public {
		balanceOf[msg.sender] = totalSupply;
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(balanceOf[msg.sender] >= _value, "not enough balance for transfer");
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value <= balanceOf[_from], "Value is smaller than balance");
		require(_value <= allowance[_from][msg.sender], "Value is smaller than allowance");
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		allowance[_from][msg.sender] -= _value;
		emit Transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}
}
