# **Frational NFTs**
## **Problem**

A holder of a NFT that has gained in value wants sell a portion of a NFT they hold.  Perhaps the value is so high, but they want to keep a portion of the NFT. 

## **Solution**

Separate the original NFT into smaller piece (user defined amount). The original NFT can be returned by any address that owns all of the original pieces.

## **How it Works**

* An owner of an NFT want to sell a portion of that NFT
* The owner will send that NFT to an contract address with the specified number of piece they want to divide the NFT into
* The smart contract will send back (using EIP-1155) the specific number of newly minted NFTs
* Any user that holds all the portions of the original NFT, may retreive the original NFT by exchanging all the original pieces (which will be burned)

## **More Advanced**

* Allow divided items to be further divided

## **Challenges**

* Validate security of contract holding original NFTs

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

