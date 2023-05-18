import { useState } from "react";
import { connectToMetaMask } from "../utils/ethereum";

function MetaMaskButton() {
	const [userAddress, setUserAddress] = useState(null);

	const handleClick = async () => {
		const address = await connectToMetaMask();
		if (address) {
			setUserAddress(address);
		}
	};

	if (userAddress) {
		return <span>{userAddress}</span>;
	} else {
		return (
			<button
				onClick={handleClick}
				className="flex flex-nowrap border py-2 px-4 rounded-full bg-amber-500
				hover:bg-rose-600 cursor-pointer font-semibold text-sm"
			>
				Connect MetaMask
			</button>
		);
	}
}

export default MetaMaskButton;
