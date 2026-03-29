const { ethers } = require("hardhat");

function log(title, value) {
  console.log(`\n=== ${title} ===`);
  console.log(value.toString());
}

async function main() {
  const [user] = await ethers.getSigners();

  console.log("User:", user.address);

  // Deploy tokens
  const Token = await ethers.getContractFactory("Token");
  const tokenA = await Token.deploy("TokenA", "TKA");
  const tokenB = await Token.deploy("TokenB", "TKB");

  await tokenA.waitForDeployment();
  await tokenB.waitForDeployment();

  // Deploy DEX
  const DEX = await ethers.getContractFactory("DEX");
  const dex = await DEX.deploy(
    await tokenA.getAddress(),
    await tokenB.getAddress()
  );
  await dex.waitForDeployment();

  console.log("\n--- CONTRACTS ---");
  console.log("TokenA:", await tokenA.getAddress());
  console.log("TokenB:", await tokenB.getAddress());
  console.log("DEX:", await dex.getAddress());

  // Approve
  await tokenA.approve(dex.target, ethers.parseEther("10000"));
  await tokenB.approve(dex.target, ethers.parseEther("10000"));

  console.log("\nAdding Liquidity...");
  await dex.addLiquidity(
    ethers.parseEther("1000"),
    ethers.parseEther("1000")
  );

  let reserves = await dex.getReserves();
  log("Reserves after liquidity", reserves);

  console.log("\nSwapping 100 TokenA → TokenB...");
  await tokenA.approve(dex.target, ethers.parseEther("100"));
  await dex.swapAforB(ethers.parseEther("100"));

  reserves = await dex.getReserves();
  log("Reserves after swap", reserves);

  const price = await dex.spotPrice();
  log("Spot Price", price);
}

main().catch(console.error);