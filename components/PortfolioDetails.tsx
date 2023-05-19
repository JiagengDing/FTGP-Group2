// import PieChart from "./PieChart";
// <PieChart data={percentages} />
import { useState } from "react";

export default function PortfolioDetails({
	name = "",
	symbol = "",
	percentages = "",
	address = "",
	totalSupply = 0,
	balance = 0,
} = {}) {
	const [portfolioPercentages, setPortfolioPercentages] = useState(
		percentages.length > 0 ? percentages : [30, 40, 30]
	);

	return (
		<div>
			<h2>{name}</h2>
			<p>Symbol: {symbol}</p>
			<p>Address: {address}</p>
			<p>Total Supply: {totalSupply}</p>
			<p>Your Current Balance: {balance}</p>
			<div className="mb-4">
				<input
					className="appearance-none border rounded w-full py-2 px-3
          text-gray-700 leading-tight focus:outline-none
          focus:shadow-outline"
					id="buyAmount"
					type="number"
					placeholder="Amount to buy"
				/>
			</div>
			<button
				className="w-full bg-[#0c2856] hover:bg-[#1a396c] text-white font-bold
        py-2 px-4 rounded focus:outline-none focus:shadow-outline"
			>
				Buy
			</button>
		</div>
	);
}
