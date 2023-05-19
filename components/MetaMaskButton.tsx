import { useState } from "react";
import { connectToMetaMask } from "../utils/ethereum";

function MetaMaskButton() {
	const [userAddress, setUserAddress] = useState("");

	const handleClick = async () => {
		const address = await connectToMetaMask();
		if (address) {
			setUserAddress(address);
		}
	};

	const buttonStyle =
		"flex flex-nowrap border py-2 px-4 rounded-full bg-amber-500 hover:bg-rose-600 cursor-pointer font-semibold text-sm";

	if (userAddress) {
		return <span className={buttonStyle}>{userAddress}</span>;
	} else {
		return (
			<button onClick={handleClick} className={buttonStyle}>
				Connect MetaMask
			</button>
		);
	}
}

export default MetaMaskButton;
