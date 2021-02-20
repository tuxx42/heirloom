const InheritFarm = artifacts.require('InheritFarm')
module.exports = async function(callback) {
	//var accounts;
	//web3.eth.getAccounts(function(err,res) { accounts = res; });
	console.log('1')

	let benefactor = "0x76716b712743F763946c64aF9a471b2707A80c49"
	let heir = "0xF4cD6098283f8848eAC6223ECBee4148B0d5B546"

	console.log('2')
	let ihf = await InheritFarm.deployed()
	console.log('3')
	let now = Math.floor(Date.now() / 1000)
	console.log('4')
	let expires_in = (await ihf.expirations(benefactor)).toNumber()
	console.log('5')
	console.log('expiration: ' + expires_in)
	console.log('now       : ' + now)
	console.log("Expires in " + expires_in - now + "s")

	await ihf.claim(benefactor, {from: heir})
	console.log('success')
	callback()
}
