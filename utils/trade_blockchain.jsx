import { ethers } from "ethers";
import abi from "../utils/tradeABI.json";
import address from "../utils/tradeAddress.json";

const contractAddress = address;
const contractAbi = abi;

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

export async function buy(amount) {
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

export async function burn(amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tx = await contract.burn(amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transaction was burned in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function getOwnerBalanceOf() {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const balance = await contract.getOwnerBalanceOf();
    console.log('Owner balance:', balance.toString());
    return balance;
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function getContractAddress() {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const contractAddress = await contract.getContractAddress();
    console.log('Contract address:', contractAddress);
    return contractAddress;
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function getTotalSupply() {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const totalSupply = await contract.getTotalSupply();
    console.log('Total supply:', totalSupply.toString());
    return totalSupply;
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function transfer(to, amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const tx = await contract.transfer(to, amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transfer was mined in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}


init();
