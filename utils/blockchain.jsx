import { ethers } from "ethers";
import abi from "./tradeABI.json";
import address from "./tradeAddress.json";

const contractAddress = address.PM1;
const LRPcontractAddress = address.LRP;
const contractAbi = abi;

let provider;
let signer;
let contract;
let LRPcontract;

export async function init() {
  if (typeof window.ethereum !== "undefined") {
    provider = new ethers.providers.Web3Provider(window.ethereum);
		await provider.send("eth_requestAccounts", []);

    signer = provider.getSigner();
		const address = await signer.getAddress();
    contract = new ethers.Contract(contractAddress, contractAbi, signer);
		LRPcontract = new ethers.Contract(LRPcontractAddress, contractAbi, signer);
    await window.ethereum.enable();
		return address;
  } else {
    console.log("Please Install Metamask!");
    return;
  }
}

export async function buyPM1(amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tx = await contract.mint(amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transaction was mined in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function buyLRP(amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tx = await LRPcontract.mint(amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transaction was mined in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}

init();
