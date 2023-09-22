require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers : [
      {version : '0.5.1'},
      {version : '0.8.0'},
      {version : '0.6.2'},
      {version : '0.6.6'},
      {version: '0.8.4'},
      {version : '0.8.0'}
    ],
  },
  networks : {
    hardhat : {
      forking : {
        url : 'https://bsc-dataseed1.binance.org/'
      },
    },
    testnet : {
      url : 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      chainId : 97,
      accounts : ['de0f6ddd6dcadffdc61744d91df8be87779eb24aff8fad370f58adef2f18561a'],
    },
    mainnet : {
      url : 'https://bsc-dataseed1.binance.org',
      chainId : 56
    },
  },
};
