import { useState } from "react";
import { init } from "../utils/blockchain";

function MetaMaskButton() {
	const [userAddress, setUserAddress] = useState("");

	const handleClick = async () => {
		const address = await init();
		if (address) {
			setUserAddress(address);
		}
	};

	const buttonStyle =
		"flex flex-nowrap border py-2 px-4 rounded-full bg-amber-500 hover:bg-rose-600 cursor-pointer font-semibold text-sm";

	if (userAddress) {
		return <span className={buttonStyle}>Connected!</span>;
	} else {
		return (
			<button onClick={handleClick} className={buttonStyle}>
				Connect MetaMask
			</button>
		);
	}
}

export default MetaMaskButton;
