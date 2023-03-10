require("@nomicfoundation/hardhat-toolbox");

//选取ganache下的4个账户的私钥
const PRIVATE_KEY1 = "0x1c2efd95faec1639421ae10cd4a18791081dc21edbe78dda7c2494f01eb3c044";
const PRIVATE_KEY2 = "0x0723673d51282eb37a5cb8b0151d20ac80e6ad54ffa0b9cb30005f508df17e25";
const PRIVATE_KEY3 = "0x9612b1bfc0a616828d4eb7b65997dbb87bfb41ab872561b71215f05ee677f1a7";
const PRIVATE_KEY4 = "0x9612b1bfc0a616828d4eb7b65997dbb87bfb41ab872561b71215f05ee677f1a7";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {

    ganache: {
      url: `http://127.0.0.1:7545`,
      accounts: [`0x${PRIVATE_KEY1}`,`0x${PRIVATE_KEY2}`,`0x${PRIVATE_KEY3}`,`0x${PRIVATE_KEY4}`]
    },
    // ropsten: {
    //   url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
    //   accounts: [`0x${ROPSTEN_PRIVATE_KEY}`]
    // },
    // rinkeby: {
    //   url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
    //   accounts: [`0x${rinkeby_PRIVATE_KEY}`]
    // },
  }
};
