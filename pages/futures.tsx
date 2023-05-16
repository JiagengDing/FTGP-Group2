import Head from "next/head";
import { useState } from "react";
import { useRouter } from "next/router";
import Header from "../components/Header";

export default function Create() {
	const router = useRouter();

	const [title, setTitle] = useState("");
	const [asset, setAsset] = useState("");
	const [seller, setSeller] = useState("");
	const [price, setPrice] = useState("");
	const [quantity, setQuantity] = useState("");
	const [expiresAt, setExpiresAt] = useState("");

	const handleSubmit = async (e) => {
		e.preventDefault();
		if (!wallet) return toast.warning("Wallet not connected");

		if (!title || !asset || !seller || !price || !quantity || !expiresAt) return;
		const params = {
			title,
			asset,
			seller,
			price,
			quantity,
			expiresAt: new Date(expiresAt).getTime(),
		};
	};

	// const onReset = () => {
	//   setTitle("");
	//   setDescription("");
	//   setSeller("");
	//   setPrice("");
	//   setTicketPrice("");
	//   setExpiresAt("");
	// };

	return (
		<div>
			<Head>
				<title>Manatee DApp - Create a Future Contract</title>
				<link rel="icon" href="/favicon.ico" />
			</Head>

			<div className="min-h-screen bg-slate-100">
				<Header />
				<div className="flex flex-col justify-center items-center mt-20">
					<div className=" flex flex-col items-center justify-center my-5">
						<h1 className="text-2xl font-bold text-slate-800 py-5">Create a Futures Contract</h1>
						<p className="text-center text-sm text-slate-600">
							On this page, you can create a custom futures contracts <br />
							which is used to hedge your holdings risk.
						</p>
					</div>

					<form onSubmit={handleSubmit} className="w-full max-w-md">
						<div className="mb-4">
							<input
								className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
								id="title"
								type="text"
								placeholder="Title"
								value={title}
								onChange={(e) => setTitle(e.target.value)}
								required
							/>
						</div>
						<div className="mb-6">
							<input
								className="appearance-none border rounded w-full py-2 px-3
                text-gray-700 leading-tight focus:outline-none
                focus:shadow-outline"
								id="ticketPrice"
								type="text"
								step={0.01}
								min={0.01}
								placeholder="Asset"
								value={asset}
								onChange={(e) => setAsset(e.target.value)}
								required
							/>
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
			</div>
		</div>
	);
}
