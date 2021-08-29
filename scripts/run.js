async function main() {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); // Go and find my smart contract and compile it, and wait for it to finish compiling
  const waveContract = await waveContractFactory.deploy(); // Hardhat will start a local Ethereum blockchain on your computer. NB: Hardhat starts and then kills the local blockchain server every time we run it
  await waveContract.deployed();
  console.log("Contract addy:", waveContract.address);

  let count = await waveContract.getTotalWaves();
  console.log(count.toNumber());

  let waveTxn = await waveContract.wave("A message!");
  await waveTxn.wait(); // wait for txn to be mined

  waveTxn = await waveContract.wave("Another message!");
  await waveTxn.wait(); // wait for txn to be mined

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
