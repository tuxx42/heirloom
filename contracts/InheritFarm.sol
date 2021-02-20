// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./DAIToken.sol";

contract InheritFarm {
	string public name = "InheritFarm";
	address public owner;
	DAIToken public daiToken;

	mapping(address => mapping (address => uint256)) public heirs;
	mapping(address => uint256) public expirations;

	modifier onlyWhenExpired() {
		require(block.timestamp >= expirations[msg.sender],
		       "holdings have not expired!");
		_;
	}

	event InheritApproval (
		address _benefactor,
		address _heir,
		uint256 _value
	);

	event Payout (
		address _benefactor,
		address _heir,
		uint256 _value
	);

	constructor(DAIToken _daiToken) public {
		daiToken = _daiToken;
		owner = msg.sender;
	}

	function inheritDAI(address _heir, uint256 _value, uint256 _expiration) external {
		require(daiToken.allowance(msg.sender, address(this)) >= _value);
		require(_value > 0, "Value is subzero");

		address _benefactor = msg.sender;

		heirs[_benefactor][_heir] = _value;
		expirations[_benefactor] = _expiration;

		emit InheritApproval(_benefactor, _heir, _value);
	}

	function claim(address _benefactor) external onlyWhenExpired returns (bool success) {
		require(heirs[_benefactor][msg.sender] > 0,
			"No mapping between benefactor and heir");
		address _heir = msg.sender;
		uint256 _value = heirs[_benefactor][_heir];

		delete heirs[_benefactor][_heir];

		daiToken.transferFrom(_benefactor, _heir, _value);

		emit Payout(_benefactor, _heir, _value);
		return true;
	}
}
