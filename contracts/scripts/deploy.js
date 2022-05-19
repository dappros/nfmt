const hre = require("hardhat");

async function main() {
  const NFMT = await hre.ethers.getContractFactory("NFMT");
  const nfmt = await NFMT.deploy();

  await nfmt.deployed();

  console.log("NFMT deployed to:", nfmt.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
