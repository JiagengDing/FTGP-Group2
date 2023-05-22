import Head from "next/head";
import { useState } from "react";
import Header from "../components/Header";
// import PieChart from "../components/PieChart";

import PortfolioButton from "../components/PortfolioButton";
import { PortfolioDetails } from "../components/PortfolioDetails";

export default function Create() {
	const [selectedPortfolio, setSelectedPortfolio] = useState<{
		name: string;
		symbol: string;
		percentages: number[];
		address: string;
		totalSupply: number;
		balance: number;
	}>({
		name: "",
		symbol: "",
		percentages: [],
		address: "",
		totalSupply: 0,
		balance: 0,
	});

	const [dai, setDai] = useState("");
	const [wbnb, setWbnb] = useState("");
	const [weth, setWeth] = useState("");
	const [name, setName] = useState("");
	const [symbol, setSymbol] = useState("");
	const [decimals, setDecimals] = useState("");
	const [totalSupply, setTotalSupply] = useState("");
	const [customIPRate, setIPR] = useState("");

	const handleSubmit = async (e: React.FormEvent) => {
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
									placeholder="DAI"
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
									placeholder="WBNB"
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
									placeholder="WETH"
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

						<div className="flex justify-around my-5">
							<div>
								<PortfolioButton
									name="PM1"
									onClick={() =>
										setSelectedPortfolio({
											name: "PM1",
											symbol: "Portfolio Symbol",
											percentages: [10, 20, 70],
											address: "0x1234567890",
											totalSupply: 0,
											balance: 0,
										})
									}
								/>
								<PortfolioButton
									name="LPR"
									onClick={() =>
										setSelectedPortfolio({
											name: "LPR",
											symbol: "Portfolio Symbol",
											percentages: [10, 20, 70],
											address: "0x1234567890",
											totalSupply: 0,
											balance: 0,
										})
									}
								/>
								<PortfolioButton
									name="TEST"
									onClick={() =>
										setSelectedPortfolio({
											name: "TEST",
											symbol: "TEST",
											percentages: [10, 20, 70],
											address: "0x517834831F0487a6D357d82B98140c94566497A7",
											totalSupply: 0,
											balance: 0,
										})
									}
								/>
							</div>
						</div>

						{selectedPortfolio && (
							<PortfolioDetails
							// name={selectedPortfolio.name}
							// symbol={selectedPortfolio.symbol}
							// percentages={selectedPortfolio.percentages.join(", ")}
							// address={selectedPortfolio.address}
							// totalSupply={selectedPortfolio.totalSupply}
							// balance={selectedPortfolio.balance}
							/>
						)}
					</div>
				</div>
			</div>
		</div>
	);
}
