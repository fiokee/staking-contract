require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition");
require("dotenv").config();

module.exports = {
  solidity: "0.8.17",
  ignition: {
    deployments: ["EtherStaking"], // Reference your deployment module here
  },
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}",
      accounts: ["0xYOUR_PRIVATE_KEY"],
    },
  },
};
