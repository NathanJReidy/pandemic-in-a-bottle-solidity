async function main() {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); // Go and find my smart contract and compile it, and wait for it to finish compiling
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  }); // Hardhat will start a local Ethereum blockchain on your computer. NB: Hardhat starts and then kills the local blockchain server every time we run it. On this line we fund our contract with 0.1 Ethereum and deploy it
  await waveContract.deployed();
  console.log("Contract addy:", waveContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveTxn = await waveContract.wave("This is wave #1!");
  await waveTxn.wait(); // wait for txn to be mined

  waveTxn = await waveContract.wave("This is wave #2!");
  await waveTxn.wait(); // wait for txn to be mined

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
