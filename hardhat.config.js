require("@nomicfoundation/hardhat-toolbox");
const { vars } = require("hardhat/config");

const INFURA_API_KEY = vars.get("INFURA_API_KEY");
const SEPOLIA_PRIVATE_KEY = vars.get("SEPOLIA_PRIVATE_KEY");
const BLAST_API_KEY = vars.get("BLAST_API_KEY");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
    fantom: {
      url: `https://fantom-testnet.blastapi.io/${BLAST_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
    scroll: {
      url: `https://scroll-sepolia.blastapi.io/${BLAST_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
  },
  // etherscan: {
  //   apiKey: ETHERSCAN_API_KEY,
  // },
  ignition: {
    requiredConfirmations: 1
  },
};
