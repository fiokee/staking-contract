

const { buildModule } = require("@nomicfoundation/hardhat-ignition");

const deployEtherStaking = buildModule("DeployEtherStaking", (m) => {
    // Deploy the EtherStaking contract
    const etherStaking = m.contract("EtherStaking");

    return { etherStaking };
});

module.exports = deployEtherStaking;
