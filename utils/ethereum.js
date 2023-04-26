import { ethers } from "ethers";

export async function connectToMetaMask() {
	if (typeof window.ethereum !== "undefined") {
		const provider = new ethers.BrowserProvider(window.ethereum);
		await window.ethereum.enable();
		const address = await Signer.getAddress();
		console.log("Connected to MetaMask with address:", address);
		return address;
	} else {
		console.log("Please install MetaMask to connect to Ethereum.");
		return null;
	}
}
