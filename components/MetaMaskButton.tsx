import { connectToMetaMask } from "../utils/ethereum";

function MetaMaskButton() {
	const handleClick = async () => {
		const address = await connectToMetaMask();
		if (address) {
			// Do something with the user's Ethereum address
		}
	};

	return <button onClick={handleClick}>Login</button>;
}

export default MetaMaskButton;
