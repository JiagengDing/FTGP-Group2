# FTGP Group2

This is an Ethereum-based trading DApp that allows users to trade options and futures on a decentralized platform. The application is built using Solidity for the smart contract and Next.js for the front-end.

## Getting Started

To get started with this application, follow the steps below:

1. Clone the repository
2. `cd front-end`
3. Install the required dependencies using `npm install`
4. Compile the Solidity contract using `npm run compile`
5. Deploy the contract using `npm run deploy`
6. Start the Next.js server using `npm run dev`

Once you have completed these steps, you can access the trading application by visiting `http://localhost:3000`.

## Features

The trading application supports the following features:

1. Options Trading: Users can buy and sell options using the platform.
2. Futures Trading: Users can buy and sell futures using the platform.
3. Account Management: Users can create and manage their accounts with metamask.
4. Trading History: Users can view their trading history on the platform.

## Back-end

The smart contract for the trading application is located in the `back-end/` directory. It is written in Solidity and implements the logic for option and future trading.

## Front-end

The front-end for the DApp is built using Next.js and is located in the `front-end/pages/` directory. The front-end communicates with the smart contract using the `web3.js` library.

## Contributing

If you would like to contribute to this project, please open an issue or submit a pull request on GitHub. We welcome contributions from the community.

## License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for more information.
