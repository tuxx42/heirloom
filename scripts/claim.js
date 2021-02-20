const InheritFarm = artifacts.require('InheritFarm')
module.exports = async function(callback) {
	//var accounts;
	//web3.eth.getAccounts(function(err,res) { accounts = res; });
	let benefactor = "0x76716b712743F763946c64aF9a471b2707A80c49"
	let heir = "0xF4cD6098283f8848eAC6223ECBee4148B0d5B546"

	console.log('Instantiating InheritFarm')
	let ihf = await InheritFarm.deployed()
	let now = Math.floor(Date.now() / 1000)
	console.log('Checking expiration (diff in s)')
	let expires_in = (await ihf.expirations(benefactor)).toNumber()
	console.log('  Expires in: ' + (expires_in - now) + "s")

	console.log('Claiming inheritance')
	await ihf.claim(benefactor, {from: heir})
	console.log('Success')
	callback()
}
