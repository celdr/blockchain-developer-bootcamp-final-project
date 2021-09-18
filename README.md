# **NFT Lockbox** 
## **Problem**

Moving multiple NFT items from wallet to wallet can be time consuming as well as expensive if the network is busy.

## **Solution**

A way to package multiple NFTs into a single NFT. Allow an interface to accept multiple NFTs and store in a contract address to hold the NFTs, and in return a sort of key is minted and returned to the user. The user can then send that key to another wallet and the packed NFTs can be extracted at another location.

This could also be a solution for extra security by storing lockbox keys inside of other lockboxes (but would cost more in network fees).

## **How it Works**

### **Basics**
1. User connects to dapp
2. dapp reads all ERC-721 available to pack and displays them to the user
3. User selects all items to pack
4. User selects the amount of keys they want to generate to be able to extract the selected NFT (minimum of 1)
5. User confirms selection
6. dapp generates a contract address that will store and mints key(s) to user or specified address

### **More Advanced** (future features)

1. Allow multiple keys to be minted for extra security, where all the key must be held.
2. User can enter specific address that will be able to extract the NFTs (any address with keys by default)

## **Challenges**

* For sending a couple NFTs from one wallet to another, this may not be as cost effective as just directly transferring, but try to make it less time consuming.

## **Final Project Checklist**

- [x] Project naming format
- [x] Contains README.md
- [ ] Contains smart contract(s)
    - [ ] Are commented to specs
    - [ ] Use at least two design patterns from 'Smart Contracts" section
    - [ ] Inherit from at least one library or interface
    - [ ] Can be easily compiled, migrated and tested
- [ ] Contains a Markdown file named design_pattern_decisions.md and avoiding_common_attacks.md
- [ ] Have at least five unit test for your smart contract(s) that pass
- [ ] Contain a deployed_address.txt file
- [ ] Have a frontend interface
    - [ ] Detects the presence of MetaMask
    - [ ] Connects to the current account
    - [ ] Displays information from your smart contract
    - [ ] Allows a user to submit a transaction to update smart contract state
    - [ ] Updates the frontend if the transaction is successful or not
- [ ] Hosted on Github Pages, Heroku, Netlify, Fleek or some other free frontend service
- [ ] Have a folder named scripts that contain the following
    - [ ] scripts/bootstrap
    - [ ] scripts/server
    - [ ] scripts/test
- [ ] A screencast walking through the project