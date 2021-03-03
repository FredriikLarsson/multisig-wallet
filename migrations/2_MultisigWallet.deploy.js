const MultisigWallet = artifacts.require("MultisigWallet");

module.exports = function (deployer) {
  deployer.deploy(MultisigWallet, '0xB75e67E9fF6a158188119498B491cCeb87B92E7E', '0x5720d59b15bA93646A32caC080f778b170886bd2', '0xDbF927B8993DCAbef630563078De68CC4FB8F11B', 2);
};