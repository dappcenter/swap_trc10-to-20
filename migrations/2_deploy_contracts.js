const SafeMath = artifacts.require("./SafeMath.sol");
const SwapErc10ToErc20 = artifacts.require("./SwapErc10ToErc20.sol");

const TronWeb = require('tronweb');

let trc10tokenId = 1999999;

// (base58) TReoAJuMHbVFjiLbq4r2eoi5kKWxUhS3sX
// (hex) 41ac069fc9d73f03a3eaf8346bc0e92c26ea060609
let trc20tokenAddress = 'TReoAJuMHbVFjiLbq4r2eoi5kKWxUhS3sX';


module.exports = function(deployer) {
  let tronWeb = new TronWeb({fullHost: 'http://127.0.0.1:9090'});
  // console.log(tronWeb.utils)
  // console.log(tronWeb.utils.base58.encode58(trc20tokenAddress));
  // console.log(tronWeb.address.toHex(trc20tokenAddress)); process.exit()
  // deployer.deploy(SafeMath);
  // deployer.link(SafeMath, SwapErc10ToErc20);

  deployer.deploy(SwapErc10ToErc20, trc10tokenId, tronWeb.address.toHex(trc20tokenAddress));
  // deployer.deploy(SwapErc10ToErc20, trc10tokenId, trc20tokenAddress);
};
