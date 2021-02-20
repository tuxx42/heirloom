const InheritFarm = artifacts.require("InheritFarm");
const DAIToken = artifacts.require("DAIToken");

module.exports = async function (deployer, network, accounts) {
  // Deploy DAI Token
  await deployer.deploy(DAIToken);
  const daiToken = await DAIToken.deployed()

  // Deploy InheritFarm
  await deployer.deploy(InheritFarm, daiToken.address)
  const inheritFarm = await InheritFarm.deployed()

  //console.log("transfering DAI to benefactor")
  //await daiToken.transfer(accounts[0], 1500000000)
  console.log("approving DAI from benefactor")
  await daiToken.approve(InheritFarm.address, "1500000000", {from: accounts[0]})
  console.log("inheiriting DAI")
  let timevar = Math.floor(Date.now() / 1000) + 5*60
  timevar = 1713850029
  let success = await inheritFarm.inheritDAI(accounts[1],   "1400000000", timevar)
  console.log(success)
	console.log("success")
};
