const { ethers } = require("hardhat");

async function main() {
    const Token = await ethers.getContractFactory("Token");

    const tokenA = await Token.deploy("TokenA", "TKA");
    const tokenB = await Token.deploy("TokenB", "TKB");

    await tokenA.waitForDeployment();
    await tokenB.waitForDeployment();

    const DEX = await ethers.getContractFactory("DEX");

    const dex1 = await DEX.deploy(
        await tokenA.getAddress(),
        await tokenB.getAddress()
    );

    const dex2 = await DEX.deploy(
        await tokenA.getAddress(),
        await tokenB.getAddress()
    );

    await dex1.waitForDeployment();
    await dex2.waitForDeployment();

    console.log("DEX1:", await dex1.getAddress());
    console.log("DEX2:", await dex2.getAddress());

    // Approvals
    await tokenA.approve(dex1.target, ethers.parseEther("10000"));
    await tokenB.approve(dex1.target, ethers.parseEther("10000"));

    await tokenA.approve(dex2.target, ethers.parseEther("10000"));
    await tokenB.approve(dex2.target, ethers.parseEther("10000"));

    // Create price difference
    await dex1.addLiquidity(
        ethers.parseEther("1000"),
        ethers.parseEther("2000")
    );

    await dex2.addLiquidity(
        ethers.parseEther("1000"),
        ethers.parseEther("1000")
    );

    console.log("\n--- Before Arbitrage ---");
    console.log("DEX1 price:", (await dex1.spotPrice()).toString());
    console.log("DEX2 price:", (await dex2.spotPrice()).toString());

    const Arbitrage = await ethers.getContractFactory("Arbitrage");
    const arb = await Arbitrage.deploy();
    await arb.waitForDeployment();

    console.log("\nExecuting arbitrage...");
    await tokenA.approve(arb.target, ethers.parseEther("10"));

    await arb.execute(
        dex1.target,
        dex2.target,
        tokenA.target,
        tokenB.target,
        ethers.parseEther("10")
    );

    console.log("\n--- After Arbitrage ---");
    console.log("DEX1 price:", (await dex1.spotPrice()).toString());
    console.log("DEX2 price:", (await dex2.spotPrice()).toString());
}

main().catch(console.error);