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
  console.log("Approving DAI from benefactor")
  await daiToken.approve(InheritFarm.address, "1500000000", {from: accounts[0]})
  console.log("Inheiriting DAI")
  let timevar = Math.floor(Date.now() / 1000) + 60
  let success = await inheritFarm.inherit(accounts[1],   "1400000000", timevar)
  console.log(success)
  console.log("Success")
};
