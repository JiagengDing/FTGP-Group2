# FTGP Group2

This is an Ethereum-based trading DApp that allows users to trade options and futures on a decentralized platform. The application is built using Solidity for the smart contract and Next.js for the front-end.

## Getting Started

To get started with this application, follow the steps below:

1. Clone the repository
2. Install the required dependencies using `npm config set legacy-peer-deps true && npm install`
3. Compile the Solidity contract using `npm run compile`
4. Deploy the contract using `npm run deploy`
5. Start the Next.js server using `npm run dev`

Once you have completed these steps, you can access the trading application by visiting `http://localhost:3000`.

You can start editing the page by modifying pages/index.tsx. The page auto-updates as you edit the file.

API routes can be accessed on http://localhost:3000/api/hello. This endpoint can be edited in pages/api/hello.ts.

The pages/api directory is mapped to /api/*. Files in this directory are treated as API routes instead of React pages.

This project uses next/font to automatically optimize and load Inter, a custom Google Font.

## Features

The trading application supports the following features:

1. Options Trading: Users can buy and sell options using the platform.
2. Futures Trading: Users can buy and sell futures using the platform.
3. Account Management: Users can create and manage their accounts with metamask.
4. Trading History: Users can view their trading history on the platform.

## Back-end

The smart contract for the trading application is located in the `back-end/` directory. It is written in Solidity and implements the logic for option and future trading.

## Front-end

The front-end for the DApp is built using Next.js and is located in the `pages/` directory. The front-end communicates with the smart contract using the `web3.js` library.

## Contributors

- [ Yiting Yu ](https://github.com/uuTing): Future trading smart contract.
- [ Longxi He ](https://github.com/LongxiHe): Option trading smart contract.
- [ Brenda Lu ](https://github.com/brendalu21fav): Portfolio trading smart contract.
- [ Jianan Wang ](https://github.com/righteousnoah): Portfolio creation smart contract.

## License

This project is licensed under the GPL-3.0 License. See the `LICENSE` file for more information.

## Reference

- [the Next.js GitHub repository](https://github.com/vercel/next.js/)

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.
