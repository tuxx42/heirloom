// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface ERC20 {
	function allowance(address tokenOwner, address spender) external view returns (uint remaining);
	function approve(address _spender, uint256 _value) external returns (bool success);
	function transfer(address _to, uint256 _value) external returns (bool success);
	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}
