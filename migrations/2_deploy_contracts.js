const SwapTrc10to20 = artifacts.require("./SwapTrc10to20.sol");

const TronWeb = require('tronweb');
const tronWeb = new TronWeb({fullHost: 'http://127.0.0.1:9090'});
const trc10tokenId = 1999999;
const trc20tokenAddress = 'TReoAJuMHbVFjiLbq4r2eoi5kKWxUhS3sX';

module.exports = function(deployer) {
  deployer.deploy(SwapTrc10to20, trc10tokenId, tronWeb.address.toHex(trc20tokenAddress));
};
