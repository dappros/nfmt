require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const { INFURA_KEY, ACCOUNT_PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.4",
  networks: {
    "rinkeby": {
      url: `https://rinkeby.infura.io/v3/${INFURA_KEY}`,
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`]
    }
  }
};
