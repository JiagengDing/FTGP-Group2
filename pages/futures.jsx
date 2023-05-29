import Head from "next/head";
import React, { useEffect, useState } from "react";
import Header from "../components/Header";
import { ethers } from "ethers";

import abi from "../utils/address/futuresABI.json";

const ABI = abi;
const contractAddress = "0x65ed55184efd596ca62e8488446448087b792277";

let userAddress;


export default function Futures() {

async function init() {
	if (typeof window.ethereum !== "undefined") {
		const provider = new ethers.providers.Web3Provider(window.ethereum);
		await provider.send("eth_requestAccounts", []);

		const signer = provider.getSigner();
		userAddress = await signer.getAddress();
		const contract1 = new ethers.Contract(contractAddress, ABI, signer);
		await window.ethereum.enable();
		return contract1;
	} else {
		console.log("Please Install Metamask!");
		return;
	}
};

// const contract = init();

const [data, setData] = useState([]);
// const [ids, setIds] = useState([]);
// useEffect(() => {
//   async function fetchIds() {
//     // const contract1 = init();
//     const contract1 = await init();
//     const result = await contract1.getOfferList();
//     const idList = result.map(item => item[0]);
//     setIds(idList);
//   }
//   fetchIds();
// }, []);

useEffect(() => {
	async function fetchData() {
		// Fetch data for each id
		const contract1 = await init();
		const idd = await contract1.getOfferList();
		const ids = idd.map(item => item[0]);
		// console.log(contract1.offers(0));
		const promises = ids.map(async (id) => {
			const { seller, asset, price, quantity,originQuantity, delivery_time, status } = await contract1.offers(id);
			return {id:id.toString(), asset: asset.toString(), price:ethers.utils.formatUnits(price, 'wei'), quantity:quantity.toString(), delivery_time:new Date(delivery_time.toNumber() * 1000).toLocaleDateString() };
		});

		// Resolve all promises and update state
		const results = await Promise.all(promises);
		// console.log(results);
		setData(results);
	}

	fetchData();
}, []);
	// const [tradeList, setTradeList] = useState<{
	//   id: string;
	//   name: string;
	//   price: number;
	//   quantity: number;
		// date: string;
	// }>({
	//   id: "",
	//   name: "",
	//   price: 0,
	//   quantity: 0,
	//   date: "",
	// });

const [balance, setBalance] = useState(null);

async function fetchBalance() {
    try {
        // Assuming `contract` is already initialized and `userAddress` is the user's Ethereum address
			  const contract1 = await init();
        const balance = await contract1.balances(userAddress);

        // Convert balance from BigNumber to string
        setBalance(ethers.utils.formatUnits(balance, 'ether')); // assuming the balance is in wei
    } catch (error) {
        console.error("An error occurred", error);
    }
}

// Fetch balance on component mount and whenever `userAddress` changes
useEffect(() => {
    fetchBalance();
}, [userAddress]);


const [depositAmount, setDepositAmount] = useState('');

async function deposit() {
    try {
        // Convert depositAmount from ether to wei
        const wei = ethers.utils.parseUnits(depositAmount, 'ether');

			  const contract1 = await init();
        const tx = await contract1.deposit({ value: wei });

        // Wait for transaction to be mined
        await tx.wait();

        // Fetch updated balance
        fetchBalance();
    } catch (error) {
        console.error("An error occurred", error);
    }
}

const [quantities, setQuantities] = useState({});

const setQuantity2 = ({ id, quantity }) => {
    setQuantities(prev => ({ ...prev, [id]: quantity }));
};

async function trade(id) {
    // Call your smart contract's trade function with the selected id
    try {
		    const contract1 = await init();
  			const quantity = quantities[id];
        const tx = await contract1.submitOffer(id, quantity);

        // Wait for transaction to be mined
        await tx.wait();
    } catch (error) {
        console.error("An error occurred", error);
    }
}


  const [assets, setAssets] = useState([]);
  const [asset, setAsset] = useState('');
	const [price, setPrice] = useState("");
	const [quantity, setQuantity] = useState("");
	const [expiresAt, setExpiresAt] = useState("");
  const assetsObject = {tockenC:"0xE035Ea35F6f629f0312A2cD722CA5F627b882a67", tockenD:"0xE55DE62Aa86b98b29D42fdA68A29B6d300a20d5b"};
		useEffect(() => {
    async function fetchAssets() {
        try {
            // Assuming `contract` is already initialized
					const contract1 = await init();
          const assets = await contract1.getAssetList();


            setAssets(assets);
            if (assets.length > 0) {
                setAsset(assets[0][0]); // Set the first asset as the initial selected asset
            }
        } catch (error) {
            console.error("An error occurred", error);
        }
    }

    fetchAssets();
}, []);

const handleSubmit = async (e) => {
    e.preventDefault();

    if (!asset || !price || !quantity || !expiresAt) return;

    try {
        // Convert values if needed
        const assetAddress = assetsObject.tockenC;
        console.log(assetAddress);
        const priceInWei = ethers.utils.parseUnits(price, 'ether'); // Convert price from ether to wei, assuming price is in ether
        const quantityInWei = ethers.utils.parseUnits(quantity, 'ether'); // Convert quantity from ether to wei, assuming quantity is in ether
        const expiresAtTimestamp = Math.floor(new Date(expiresAt).getTime() / 1000); // Convert JavaScript timestamp (ms) to Unix timestamp (s)

        // Call the smart contract function
		    const contract = await init();
        const tx = await contract.pushOffer(assetAddress, priceInWei, quantityInWei, expiresAtTimestamp);

        // Wait for the transaction to be mined
        await tx.wait();

    } catch (error) {
        console.error("An error occurred", error);
    }
};


// console.log(assetsObject.tockenC);
		// console.log(asset1);

	return (
		<div>
			<Head>
				<title>Manatee DApp - Create a Future Contract</title>
				<link rel="icon" href="/favicon.ico" />
			</Head>

			<div className="min-h-screen bg-slate-100">
				<Header />
				<div className="flex flex-col lg:flex-row justify-center mt-20">
					<div className="flex flex-col justify-center items-center w-full lg:w-1/2">
						<h1 className="text-2xl font-bold text-slate-800 py-5">Create New Futures</h1>

						<p className="text-center text-sm text-slate-600">
							On this page, you can create a custom futures contracts <br />
							which is used to hedge your holdings risk.
						</p>

						<form onSubmit={handleSubmit} className="w-full max-w-md">

						<div className="mb-6">
             <select
              className="appearance-none border rounded w-full py-2 px-3
              text-gray-700 leading-tight focus:outline-none
              focus:shadow-outline"
             id="asset"
             value={asset}
             onChange={(e) => setAsset(e.target.value)}
             required
              >
        {assets.map((asset, index) => (
            <option key={index} value={asset}>{asset}</option>
        ))}
    </select>
</div>
							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="price"
									type="number"
									step={0.01}
									min={0.01}
									placeholder="Price"
									value={price}
									onChange={(e) => setPrice(e.target.value)}
									required
								/>
							</div>
							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="quantity"
									type="number"
									step={0.01}
									min={0.01}
									placeholder="Quantity"
									value={quantity}
									onChange={(e) => setQuantity(e.target.value)}
									required
								/>
							</div>
							<div className="mb-6">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="expiresAt"
									type="datetime-local"
									value={expiresAt}
									onChange={(e) => setExpiresAt(e.target.value)}
									required
								/>
							</div>
							<div className="flex justify-center">
								<button
									className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
                py-2 px-4 rounded focus:outline-none focus:shadow-outline"
									type="submit"
								>
									Submit This Futures
								</button>
							</div>
						</form>
					</div>

					<div className="flex flex-col justify-center items-center w-full lg:w-1/2">
						<div>
						<h1 className="text-2xl font-bold text-slate-800 py-5">Existing Futures</h1>
						<table className="table-auto border-collapse border border-gray-300 mx-auto my-5">
    <thead>
        <tr>
            <th className="border border-gray-300 px-3 py-2">ID</th>
            <th className="border border-gray-300 px-3 py-2">Price</th>
            <th className="border border-gray-300 px-3 py-2">Quantity</th>
            <th className="border border-gray-300 px-3 py-2">Delivery Date</th>
            <th className="border border-gray-300 px-3 py-2">Action</th>
        </tr>
    </thead>
    <tbody>
		{data.map((item) => (
    <tr key={item.id}>
        <td className="border border-gray-300 px-3 py-2">{item.id}</td>
        <td className="border border-gray-300 px-3 py-2">{item.price}</td>
        <td className="border border-gray-300 px-3 py-2">{item.quantity}</td>
        <td className="border border-gray-300 px-3 py-2">{item.delivery_time}</td>
        <td className="border border-gray-300 px-3 py-2 flex items-center">
            <input
                type="number"
                min="1"
                onChange={(e) => setQuantity2({ id: item.id, quantity: e.target.value })}
            />
            <button
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-1 px-4 rounded"
                onClick={() => trade(item.id, item.quantity)}
            >
                Trade
            </button>
        </td>
    </tr>
))}

    </tbody>
</table>

						<h1 className="text-2xl font-bold text-slate-800 py-5">My Account</h1>
<p>Your Current Balance: {balance} ETH</p>
<input
    type="number"
    step="0.01"
    min="0.01"
    value={depositAmount}
    onChange={(e) => setDepositAmount(e.target.value)}
    placeholder="Amount to deposit"
/>
<button                 className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-1 px-4 rounded"
 onClick={deposit}>Deposit</button>

						</div>
					</div>
				</div>
			</div>
		</div>
	);
}
