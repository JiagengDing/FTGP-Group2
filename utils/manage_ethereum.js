import { ethers } from "ethers";
import { useWeb3React } from "@web3-react/core";
import factoryAbi from "../utils/manageABI.json";
import factoryAddress from "../utils/manageAddress.json";

const { active, activate, library: provider } = useWeb3React();
const contractAddress = factoryAddress;
const contractAbi = factoryAbi;
let factoryContract;

const connectToMetaMask = async () => {
	if (typeof window.ethereum !== "undefined") {
		const provider = new ethers.providers.Web3Provider(window.ethereum);
		// MetaMask requires requesting permission to connect users accounts
		await provider.send("eth_requestAccounts", []);

		// await window.ethereum.enable();
		const signer = provider.getSigner();
		const address = await signer.getAddress();
		console.log("Connected to MetaMask with address:", address);

		// Instantiate the contract
		factoryContract = new ethers.Contract(contractAddress, contractAbi, signer);

		return address;
	} else {
		console.log("Please install MetaMask to connect to Ethereum.");
		return null;
	}
};

export { connectToMetaMask, factoryContract };
