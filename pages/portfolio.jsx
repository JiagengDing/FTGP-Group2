import Head from "next/head";
import { useState } from "react";
import Header from "../components/Header";
import { ethers } from "ethers";
import abi from "../utils/address/tradeABI.json";
import address from "../utils/address/tradeAddress.json";



const contractAddress = address.PM1;
const contractAddress2 = address.LRP;
const contractAbi = abi;

let provider;
let signer;
let contract1;
let contract2;


export default function Portfolio() {
	async function init() {
	if (typeof window.ethereum !== "undefined") {
		provider = new ethers.providers.Web3Provider(window.ethereum);
		await provider.send("eth_requestAccounts", []);

		signer = provider.getSigner();
		const userAddress = await signer.getAddress();
		contract1 = new ethers.Contract(contractAddress, contractAbi, signer);
		contract2 = new ethers.Contract(contractAddress2, contractAbi, signer);
		await window.ethereum.enable();
		return contract1;
	} else {
		console.log("Please Install Metamask!");
		return;
	}
};


	const [dai, setDai] = useState("");
	const [wbnb, setWbnb] = useState("");
	const [weth, setWeth] = useState("");
	const [name, setName] = useState("");
	const [symbol, setSymbol] = useState("");
	const [buyAmount, setBuyAmount] = useState("");
	const [buyAmount2, setBuyAmount2] = useState("");
	const [decimals, setDecimals] = useState("");
	const [totalSupply, setTotalSupply] = useState("");
	const [customIPRate, setIPR] = useState("");
	const [latestPrice, setLatestPrice] = useState("");

  async function buyPM1(amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
		await init();
    const tx = await contract1.mint(amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transaction was mined in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}
  async function buyLRP(amount) {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
		await init();
    const tx = await contract2.mint(amount);
    console.log('Transaction Hash:', tx.hash);
    const receipt = await tx.wait();
    console.log('Transaction was mined in block', receipt.blockNumber);
  } catch (error) {
    console.error('Error:', error);
  }
}


		const handleBuy = async () => {
		await init();
		const amount = buyAmount;
		await buyPM1(amount);
	};

	const handleBuyAmountChange = (e) => {
		setBuyAmount(e.target.value);
	};

		const handleBuy2 = async () => {
		await init();
		const amount = buyAmount2;
		await buyLRP(amount);
	};

	const handleBuyAmountChange2 = (e) => {
		setBuyAmount2(e.target.value);
	};

 async function getTotalSupply() {
  if (!provider || !signer) {
    console.log("Ethers Not Init");
    return;
  }

  try {
    const supply = await contract1.getTotalSupply();
		setTotalSupply(supply);
    console.log('Total supply:', totalSupply.toString());
    return totalSupply;
  } catch (error) {
    console.error('Error:', error);
  }
};



	const handleSubmit = async (e) => {
		e.preventDefault();
	};

	return (
		<div>
			<Head>
				<title>Manatee Portfolio</title>
			</Head>

			<div className="min-h-screen bg-slate-100">
				<Header />
				<div className="flex flex-col lg:flex-row justify-center mt-20">
					<div className="flex flex-col justify-center items-center w-full lg:w-1/2">
						<h1 className="text-2xl font-bold text-slate-800 py-5">Create New Portfolio</h1>
						<p className="text-center text-sm text-slate-600">
							Any user can create your portfolio.
						</p>

						<form onSubmit={handleSubmit} className="w-full max-w-md">
							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="dai"
									type="number"
									placeholder="HOPE RATIO"
									value={dai}
									onChange={(e) => setDai(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="wbnb"
									type="number"
									placeholder="USDC RATIO"
									value={wbnb}
									onChange={(e) => setWbnb(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="weth"
									type="number"
									placeholder="LINK RATIO"
									value={weth}
									onChange={(e) => setWeth(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="name"
									type="text"
									placeholder="NAME (eg. mtt)"
									value={name}
									onChange={(e) => setName(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="symbol"
									type="text"
									placeholder="SYMBOL (eg. MTT)"
									value={symbol}
									onChange={(e) => setSymbol(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="decimals"
									type="number"
									placeholder="DECIMALS (eg. 18)"
									value={decimals}
									onChange={(e) => setDecimals(e.target.value)}
									required
								/>
							</div>

							<div className="mb-6">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="totalSupply"
									type="number"
									placeholder="TOTAL SUPPLY (eg. 100)"
									value={totalSupply}
									onChange={(e) => setTotalSupply(e.target.value)}
									required
								/>
							</div>

							<div className="mb-4">
								<input
									className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
									id="customIPRate"
									type="number"
									placeholder="Percentage of creators profit (eg. 2 means 2%)"
									value={decimals}
									onChange={(e) => setIPR(e.target.value)}
									required
								/>
							</div>

							<div className="flex justify-center">
								<button
									className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
                py-2 px-4 rounded focus:outline-none focus:shadow-outline"
									type="submit"
								>
									Create
								</button>
							</div>
						</form>
					</div>

					<div className="flex flex-col justify-center items-center w-full lg:w-1/2">
						<h1 className="text-2xl font-bold text-slate-800 py-5">Trade Portfolio</h1>
						<p className="text-center text-sm text-slate-600">
							Any user can buy or sell any Existed Portfolio from here.
						</p>
								<div>
			<h2 className="text-2xl font-bold text-slate-800 py-5">PM1</h2>

			<div className="block center">
			  <p>Address: 0x3B....1573</p>
				<p>Token Name: PM1</p>
				<p>Latest Price: 0.00007688</p>
			</div>

			<div className="mb-4">
				<input
					className="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="buyAmount"
					type="number"
					placeholder="Amount to buy"
					value={buyAmount}
					onChange={handleBuyAmountChange}
				/>
			</div>
			<button
				onClick={handleBuy}
				className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
        py-2 px-4 rounded focus:outline-none focus:shadow-outline"
			>
				Buy
			</button>
		</div>

			<div>
			<h2 className="text-2xl font-bold text-slate-800 py-5">LRP</h2>

			<div className="block center">
			  <p>Address: 0x41....a749</p>
				<p>Token Name: LRP</p>
				<p>Latest Price: 0.00005123</p>
			</div>

			<div className="mb-4">
				<input
					className="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="buyAmount"
					type="number"
					placeholder="Amount to buy"
					value={buyAmount2}
					onChange={handleBuyAmountChange2}
				/>
			</div>
			<button
				onClick={handleBuy2}
				className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
        py-2 px-4 rounded focus:outline-none focus:shadow-outline"
			>
				Buy
			</button>
		</div>

					</div>
				</div>
			</div>
		</div>
	);
}
