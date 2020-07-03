const env = require('node-env-file');
env(__dirname + '/.env');

const port = process.env.HOST_PORT || 9090

module.exports = {
  networks: {
    mainnet: {
      // Don't put your private key here:
      privateKey: process.env.PRIVATE_KEY_MAINNET,
      userFeePercentage: 100,
      feeLimit: 1e8,
      fullHost: 'https://api.trongrid.io',
      network_id: '1',
      trc10TokenId: process.env.TRC10_TOKEN_ID_MAINNET,
      trc20TokenAddress: process.env.TRC20_TOKEN_ADDRESS_MAINNET
    },
    shasta: {
      privateKey: process.env.PRIVATE_KEY_SHASTA,
      userFeePercentage: 100,
      feeLimit: 1e8,
      fullHost: 'https://api.shasta.trongrid.io',
      network_id: '2',
      trc10TokenId: process.env.TRC10_TOKEN_ID_SHASTA,
      trc20TokenAddress: process.env.TRC20_TOKEN_ADDRESS_SHASTA
    },
    nile: {
      privateKey: process.env.PRIVATE_KEY_NILE,
      fullNode: 'https://httpapi.nileex.io/wallet',
      solidityNode: 'https://httpapi.nileex.io/walletsolidity',
      eventServer: 'https://eventtest.nileex.io',
      network_id: '3',
    },
    development: {
      privateKey: process.env.PRIVATE_KEY_DEV,
      userFeePercentage: 0,
      feeLimit: 1e8,
      fullHost: `http://127.0.0.1:${port}`,
      network_id: '9'
    },
    compilers: {
      opmtimization: 'on',
      solc: {
        version: '0.5.8'
      }
    }
  }
}

module.exports.getNetwork = () => {
  let myArgs = process.argv.slice(2);
  if (myArgs[0] === 'migrate') {
    if (
      myArgs[1] === '--network=shasta' ||
      myArgs[1] === '--network' && myArgs[2] === 'shasta'
    ) {
      return 'shasta'
    } else if (
      myArgs[1] === '--network=mainnet' ||
      myArgs[1] === '--network' && myArgs[2] === 'mainnet'
    ) {
      return 'mainnet'
    } else if (
      myArgs[1] === '--network=development' ||
      myArgs[1] === '--network' && myArgs[2] === 'development'
    ) {
      return 'development'
    } else {
      return 'development'
    }
  }
};
