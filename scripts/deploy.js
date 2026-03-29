const { ethers } = require("hardhat");

async function main() {
  const Token = await ethers.getContractFactory("Token");

  const tokenA = await Token.deploy("TokenA", "TKA");
  const tokenB = await Token.deploy("TokenB", "TKB");

  await tokenA.waitForDeployment();
  await tokenB.waitForDeployment();

  const tokenAAddress = await tokenA.getAddress();
  const tokenBAddress = await tokenB.getAddress();

  const DEX = await ethers.getContractFactory("DEX");
  const dex = await DEX.deploy(tokenAAddress, tokenBAddress);

  await dex.waitForDeployment();

  console.log("TokenA:", tokenAAddress);
  console.log("TokenB:", tokenBAddress);
  console.log("DEX:", await dex.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});