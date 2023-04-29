import React from 'react';

const Guide = () => {
  return (
    <div>
      <h1>Futures and Options Trading Platform</h1>
      <p>
        This platform allows users to trade futures and options contracts for
        various underlying assets using Ethereum blockchain.
      </p>
      <h2>Key features:</h2>
      <ul>
        <li>Create and manage futures and options contracts.</li>
        <li>Lock contracts to activate positions.</li>
        <li>Execute market orders to buy or sell underlying assets.</li>
        <li>Automated contract settlement upon expiration or stop-loss triggers.</li>
        <li>Margin calls and stop-loss orders management.</li>
        <li>View trade history and executed orders.</li>
      </ul>
      <h2>How to use:</h2>
      <ol>
        <li>
          To get started, both the buyer and seller should agree on the terms
          of the contract, including the price, strike price, quantity, expiration
          date, margin requirements, leverage, stop-loss, and margin call levels.
        </li>
        <li>
          After the contract is created, either the buyer or seller can lock the
          contract by providing a sufficient margin to open a position. Once the
          contract is locked, the platform will calculate the position size based
          on the margin and leverage provided.
        </li>
        <li>
          Users can execute market orders to buy or sell the underlying assets.
          Please ensure that there are sufficient funds or assets in your account
          to execute the order.
        </li>
        <li>
          The platform will automatically settle the contract when it expires or
          when a stop-loss order or margin call is triggered. Users will be notified
          of the contract settlement, including the winner and payout amount.
        </li>
        <li>
          You can view the trade history and executed orders on the platform by
          accessing the trades mapping.
        </li>
      </ol>
      <p>
        Happy trading! Please trade responsibly and be aware of the risks
        associated with futures and options trading.
      </p>
    </div>
  );
};

export default Guide;
