import { ethers } from "ethers";
import factoryAbi from "../utils/manageABI.json";
import factoryAddress from "../utils/manageAddress.json";

const contractAddress = factoryAddress;
const contractAbi = factoryAbi;

let provider;
let signer;
let contract;

export async function init() {
  if (typeof window.ethereum !== "undefined") {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);

    signer = provider.getSigner();
    const address = await signer.getAddress();
    contract = new ethers.Contract(contractAddress, contractAbi, signer);
    await window.ethereum.enable();
    return address;
  } else {
    console.log("Please Install Metamask!");
    return;
  }
}

export async function createPToken(_name, _symbol, _totalSupply, _hopeRatio, _usdcRatio, _linkRatio, _customIPRate) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tx = await contract.createPToken(_name, _symbol, _totalSupply, _hopeRatio, _usdcRatio, _linkRatio, _customIPRate);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('PToken was created in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function getTokenAddress() {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tokenAddress = await contract.getTokenAddress();
    console.log('Token address:', tokenAddress);
    return tokenAddress;
  } catch (error) {
    console.error('Error:', error);
  }
}
