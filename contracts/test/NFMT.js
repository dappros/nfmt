const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

describe("NFMT", function () {
  let owner, usr1, usr2, usr3, nfmt;

  const CHARITY1 = 0x68B11194369F0145a86C855c1db1750BD51CC8de;
  const CHARITY2 = 0x21f5874aBC2c220d0Da49D142000D9dc75289C42;
  const CHARITY3 = 0xe315f685aA63d0B17AE4fd8AAfCAF2C811BE34c0;

  beforeEach(async () => {
    [owner, usr1, usr2, usr3] = await ethers.getSigners();
    const NFMT = await ethers.getContractFactory("NFMT");
    nfmt = await NFMT.deploy();
    await nfmt.deployed();
  });

  it("mint 1", async function () {
    let mintRes = await nfmt.connect(usr1).mint(1, 1);
    let balance = await nfmt.balanceOf(usr1.address, 1);

    expect(balance.toNumber()).to.equal(1)
  });

  it("mint 1 should not allow to mint many at the same time", async function () {
    await expect(nfmt.connect(usr1).mint(1, 2)).to.be.reverted;
  });

  it("mint 2 should execute only if STEEL_COST was paid", async function () {
    let steelCost = await nfmt.STEEL_COST();
    await nfmt.connect(usr1).mint(2, 1, {value: steelCost.toString()});
    let contractBalance = await waffle.provider.getBalance(nfmt.address);

    expect(contractBalance.toString()).to.equal(steelCost.toString());
  });
});
