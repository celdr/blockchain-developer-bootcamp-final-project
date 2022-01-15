# Fragmints - Fractional NFTs

## Project Description

Fragmints is a dapp that allows users to fractionalize NFTs into multiple pieces. To retrieve the original token, a single address must hold all of the fragments. While current (1/13/2022) it only works with within this contract, the hope is in the future to allow any ERC-721 and ERC-1155 tokens.

## How it Works

* A user mints a NFT by clicking the mint button
* Once the user has minted one of the original token, the user can then select the desired token ID to fragment and the amount of pieces they want. Once the fields have been filled, the user can press 'Fragmint'. This sends transfer the token with the select ID to the contract and then mints tokens (amount determined by the user) to the user.
* If the user holds all the fragmented tokens, the user can reform for the original token. This burns the users token and sends the original to the user.
* The interface also allows the tokens (original and fragment tokens) to other users. 

## Screencast

2x Speed Recommended
<https://www.loom.com/share/92f83451ff7842ab91ca148dbddfabf9>

## Deployment

<https://celdr.github.io/blockchain-developer-bootcamp-final-project/index.html>

## Project Structure

```
.
├── build/                          # Truffle Build 
├── contracts/                      # Truffle Contracts 
├── migrations/                     # Truffle Migrations 
├── node_modules                    # OpenZeppelin Modules       
├── test/fragmints.js               # Automated Tests 
├── dapp.js                         # Front End
├── index.css                       # Front End
├── index.html                      # Front End
├── truffle-config.js               # Truffle Configuration
├── package-lock.json               
├── package.json                    # Dependencies
├── design_pattern_decisions.md     
├── avoiding_common_attacks.md      
├── deployed_address.txt
└── README.md
```

## Run Locally

### Prerequisites

* Node.js: v14.17.6
* npm: v6.14.15
* truffle: v5.4.13
* ganache-cli 

### Steps

1. git clone https://github.com/celdr/blockchain-developer-bootcamp-final-project.git
2. cd blockchain-developer-bootcamp-final-project
3. npm install
4. truffle compile
5. ganache-gli --port 8545 --networkId 5777
6. truffle migrate --network development
7. Run index.html on localhost

## Future Plans

* Update the frontend
* Allow other contract tokens to be fragmented

## Certification Address

Ethereum Account: 0xb7F5D226F43A9D126C50019C90A46Cf38518aad3



