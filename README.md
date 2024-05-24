# Betting Smart Contract

This repository contains the Solidity code for a simple betting smart contract deployed on the Ethereum blockchain. The smart contract allows users to place bets on an event with a binary outcome and distributes the total pool of bets to the winners.

## Features

- **Place Bets:** Users can place bets on either outcome of the event.
- **Finalize Event:** The contract owner can finalize the event, specifying the winning outcome.
- **Payout Winners:** The contract automatically distributes the total pool of bets to the winners based on their stake.

## Requirements

- Solidity ^0.8.0
- OpenZeppelin Contracts

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Node.js](https://nodejs.org/en/download/)
- [Truffle](https://www.trufflesuite.com/truffle)
- [Ganache](https://www.trufflesuite.com/ganache)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/betting-smart-contract.git
   cd betting-smart-contract
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Compile the smart contract:**

   ```bash
   truffle compile
   ```

4. **Deploy the smart contract to the local blockchain:**

   Start Ganache:

   ```bash
   ganache-cli
   ```

   In another terminal, deploy the contract:

   ```bash
   truffle migrate
   ```

### Usage

#### Interacting with the Contract

1. **Place a Bet:**

   Call the `placeBet` function with the outcome you are betting on and send the amount of Ether you want to bet.

   ```javascript
   bettingInstance.placeBet(outcome, { from: userAddress, value: betAmount });
   ```

2. **Finalize the Event:**

   Only the contract owner can call the `finalizeEvent` function to specify the winning outcome.

   ```javascript
   bettingInstance.finalizeEvent(winningOutcome, { from: ownerAddress });
   ```

3. **Claim Winnings:**

   After the event is finalized, winners can call the `claimWinnings` function to receive their share of the total pool.

   ```javascript
   bettingInstance.claimWinnings({ from: userAddress });
   ```

### Testing

Run the tests to ensure the smart contract behaves as expected:

```bash
truffle test
```

## Contract Details

### Contract Structure

- **BettingContract.sol:** Main contract file containing the logic for placing bets, finalizing events, and distributing winnings.

### Functions

- `placeBet(uint8 _outcome)`: Place a bet on the specified outcome.
- `finalizeEvent(uint8 _winningOutcome)`: Finalize the event with the specified winning outcome.
- `claimWinnings()`: Claim the winnings if you have bet on the correct outcome.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes.
4. Push to your branch.
5. Create a pull request.

## License

This project is licensed under the MIT License.

---

For any issues or feature requests, please open an issue on the [GitHub repository](https://github.com/yourusername/betting-smart-contract).

---

### Acknowledgements

This project utilizes the OpenZeppelin library for secure and efficient smart contract development. Special thanks to the Ethereum community for their continuous support and innovation in the blockchain space.

---

Happy betting!
