const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("ElektraModule", (m) => {
    const elektra =(m.contract("Elektra", []));
    return { elektra };
});