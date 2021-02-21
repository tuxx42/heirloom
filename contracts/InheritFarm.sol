// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC20.sol";

contract InheritFarm {
	string public name = "InheritFarm";
	address public owner;

	mapping(address => mapping (address => uint256)) public heirs;
	mapping(address => uint256) public expirations;

	modifier onlyExpired(address _benefactor) {
		require(block.timestamp >= expirations[_benefactor],
		       "holdings have not expired!");
		_;
	}

	event Approval (
		address _benefactor,
		address _heir,
		uint256 _value
	);

	event Payout (
		address _benefactor,
		address _heir,
		uint256 _value
	);

	constructor() public {
		owner = msg.sender;
	}

	function bequeath(address _heir, ERC20 _erc20, uint256 _value, uint256 _expiration) external returns (bool success) {
		require(_erc20.allowance(msg.sender, address(this)) >= _value);
		require(_value > 0, "Value is subzero");

		address _benefactor = msg.sender;

		heirs[_benefactor][_heir] = _value;
		expirations[_benefactor] = _expiration;

		emit Approval(_benefactor, _heir, _value);
		return true;
	}

	function claim(address _benefactor, ERC20 _erc20) external onlyExpired(_benefactor) returns (bool success) {
		require(heirs[_benefactor][msg.sender] > 0,
			"No mapping between benefactor and heir");
		address _heir = msg.sender;
		uint256 _value = heirs[_benefactor][_heir];

		delete heirs[_benefactor][_heir];

		_erc20.transferFrom(_benefactor, _heir, _value);

		emit Payout(_benefactor, _heir, _value);
		return true;
	}
}
