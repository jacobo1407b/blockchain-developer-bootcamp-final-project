const AssetT = artifacts.require('AssetT');

module.exports = function(deployer) {
  deployer.deploy(AssetT);
};