// First, you need the CustomToken ABI
const customTokenABI = [
  // Deposit function
  {
    inputs: [],
    name: "deposit",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  // Withdraw function
  {
    inputs: [{ type: "uint256", name: "amount" }],
    name: "withdraw",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  // Other functions like balanceOf, etc.
];

// Connect to the specific token
async function interactWithToken(tokenAddress) {
  // Using ethers.js
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const tokenContract = new ethers.Contract(
    tokenAddress,
    customTokenABI,
    signer
  );

  // Mint tokens by sending ETH
  await tokenContract.deposit({ value: ethers.utils.parseEther("1.0") });

  // Withdraw tokens
  await tokenContract.withdraw(ethers.utils.parseEther("0.5"));

  // Check balance
  const balance = await tokenContract.balanceOf(await signer.getAddress());
  console.log("Token balance:", ethers.utils.formatEther(balance));
}
