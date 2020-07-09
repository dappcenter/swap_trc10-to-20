const TronWeb = require('tronweb');

const config = require('../tronbox');
const { getNetwork } = require('../tronbox');

const SwapTrc10to20 = artifacts.require("./SwapTrc10to20.sol");

let network = getNetwork();
const tronWeb = new TronWeb({
  fullHost: config.networks[network].fullHost,
  fullNode: config.networks[network].fullHost,
  solidityNode: config.networks[network].fullHost,
  privateKey: config.networks[network].privateKey
});
const trc10tokenId = config.networks[network].trc10TokenId;
const trc20tokenAddress = config.networks[network].trc20TokenAddress;
const trc10decimal = process.env.TRC10_DECIMAL || 0;
const trc20decimal = process.env.TRC20_DECIMAL || 6;

module.exports = function(deployer) {
  deployer.deploy(SwapTrc10to20, trc10tokenId, tronWeb.address.toHex(trc20tokenAddress), trc10decimal, trc20decimal);
};
