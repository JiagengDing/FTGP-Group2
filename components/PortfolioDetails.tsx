// import PieChart from "./PieChart";
// <PieChart data={percentages} />
import { useState } from "react";
import { ethers } from "ethers";
import { useEffect } from "react";
import { ChangeEvent } from "react";
import { init, buy } from "@/utils/blockchain";

import abi from "../utils/portfolioABI.json";
import address from "../utils/portfolioAddress.json";

const contractAddress = address.address;
const contractAbi = abi;
// const [totalSupply, setTotalSupply] = useState("");
// const [name, setName] = useState("");
// const [address, setAddress] = useState("");
// const [symbol, setSymbol] = useState("");
// const [balance, setBalance] = useState("");

const PortfolioDetails = () => {
	const [buyAmount, setBuyAmount] = useState("");

	const portfolioTrade = new ethers.Contract(
		contractAddress,
		contractAbi,
		ethers.providers.getDefaultProvider("kovan")
	);
	useEffect(() => {
		// setTotalSupply(portfolioTrade.totalSupply().toString);
		// portfolioTrade.totalSupply().then((res) => {
		//   setTotalSupply(res.toString());
		// });
	});

	const handleMint = async () => {
		try {
			const result = await portfolioTrade.mint(buyAmount);
			console.log("Mint Result:", result);
		} catch (error) {
			console.error("Mint Error:", error);
		}
	};

	const handleBuy = async () => {
		await init();
		const amount = buyAmount;
		await buy(amount);
	};

	const handleBuyAmountChange = (event: ChangeEvent<HTMLInputElement>) => {
		setBuyAmount(event.target.value);
	};

	return (
		<div>
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
	);
	// return (
	//   // <div className="block center">
	//   //   <h2>
	//   //     {props.token.name} ({props.token.symbol})
	//   //   </h2>
	//   //   <p>Circulating Supply:</p>
	//   <p>{totalSupply}</p>
	//   // </div>
	// );
};
export { PortfolioDetails };

// export default function PortfolioDetails({
//   name = "",
//   symbol = "",
//   percentages = "",
//   address = "",
//   totalSupply = 0,
//   balance = 0,
// } = {}) {
//   const [portfolioPercentages, setPortfolioPercentages] = useState(
//     percentages.length > 0 ? percentages : [30, 40, 30]
//   );
//
//   return (
//     <div>
//       <h2>{name}</h2>
//       <p>Symbol: {symbol}</p>
//       <p>Address: {address}</p>
//       <p>Total Supply: {totalSupply}</p>
//       <p>Your Current Balance: {balance}</p>
//       <div className="mb-4">
//         <input
//           className="appearance-none border rounded w-full py-2 px-3
//           text-gray-700 leading-tight focus:outline-none
//           focus:shadow-outline"
//           id="buyAmount"
//           type="number"
//           placeholder="Amount to buy"
//         />
//       </div>
//       <button
//         className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
//         py-2 px-4 rounded focus:outline-none focus:shadow-outline"
//       >
//         Buy
//       </button>
//     </div>
//   );
// }
