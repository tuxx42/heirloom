const InheritFarm = artifacts.require('InheritFarm')
const DAIToken = artifacts.require('DAIToken')
const truffleAssert = require('truffle-assertions')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('InheritFarm', ([benefactor, heir]) => {
	it('Check expiration=true', async () => {
		let value = 100000
		let dai = await DAIToken.new()
		let inherit = await InheritFarm.new(dai.address)

		// approve funds
		let tx = await dai.approve(inherit.address, value)
		// check event is emitted
		//truffleAssert.eventEmitted(tx, 'Approval', (ev) => {
		//	return ev._from === benefactor
		//})

		// add unexpired transaction
		let expires = Math.floor(Date.now() / 1000) + 600
		await inherit.bequeath(heir, value, expires, {from: benefactor})

		// check that claim rejected
		await inherit.claim(benefactor, {from: heir}).should.be.rejectedWith('holdings have not expired!');
	})

	it('Check expiration=false', async () => {
		let value = 100000
		let dai = await DAIToken.new()
		let inherit = await InheritFarm.new(dai.address)

		await dai.approve(inherit.address, value)
		await inherit.bequeath(heir, value, Math.floor(Date.now() / 1000) - 60, {from: benefactor})

		assert.equal(await dai.balanceOf(heir), 0)
		await inherit.claim(benefactor, {from: heir})
		assert.equal(await dai.balanceOf(heir), value)
	})
})

